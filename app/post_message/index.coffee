module = angular.module 'xdmessage'

module.directive 'postMessage', ($window, xdmessage) ->
  restrict: 'EA'

  scope:
    xdmessageParams: '='
    remoteUrl: '='
    eventName: '='
    exports: '=postMessageExports'

  link: ($scope, $element, $attributes) ->
    # Sanity checks
    throw 'Attribute `remoteUrl` is expected' unless $scope.remoteUrl?
    throw 'Attribute `eventName` is expected' unless $scope.eventName?

    xdmessage.create $scope.remoteUrl,
      container: $element[0]
      xdmessageParams: $scope.xdmessageParams
    , (xdm) ->
      # Set up receiver
      xdm.on $scope.eventName, (message, callback) ->
        message = JSON.parse message
        $scope.exports?.onMessage message, callback

      xdm.on 'ready', ->
        $scope.exports?.onReady?()

      # Set up sender
      $scope.exports.sendMessage = (message, callback) ->
        message = JSON.stringify message
        xdm.invoke $scope.eventName, message, callback

      # Load iframe
      xdm.open()
