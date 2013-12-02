module = angular.module 'xdmessage'

module.directive 'postMessage', ($window, xdmessage) ->
  scope: true

  link: ($scope, $element, $attributes) ->
    # Sanity checks
    throw 'Attribute `remoteUrl` is expected' unless $scope.remoteUrl?
    throw 'Attribute `eventName` is expected' unless $scope.eventName?
    #unless $scope.sendMessage? or $scope.onMessage?
    #  throw 'Either attribute `onMessage` or `sendMessage` is expected'

    xdm = xdmessage.create $scope.remoteUrl,
      container: $element[0]

    # Set up receiver
    xdm.on $scope.eventName, $scope.onMessage

    xdm.on 'ready', ->
      $scope.xdmReady?()

    # Set up sender
    $scope.sendMessage = (message, callback) ->
      xdm.invoke $scope.eventName, message, callback

    # Load iframe
    xdm.open()
