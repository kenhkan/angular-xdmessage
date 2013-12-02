(function() {
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
            xdm = xdmessage.create('http://localhost:8888/child.html', {
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
            return xdmessage.create('http://localhost:8888/child.html');
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