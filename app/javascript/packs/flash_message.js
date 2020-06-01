document.addEventListener("turbolinks:load", () => {
  setTimeout("$('.flash-message').fadeOut('slow')", 2000);
});
