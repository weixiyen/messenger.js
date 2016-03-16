Messenger-pool - Fast Node.js json over tcp connection pool
============
Installation

    npm install messenger-pool

[![Build Status](https://travis-ci.org/MoLow/messenger-pool.svg?branch=master)](https://travis-ci.org/MoLow/messenger-pool)
[![Coverage Status](https://coveralls.io/repos/MoLow/messenger-pool/badge.svg?branch=masterservice=github)](https://coveralls.io/github/MoLow/messenger-pool?branch=master)
[![npm](https://img.shields.io/npm/v/messenger-pool.svg)](https://www.npmjs.com/package/messenger-pool)
![dependencies](https://img.shields.io/david/MoLow/messenger-pool.svg)

this package is based on [Messenger.js](https://github.com/weixiyen/messenger.js)
the syntax is the same, only this repo supports both a single connection, and a connection pool

this packege uses [node-pool](https://github.com/coopernurse/node-pool) to do the connection pooling

Example:

```javascript
var messenger = require('messenger-pool');
var poolOptions = {
    max      : 10,
    min      : 2,
    idleTimeoutMillis : 30000
};

var client = messenger.createSpeakerPool(8000, poolOptions);
var server = messenger.createListener(8000);

server.on('give it to me', function(message, data){
  message.reply({'you':'got it'});
});

setInterval(function(){
  client.request('give it to me', {hello:'world'}, function(data){
    console.log(data);
  });
}, 1000);
```

Output:

```javascript
> {'you':'got it'}
> {'you':'got it'}
> ...etc...
```

more examples, and syntax for single connection without pooling could be found in [Messenger.js](https://github.com/weixiyen/messenger.js) docs

all optional and default values for poolOptions could be found in [node-pool](https://github.com/coopernurse/node-pool) docs