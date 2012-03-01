net = require 'net'
MessengerBase = require './messengerBase'

ERR_REQ_REFUSED = -1
MAX_WAITERS = 999999999

class Speaker extends MessengerBase
  
  constructor: (addresses) ->
    @uniqueId = 1
    @sockets = []
    @waiters = {}
    @waitersToFlush = {}
    @socketIterator = 0
    
    for address in @arrayAddresses(addresses)
      @connect(address)
  
  connect: (address) ->
    host = @getHostByAddress(address)
    port = @getPortByAddress(address)
    
    socket = new net.Socket
    
    socket.setEncoding('utf8')
    socket.setNoDelay(true)
    socket.setMaxListeners(Infinity)
    
    socket.connect port, host, =>
      @sockets.push(socket)
      
    socket.on 'data', (data) =>
      for messageText in @tokenizeData(data)
        message = JSON.parse(messageText)
        
        if !@waiters[message.id]
          continue
          
        @waiters[message.id](message.data)
        delete @waiters[message.id]
        delete @waitersToFlush[message.id]
    
    socket.on 'end', ->
      socket.connect(port, host)
    
    socket.on 'error', ->
      socket.connect(port, host)

  request: (subject, data, callback) ->
    
    if @sockets.length == 0
      return callback
        error: ERR_REQ_REFUSED

    @socketIterator = 0 if !@sockets[@socketIterator]
    
    messageId = @generateUniqueId()
    
    payload = @prepareJsonToSend
      id: messageId
      subject: subject
      data: data
      
    @waiters[messageId] = callback
    @waitersToFlush[messageId] = true
    @sockets[@socketIterator++].write(payload)
    
  shout: (subject, data) ->
    payload =
      subject: subject
      data: data
      
    for socket in @sockets
      socket.write(@prepareJsonToSend(payload))
    
  arrayAddresses: (addresses) ->
    if addresses instanceof Array
      return addresses
      
    return [addresses]
  
  generateUniqueId: ->
    id = 'id-' + @uniqueId
    if !@waiters[id]
      return id
      
    @uniqueId = 1 if @uniqueId++ == MAX_WAITERS
    
    if @waitersToFlush[@uniqueId]
      delete @waitersToFlush[@uniqueId]
      delete @waiters[@uniqueId]
    
    return @generateUniqueId()
    
module.exports = Speaker