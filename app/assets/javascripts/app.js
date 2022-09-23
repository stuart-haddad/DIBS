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

// Book Button Click Function
$('.btnAddMeeting, .btnBookAvailable').on("click", function(e) {
  let button = $(this);
  let busyMessage = "BOOKING.";
  // Prevent Multiple Taps
  if (button.hasClass('tapped'))
    e.preventDefault();
  button.addClass('tapped');
  // Dot-Dot-Dot Busy Button Feedback - D3B2F
  setInterval(function() {
    if (busyMessage.length === 10)
      busyMessage = "BOOKING.";
    else
      busyMessage = busyMessage.concat(".");
    button.attr("data-message", busyMessage);
  }, 500);
});


// Random Number Function
jQuery.rnd = function(m, n) {
  const mm = parseInt(m);
  const nn = parseInt(n);
  return Math.floor(Math.random() * (nn - mm + 1)) + mm;
};
