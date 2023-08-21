

$(document).ready(() => {

  $("input[type='checkbox']#selectAll").change(function () {
    logg(this, 'clicked')

    const checked = $(this).prop('checked')
    $(this).closest('table').find("tbody input[type='checkbox']").prop('checked', checked)
  })

})

