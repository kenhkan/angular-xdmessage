describe 'xdmessage', ->
  module = null
  provider = null

  beforeEach ->
    test = angular.module 'test', []
    test.config (xdmessageProvider) ->
      provider = xdmessageProvider

    angular.mock.module 'xdmessage', 'test'

  it 'checks for sanity', ->
    expect(provider).not.toBeUndefined()

  describe 'as a host frame', ->
    container = null

    beforeEach ->
      container = document.createElement 'div'

    it 'sets a container in provider and a URL in service', ->
      inject (xdmessage) ->
        xdm = null
        onReady = null

        runs ->
          provider.setContainer container
          xdm = xdmessage.create 'http://localhost:8888/child.html'
          onReady = jasmine.createSpy 'onReady'
          xdm.on 'ready', onReady
          xdm.open()

        waitsFor ->
          onReady.callCount > 0
        , 'ready not called', 1000

    it 'throws when there is no URL', ->
      inject (xdmessage) ->
        xdm = null

        provider.setContainer container
        create = ->
          xdmessage.create()
        expect(create).toThrow()

    it 'throws when there is no container', ->
      inject (xdmessage) ->
        xdm = null

        create = ->
          xdmessage.create 'http://localhost:8888/child.html'
        expect(create).toThrow()

    it 'throws when running with child without XDMessage installed', ->
      inject (xdmessage) ->
        xdm = null

        provider.setContainer container
        create = ->
          xdm = xdmessage.create 'http://www.w3.org/'
          xdm.run()
        expect(create).toThrow()
