window.onload = function() {
	//If animation is required on page load, add slide out class
	jQuery('.animate-on-load').addClass('slide-out');
	//On click of X, remove slide out class
	jQuery("#close-welcome-message").click(function(){
		console.log("WORKING");
		jQuery('.welcome-panel').removeClass('stay-there');
		jQuery('.welcome-panel').removeClass('slide-out');
	});
	jQuery(".btnAddMeeting").click(function(){
		jQuery(this).attr("disabled", true);
	});

	function confetti() {
  	//For each confetti div
	  $.each($(".particletext.confetti"), function(){
	      //Calculate number of confetti pieces relative to the width of the container
	      var confetticount = ($(this).width()/50)*10;
	      //Create random individual confetti pieces and append to dom
	      for(var i = 0; i <= confetticount; i++) {
	       $(this).append('<span class="particle c' + $.rnd(1,3) + '" style="top:' + $.rnd(75,98) + '%; left:' + $.rnd(0,98) + '%;width:' + $.rnd(10,12) + 'px; height:' + $.rnd(5,6) + 'px;animation-delay: ' + ($.rnd(0,30)/10) + 's;"></span>');
	      }
	  });
  }
	//Call Confetti function when ready
	confetti();

}
// Random Number Function
    jQuery.rnd = function(m,n) {
          m = parseInt(m);
          n = parseInt(n);
          return Math.floor( Math.random() * (n - m + 1) ) + m;
    }
