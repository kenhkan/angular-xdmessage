(function() {
  describe('xdmessage', function() {
    var module, provider;
    module = null;
    provider = null;
    beforeEach(function() {
      var test;
      test = angular.module('test', []);
      test.config(function(xdmessageProvider) {
        return provider = xdmessageProvider;
      });
      return angular.mock.module('xdmessage', 'test');
    });
    it('checks for sanity', function() {
      return expect(provider).not.toBeUndefined();
    });
    return describe('as a host frame', function() {
      var container;
      container = null;
      beforeEach(function() {
        return container = document.createElement('div');
      });
      it('sets a container in provider and a URL in service', function() {
        return inject(function(xdmessage) {
          var onReady, xdm;
          xdm = null;
          onReady = null;
          runs(function() {
            provider.setContainer(container);
            xdm = xdmessage.create('http://localhost:8888/child.html');
            onReady = jasmine.createSpy('onReady');
            xdm.on('ready', onReady);
            return xdm.open();
          });
          return waitsFor(function() {
            return onReady.callCount > 0;
          }, 'ready not called', 1000);
        });
      });
      it('throws when there is no URL', function() {
        return inject(function(xdmessage) {
          var create, xdm;
          xdm = null;
          provider.setContainer(container);
          create = function() {
            return xdmessage.create();
          };
          return expect(create).toThrow();
        });
      });
      it('throws when there is no container', function() {
        return inject(function(xdmessage) {
          var create, xdm;
          xdm = null;
          create = function() {
            return xdmessage.create('http://localhost:8888/child.html');
          };
          return expect(create).toThrow();
        });
      });
      return it('throws when running with child without XDMessage installed', function() {
        return inject(function(xdmessage) {
          var create, xdm;
          xdm = null;
          provider.setContainer(container);
          create = function() {
            xdm = xdmessage.create('http://www.w3.org/');
            return xdm.run();
          };
          return expect(create).toThrow();
        });
      });
    });
  });

}).call(this);

;