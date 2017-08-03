# MySql

**Flags to provide password in file**  
`--defaults-file=user_pass.cnf`  
`--login-path`  

## Exports
```shell
# If you have a larger db you gotta use --max_allowed_packet
mysqldump --max_allowed_packet=500M --single-transaction --events --databases dbname > backup-dbname-$(date +%Y-%m-%d_%H-%M).sql

# Export all databases
mysqldump --all-databases > backup-all-$(date +%Y-%m-%d_%H-%M).sql

# Export database schema with triggers & routines
mysqldump --no-data --routines --triggers > schema.sql
```

- https://serversforhackers.com/c/mysqldump-with-modern-mysql
- http://www.ducea.com/2007/07/25/dumping-mysql-stored-procedures-functions-and-triggers/
- http://loopj.com/2009/07/06/fast-mysql-backup-restore/
- http://francis-besset.com/backup-your-mysql-servers-and-restore-them-quickly.html


### mydumper
Faster, parallelized database dumps for mysql.
- https://www.pythian.com/blog/multi-tb-migration-using-mydumper/
- https://vitobotta.com/2011/01/06/mysql-backups-and-restores/
- https://www.percona.com/blog/2015/11/12/logical-mysql-backup-tool-mydumper-0-9-1-now-available/
- http://imagexmedia.com/blog/2014/11/speeding-your-mysql-dumprestores-mydumper

### XtraBackup
"Enterprisey" level backup tool for mysql.

- https://www.percona.com/doc/percona-xtrabackup/2.4/index.html

## Links
- https://speakerdeck.com/samlambert/the-mysql-ecosystem-at-github-2015
- https://www.percona.com/blog/2017/03/06/mysql-i-am-a-dummy/
- https://twindb.com/use-proxysql-tools/
- http://code.openark.org/blog/mysql/whats-so-complicated-about-a-master-failover
- https://www.digitalocean.com/community/tutorials/how-to-measure-mysql-query-performance-with-mysqlslap
- http://code.openark.org/blog/mysql/whats-so-complicated-about-a-master-failover