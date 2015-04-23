/* Intialize */
var InquirlyApp = angular.module('InquirlyApp', ['ngRoute']);
 
InquirlyApp.controller('navController', function($scope, $location) {
    $scope.isActive = function(route) {
        return route === $location.path();
    }
});

/* Left Navigation Routes */
InquirlyApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/home', {
        templateUrl: '../assets/home/index.html',
        controller: 'HomeController'
    }).
      when('/campaigns', {
        templateUrl: '../assets/campaigns/index.html',
        controller: 'CampaignsController'
      }).
      when('/listen', {
        templateUrl: '../assets/listen/index.html',
        controller: 'ListenController'
      }).
      when('/configure', {
        templateUrl: '../assets/configure/index.html',
        controller: 'ConfigureController'
      }).
      when('/alerts', {
            templateUrl: '../assets/alerts/index.html',
            controller: 'AlertsController'
      }).
      otherwise({
        redirectTo: '/home'
      });
}]);


InquirlyApp.controller('HomeController', function($scope) {
    $scope.message = 'This is home screen';
});

InquirlyApp.controller('CampaignsController', function($scope) {
    $scope.message = 'This is campaigns screen';
});

InquirlyApp.controller('ListenController', function($scope) {
    $scope.message = 'This is listen screen';
});

InquirlyApp.controller('ConfigureController', function($scope) {
    $scope.message = 'This is configure screen';
});

InquirlyApp.controller('AlertsController', function($scope) {
    $scope.message = 'This is alerts screen';
});
