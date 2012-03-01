class MessengerBase
    
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
    tokens = data.toString().split('\0')
    tokens.pop()
    return tokens

module.exports = MessengerBase