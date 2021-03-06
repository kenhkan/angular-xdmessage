module = angular.module 'xdmessage'

# This must happen outside of Angular because Angular could erase the URL
# before any code in Angular runs
opener = null
token = null
search = window.location.search[1...]
terms = search.split '&'

for term in terms
  [ key, value ] = term.split '='
  switch key
    # The window host URL
    when 'opener'
      opener = decodeURIComponent value
    # The session token
    when 'XDMessage_token'
      token = value

module.factory 'xdmessage', ($window) ->
  ###
    Get the XDMessage object by providing a URL to load as iframe in the
    specified container. If no URL or container is provided, this is treated
    as the iframe itself. It would also assume that this is the iframe when
    `window.self != window.top` or container has not been set.

    @param {String=} url The URL to load as iframe
    @param {DOMElement} params.container The DOM containing the iframe
    @param {function} done Called with the XDMessage object
  ###
  create: (url, params, done) ->
    { container } = params

    create = (XDMessage) ->
      # Initiate as iframe
      if $window.self is $window.top and container? and url?
        done new XDMessage url,
          container: container
          target: container
          style:
            position: 'absolute'
            left: '0px'
            top: '0px'
            width: '100%'
            height: '100%'
      else
        done new XDMessage
          windowHostURL: opener
          token: token

    # AMD
    if typeof define is "function" and define.amd
      require ['xdmessage'], create
    # CommonJS
    else if typeof exports isnt 'undefined'
      create require 'xdmessage'
    # Old School
    else
      create window.XDMessage
