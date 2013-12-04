(function() {
  describe('postMessage', function() {
    var controller, directive, scope, template;
    controller = null;
    directive = null;
    template = null;
    scope = null;
    beforeEach(angular.mock.module('xdmessage'));
    beforeEach(inject(function($rootScope, $controller, $window) {
      template = '<post-message\n  remote-url="remoteUrl"\n  event-name="eventName"\n  post-message-exports="postMessage"\n></post-message>';
      $window.self = $window.top;
      scope = $rootScope.$new();
      return scope.postMessage = {};
    }));
    describe('checking sanity', function() {
      return it('expects a remoteUrl and an eventName', function() {
        return inject(function($compile) {
          var link;
          scope.remoteUrl = 'http://localhost:8888/';
          scope.eventName = 'event';
          scope.postMessage.onMessage = function() {};
          link = function() {
            var element;
            return element = $compile(template)(scope);
          };
          return expect(link).not.toThrow();
        });
      });
    });
    return describe('while communicating', function() {
      it('is notified when ready', function() {
        return inject(function($compile) {
          var isReady;
          isReady = false;
          runs(function() {
            var element;
            scope.remoteUrl = 'http://localhost:8888/';
            scope.eventName = 'echo';
            scope.postMessage.onReady = function() {
              return isReady = true;
            };
            return element = $compile(template)(scope);
          });
          return waitsFor(function() {
            return isReady;
          }, 'never ready', 100);
        });
      });
      it('sends a message', function() {
        return inject(function($compile) {
          var ret;
          ret = null;
          runs(function() {
            var element;
            scope.remoteUrl = 'http://localhost:8888/';
            scope.eventName = 'echo';
            scope.postMessage.onReady = function() {
              return element.scope().postMessage.sendMessage({
                test: 'message'
              }, function(data) {
                return ret = data;
              });
            };
            return element = $compile(template)(scope);
          });
          return waitsFor(function() {
            return (ret != null ? ret.test : void 0) === 'message';
          }, 'nothing has returned', 100);
        });
      });
      return it('receives a message', function() {
        return inject(function($compile) {
          var ret;
          ret = null;
          runs(function() {
            var element;
            scope.remoteUrl = 'http://localhost:8888/';
            scope.eventName = 'yes';
            scope.postMessage.onMessage = function(data) {
              return ret = data;
            };
            scope.postMessage.onReady = function() {
              return element.scope().postMessage.sendMessage('message');
            };
            return element = $compile(template)(scope);
          });
          return waitsFor(function() {
            return ret === 'message';
          }, 'nothing was received', 100);
        });
      });
    });
  });

}).call(this);

;(function() {
  describe('xdmessage', function() {
    beforeEach(function() {
      return angular.mock.module('xdmessage');
    });
    return describe('as a host frame', function() {
      var container;
      container = null;
      beforeEach(function() {
        return inject(function($window) {
          $window.self = $window.top;
          return container = document.createElement('div');
        });
      });
      it('sets a container in provider and a URL in service', function() {
        return inject(function(xdmessage) {
          var onReady, xdm;
          xdm = null;
          onReady = null;
          runs(function() {
            xdm = xdmessage.create('http://localhost:8888/', {
              container: container
            });
            onReady = jasmine.createSpy('onReady');
            xdm.on('ready', onReady);
            return xdm.open();
          });
          return waitsFor(function() {
            return onReady.callCount > 0;
          }, 'ready not called', 500);
        });
      });
      it('throws when there is no URL', function() {
        return inject(function(xdmessage) {
          var create;
          create = function() {
            return xdmessage.create(null, {
              container: container
            });
          };
          return expect(create).toThrow();
        });
      });
      it('throws when there is no container', function() {
        return inject(function(xdmessage) {
          var create;
          create = function() {
            return xdmessage.create('http://localhost:8888/');
          };
          return expect(create).toThrow();
        });
      });
      return it('throws when running with child without XDMessage installed', function() {
        return inject(function(xdmessage) {
          var create;
          create = function() {
            var xdm;
            xdm = xdmessage.create('http://www.w3.org/', {
              container: container
            });
            return xdm.run();
          };
          return expect(create).toThrow();
        });
      });
    });
  });

}).call(this);

;