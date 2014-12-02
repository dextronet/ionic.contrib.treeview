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
      template: "<tree-item ng-style=\"{width: fullWidth}\" 
        collection-item-width=\"'100%'\" collection-item-height=\"itemHeight\" 
        collection-repeat=\"row in treeRows | filter:filterExpanded() track by row.id\" 
        row=\"row\">{{row.name}}</tree-item>",
      scope: 
        onExpandChange: '&'
        onCheckboxChange: '&'
        onClick: '&'
        items: '='
        showCheckboxes: '='
        showNumbers: '='
        fetchData: '=',
        hasMoreData: '=',
        itemHeight: '='
      compile: ($element, $attr) ->
        listEl = angular.element("<div class=\"tree-view list\">").append($element.contents())
        infiniteScroll = angular.element("<ion-infinite-scroll ng-if=\"hasMoreData()\" on-infinite=\"fetchData()\" distance=\"1%\">")
        $element.append(listEl).append(infiniteScroll);
        
        ($scope, $element, $attrs, ctrls) ->
          treeRows = []
          $scope.fullWidth = '100%';

          $scope.filterExpanded = ->
            (row) -> row.$treeview.visible is true
          
          buildTreeRows = (items, level, number, visible) ->
            # set custom 
            if $attrs.scrollHeight
              $element.parent()[0]?.style.height = $attrs.scrollHeight;
            
            number = [] unless number
            
            for item, index in items
              rowNumber = number.slice()
              rowNumber.push index + 1
              
              # Allow predefining some config option from outside this directive.
              item.$treeview = {} unless item.$treeview

              # Non-customizable config options
              item.$treeview.level = level
              item.$treeview.rowNumber = rowNumber
              
              # Customizable config option
              item.$treeview.showCheckbox = null if item.$treeview.showCheckbox is undefined
              item.$treeview.visible = if item.visible is false then false else visible
              item.$treeview.checked = false if item.$treeview.checked is undefined
              item.$treeview.hideExpander = if item.hideExpander isnt undefined then item.hideExpander else false
              item.expanded = false if item.expanded is undefined

              treeRows.push item
              
              childrenVisible = visible and item.expanded
              buildTreeRows item.children, level + 1, rowNumber, childrenVisible if item.children

          init = ->
            #console.log 'REBUILD'
            treeRows = []
            buildTreeRows $scope.items, 0, null, true
            $scope.treeRows = treeRows

          $scope.$watch 'items', init, true

          return
    )
]