
$(document).ready(() => {

  if ($(".email-templates--form").length) {
    $(".tab-labels > a").click(function() {
      logg( $(this).data('ref'), 'ref')

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