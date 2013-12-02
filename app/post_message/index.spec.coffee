describe 'postMessage', ->
  directive = null
  template = null
  scope = null

  beforeEach angular.mock.module 'postMessage'

  beforeEach inject ($rootScope, $controller) ->
    template = '<div postMessage></div>'
    scope = $rootScope.$new()

  describe 'checking sanity', ->

    it 'expects a remoteUrl', ->
      link = ->
        element = $compile(template) scope
      expect(link).toThrow()

    it 'expects an eventName', ->
      scope.remoteUrl = 'http://localhost:8888/'
      link = ->
        element = $compile(template) scope
      expect(link).toThrow()

    it 'expects a sendMessage', ->
      inject ($compile) ->
        scope.remoteUrl = 'http://localhost:8888/'
        scope.eventName = 'event'
        scope.sendMessage = ->
        link = ->
          element = $compile(template) scope
        expect(link).not.toThrow()

    it 'expects an onMessage if there is no sendMessage', ->
      inject ($compile) ->
        scope.remoteUrl = 'http://localhost:8888/'
        scope.eventName = 'event'
        scope.onMessage = ->
        link = ->
          element = $compile(template) scope
        expect(link).not.toThrow()
