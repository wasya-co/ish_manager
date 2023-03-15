
$(document).ready(() => {

  $("body.email_conversations-show a.preview").click(function(e) {
    // logg(e, 'clicked')

    if ($(this).data('expanded')) {
      $(this).parent().find(".expand").html('')
      $(this).parent().find(".my-actions").addClass('hide')
      $(this).data('expanded', false)
      return
    }

    const action_path = "/api/email_messages/" + $(this).data('id')

    $.ajax({
      url: action_path,
      type: 'GET',
      data: {
        jwt_token: $( $("#Config")[0] ).data('jwt-token'),
      },
      success: e => {
        $(this).parent().find(".expand").html(e.item.part_html)
        $(this).parent().find(".my-actions").removeClass('hide')
        $(this).data('expanded', true)
      },
      error: e => {
        logg((e||{}).responseText, 'cannot get email_message')
      },
    })
  })

})
