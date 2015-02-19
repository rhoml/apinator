ready = ->
  $('#inputs-entity').delegate '.delete-input-entity', 'click', (event) ->
    event.preventDefault()
    $(@).parent().parent().remove()

  $('.add-input-entity').on 'click', (event) ->
    event.preventDefault()
    element = $('#input-entity-template').clone()
    element.show()
    $('#inputs-entity').append(element.html())

$(document).ready(ready)
$(document).on('page:load', ready)
