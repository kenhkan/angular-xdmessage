module = angular.module 'xdmessage'

module.directive 'postMessage', ($window, xdmessage) ->
  restrict: 'EA'

  scope:
    remoteUrl: '='
    eventName: '='
    exports: '=postMessageExports'

  link: ($scope, $element, $attributes) ->
    # Sanity checks
    throw 'Attribute `remoteUrl` is expected' unless $scope.remoteUrl?
    throw 'Attribute `eventName` is expected' unless $scope.eventName?

    xdm = xdmessage.create $scope.remoteUrl,
      container: $element[0]

    # Set up receiver
    xdm.on $scope.eventName, $scope.exports.onMessage

    xdm.on 'ready', $scope.exports.onReady

    # Set up sender
    $scope.exports.sendMessage = (message, callback) ->
      xdm.invoke $scope.eventName, message, callback

    # Load iframe
    xdm.open()
