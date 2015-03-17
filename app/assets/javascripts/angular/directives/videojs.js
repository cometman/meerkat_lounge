angular.module('app.meerkatSearch').directive('videojs', [function () {
  return {
      restrict: 'A',
      link: function (scope, element, attrs) {
          attrs.type = attrs.type || "video/mp4";
          attrs.id = attrs.id || "videojs" + Math.floor(Math.random() * 100);
          attrs.setup = attrs.setup || {};
          var setup = {
              'techOrder': ['html5', 'flash'],
              'controls': true,
              'preload': 'auto',
              'autoplay': false,
              'height': 400,
              'width': "100%",
              'poster': '',
          };

          setup = angular.extend(setup, attrs.setup);
          l(setup)
          element.attr('id', attrs.id);

          var player = videojs(attrs.id, setup, function() {
              this.src({
                  type: attrs.type,
                  src: attrs.src
              });
          });
      }
  };
}]);