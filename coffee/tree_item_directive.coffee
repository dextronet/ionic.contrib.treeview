angular.module('ionic.contrib.TreeView').directive "treeItem", [
  "$animate"
  "$compile"
  ($animate, $compile) ->
    return (
      restrict: "E"
      controller: [
        "$scope"
        "$element"
        ($scope, $element) ->
          $scope.toggle = ($event, row) ->
            $event.stopPropagation()
            row.item.expanded = !row.item.expanded
            $scope.onExpandChange({ row: row })

          $scope.checkboxClick = ($event, row) ->
            $event.stopPropagation()
            # todo: configurable
            row.item.done = !row.item.done
            $scope.onCheckboxChange({ row: row })

          $scope.rowClick = (row) ->
            $scope.onClick({ row: row })
      ]
      compile: ($element, $attrs) ->
        $element.addClass "item item-complex tree-item"

        link = ($scope, $element, $attrs) ->
          $scope.getTreePadding = (row) ->
            padding = row.level * 40
            return { 'padding-left': padding + 'px' }
          
          $scope.getVisibility = (row) ->
            if row.item.hideExpander
              return 'hidden'
            else
              if row.item.children?.length > 0
                'visible'
              else
                'hidden'

#          if $scope.showNumbers
#          treeItemNumberClass = "tree-item-with-number"
          number = angular.element("<span ng-if=\"showNumbers\" class=\"tree-item-number\">{{row.number.join('.')}}:</span>")
#          else
#            treeItemNumberClass = ""

#          showCheckbox = $scope.row.showCheckbox || ($scope.showCheckboxes && $scope.row.showCheckbox != false)
#          if showCheckbox
#            treeItemCheckboxClass = "tree-item-with-checkbox"
          checkbox = angular.element("<label
            ng-if=\"row.showCheckbox || (showCheckboxes && row.showCheckbox !== false)\"
            class=\"checkbox\"><input type=\"checkbox\" ng-checked=\"row.item.done\" 
            ng-click=\"checkboxClick($event, row)\">
            </label>") 
#          else
#            treeItemCheckboxClass = ""

          containerLink = angular.element("<a 
            class=\"item-content item-icon-right\" 
            ng-class=\"{'tree-item-with-number': showNumbers, 'tree-item-with-checkbox': row.showCheckbox || (showCheckboxes && row.showCheckbox !== false)}\"
            ng-click=\"rowClick(row)\"
            ng-style=\"getTreePadding(row)\"
            ></a>")

          chevron = angular.element("<a class=\"expand-button icon ion-chevron-down\" 
            ng-class=\"{'tree-item-expanded': row.item.expanded}\" 
            ng-style=\"{'visibility': getVisibility(row)}\"
            ng-click=\"toggle($event, row)\"></a>")

          textContainer = angular.element("<span class=\"tree-item-text\"></span>")

          textContainer.append $element.contents()

#          if $scope.showNumbers
          containerLink.append(number)
          
          containerLink.append(checkbox)
          
          containerLink.append(textContainer).append(chevron)

          $element.append containerLink
          $compile(containerLink)($scope)

          return

        return link
    )
]