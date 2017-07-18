# Notes - Influxdb


- measurements ~ table
- fields are non-indexed columns
- If you are using a field & tag that are the same, use a different name
  eg fields: {class: 1, sn: 23434, cpu 0.232}, tags: {class:1} vs tags:{pclass:1}
  makes querying easier
- tags are indexed columns and should be used on columns that don't have lots of unique values make filtering faster (~10x)
- tune precision (seconds, minutes, etc)
- values default to int
- types are bool, int, float, str and after the first record the field to type mapping is set
- https://cobe.io/blog/posts/memory-adventures-with-influxdb/
- https://vimeo.com/169742452
- https://vimeo.com/170035101
- https://vimeo.com/195058724
- https://vimeo.com/198723778
- https://vimeo.com/200898048
- https://grisha.org/blog/2015/03/20/influxdb-data/
- http://www.ryandaigle.com/a/time-series-db-design-with-influx
- http://roobert.github.io/2015/10/10/Columned-Graphite-Data-in-InfluxDB/
- https://maxchadwick.xyz/blog/monitoring-magento-cron
- http://techblog.shutl.com/2016/06/moving-from-graphite-to-influxdb/
- http://ryanfrantz.com/posts/solving-monitoring/
- https://blog.karmawifi.com/the-software-behind-karma-metrics-and-alerting-57cb1d0ddaf#.1k9rpu78w
- http://blog.aiven.io/2016/04/monitoring-influxdb-telegraf-grafana.html
- https://www.digitalocean.com/community/tutorials/how-to-analyze-system-metrics-with-influxdb-on-centos-7
- http://www.vishalbiyani.com/graphing-performance-with-collectd-influxdb-grafana/
- https://milinda.svbtle.com/cluster-and-service-monitoring-using-grafana-influxdb-and-collecd
- https://streamsets.com/blog/streamsets-monitoring-grafana-influxdb-jmxtrans/
- http://rmoff.net/2016/05/12/monitoring-logstash-ingest-rates-with-influxdb-and-grafana/
- http://jansipke.nl/monitoring-hosts-with-collectd-influxdb-and-grafana/
- https://markri.nl/custom-monitoring-stack/
- http://tech.aabouzaid.com/2016/08/monitoring-processes-with-telegraf-influxdb-kapacitor-python.html
- https://github.com/mark-rushakoff/awesome-influxdb
- https://influxdata.com/tldr-influxdb-tech-tips-february-16-2017/
