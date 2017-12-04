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
//= require ish_manager/jquery-3.2.1.min
//= require ish_manager/bootstrap.min
//= require ish_manager/jquery.iframe-transport
//= require ish_manager/jquery.ui.widget
//= require ish_manager/jquery.fileupload
//

$(function () {
  $('#fileupload').fileupload({
    dataType: 'json',
    done: function (e, data) {
      var photos = $('#photos');
      var tempUrl = data.result[0].thumbnail_url;
      $('<img/>').attr('src', tempUrl).appendTo(photos);
    }
  });  
});

$(document).ready(function () {
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
  
  $('select').material_select()

  $(".caret").each(function(idx) {
    $($(".caret")[idx]).html('')
  })

  var mainHeaderContext = $(".manager--main-header")
  $(".manager--main-header #collapseHeader").click(function (_e) {
    if ($(this).hasClass('fa-compress')) {
      $(this).addClass('fa-expand')
      $(this).removeClass('fa-compress')
      localStorage.setItem('mainHeaderCollapsed', 'true')
      $('.content', $(this).parent()).css('display', 'none')
    } else {
      $(this).removeClass('fa-expand')
      $(this).addClass('fa-compress')
      localStorage.setItem('mainHeaderCollapsed', 'false')
      $('.content', $(this).parent()).css('display', 'block')
    }    
  })
  if (localStorage.getItem('mainHeaderCollapsed') === 'true') {
    console.log('here')
    $("#collapseHeader").addClass('fa-expand')
    $("#collapseHeader").removeClass('fa-compress')
    $(".content", mainHeaderContext).css("display", 'none')
  }

});
 
