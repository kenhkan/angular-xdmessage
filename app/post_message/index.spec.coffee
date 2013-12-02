describe 'postMessage', ->
  controller = null
  directive = null
  template = null
  scope = null

  beforeEach angular.mock.module 'xdmessage'

  beforeEach inject ($rootScope, $controller, $window) ->
    template = '''
      <div post-message="postMessage"
           remote-url="remoteUrl"
           event-name="eventName"
           send-message="sendMessage"
      ></div>
    '''
    $window.self = $window.top
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

  describe 'while communicating', ->

    it 'is notified when ready', ->
      inject ($compile) ->
        isReady = false

        runs ->
          scope.remoteUrl = 'http://localhost:8888/'
          scope.eventName = 'echo'
          scope.xdmReady = ->
            isReady = true
          element = $compile(template) scope

        waitsFor ->
          isReady
        , 'never ready', 100

    it 'sends a message', ->
      inject ($compile) ->
        ret = null

        runs ->
          scope.remoteUrl = 'http://localhost:8888/'
          scope.eventName = 'echo'

          scope.xdmReady = ->
            element.scope().sendMessage
              test: 'message'
            , (data) ->
              ret = data

          element = $compile(template) scope

        waitsFor ->
          ret?.test is 'message'
        , 'nothing has returned', 100

    it 'receives a message', ->
      inject ($compile) ->
        ret = null

        runs ->
          scope.remoteUrl = 'http://localhost:8888/'
          scope.eventName = 'yes'
          scope.onMessage = (data) ->
            ret = data

          scope.xdmReady = ->
            element.scope().sendMessage 'message'

          element = $compile(template) scope

        waitsFor ->
          ret is 'message'
        , 'nothing was received', 100
