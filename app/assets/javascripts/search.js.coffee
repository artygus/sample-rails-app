$ ->
  # send
  xhr = false
  $form = $('#trips-search')
  $list = $('#trips-list tbody')

  $form.submit ->
    false

  search = ->
    xhr && xhr.abort()
    xhr = $.post '/trips/search', $form.serialize()

    xhr.done (data) ->
      $list.html(data)

    xhr.error ->
      $.noop()

    false

  # input
  inputTimeout = 0

  $('input', $form).on 'keyup', (e) ->
    clearInterval(inputTimeout)

    inputTimeout = setTimeout ->
      search()
    , e.which == 13 && 50 || 1000
