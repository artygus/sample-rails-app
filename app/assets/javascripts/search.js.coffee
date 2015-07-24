$ ->
  # send
  xhr = false
  $form = $('#trips-search')
  $input = $('input[name=q]', $form)
  $list = $('#trips-list tbody')

  $form.submit ->
    false

  search = (val) ->
    xhr && xhr.abort()
    xhr = $.get '/trips/search', q: val

    xhr.done (data) ->
      $list.html(data)

    xhr.error ->
      $.noop()

    false

  # input
  inputTimeout = 0

  $input.on 'keyup', (e) ->
    clearInterval(inputTimeout)

    inputTimeout = setTimeout ->
      search($input.val())
    , e.which == 13 && 50 || 1000
