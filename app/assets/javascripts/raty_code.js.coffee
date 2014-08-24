windowReady = ->
  $('.star-rating').raty({
    path: 'https://s3.amazonaws.com/yelpdemo/stars',
    readOnly: true,
    score: ->
      $(this).attr('data-score')
    })

  $('#star-rating').raty({
    path: 'https://s3.amazonaws.com/yelpdemo/stars',
    scoreName: 'review[rating]'
  })

$(document).on("page:load ready", windowReady)