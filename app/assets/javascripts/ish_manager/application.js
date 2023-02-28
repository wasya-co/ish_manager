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
//= require ish_manager/vendor/jquery.iframe-transport
//= require ish_manager/vendor/jquery.ui.widget
//= require ish_manager/vendor/jquery.fileupload
//= require ish_manager/vendor/jquery-ui.min
//= require ish_manager/shared
//
//= require ish_manager/maps
//= require ish_manager/email_contexts

$(function () {

  $('#fileupload').fileupload({
    dataType: 'json',
    done: function (e, data) {
      var photos = $('#photos');
      var tempUrl = data.result[0].thumbnail_url;
      $('<img/>').attr('src', tempUrl).appendTo(photos);
    }
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
      $('.select2').select2({
        width: 'element'
      })
    }
  }


  $(".collapse-expand").each(function(idx, obj) {
    const thisId = $(this).attr('id')
    const state = localStorage.getItem("collapse-expand#"+thisId)
    if (state === 'collapsed') {
      $(this).next().slideToggle();
    }
  })
  $(".collapse-expand").click(function (_e) {
    const thisId = $(this).attr('id')
    const state = localStorage.getItem("collapse-expand#"+thisId)
    if (state === 'collapsed') {
      localStorage.removeItem("collapse-expand#"+thisId)
    } else {
      localStorage.setItem("collapse-expand#"+thisId, "collapsed")
    }
    $(this).next().slideToggle();
  }).children().click(function (e) {
    e.stopPropagation()
  })


  if ('function' === typeof $('body').DataTable) {
    const _props = {
      pageLength: 10,
      lengthMenu: [[10, 25, 100, -1], [10, 25, 100, 'All']],
      lengthChange: true,
      "aLengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]]
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

  if ($(".data-table").length) {
    $("input[type='checkbox'].i-sel").change(() => {
      $( $(".n-selected")[0] ).html( $("input[type='checkbox'].i-sel:checked").length )
    })
  }

  $("button.delete-btn").click(e => {
    let out = []

    $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
      let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
      out.push(val)
    })

    $.ajax({
      url: '/api/leadsets',
      type: 'DELETE',
      data: { leadset_ids: out },
      success: e => {
        logg(e, 'deleted Ok')
      },
      error: e => {
        logg(e, 'deleted Err')
      },
    })

  })

  $(".select-all input[type='checkbox']").change((e) => {
    const count = $("input[type='checkbox'].i-sel:checked").length
    const new_state = count ? false : true

    $( $("input[type='checkbox'].i-sel") ).each( i => {
      $( $("input[type='checkbox'].i-sel")[i] ).prop('checked', new_state)
    })

    $( $(".n-selected")[0] ).html( $("input[type='checkbox'].i-sel:checked").length )
  })

});

