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
        xdmessageParams: '=',
        remoteUrl: '=',
        eventName: '=',
        exports: '=postMessageExports'
      },
      link: function($scope, $element, $attributes) {
        if ($scope.remoteUrl == null) {
          throw 'Attribute `remoteUrl` is expected';
        }
        if ($scope.eventName == null) {
          throw 'Attribute `eventName` is expected';
        }
        return xdmessage.create($scope.remoteUrl, {
          container: $element[0],
          xdmessageParams: $scope.xdmessageParams
        }, function(xdm) {
          xdm.on($scope.eventName, function(message, callback) {
            return $scope.$apply(function() {
              var _ref;
              message = JSON.parse(message);
              return (_ref = $scope.exports) != null ? _ref.onMessage(message, callback) : void 0;
            });
          });
          xdm.on('ready', function() {
            return $scope.$apply(function() {
              var _ref;
              return (_ref = $scope.exports) != null ? typeof _ref.onReady === "function" ? _ref.onReady() : void 0 : void 0;
            });
          });
          $scope.exports.sendMessage = function(message, callback) {
            message = JSON.stringify(message);
            return xdm.invoke($scope.eventName, message, callback);
          };
          return xdm.open();
        });
      }
    };
  });

}).call(this);

;(function() {
  var key, module, opener, search, term, terms, token, value, _i, _len, _ref;

  module = angular.module('xdmessage');

  opener = null;

  token = null;

  search = window.location.search.slice(1);

  terms = search.split('&');

  for (_i = 0, _len = terms.length; _i < _len; _i++) {
    term = terms[_i];
    _ref = term.split('='), key = _ref[0], value = _ref[1];
    switch (key) {
      case 'opener':
        opener = decodeURIComponent(value);
        break;
      case 'XDMessage_token':
        token = value;
    }
  }

  module.factory('xdmessage', function($window) {
    return {
      /*
        Get the XDMessage object by providing a URL to load as iframe in the
        specified container. If no URL or container is provided, this is treated
        as the iframe itself. It would also assume that this is the iframe when
        `window.self != window.top` or container has not been set.
      
        @param {String=} url The URL to load as iframe
        @param {DOMElement} params.container The DOM containing the iframe
        @param {function} done Called with the XDMessage object
      */

      create: function(url, params, done) {
        var container, create;
        container = params.container;
        create = function(XDMessage) {
          if ($window.self === $window.top && (container != null) && (url != null)) {
            return done(new XDMessage(url, {
              container: container,
              target: container,
              style: {
                position: 'absolute',
                left: '0px',
                top: '0px',
                width: '100%',
                height: '100%'
              }
            }));
          } else {
            return done(new XDMessage({
              windowHostURL: opener,
              token: token
            }));
          }
        };
        if (typeof define === "function" && define.amd) {
          return require(['xdmessage'], create);
        } else if (typeof exports !== 'undefined') {
          return create(require('xdmessage'));
        } else {
          return create(window.XDMessage);
        }
      }
    };
  });

}).call(this);

;