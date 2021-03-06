# Mongodb

**Get stats**  
`mongo Health --eval "db.stats()" &>/dev/null`  

**Query inline**  
```shell
second_ago=$(date --date="2 minutes ago" +%s)
query="{class: 0, ts: {\$gt: ${second_ago} }}"
mongo Health --eval "db.Stats.findOne($query).ts" &>/dev/null
```



## Export
**Snapshot**  
`mongodump --quiet -d User -o /data/snapshot/user-$(date +%Y%m%d)`

**CSV**  
`mongoexport --db Health --collection Stats --csv -q '{class: 1, type:"Customer"}' --fields sn,model_full,domain,cluster_serials,ts --out /tmp/data.csv`

## Restore
**Import from json** 
`mongoimport -db HealthTS --collection CountTS --jsonArray --file count-ts.json`   

**Import from snapshots**
```shell
restore_data()
{
  local reindex='db.getCollectionNames().forEach(function(col){db[col].reIndex()});'
  mongorestore --db Health ./snapshot/Health/
  mongorestore --db User ./snapshot/User/
  mongo User --eval "$reindex" &>/dev/null
  mongo Health --eval "$reindex" &>/dev/null  
}
```

## Schema Inspection
With `variety.js` you can inspect a collection's schema, to get an idea of the field names and data types!

https://github.com/variety/variety


```bash
product_class=2
hours_ago=$(date -d '8 hour ago' "+%s")
query="{'class': ${product_class}, 'ts': {'\$gt': ${hours_ago} }}"

mongo Health --quiet --eval "var collection='Stats', query=${query}, outputFormat='json', limit=3000, maxDepth=1" variety.js
```

## Security
- https://www.cyberciti.biz/faq/how-to-secure-mongodb-nosql-production-database/
- http://thecodebarbarian.com/casting-mongodb-queries-with-archetype.html