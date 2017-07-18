#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

# @todo add locking
set -e

# Store separator for reverting
OLD_IFS=$IFS
# ... to a comma ..
IFS=$' '
# Copy ARGS to an array 
read -r -a ARRGS <<< "$ARGS"
IFS=OLD_IFS

LOGTO=''

# Exit codes
readonly EXIT_PS_NOT_EXIST=1
readonly EXIT_THRESH_PASSED_MEM=2
readonly EXIT_THRESH_PASSED_CPU=3
readonly EXIT_UNSAFE_FAIL_HOOK=99
readonly EXIT_BAD_CONF_SCRIPT=5
readonly EXIT_BAD_CONF_PIDFILE=6
readonly EXIT_PIDFILE_NO_EXIST=7
readonly EXIT_ZOMBIES_FOUND=8

# Log with timestamps. 
# Print to stdout or if log file is specified print to it
loggy()
{
    local message="$1"
    local ts=$(date +%Y-%m-%d:%H:%M:%S)
    local output="[$ts] $message"

    if [[ -f $LOGTO ]]; then
        echo "$output" >> $LOGTO
        return 0
    fi

    echo "$output"
}

# Check if pid+script exists
check_ps_pair_exits()
{
    local check_pid="$1"
    local check_name="$2"

    local pair_exists=$(ps h -o pid,args $check_pid | grep "$check_name")


    if [ -z "$pair_exists" ]; then
        # echo "Cannot find the process with pid: $check_pid, name: $check_name"
        return $EXIT_PS_NOT_EXIST
    fi

    return 0
}

# Check the mem and cpu thresholds for a pid
# Throws exit codes for passing thresholds
check_pid_thresholds()
{
    local check_pid="$1"
    local threshold_mem="$2"
    local threshold_cpu="$3"

    local stats=$(ps h -o pid,user,pcpu,vsize,args $check_pid | xargs)

    if [ -z "$stats" ]; then
        return $EXIT_PS_NOT_EXIST
    fi

    local stat_cpu=$(echo $stats | awk '{print $3}' | xargs)
    local stat_mem=$(echo $stats | awk '{print $4}' | xargs)
    
    loggy "INFO pid: $check_pid, mem: $stat_mem, cpu: $stat_cpu"

    # remove decimals
    stat_cpu=${stat_cpu%.*}

    if [ ! -z $threshold_mem ] &&  [ $stat_mem -gt $threshold_mem ]; then
        loggy "WARN pid: $check_pid, mem:  $threshold_mem > $stat_mem"
        return $EXIT_THRESH_PASSED_MEM
    fi

    if [ ! -z $threshold_cpu ] && [ $stat_cpu -gt $threshold_cpu ]; then
        loggy "WARN pid: $check_pid, cpu: $threshold_mem > $stat_cpu"
        return $EXIT_THRESH_PASSED_CPU
    fi

    return 0
}

# Check for defunct procsses
check_for_zombies()
{
    local check_name="$1"
    local stats=$(ps | grep $check_name | grep '<defunct>' | xargs)

    if [ -z "$stats" ]; then
        return 0
    fi

    return $EXIT_ZOMBIES_FOUND
}

# Ensure pidfile option is set and verify it exists
validate_pidfile()
{
    local pidfile="$1"

    if [[ -z "$pidfile" ]]; then
        return $EXIT_BAD_CONF_PIDFILE
    fi

    if [[ ! -f "$pidfile" ]]; then
        return $EXIT_PIDFILE_NO_EXIST
    fi

    return 0
}

# Make sure the on-fail hook does not do anything dangerous or dumb
# like remove files or format etc
validate_on_fail()
{
    local cmd=$(echo $1 | xargs)
    local bad_ideas=('mkfs' 'dd' 'mv' 'mkdir' 'touch' 'rm' '>' '<')
    local exit_code=0

    for dont_do in "${bad_ideas[@]}"; do

        if [[ "$cmd" == *$dont_do* ]]; then
          exit_code=$EXIT_UNSAFE_FAIL_HOOK
          break
        fi
    done

    return $exit_code
}

# Runs on-fail hook in its own context replacing 
# the $event variable with the event name
run_on_fail() {
    local run_command="$1"
    local event="$2"
    local output=''
    local exit_code=0

    # replace $event var with event name
    run_command="${run_command//\$event/$event}"

    { 
        output=$(echo $run_command | bash 2>&1)
    } || {
        exit_code=$?
    }

    # if the on-fail exits badly ...
    if [[ $exit_code != 0 ]]; then
        loggy "FAIL part: on-fail, exit: $exit_code, out: $output"
    elif [[ ! -z $output ]]; then
        loggy "INFO part: on-fail, out: $output"
    fi
}

