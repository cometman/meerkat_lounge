// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require angular
//= require angular-rails-templates

//= require_tree angular/templates
//= require_tree angular/modules
//= require_tree angular/filters
//= require_tree angular/directives
//= require_tree angular/models
//= require_tree angular/services
//= require_tree angular/controllers
//= require_tree angular/lib
//= require angular/app

//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });

videojs.options.flash.swf = "http://www.flashls.org/videojs/video-js.swf";