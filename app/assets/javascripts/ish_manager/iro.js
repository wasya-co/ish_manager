
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
  })



  $(".gameuiW.next-position").each( function (idx, w) {
    // logg($(w).data(), 'next-position')

    let gainp = $(w).data('ccGainp')
    if (gainp > 0) {
      $(w).find('.elephant').css('border-width', `${gainp*200 + 1}px` )
      $(w).find('.elephantLoss').css('display', 'none')
    } else {
      gainp = -1 * gainp
      $(w).find('.elephantLoss').css('border-width', `${gainp*200 + 1}px` )
    }
  })

  $(".recklessDefenseW").each( function(idx, w) {
    let longStrike = $(w).data('ccLongstrike')
    // logg(longStrike, 'longStrike')
    let shortStrike = $(w).data('ccShortstrike')
    let shortOpenedPrice = $(w).data('ccShortopenedprice')
    let shortCurrentPrice = $(w).data('ccShortcurrentprice')
    let longOpenedPrice = $(w).data('ccLongopenedprice')
    let longCurrentPrice = $(w).data('ccLongcurrentprice')

    $(w).css('left', `-${dollarWidth * ( origin - longStrike )}px` )
    $(w).css('width', `${dollarWidth * (shortStrike - longStrike - shortOpenedPrice + longOpenedPrice )}px`)

    let gainLoss = longCurrentPrice - longOpenedPrice + shortOpenedPrice - shortCurrentPrice
    if (gainLoss > 0) {
      $(w).find('.recklessDefenseC').css('left', `${dollarWidth * gainLoss}px`)
    } else {
      $(w).find('.recklessDefenseC').css('left', `${dollarWidth * gainLoss}px`)
      $(w).css('border-color', 'red')
      $(w).find('.recklessDefenseC').css('border-color', 'red')
    }
  })


})
