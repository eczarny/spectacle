$(function() {
  var i = 0,
      n = 11;

  function nextScreenshot() {
    $('#macbook-pro > img').eq(i).fadeOut('slow');
    i = (i + 1) % n;
    $('#macbook-pro > img').eq(i).fadeIn('slow');

    setTimeout(nextScreenshot, 3000);
  }

  $("#macbook-pro > img").not(':eq(' + i + ')').hide();

  setTimeout(nextScreenshot, 3000);
});
