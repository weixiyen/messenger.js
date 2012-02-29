var Listener, Speaker,
  __slice = Array.prototype.slice;

Listener = require('./listener');

Speaker = require('./speaker');

exports.createListener = function(address) {
  return new Listener(address);
};

exports.createSpeaker = function() {
  var addresses;
  addresses = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return new Speaker(addresses);
};
