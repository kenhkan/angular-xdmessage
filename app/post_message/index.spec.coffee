describe 'postMessage', ->
  controller = null
  directive = null
  template = null
  scope = null

  beforeEach angular.mock.module 'xdmessage'

  beforeEach inject ($rootScope, $controller, $window) ->
    template = '''
      <post-message
        remote-url="remoteUrl"
        event-name="eventName"
        post-message-exports="postMessage"
      ></post-message>
    '''
    $window.self = $window.top
    scope = $rootScope.$new()
    scope.postMessage = {}

  describe 'checking sanity', ->

    it 'expects a remoteUrl and an eventName', ->
      inject ($compile) ->
        scope.remoteUrl = 'http://localhost:8888/'
        scope.eventName = 'event'
        scope.postMessage.onMessage = ->
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
          scope.postMessage.onReady = ->
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

          scope.postMessage.onReady = ->
            element.scope().postMessage.sendMessage
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
          scope.postMessage.onMessage = (data) ->
            ret = data

          scope.postMessage.onReady = ->
            element.scope().postMessage.sendMessage 'message'

          element = $compile(template) scope

        waitsFor ->
          ret is 'message'
        , 'nothing was received', 100
