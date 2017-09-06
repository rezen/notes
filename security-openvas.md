# Security - OpenVAS

### CLI
```shell
# XML handling utils to make life easier
apt-get install -y  libxml2-utils

# List all targets
omp -u admin -w admin  --xml='<get_targets/>'

# Create a target
omp --xml='<create_target><name>Docker - Local</name><hosts>192.168.99.101</hosts></create_target>'

# Confirm target was added
omp --xml='<get_targets/>'

# Get tasks running
omp --xml='<get_tasks/>'

# Get config listings of types of scans
omp --pretty-print --xml='<get_configs/>'

# Create a task
omp --xml='<create_task><name>ScanWebserver</name><config id="698f691e-7489-11df-9d8c-002264764cea"/><target id="b34578b3-2c0e-485f-9cda-38ecd63ea40c"/></create_task>'

# Start the task
omp --pretty-print -xml='<start_task task_id="8d5e6664-709f-4275-a661-158feb596386" />'

# Get detailed info on the task
omp --pretty-print --xml='<get_tasks task_id="8d5e6664-709f-4275-a661-158feb596386" details="1"/>'

# Get report formats
omp --xml='<get_report_formats/>' | grep -i -A4 '<report_format id=' | egrep -i '(format|name>[a-z]+)'

# Output the report
omp --pretty-print --xml='<get_reports report_id="adb7dc80-f3e8-4231-9533-56bd45c2c3a5" format_id="c1645568-627a-11e3-a660-406186ea4fc5" max_results="200" />' > report.xml
xmllint --xpath 'string(/get_reports_response/report)' report.xml  | head -n -16 |  base64 --decode > report.csv
```

## Links
- https://github.com/mikesplain/openvas-docker
- https://www.linuxquestions.org/questions/linux-networking-3/openvas-create-new-tasks-from-omp-4175511045/
- https://elastic-security.com/2013/07/18/automation-of-vulnerability-assessments-with-openvas/
- https://pypi.python.org/pypi/openvas.omplib
- https://github.com/hay/xml2json/new/master
- https://isc.sans.edu/forums/diary/Automating+Vulnerability+Scans/20685/
- http://blog.identityautomation.com/managing-infrastructure-with-rapididentity-part-5-performing-openvas-vulnerability-scans
- https://www.digitalocean.com/community/tutorials/how-to-use-openvas-to-audit-the-security-of-remote-systems-on-ubuntu-12-04
- https://www.nopsec.com/blog/docker-based-openvas-scanning-cluster-improve-scope-scalability/
- https://www.linode.com/docs/security/install-openvas-on-ubuntu-16-04
- https://joedsweb.wordpress.com/2017/02/11/openvas-nagiosplugin/
- https://www.coveros.com/automating-security-with-devops-it-can-work/