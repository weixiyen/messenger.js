var MessengerBase;

MessengerBase = (function() {

  function MessengerBase() {}

  MessengerBase.prototype.getHostByAddress = function(address) {
    if (typeof address === 'number') return null;
    if (typeof address === 'string') return address.split(':')[0];
  };

  MessengerBase.prototype.getPortByAddress = function(address) {
    if (typeof address === 'number') return address;
    if (typeof address === 'string') return address.split(':')[1];
  };

  MessengerBase.prototype.prepareJsonToSend = function(json) {
    return JSON.stringify(json) + '\0';
  };

  MessengerBase.prototype.tokenizeData = function(data) {
    var tokens;
    tokens = data.toString().split('\0');
    tokens.pop();
    return tokens;
  };

  return MessengerBase;

})();

module.exports = MessengerBase;
