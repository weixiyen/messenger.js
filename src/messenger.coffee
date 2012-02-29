Listener = require './listener'
Speaker = require './speaker'

exports.createListener = (address) ->
  return new Listener(address)
  
exports.createSpeaker = (addresses...) ->
  return new Speaker(addresses)