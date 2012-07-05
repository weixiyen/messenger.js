class MessengerBase
  constructor: ->
    @savedBuffer = '';

  getHostByAddress: (address) ->
    if typeof address == 'number'
      return null
    
    if typeof address == 'string'
      return address.split(':')[0]
    
  getPortByAddress: (address) ->
    if typeof address == 'number'
      return address
    
    if typeof address == 'string'
      return address.split(':')[1]
  
  prepareJsonToSend: (json) ->
    return JSON.stringify(json) + '\0'
    
  tokenizeData: (data) ->
    @savedBuffer += data
    tokens = @savedBuffer.split('\0')
    
    if tokens.pop()
      return []

    @savedBuffer = ''
    return tokens

module.exports = MessengerBase