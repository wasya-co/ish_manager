// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require ish_manager/vendor/jquery-3.6.0.min
// require ish_manager/vendor/bootstrap.min
//
//= require ish_manager/vendor/jquery.iframe-transport
//= require ish_manager/vendor/jquery.ui.widget
//= require ish_manager/vendor/jquery.fileupload
//= require ish_manager/vendor/jquery-ui.min
//= require ish_manager/shared
//
//= require_self
//= require ish_manager/maps
//= require ish_manager/email_contexts
//= require ish_manager/email_conversations
//= require ish_manager/email_templates
//= require ish_manager/galleries
//= require ish_manager/iro

const AppRouter = {
  gallery_update_ordering_path: ({ id, slug }) => `/manager/galleries/${slug || id}/update_ordering`,
  new_email_context_with_template_path: (slug) => `/manager/email_contexts/new_with_template/${slug}`,
}

$(function () {

  var fileuploadCount = 0
  $('#fileupload').fileupload({
    dataType: 'json',
    success: function(ev) {
      logg(ev, 'success')
      ev = ev[0]
      fileuploadCount += 1

      var el = $('<div class="item" />')
      var photosEl = $('#photos')

      $('<div/>').html(fileuploadCount).appendTo(el)
      $('<img/>').attr('src', ev.thumbnail_url).appendTo(el)
      $('<div/>').html(ev.name).appendTo(el)
      el.appendTo(photosEl)
    },
    error: function(err) {
      logg(err, 'error')
      err = err.responseJSON
      fileuploadCount += 1

      var el = $('<div class="item" />')
      var errorsEl = $('.photos--multinew .errors')

      $('<div/>').html(fileuploadCount).appendTo(el)
      $('<div />').html(err.filename).appendTo(el)
      $('<div />').html(err.message).appendTo(el)
      el.appendTo(errorsEl)
    },
  });

  $('*[data-confirm]').click(function(){
    return confirm($(this).attr('data-confirm'));
  });

  if ($(".tinymce").length > 0) {
    tinymce.init({
      mode: "specific_textareas",
      editor_selector: 'tinymce',
      plugins: 'link'
    });
  }

  $(".caret").each(function(idx) {
    $($(".caret")[idx]).html('')
  })


  /*
   * material_select & select2
  **/
  if ($('body').length > 0) {
    if ('function' === typeof $('body').material_select ) {
      $('select').material_select()
    }
    if (!!$('body').select2) {
      $('.select2').each(function() {
        $( this ).select2({
          width: 'auto',
        })
      })
    }
  }

  $(".close").click(function(ev) {
    $(this).parent().slideToggle()
  })

  $(".collapse-expand").each(function() {
    const thisId = $(this).attr('id')
    const state = localStorage.getItem("collapse-expand#"+thisId)
    if (state === 'collapsed') {
      $(this).next().slideToggle()
      $(this).addClass('collapsed')
    }
  })
  $(".collapse-expand").click(function (_e) {
    const thisId = $(this).attr('id')
    const state = localStorage.getItem("collapse-expand#"+thisId)
    if (state === 'collapsed') {
      localStorage.removeItem("collapse-expand#"+thisId)
      $(this).removeClass('collapsed')
    } else {
      localStorage.setItem("collapse-expand#"+thisId, "collapsed")
      $(this).addClass('collapsed')
    }
    $(this).next().slideToggle();
  }).children().click(function (e) {
    e.stopPropagation()
  })

  $(".expand-next").click(function (_e) {
    $(this).next().slideToggle()
  })

  if ('function' === typeof $('body').DataTable) {
    const _props = {
      pageLength: 10,
      lengthMenu: [[10, 25, 100, -1], [10, 25, 100, 'All']],
      lengthChange: true,
    }
    $('#dataTable').DataTable(_props)
    $('.data-table').DataTable(_props)
  }

  if ('function' === typeof $('body').datepicker) {
    $(".datepicker").datepicker({ dateFormat: 'yy-mm-dd' })
  }

  // From: https://materializecss.com/select.html
  if ('function' === typeof $('select').formSelect) {
    $('select').formSelect();
  }

  //
  // select-all
  // _vp_ 2023-02-28

  $("input[type='checkbox'].i-sel").change(() => {
    $( $(".n-selected")[0] ).html( $("input[type='checkbox'].i-sel:checked").length )
  })

  $(".select-all input[type='checkbox']").change((e) => {
    const count = $("input[type='checkbox'].i-sel:checked").length
    const new_state = count ? false : true // all will be checked?

    $(".select-all input[type='checkbox']").prop('checked', new_state)

    $( $("input[type='checkbox'].i-sel") ).each( i => {
      $( $("input[type='checkbox'].i-sel")[i] ).prop('checked', new_state)
    })

    $( $(".n-selected")[0] ).html( $("input[type='checkbox'].i-sel:checked").length )
  })


});

