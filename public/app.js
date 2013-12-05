(function() {
  var module;

  module = angular.module('xdmessage', []);

}).call(this);

;(function() {
  var module;

  module = angular.module('xdmessage');

  module.directive('postMessage', function($window, xdmessage) {
    return {
      restrict: 'EA',
      scope: {
        remoteUrl: '=',
        eventName: '=',
        exports: '=postMessageExports'
      },
      link: function($scope, $element, $attributes) {
        var xdm;
        if ($scope.remoteUrl == null) {
          throw 'Attribute `remoteUrl` is expected';
        }
        if ($scope.eventName == null) {
          throw 'Attribute `eventName` is expected';
        }
        xdm = xdmessage.create($scope.remoteUrl, {
          container: $element[0]
        });
        xdm.on($scope.eventName, function(message, callback) {
          var _ref;
          message = JSON.parse(message);
          return (_ref = $scope.exports) != null ? _ref.onMessage(message, callback) : void 0;
        });
        xdm.on('ready', function() {
          var _ref;
          return (_ref = $scope.exports) != null ? typeof _ref.onReady === "function" ? _ref.onReady() : void 0 : void 0;
        });
        $scope.exports.sendMessage = function(message, callback) {
          message = JSON.stringify(message);
          return xdm.invoke($scope.eventName, message, callback);
        };
        return xdm.open();
      }
    };
  });

}).call(this);

;(function() {
  var module;

  module = angular.module('xdmessage');

  module.factory('xdmessage', function($window) {
    return {
      /*
        Get the XDMessage object by providing a URL to load as iframe in the specified container. If no
        URL or container is provided, this is treated as the iframe itself. It would also
        assume that this is the iframe when `window.self != window.top` or
        container has not been set.
      
        @param {String=} url The URL to load as iframe
        @param {DOMElement} params.container The container dom
        @returns {XDMessage} the XDMessage object
      */

      create: function(url, params) {
        var container;
        container = params.container;
        if ($window.self === $window.top && (container != null) && (url != null)) {
          return new XDMessage(url, {
            container: container
          });
        } else {
          return new XDMessage();
        }
      }
    };
  });

}).call(this);

;