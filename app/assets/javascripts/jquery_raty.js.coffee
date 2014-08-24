$('.star-rating').raty ->
  path: '/images/jquery_raty/star-half.png',
  readOnly: true,
  score: ->
    $(this).attr('data-score')