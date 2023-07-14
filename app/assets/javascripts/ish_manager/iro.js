
$(document).ready(function () {

  const dollarWidth = $('.gameui-positions').data('ccDollarwidth')
  const origin = $('.gameui-positions').data('ccOrigin')
  const cUS = $(".gameui-positions").data('ccCus')

  $(".step").css('height', `${dollarWidth * .75}px`)
  $(".gameui").css('height', `${dollarWidth}px`)
  $('.windW').css('left', `${dollarWidth * (origin - cUS)}px`)
  $('.gameuiCUS').css('left', `${dollarWidth * (origin - cUS)}px`)

  $(".elephantW").each( function (idx, w) {
    // logg($(w).data(), 'data')

    let ccStrike = $(w).data('ccStrike')
    let ccStartPrice = $(w).data('ccStartprice') // e.g. 0.88
    let ccCurrentPrice = $(w).data('ccCurrentprice')

    let loss = ccCurrentPrice - ccStartPrice;

    $(w).css('left', `${dollarWidth * (origin-ccStrike)}px` );
    // $(w).find('.elephantW').css('width', `${dollarWidth * ccStartPrice}px` );
    $(w).css('height', `${dollarWidth * ccStartPrice}px` );
    $(w).find('.elephant ').css('left', `-${dollarWidth * (ccStartPrice)}px` );
    $(w).find('.elephant ').css('width', `${dollarWidth * (ccStartPrice)}px` );
    $(w).find('.elephant ').css('height', `${dollarWidth * (ccStartPrice)}px` );
    $(w).find('.elephant ').css('border-radius', `${dollarWidth * (ccStartPrice)}px ${dollarWidth * (ccStartPrice)}px 0 0` );
    $(w).find('.elephantC > .amount').html( " $" + ccStartPrice )
    if (loss > 0) {
      $(w).find('.elephantC ').css('left', `-${dollarWidth * (ccStartPrice - loss)}px` );
      $(w).find('.elephantC ').css('width', `${dollarWidth * (ccStartPrice - loss)}px` );
      $(w).find('.elephantC ').css('height', `${dollarWidth * (ccStartPrice - loss)}px` );
      $(w).find('.elephantC ').css('border-radius', `${dollarWidth * (ccStartPrice - loss)}px ${dollarWidth * (ccStartPrice - loss)}px 0 0` );
      $(w).find('.elephant').css('border-color', 'red');
      $(w).find('.elephantC ').css('border-color', 'red');
    } else {
      $(w).find('.elephantC ').css('left', `-${dollarWidth * (ccCurrentPrice)}px` );
      $(w).find('.elephantC ').css('width', `${dollarWidth * (ccCurrentPrice)}px` );
      $(w).find('.elephantC ').css('height', `${dollarWidth * (ccCurrentPrice)}px` );
      $(w).find('.elephantC ').css('border-radius', `${dollarWidth * (ccCurrentPrice)}px ${dollarWidth * (ccCurrentPrice)}px 0 0` );
    }





    // return false;
    // $(".c-u-s").each(function (idx, elem) {
    //   $(elem).html(cUS)
    // })
    // $(".windW").each(function (idx, elem) {
    //   ans = ( origin - cUS ) * scale
    //   $(elem).css('left', ans)
    // })
    // // $($(w).find('.elephantW')).css('left', (origin - ccStrike)* scale )
    // $(w).find('.riderStart > .amount').html( " $" + ccStartPrice )
    // $(w).find('.riderStart').css('width', scale * ccStartPrice )
    // $(w).find('.riderStart').css('left', -1 * scale * ccStartPrice )
    // $(w).find('.riderStart2').css('width', scale * ccStartPrice )
    // let currentAmount = ((ccStartPrice - ccCurrentPrice)*100).toPrecision(2)/100
    // let ccCurrentGain = ccStartPrice - ccCurrentPrice
    // $(w).find('.riderCurrent > .amount').html( " $" + currentAmount )
    // ans = `${-1*ccCurrentGain*scale}px`
    // $(w).find('.riderW').css('left', ans)
    // if (ccCurrentGain > 0) {
    //   $(w).find('.riderCurrent').css('width', scale * ccCurrentGain )
    // } else {
    //   $(w).find('.riderCurrent').css('display', 'none')
    //   $(w).find('.riderCurrent2').css('display', 'block')
    //   $(w).find('.riderCurrent2').css('width', -1 * scale * ccCurrentGain )
    //   $(w).find('.rider').addClass('riderF')
    // }
  })



  $(".gameuiW.next-position").each( function (idx, w) {
    logg($(w).data(), 'next-position')

    let ans

    let gainp = $(w).data('ccGainp')
    if (gainp > 0) {
      $(w).find('.elephant').css('border-width', `${gainp*200 + 1}px` )
      $(w).find('.elephantLoss').css('display', 'none')
    } else {
      gainp = -1 * gainp
      $(w).find('.elephantLoss').css('border-width', `${gainp*200 + 1}px` )
    }
  })

})
