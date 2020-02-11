window.onload = function() {
  // If animation is required on page load, add slide out class
  jQuery('.animate-on-load').addClass('slide-out');
  // On click of X, remove slide out class
  jQuery('.X-cancel-button').click(function() {
    jQuery('.welcome-panel').toggle();
  });
  // On click of button, disable it and add the animate class
  jQuery('.btnAddMeeting').click(function() {
    jQuery(this).attr('disabled', true);
  });

  function confetti() {
    // For each confetti div
    $.each($('.particletext.confetti'), function() {
      // Calculate number of confetti pieces relative to the width of the container
      const confetticount = ($(this).width() / 50) * 10;
      // Create random individual confetti pieces and append to dom
      for (let i = 0; i <= confetticount; i += 1) {
        $(this).append(
          `<span class="particle c${$.rnd(1, 3)}" style="top:${$.rnd(
            75,
            98
          )}%; left:${$.rnd(0, 98)}%;width:${$.rnd(10, 12)}px; height:${$.rnd(
            5,
            6
          )}px;animation-delay: ${$.rnd(0, 30) / 10}s;"></span>`
        );
      }
    });
  }
  // Call Confetti function when ready
  confetti();
};

// Button Feedback
$(function() {
  $('.btnAddMeeting, .btnBookAvailable').click(function() {
    let button = $(this);
    $(this).addClass('tapped');
    setInterval(function(){
      setTimeout(function () {
        button.attr("data-message","BOOKING..");
      }, 500);
      setTimeout(function () {
        button.attr("data-message","BOOKING...");
      }, 1000);
      setTimeout(function () {
        button.attr("data-message","BOOKING.");
      }, 1500);
    }, 500);
  });
});

// Random Number Function
jQuery.rnd = function(m, n) {
  const mm = parseInt(m);
  const nn = parseInt(n);
  return Math.floor(Math.random() * (nn - mm + 1)) + mm;
};
