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