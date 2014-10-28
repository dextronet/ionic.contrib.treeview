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
  $scope.tree_items = [
    { id: 1, name: 'Test Item 1', expanded: true, showCheckbox: true, children: [ 
      { id: 3, name: 'A long label or name for this subitem should work properly', children: 
        [
          { id: 4, name: "Subsubitem", showCheckbox: true },
          { id: 44, name: "Third degree subtask with long item name" }
        ] 
      } 
    ] },
    { id: 2, name: 'Test Item 2' }
  ];

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
});