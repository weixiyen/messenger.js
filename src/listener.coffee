net = require 'net'
MessengerBase = require './messengerBase'

class Listener extends MessengerBase
  
  constructor: (address) ->
    super()

    @remoteMethods = {}
    @host = @getHostByAddress(address)
    @port = @getPortByAddress(address)
    @startServer()
    
    @errorFn = =>
      @startServer()
    
  startServer: ->
    tcpServer = net.createServer (connection) =>
      connection.on 'data', (data) =>
        
        for messageText in @tokenizeData(data)
          message = JSON.parse(messageText)
          message.conn = connection
          
          message = @prepare(message)
          @dispatch(message)
    
    tcpServer.listen(@port, @host)
    tcpServer.setMaxListeners(Infinity)
    tcpServer.on 'error', (exception) =>
      @errorFn(exception)
      
  onError: (@errorFn) ->
    
  prepare: (message) ->
    subject = message.subject
    i = 0
    
    message.reply = (json) =>
      payload = 
        id: message.id
        data: json
      message.conn.write(@prepareJsonToSend(payload))
    
    message.next = =>
      @remoteMethods[subject]?[i++](message, message.data)
      
    return message
    
  dispatch: (message) ->
    subject = message.subject
    message.next()
  
  on: (subject, methods...) ->
    @remoteMethods[subject] = methods
    
module.exports = Listener