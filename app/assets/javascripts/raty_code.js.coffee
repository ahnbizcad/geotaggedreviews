windowReady = ->
  $('.star-rating').raty({
    path: '/assets/jquery_raty',
    readOnly: true,
    score: ->
      $(this).attr('data-score')
    })

  $('#star-rating').raty({
    path: '/assets/jquery_raty',
    scoreName: 'review[rating]'
  })

$(document).on("page:load ready", windowReady)