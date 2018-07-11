window.onload = function() {
	//If animation is required on page load, add slide out class
	jQuery('.animate-on-load').addClass('slide-out');
	//On click of X, remove slide out class
	jQuery("#close-welcome-message").click(function(){
		jQuery('.welcome-panel').removeClass('stay-there');
		jQuery('.welcome-panel').removeClass('slide-out');
	});
};
