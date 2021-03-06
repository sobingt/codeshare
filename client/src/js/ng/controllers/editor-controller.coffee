define [
  './module'
], (module) ->
  module.controller('EditorController', [
    '$scope',
    '$http'
    ($scope, $http) ->
      #
      # Wire up ShareJS
      #
      editor = ace.edit('editor')
      testEditor = ace.edit('testEditor')
      compileOutputArea = ace.edit('compileOutput')
      runOutputArea = ace.edit('runOutput')

      sharejs.open('hello', 'text', (error, doc) ->
        if (error) then console.log("error loading document: ", error)
        else doc.attach_ace(editor))
      sharejs.open('tests', 'text', (error, doc) ->
        if (error) then console.log("error loading document: ", error)
        else doc.attach_ace(testEditor))
      sharejs.open('compileOutput', 'text', (error, doc) ->
        if (error) then console.log("error loading document: ", error)
        else doc.attach_ace(compileOutputArea))
      sharejs.open('runOutput', 'text', (error, doc) ->
        if (error) then console.log("error loading document: ", error)
        else doc.attach_ace(runOutputArea))

      $scope.compileOutput = ""
      $scope.runOutput = ""

      $scope.compile = ->
        compileOutputArea.getSession().setValue("")
        runOutputArea.getSession().setValue("")

        payload =
          java: editor.getSession().getValue()
          tests: testEditor.getSession().getValue()

        $http.post("http://localhost:9000/services/execute_java", payload)
          .success((data, status, headers, config) ->
            compOut = data.compileOutput
            runOut = data.runOutput
            compileOutputArea.getSession().setValue(compOut)
            runOutputArea.getSession().setValue(runOut)

            $scope.data = data
          ).error((data, status, headers, config) ->
            $scope.status = status
          )

      $scope.aceChanged = (text) ->
  ])