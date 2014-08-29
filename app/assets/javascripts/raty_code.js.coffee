$(document).ready ->

  $('.star-rating').raty({
    path: '/assets/jquery_raty',
    readOnly: true,
    score: ->
      $(this).attr('data-score')
    })

  currentRating = $('#star-rating').data('score')

  $('#star-rating').raty({
    path: '/assets/jquery_raty',
    scoreName: 'review[rating]'
    score: currentRating
  })