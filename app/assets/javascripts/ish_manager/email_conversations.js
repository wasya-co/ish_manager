
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


  $(".delete-btn").click(function(e) {
    const jwt_token = $("#Config").data('jwt-token')
    const action_path = $(this).data('url')
    const out = []

    $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
      let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
      out.push(val)
    })

    $.ajax({
      url: action_path,
      type: 'DELETE',
      data: {
        ids: out,
        jwt_token: jwt_token,
      },
      success: e => {
        logg((e||{}).responseText, 'deleted Ok')
        location.reload()
      },
      error: e => {
        logg((e||{}).responseText, 'deleted Err')
      },
    })

  })

})
