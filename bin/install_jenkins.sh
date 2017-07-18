#!/usr/bin/env bash

# @author Andres Hermosilla
# @notes
# Jenkins ssl
# http://balodeamit.blogspot.com/2014/03/jenkins-switch-to-ssl-https-mode.html
# https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-with-ssl-as-a-reverse-proxy-for-jenkins
# @todo
# - Setup security with LDAP
# - Add optional systems such as selenium
# - Add setup for ssl
set -e

install_git()
{
    echo "[i] Installing git"
    cd ~
    wget -O git.zip https://github.com/git/git/archive/master.zip
    unzip git.zip
    cd git-master
    sudo make configure
    sudo ./configure --prefix=/usr/local
    sudo make all doc
    sudo make install install-doc install-html 
}

install_jenkins_deb()
{
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get -y install jenkins
}

install_jenkins_rhel()
{
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    sudo yum install jenkins
}

install_deps_deb()
{
    echo "[i] Installing dependancies with apt"
    sudo apt-get update
    sudo apt-get install build-essential autoconf zlib1g-dev curl libcurl4-openssl-dev libexpat1-dev gettext zlib1g-dev asciidoc
    sudo apt-get install libssl-dev ncurses-dev
    sudo apt-get install screen inotify-tools perl perl-CPAN

    # Need that java!
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt-get update
    sudo apt-get install  -y openjdk-8-jdk
}

install_deps_rhel()
{
    echo "[i] Installing dependancies with yum"
    sudo yum -y update
    sudo rpm -Uvh http://repo.webtatic.com/yum/el6/latest.rpm 
    sudo yum install -y vim curl wget build-essential python-software-properties python-setuptools libaio gcc gcc-c++ make automake autoconf
    sudo yum install -y zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto bzip2-devel openssl-devel ncurses-devel
    sudo yum install -y screen inotify-tools perl perl-CPAN

    # Need that java!
    sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
}
install_dependancies()
{
    install_git
    if $(which apt)
    then 
        install_deps_deb
    else
        install_deps_rhel
    fi
}

install_jenkins()
{
    echo "[i] Installing Jenkins!"
    if $(which apt)
    then 
       install_jenkins_deb
    else
       install_jenkins_rhel
    fi
    # update timezone ... if need be
    # sudo sed -e 's@JENKINS_JAVA_OPTIONS="@&-Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Los_Angeles @' /etc/sysconfig/jenkins | sudo tee /etc/sysconfig/jenkins
    sudo service jenkins start
}

install_plugins()
{
    echo "[i] Installing Jenkins plugins"
    # wait for jenkins to warm up
    sleep 20
    # grab the jenkins cli
    cd /var/lib/jenkins && sudo wget http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar

    # https://github.com/jenkinsci/puppet-jenkins/blob/master/manifests/cli.pp

    # change the owner
    sudo chown jenkins:jenkins /var/lib/jenkins/jenkins-cli.jar

    # allow execution
    sudo chmod +x /var/lib/jenkins/jenkins-cli.jar
     
     # list of plugins we should install
    jenkins_plugins=(
        'active-directory'
        'build-environment'
        'build-name-setter'
        'build-pipeline-plugin'
        'clone-workspace-scm'
        'conditional-buildstep'
        'dashboard-view'
        'git'
        'git-client'
        'github'
        'groovy'
        'jira'
        'jenkins-jira-issue-updater'
        'jobConfigHistory'
        'slack'
        'ssh'
        'ssh-agent'
        'thinBackup'
        'timestamper'
        'token-macro'
        'versionnumber'
        'workflow-aggregator'
        'ws-cleanup'
    )

    for plugin in "${jenkins_plugins[@]}"
    do
        java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin $plugin -deploy
    done

    java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ restart
}

main()
{
    install_dependancies
    install_jenkins
    install_plugins
}

main