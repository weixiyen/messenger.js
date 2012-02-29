USAGE
-----------------------

web.js 

  var http = require('http');
  var cluster = require('cluster');
  var numCPUs = require('os').cpus().length;
  var messenger = require('messenger');
  
  // use cluster to fork processes
  if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) {
      cluster.fork();
    }
    cluster.on('death', function(worker) {
      console.log('worker ' + worker.pid + ' died');
    });
    return;
  }
  
  // a list data services
  var dataServices = [
    '127.3.2.4:4000',
    '23.4.2.5:4000',
    '34.5.3.234:4000'
  ];
  
  // create a messenger to access data
  var dataAccess = messenger.createSpeaker(dataServices);
  
  // create a http server to route
  // requests to dataAccess layer
  // this can be done through middleware too
  http.createServer(function (req, res) {
    
    var subject = req.params.subject;
    var message = req.params.message;
    
    dataAccess.request(subject, message, function(reply){
      res.end(reply);
    });
    
  }).listen(8000);
  
stream.js

  var cluster = require('cluster');
  var numCPUs = require('os').cpus().length;
  var messenger = require('messenger');
  
  var stream = messenger.createListener(5000);
  
  stream.on('user deleted', function(message){
    // send http message here back to user if necessary
  });

data.js

  var cluster = require('cluster');
  var numCPUs = require('os').cpus().length;
  var messenger = require('messenger');
  
  // use cluster to fork processes
  if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) {
      cluster.fork();
    }
    cluster.on('death', function(worker) {
      console.log('worker ' + worker.pid + ' died');
    });
    return;
  }
  
  // all clusters listen to port 4000
  var db = messenger.createListener(4000);
  
  // create shouter to fanout to stream server
  var streamServices = [
    '127.3.2.4:5000',
    '23.4.2.5:5000',
    '34.5.3.234:5000'
  ];
  var stream = messenger.createSpeaker(streamServices);
  
  db.on('get me some popular users', function(message){
    // do something with database model
  });
  
  db.on('delete this user', function(message){
    stream.shout("user deleted", message.contents.userId);
  });
  
  var memberOnly = function(message) {
    var userId = message.params.userId;
    
    if (userId) {
      message.next();
    }
    
    message.reply({
      error: true,
      content: {
        reason: "You are not authenticated."
      }
    });
  }
  
  db.on('delete this user', memberOnly, function(message) {
    // delete this user
    message.reply({some:data});
  });
  
  
  
  