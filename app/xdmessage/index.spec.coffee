describe 'xdmessage', ->
  beforeEach ->
    angular.mock.module 'xdmessage'

  describe 'as a host frame', ->
    container = null

    beforeEach ->
      inject ($window) ->
        $window.self = $window.top
        container = document.createElement 'div'

    it 'sets a container in provider and a URL in service', ->
      inject (xdmessage) ->
        xdm = null
        onReady = null

        runs ->
          xdm = xdmessage.create 'http://localhost:8888/',
            container: container
          onReady = jasmine.createSpy 'onReady'
          xdm.on 'ready', onReady
          xdm.open()

        waitsFor ->
          onReady.callCount > 0
        , 'ready not called', 500

    it 'throws when there is no URL', ->
      inject (xdmessage) ->
        create = ->
          xdmessage.create null,
            container: container
        expect(create).toThrow()

    it 'throws when there is no container', ->
      inject (xdmessage) ->
        create = ->
          xdmessage.create 'http://localhost:8888/'
        expect(create).toThrow()

    it 'throws when running with child without XDMessage installed', ->
      inject (xdmessage) ->
        create = ->
          xdm = xdmessage.create 'http://www.w3.org/',
            container: container
          xdm.run()
        expect(create).toThrow()
