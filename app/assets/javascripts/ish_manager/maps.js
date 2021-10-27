
/*
 * only for maps map editor
 */
$(document).ready(() => {
  if (!$("body.maps-map_editor").length) { return }
  logg('maps#map_editor')

  const mapEditorEl = $(".maps-map-editor .map-editor")
  const mapEditorX = mapEditorEl.offset().left
  const mapEditorY = mapEditorEl.offset().top

  $(".maps-map-editor .map-editor .marker").each(function() {
    const m = $(this)
    const centerOffsetX = parseInt(m.attr('data-center-offset-x'))
    const centerOffsetY = parseInt(m.attr('data-center-offset-y'))
    const slug = m.attr('data-slug')
    logg(slug, 'slug')

    $(m).draggable({
      drag: function () {
        const x = $(this).offset().left - mapEditorX + centerOffsetX
        const y = $(this).offset().top - mapEditorY + centerOffsetY
        logg(`${x}, ${y}`, 'marker')
        $(`.${slug} input[name='gameui_marker[x]']`).val(x)
        $(`.${slug} input[name='gameui_marker[y]']`).val(y)
      },
    })
  })

})

/*
 * only for markers#edit
 */
$(document).ready(() => {
  if (!$("body.markers-edit").length) { return }
  logg('markers#edit')

  $($(".image-thumb img")[0]).click(function (e) {
    var posX = $(this).offset().left,
        posY = $(this).offset().top;
    logg((e.pageX - posX) + ' , ' + (e.pageY - posY));
    const x = e.pageX - posX
    const y = e.pageY - posY
    $(".image-thumb .red-cross").css('top', y-10)
    $(".image-thumb .red-cross").css('left', x-10)
    $("#gameui_marker_centerOffsetX").val(x)
    $("#gameui_marker_centerOffsetY").val(y)
  })

})

