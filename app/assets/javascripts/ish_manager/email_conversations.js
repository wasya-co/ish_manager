
$(document).ready(() => {

  $("body.email_conversations-show a.preview").click(function(e) {
    // logg(e, 'clicked')

    if ($(this).data('expanded')) {
      $(this).data('expanded', false)
      $(this).parent().find(".my-actions").addClass('hide')
      $(this).parent().find("iframe").css('display', 'none')
    } else {
      $(this).data('expanded', true)
      $(this).parent().find(".my-actions").removeClass('hide')
      $(this).parent().find("iframe").css('display', 'block')
    }

  })

})
