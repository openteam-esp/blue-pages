$ ->

  options = $('#permission_context_id option')
  values = $.map options, (option) ->
    { label: option.text, value: option.text, id: option.value }

  $('.context_autocomplete').autocomplete
    source: values
    select: (event, ui) ->
      $('#permission_context_id').val(ui.item.id)
      return

  return
