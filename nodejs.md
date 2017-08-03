# NodeJS

https://blog.heroku.com/archives/2015/11/10/node-habits-2016

## Learning
- https://nodeschool.io/
- http://exercism.io/languages/javascript

## node-gyp
**Hotfix**  
For Windows users, sometimes will fix your problem!  
`set VCTargetsPath=C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\V140`

## Debugging
**debug-options**  
The `node` binary has *tons* of options to play with
```shell
node --optimize_for_size --max_old_space_size=920 --gc_interval=100
node --prof-process --perf_basic_prof --trace-gc --abort-on-uncaught-exception
```

### Modules
There are a number of modules you should check out for debugging your node.js application. I use `heapdump`,`blocked` & `memwatch` in production with an endpoint
to get stats and trigger dumps to debug production apps.

```javascript
'use strict';

// Ideally you have an endpoint that only accepts localhost
// requests to trigger a heapdump
const heapdump = require('heapdump');
const blocked  = require('blocked');
const memwatch = require('memwatch');
const gc       = require('gc-stats');
const procfs   = require('procfs-stats');

const ps = procfs(process.pid);

ps.io(function(err,io){
  console.log('my process has done this much io', io);
});

ps.stat(function(err,io){
  console.log('my process has done this much io', io);
});

gc.on('stats', function (stats) {
  console.log('GC happened', stats);
});

```

### Performance

```shell
gcore `pgrep node`  # core dump for mdb?
perf record -F 99 -p `pgrep -n node` -g -- sleep 30
```


### Links
- https://nodejs.org/en/blog/uncategorized/profiling-node-js/
- https://github.com/joyent/node-stackvis
- https://github.com/chrisa/node-dtrace-provider
- https://www.npmjs.com/package/appmetrics
- http://techblog.netflix.com/2014/11/nodejs-in-flames.html
- https://nodejs.org/en/docs/guides/simple-profiling/
- https://blog.heroku.com/node-habits-2016
- http://www.slideshare.net/yunongx/debugging-node-in-prod
- https://github.com/node-inspector/v8-profiler
- https://blog.risingstack.com/finding-a-memory-leak-in-node-js/
- http://www.brendangregg.com/blog/2014-09-17/node-flame-graphs-on-linux.html
- http://www.bretfisher.com/node-docker-good-defaults/
- https://medium.com/mozilla-tech/mozilla-and-node-js-33c13e29beb1
