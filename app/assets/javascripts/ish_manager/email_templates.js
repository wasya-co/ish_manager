
$(document).ready(() => {

  if ($(".email-templates--form").length || $(".email-contexts--form").length) {
    $(".tab-labels > a").click(function() {

      $(this).parent().find("a").each((idx, item) => {
        $(item).removeClass('active')
      })
      $( this ).addClass('active')

      $(this).parent().parent().find(".tabs > div").each((idx, item) => {
        $(item).css('display', 'none')
      })
      $(this).parent().parent().find( $(this).data('ref') ).css('display', 'block')
    })
  }

})
