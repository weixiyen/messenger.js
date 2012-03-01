net = require 'net'
MessengerBase = require './messengerBase'

ERR_REQ_REFUSED = -1
MAX_WAITERS = 9999999

class Speaker extends MessengerBase
  
  constructor: (addresses) ->
    @uniqueId = 1
    @sockets = []
    @waiters = {}
    @socketIterator = 0
    
    for address in addresses
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
    
    socket.on 'end', ->
      socket.connect(port, host)
    
    socket.on 'error', ->
      socket.connect(port, host)

  request: (subject, data, callback=null) ->
    @send subject, data, callback
  
  send: (subject, data, callback=null) ->
    if @sockets.length == 0
      if callback then callback
        error: ERR_REQ_REFUSED
      return

    @socketIterator = 0 if !@sockets[@socketIterator]

    if callback
      messageId = @generateUniqueId() 
      @waiters[messageId] = callback

    payload = @prepareJsonToSend
      id: messageId
      subject: subject
      data: data
      
    @sockets[@socketIterator++].write(payload)
    
  shout: (subject, data) ->
    payload =
      subject: subject
      data: data
      
    for socket in @sockets
      socket.write(@prepareJsonToSend(payload))
  
  generateUniqueId: ->
    id = 'id-' + @uniqueId
    if !@waiters[id]
      return id
    
    @uniqueId = 1 if @uniqueId++ == MAX_WAITERS
    
    if @waiters[newId = 'id-' + @uniqueId]
      delete @waiters[newId]
      
    return @generateUniqueId()
    
module.exports = Speaker