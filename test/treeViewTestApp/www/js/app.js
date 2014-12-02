// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('starter', ['ionic', 'ionic.contrib.TreeView'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if(window.StatusBar) {
      StatusBar.styleDefault();
    }
  });
})

.controller('TestCtrl', function($scope) {
  $scope.items = [
    { id: 1, name: 'Test Item 1', expanded: true, $treeview: { showCheckbox: true }, children: [ 
      { id: 3, name: 'A long label or name for this subitem should work properly', children: 
        [
          { id: 4, name: "Subsubitem", $treeview: { showCheckbox: true } },
          { id: 44, name: "Third degree subtask with long item name" }
        ] 
      } 
    ] },
    { id: 200, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 201, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 202, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 203, name: 'Test Item 2' },
    { id: 204, name: 'Test Item 2' },
    { id: 205, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 206, name: 'Test Item 2' },
    { id: 207, name: 'Test Item 2' },
    { id: 208, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 209, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 210, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 211, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 212, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 213, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 214, name: 'Test Item 2' },
    { id: 215, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 216, name: 'Test Item 2' },
    { id: 217, name: 'Test Item 2' },
    { id: 218, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 219, name: 'Test Item 2' },
    { id: 220, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 221, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 222, name: 'Test Item 2' },
    { id: 223, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 224, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 225, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 226, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 227, name: 'Test Item 2' },
    { id: 228, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 229, name: 'Test Item 2' },
    { id: 230, name: 'Test Item 2', $treeview: { showCheckbox: true } },
    { id: 231, name: 'Test Item 2' }
  ];

  var treeRows = []
  function buildTreeRows(items) {
    items.forEach(function(item) {
      var row = {
        item: item
      };
      treeRows.push(row);
    });
  }

  function init() {
    treeRows = [];
    buildTreeRows($scope.items);
    $scope.tree_items = treeRows;
  }
  
  $scope.checkboxClick = function($event, row) {
    $event.stopPropagation();
    row.item.done = !row.item.done;
  }

  //$scope.$watch("items", init, true);

  $scope.showCheckboxes = false;

  $scope.showNumbers = false;

  $scope.expandChange = function(row) {
    console.log(row);
    console.log('onExpandChange');
  }

  $scope.doneChange = function(row) {
    console.log(row);
    console.log('onCheckboxChange');
  }

  $scope.navigate = function(row) {
    console.log(row);
    console.log('onClick');
  }

  $scope.add = function() {
    $scope.tree_items.push({ id: 5, name: 'Added 1', children: [{ id: 6, name: 'Added 2' }] });
    $scope.tree_items[0].children.push({ id: 7, name: 'Added 3' });
  }

  $scope.expand = function() {
    function expand(items) {
      items.forEach(function(item) {
        item.expanded = true;
        if (item.children) {
          expand(item.children);
        }
      });
    }

    expand($scope.tree_items);
  }

  $scope.collapse = function() {
    function collapse(items) {
      items.forEach(function(item) {
        item.expanded = false;
        if (item.children) {
          collapse(item.children);
        }
      });
    }

    collapse($scope.tree_items);
  }
})

.directive(
    "logCreate",
    function() {

        // I bind the UI to the $scope.
        function link( $scope, element, attributes ) {

            console.log(
                attributes.logCreate,
                $scope.$index
            );

        }


        // Return the directive configuration.
        return({
            link: link
        });

    }
);