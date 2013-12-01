module = angular.module 'xdmessage', []

module.provider 'xdmessage', ->
  container = null

  ###
    Provide the DOM reference to the intended XDMessage container

    @param {DOMElement} container The container dom
  ###
  setContainer: (_container) ->
    container = _container

  $get: ($window) ->
    new class XDM
      ###
        Get the XDMessage object by providing a URL to load as iframe. If no
        URL is provided, this is treated as the iframe itself. It would also
        assume that this is the iframe when `window.self != window.top` or
        container has not been set.

        @param {String=} url The URL to load as iframe
        @returns {XDMessage} the XDMessage object
      ###
      create: (url) ->
        # Initiate as iframe
        if $window.self is $window.top and container? and url?
          new XDMessage url,
            container: container
        else
          new XDMessage()
