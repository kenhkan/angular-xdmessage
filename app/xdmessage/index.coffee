module = angular.module 'xdmessage'

module.factory 'xdmessage', ($window) ->
  ###
    Get the XDMessage object by providing a URL to load as iframe in the specified container. If no
    URL or container is provided, this is treated as the iframe itself. It would also
    assume that this is the iframe when `window.self != window.top` or
    container has not been set.

    @param {String=} url The URL to load as iframe
    @param {DOMElement} params.container The container dom
    @returns {XDMessage} the XDMessage object
  ###
  create: (url, params) ->
    { container } = params

    # Initiate as iframe
    if $window.self is $window.top and container? and url?
      new XDMessage url,
        container: container
    else
      new XDMessage()
