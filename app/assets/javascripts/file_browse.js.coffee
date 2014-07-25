$ ->
  initialized = false
  $('#browse-btn').browseEverything()
    .show ->
      skip_box = $('#workflow_checkbox').clone().css('margin-right','10px')
      skip_box.find('i').remove()
      
      $('.ev-cancel').before skip_box
      $('.ev-providers .ev-container a').click()
      initialized = true
    .done (data) -> 
      if data.length > 0
        $('#dropbox_form input[name=workflow]').val($('#browse-everything input[name=workflow]:checked').val())
        $('#dropbox_form').submit() 
  
