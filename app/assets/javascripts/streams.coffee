# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
angular.element(document).ready ->
	# Disable space bar scrolling 

	is_showing = false
	angular.element(".main").scope().recent_key_pressed = false
	$("#mainsearch").hide()

	startRemove = ->
		if angular.element(".main").scope().recent_key_pressed == false
			$(".main").removeAttr('style')
			$("#mainsearch").hide()
			$("section").removeClass('stop-scrolling')
			console.log "hidding no recent key"

	$(document).keydown (e) ->
		console.log angular.element(".main").scope().search
		angular.element(".main").scope().recent_key_pressed = true
		if $("#mainsearch").css('display') == "none" && e.metaKey == false
			is_showing = true
			$(".main").css('-webkit-filter', "blur(3px)")
			$(".main").css('-moz-filter', "blur(3px)")
			$("#mainsearch")[0].value = ""
			# Disable scrolling while searching
			$("section").addClass('stop-scrolling')
			$("#mainsearch").show()
			#angular.element(".main").scope().search += String.fromCharCode(e.keyCode);
		else if is_showing == true && e.keyCode == 13
			$("#mainsearch").hide()
			is_showing = false
			$(".main").removeAttr('style')
			$("section").removeClass('stop-scrolling')
			return
		if is_showing == true
			console.log e
			$("#mainsearch").focus()
			setTimeout ( ->
				angular.element(".main").scope().recent_key_pressed = false
				startRemove()
			), 3000
		return
	$(".searchtop").click ->
		angular.element(".main").scope().recent_key_pressed = true
		if $("#mainsearch").css('display') == "none"
			is_showing = true
			$(".main").css('-webkit-filter', "blur(3px)")
			$(".main").css('-moz-filter', "blur(3px)")
			$("#mainsearch")[0].value = ""
			# Disable scrolling while searching
			$("section").addClass('stop-scrolling')
			$("#mainsearch").show()
			#angular.element(".main").scope().search += String.fromCharCode(e.keyCode);
		else if is_showing == true
			$("#mainsearch").hide()
			is_showing = false
			$(".main").removeAttr('style')
			$("section").removeClass('stop-scrolling')
			return
		if is_showing == true
			$("#mainsearch").focus()
			setTimeout ( ->
				angular.element(".main").scope().recent_key_pressed = false
				startRemove()
			), 3000
		return
	
#-webkit-filter: blur(3px);
#-moz-filter: blur(3px);
