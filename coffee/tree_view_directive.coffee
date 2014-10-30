angular.module('ionic.contrib.TreeView', ['ionic'])
.directive "treeView", [
  "$animate"
  "$compile"
  "$timeout"
  ($animate, $compile, $timeout) ->
    return (
      restrict: "E"
      require: [
        "^?$ionicScroll"
      ]
      #controller: "$treeView"
      template: "<tree-item 
        ng-repeat=\"row in treeRows | filter:{visible:true} track by row.item.id\" row=\"row\">{{row.item.name}}</tree-item>"
      scope: 
        onExpandChange: '&'
        onCheckboxChange: '&'
        onClick: '&'
        items: '='
        showCheckboxes: '='
        showNumbers: '='
      compile: ($element, $attr) ->
        listEl = angular.element("<div class=\"tree-view list\">").append($element.contents())
        $element.append listEl
        
        ($scope, $element, $attrs, ctrls) ->

          buildTreeRows = (items, level, number, visible) ->
            # set custom 
            if $attrs.scrollHeight
              $element.parent()[0]?.style.height = $attrs.scrollHeight;
            
            number = [] unless number
            for item, index in items
              rowNumber = number.slice()
              rowNumber.push index + 1
              row =
                item: item
                level: level
                number: rowNumber
                showCheckbox: item.showCheckbox
              if item.visible == false
                row.visible = item.visible
              else
                row.visible = visible
              $scope.treeRows.push row
              childrenVisible = visible and item.expanded
              buildTreeRows item.children, level + 1, rowNumber, childrenVisible if item.children

          init = ->
            $scope.treeRows = []
            buildTreeRows $scope.items, 0, null, true

          $scope.$watch 'items', init, true

            #listEl.append $compile(angular.element("<tree-item>#{item.name}</tree-item>"), item)($scope)

          #$timeout init

          return
    )
]