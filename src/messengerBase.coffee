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
    data = @savedBuffer + data
    tokens = data.toString().split('\0')
    lastToken = tokens.pop()

    if lastToken
      @savedBuffer += lastToken
      return []

    @savedBuffer = ''
    return tokens

module.exports = MessengerBase