#
# @note link below helped with creating config setup
# http://unix.stackexchange.com/questions/175648/use-config-file-for-my-shell-script
handle_conf()
{
    declare -A config
    local config_file="$1"
    local config=(
        [script]=""
        [keep_alive]=""
        [pidfile]=""
        [threshold_cpu]="50"
        [threshold_mem]=710000
        [on_fail]=""
    )

    local config_contents=$(cat $config_file)

    # We need the extra newline to ensure the config is valid
    config_contents=$(echo -e "${config_contents} \n")

    while read line
    do
        if echo $line | grep -F = &>/dev/null
        then
            local key=$(echo "$line" | cut -d '=' -f 1)
            # replace -dashes with _underscores
            key=${key/-/_}
            local config_value=$(echo "$line" | cut -d '=' -f 2-)
            config[$key]="$config_value"
        fi
    done <<< "$config_contents"

    # no script ... no fun
    if [[ -z ${config[script]} ]]; then
        return $EXIT_BAD_CONF_SCRIPT
    fi

    # Make sure the on-fail is safe to run
    {
        validate_on_fail "${config[on_fail]}"
    } || {
        return $?
    }

    # Make sure there is a pid
    # @todo if no pidfile should restart?
    {
        validate_pidfile "${config[pidfile]}"
    } || {
        return $?
    }

    # Default is pass
    local fail_code=0
    local ps_pid=$(cat "${config[pidfile]}")
    
    # If pid+script is not running restart run on-fail
    {
        check_ps_pair_exits "$ps_pid" "${config[script]}"
    } || {
        fail_code="$?"
        run_on_fail ${config[on_fail]} 'dead'
        return $fail_code
    }

    {
        check_for_zombies "${config[script]}"
    } || {
        fail_code="$?"
        run_on_fail ${config[on_fail]} "zombies"
        return $fail_code
    }

    # Check the mem & cpu thresholds and run on-fail
    # if they pass the thresholds
    {
        check_pid_thresholds $ps_pid ${config[threshold_mem]} ${config[threshold_cpu]}
    } || {
        fail_code="$?"
        local fail_arg='threshold'

        if [ $fail_code == $EXIT_THRESH_PASSED_MEM ]; then
            fail_arg="$fail_arg:mem"
        elif [ $fail_code == $EXIT_THRESH_PASSED_CPU ]; then
            fail_arg="$fail_arg:cpu"
        fi

        run_on_fail ${config[on_fail]} "$fail_arg"
        return $fail_code
    }

    return 0
}

# Function for handling a conf file
handle_conf_api() {
    local conf_file="$1"
    local exit_code=0
    conf_file=$(readlink -m "$conf_file")

    loggy "INFO conf: $conf_file ... parsing"

    {
        handle_conf $conf_file
    } || {
        exit_code="$?"
        case $exit_code in
            $EXIT_PS_NOT_EXIST)
                loggy "ERR conf: $conf_file PS_NOT_EXIST"
                ;;
            $EXIT_THRESH_PASSED_MEM)
                loggy "FAIL conf: $conf_file THRESH_PASSED_MEM"
                ;;
            $EXIT_THRESH_PASSED_CPU)
                loggy "FAIL conf: $conf_file THRESH_PASSED_CPU"
                ;;
            $EXIT_UNSAFE_FAIL_HOOK)
                loggy "ERR conf: $conf_file UNSAFE_FAIL_HOOK"
                ;;
            $EXIT_BAD_CONF_PIDFILE)
                loggy "ERR conf: $conf_file BAD_CONF_PIDFILE"
                ;;
            $EXIT_PIDFILE_NO_EXIST)
                loggy "ERR conf: $conf_file PIDFILE_NO_EXIST"
                ;;
            $EXIT_BAD_CONF_SCRIPT)
                loggy "ERR conf: $conf_file BAD_CONF_SCRIPT"
                ;;
            $EXIT_ZOMBIES_FOUND)
                loggy "FAIL conf: $conf_file ZOMBIES_FOUND"
                ;;
            *)
        esac
    }

    if [[ $exit_code == 0 ]]; then
        loggy "INFO conf: $conf_file PASSES"
    fi

    return 0
}

# Loads confs from conf directory, does not recurse
handle_conf_dir()
{
    local conf_dir=$(readlink -m "$1")
    local conf_files=$(find $conf_dir  -maxdepth 1  -type f| xargs)
    
    loggy "INFO Loading dir: $conf_dir"

    for conf_file in "${conf_files[@]}"; do
        handle_conf_api "$conf_file"
    done
}

# Help
help()
{
    echo "INFO"
    echo "  arg{0} Required: Point to a conf file or directory of conf files"
    echo "  arg{1} Optional: Point to a file you would like to log to ... file must already exist"
    echo ""

    echo "USAGE"
    echo "  ./$PROGNAME \$conf_file|required \$log_file|optional"
    echo ""
    echo "EXAMPLES"
    echo "  ./$PROGNAME /cat_facts.conf"
    echo "  ./$PROGNAME /cat_facts.conf /var/log/mon_cat_cats.log"
    echo ""
    exit 33
}

# ...
main() 
{
    local ts_start=$(date +%s%N)
    local conf="${ARRGS[0]}"

    # If a second arg was passed, log to it
    if [ ! -z "${ARRGS[1]}" ]; then
        LOGTO="${ARRGS[1]}"
    fi

    # If empty ... help
    if [ -z $conf ]; then
        help
    elif [ -f $conf ]; then
        handle_conf_api $conf
    elif [ -d $conf ]; then
        handle_conf_dir $conf
    else
        help
    fi

    local ts_end=$(date +%s%N)
    local duration=$(echo $ts_start,$ts_end | awk -F',' '{print ($2 - $1) / 1000000000}')

    loggy "INFO Done duration: $duration"
}

main