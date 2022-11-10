
AppRouter = {
  new_email_context_with: (slug) => `/manager/email_contexts/new_with/${slug}`
}

$(document).ready(() => {

  if ($(".email-contexts--form").length) {
    $("#ish_email_context_email_template_id").on('change', (ev) => {
      const val = ev.target.value
      window.location.href = AppRouter.new_email_context_with(val)
    })
  }

})

