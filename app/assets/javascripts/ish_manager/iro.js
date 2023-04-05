
$(document).ready(function () {

  const origin = 23
  scale = 200 // pixels per dollar



  $(".gameuiW").each( function (idx, w) {

    let ccStrike = $(w).data('ccStrike')
    let ccStartPrice = $(w).data('ccStartprice') // e.g. 0.88
    let ccCurrentPrice = $(w).data('ccCurrentprice')
    let cUS = $(w).data('cus')

    $(".c-u-s").each(function (idx, elem) {
      $(elem).html(cUS)
    })

    $(".windW").each(function (idx, elem) {
      $(elem).css('left', (origin - cUS)*scale)
    })

    $($(w).find('.elephantW')).css('left', (origin - ccStrike)* scale )
    $(w).find('.elephantC > .amount').html( " $" + ccStrike )
    $(w).find('.riderStart > .amount').html( " $" + ccStartPrice )
    $(w).find('.riderStart').css('width', scale * ccStartPrice )
    $(w).find('.riderStart').css('left', -1 * scale * ccStartPrice )
    $(w).find('.riderStart2').css('width', scale * ccStartPrice )

    let currentAmount = ((ccStartPrice - ccCurrentPrice)*100).toPrecision(1)/100
    let ccCurrentGain = ccStartPrice - ccCurrentPrice
    // logg(ccCurrentGain, 'ccCurrentGain')
    // logg(currentAmount, 'currentAmount')
    $(w).find('.riderCurrent > .amount').html( " $" + currentAmount )
    let ans = `${-1*ccCurrentGain*scale}px`
    logg(ans, 'ans')
    $(w).find('.riderW').css('left', ans)

    if (ccCurrentGain > 0) {
      $(w).find('.riderCurrent').css('width', scale * ccCurrentGain )
    } else {
      ccCurrentGain = -1 * ccCurrentGain
      $(w).find('.riderCurrent').css('width', scale * ccCurrentGain )
      $(w).find('.riderCurrent').css('background', 'red')
      $(w).find('.riderCurrent').css('right', `-${ccCurrentGain*scale}px`)
      $(w).find('.rider').addClass('riderF')
    }
  })

})
