
$(document).ready(() => {

  $("body.email_conversations-show .preview-btn").click(function(e) {
    // logg($(this).data(), 'clicked')

    var msgId = $(this).data().msg.id
    var msgC = $(`.msg-container[data-msg-id='${msgId}']`) // msgContainer

    if ($(msgC).data('expanded')) {
      $(msgC).data('expanded', false)
      msgC.find(".to-expand").css('display', 'none')
    } else {
      $(msgC).data('expanded', true)
      msgC.find(".to-expand").css('display', 'block')
    }

  })

  $(".archive-btn").click(function(e) {
    if ( !confirm('Are you sure?') ) { return; }

    const jwt_token = $("#Config").data('jwt-token')
    const action_path = $(this).data('url')
    const out = []

    $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
      let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
      out.push(val)
    })

    $.ajax({
      url: action_path,
      type: 'POST',
      data: {
        ids: out,
        jwt_token: jwt_token,
      },
      success: e => {
        logg((e||{}).responseText, 'archived Ok')
        location.reload()
      },
      error: e => {
        logg((e||{}).responseText, 'archived Err')
      },
    })

  })

  $(".add-tag-btn").click(function(e) {
    if ( !confirm('Are you sure?') ) { return; }

    const jwt_token = $("#Config").data('jwt-token')
    const action_path = $(this).data('url')
    const emailtag = $("select[name='emailtag']").val()
    const out = []

    $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
      let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
      out.push(val)
    })

    $.ajax({
      url: action_path,
      type: 'POST',
      data: {
        ids: out,
        jwt_token: jwt_token,
        emailtag: emailtag,

      },
      success: e => {
        logg((e||{}).responseText, 'Ok')
        location.reload()
      },
      error: e => {
        logg((e||{}).responseText, 'Err')
      },
    })

  })

  $(".remove-tag-btn").click(function(e) {
    if ( !confirm('Are you sure?') ) { return; }

    const jwt_token = $("#Config").data('jwt-token')
    const action_path = $(this).data('url')
    const emailtag = $("select[name='emailtag']").val()
    const out = []

    $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
      let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
      out.push(val)
    })

    $.ajax({
      url: action_path,
      type: 'POST',
      data: {
        ids: out,
        jwt_token: jwt_token,
        emailtag: emailtag,

      },
      success: e => {
        logg((e||{}).responseText, 'Ok')
        location.reload()
      },
      error: e => {
        logg((e||{}).responseText, 'Err')
      },
    })

  })

  $(".delete-btn").click(function(e) {
    if ( !confirm('Are you sure?') ) { return; }

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
