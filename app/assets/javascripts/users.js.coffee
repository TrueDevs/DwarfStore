ready = ->

	###  CHANGE EMAIL EVENTS  ###
	
	close_and_clear_dialog = (event) ->
		event.preventDefault()
		dialog = $('#change_email_dialog')
		dialog.foundation('reveal', 'close')
		dialog.find('input[type="password"]').val('')

	#event for canceling dialog
	$('#cancel_email_dialog').on 'click', (event) ->
		close_and_clear_dialog(event)

	#event for send change request
	$('#send_email_dialog').on 'click', (event) ->
		email_input = $('#email').find('input[name="email"]')
		email = email_input.val()

		password_input = $('#change_email_dialog').find('input[name="password"]')
		password = password_input.val()

		error_block = $('#email').find('.error')
		action_url = $('#email').closest('form').attr('action')
		
		$.ajax
			type: 'PATCH'
			url: action_url
			data: { user: {password: password, email: email} }
			success: (data) ->
				console.log('success: ' + data)
				error_block.hide()
				return true
			error: (data) ->
				if data.status == 403
					error_block.text('Wrong password!') 
				else
					error_block.text('Invalid email') 

				error_block.show()
				return false

		close_and_clear_dialog(event)

### REGISTER JQUERY FUNCION ON LOAD AND ON CHANGE ###
$(document).ready(ready)
$(document).on('page:load', ready)