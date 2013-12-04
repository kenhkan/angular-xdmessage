module = angular.module 'xdmessage'

module.directive 'postMessage', ($window, xdmessage) ->
  restrict: 'EA'

  scope:
    remoteUrl: '='
    eventName: '='
    postMessageExports: '='

  link: ($scope, $element, $attributes) ->
    # Sanity checks
    throw 'Attribute `remoteUrl` is expected' unless $scope.remoteUrl?
    throw 'Attribute `eventName` is expected' unless $scope.eventName?

    xdm = xdmessage.create $scope.remoteUrl,
      container: $element[0]

    # Set up receiver
    xdm.on $scope.eventName, $scope.postMessageExports.onMessage

    xdm.on 'ready', $scope.postMessageExports.onReady

    # Set up sender
    $scope.postMessageExports.sendMessage = (message, callback) ->
      xdm.invoke $scope.eventName, message, callback

    # Load iframe
    xdm.open()
