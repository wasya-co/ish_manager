
const AppRouter = {
  gallery_update_ordering_path: ({ id, slug }) => `/manager/galleries/${slug || id}/update_ordering`,
}
$(document).ready(function () {

  if ( $(".orderable-items").length ) {
    if ($(".orderable-items").length > 1) {
      logg("There are many .orderable-items! This was only meant to work with one.")
    }
    // let slug = $( $(".orderable-items")[0] ).data('slug')
    let id = $( $(".orderable-items")[0] ).data('id')
    let token = $( $(".orderable-items")[0] ).data('token')

    $(".orderable-items .items > div").each(function (idx, item) {
      let $el = $(this)

      $(this).find('a.mvLeft').click(function() {
        // move element up one step
        if ($el.not(':first-child'))
          $el.prev().before($el);
      })

      $(this).find('a.mvRight').click(function() {
        // move element down one step
        if ($el.not(':last-child'))
            $el.next().after($el);
      })

    })
    $(".save-ordering").click(function() {

      let els = $(this).parent().find(".items .item")
      let ids = []
      $(els).map((idx, item) => {
        ids.push( $(item).data('id') )
      })

      $.ajax({
        type: 'PATCH',
        url: AppRouter.gallery_update_ordering_path({ id: id }),
        data: {
          authenticity_token: token,
          gallery: {
            sorted_photo_ids: ids,
          },
        },
        success: (e) => {
          logg('success')
        },

      })

      logg('ok')
    })
  }

})

/*
//element to move
var $el = $(selector);

//move element down one step
if ($el.not(':last-child'))
    $el.next().after($el);

//move element up one step
if ($el.not(':first-child'))
    $el.prev().before($el);

//move element to top
$el.parent().prepend($el);

//move element to end
$el.parent().append($el);
*/

