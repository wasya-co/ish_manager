

$(document).ready(() => {

  if ($(".email-contexts--form").length) {
    $("#ish_email_context_email_template_id").on('change', (ev) => {
      const val = ev.target.value
      window.location.href = AppRouter.new_email_context_with_template_path(val)
    })

    $("#ish_email_context_type").on('change', (ev) => {
      const val = ev.target.value
      if (val == 'TYPE_CAMPAIGN') {
        $(".email-contexts--form .TYPE_SINGLE").css('display', 'none')
      } else {
        $(".email-contexts--form .TYPE_SINGLE").css('display', 'block')
      }
    })
    // on page load:
    if ($("#ish_email_context_type").val() == 'TYPE_CAMPAIGN') {
      $(".email-contexts--form .TYPE_SINGLE").css('display', 'none')
    } else {
      $(".email-contexts--form .TYPE_SINGLE").css('display', 'block')
    }

  }

})

