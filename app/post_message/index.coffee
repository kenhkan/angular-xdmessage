module = angular.module 'postMessage', ['xdmessage']

module.directive 'postMessage', ($window, xdmessage) ->
  scope:
    # Remote address to load
    '=': 'remoteUrl'
    # The event name to watch for incoming messages
    '=': 'eventName'
    # Accepts a value and a callback that `onMessage` should call upon
    # completion
    '&': 'onMessage'
    # A function that accepts a JSONifiable value and a callback that's called
    # by the remote's returning call
    '&': 'sendMessage'

  link: ($scope, $element, $attributes) ->
    # Sanity checks
    throw 'Attribute `remoteUrl` is expected' unless $scope.remoteUrl?
    throw 'Attribute `eventName` is expected' unless $scope.eventName?
    unless $scope.sendMessage? or $scope.onMessage?
      throw 'Either attribute `onMessage` or `sendMessage` is expected'

    xdm = xdmessage.create $scope.remoteUrl, $element

    # Set up receiver
    xdm.on $scope.eventName, $scope.onMessage
    # Set up sender
    $scope.sendMessage = (message, callback) ->
      xdm.invoke $scope.eventName, message, callback

    # Load iframe
    xdm.start()
