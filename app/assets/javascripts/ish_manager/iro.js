
$(document).ready(function () {

  const origin = 23
  scale = 200 // pixels per dollar



  $(".gameuiW").each( function (idx, w) {
    // logg($(w).data(), 'data')

    let ans

    let ccStrike = $(w).data('ccStrike')
    let ccStartPrice = $(w).data('ccStartprice') // e.g. 0.88
    let ccCurrentPrice = $(w).data('ccCurrentprice')
    let cUS = $(w).data('ccCus')

    $(".c-u-s").each(function (idx, elem) {
      $(elem).html(cUS)
    })

    $(".windW").each(function (idx, elem) {
      ans = ( origin - cUS ) * scale
      $(elem).css('left', ans)
    })

    $($(w).find('.elephantW')).css('left', (origin - ccStrike)* scale )
    $(w).find('.elephantC > .amount').html( " $" + ccStrike )
    $(w).find('.riderStart > .amount').html( " $" + ccStartPrice )
    $(w).find('.riderStart').css('width', scale * ccStartPrice )
    $(w).find('.riderStart').css('left', -1 * scale * ccStartPrice )
    $(w).find('.riderStart2').css('width', scale * ccStartPrice )

    let currentAmount = ((ccStartPrice - ccCurrentPrice)*100).toPrecision(2)/100
    let ccCurrentGain = ccStartPrice - ccCurrentPrice
    $(w).find('.riderCurrent > .amount').html( " $" + currentAmount )
    ans = `${-1*ccCurrentGain*scale}px`
    $(w).find('.riderW').css('left', ans)

    if (ccCurrentGain > 0) {
      $(w).find('.riderCurrent').css('width', scale * ccCurrentGain )
    } else {
      $(w).find('.riderCurrent').css('display', 'none')
      $(w).find('.riderCurrent2').css('display', 'block')
      $(w).find('.riderCurrent2').css('width', -1 * scale * ccCurrentGain )
      $(w).find('.rider').addClass('riderF')
    }
  })

})
