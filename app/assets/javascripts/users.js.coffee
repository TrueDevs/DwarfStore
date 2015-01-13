ready = ->

	###  CHANGE EMAIL EVENTS  ###
	action_url = $('#email').closest('form').attr('action')

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
		
		$.ajax
			type: 'PATCH'
			url: action_url
			data: { user: {password: password, email: email, change_email_only: true} }
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


	info_dialog = $('#info_dialog')
	info_block = info_dialog.find('p')

	### CHANGE PASSWORD EVENTS ###
	$('#change_password').on 'click', (event) ->
		event.preventDefault()

		pass_scope = $('#password')
		old_pass_input = pass_scope.find('input[name="old_password"]')
		new_pass_input = pass_scope.find('input[name="new_password"]')

		old_password = old_pass_input.val()
		new_password = new_pass_input.val()

		$.ajax
			type: 'PATCH'
			url: action_url
			data: {user: {old_password: old_password, new_password: new_password, change_password_only: true}}
			success: (data) ->
				info_block.removeClass('error')
				info_block.text('Changed successfuly!')
				info_dialog.foundation('reveal', 'open')
				return true
			error: (data) ->
				error_obj = JSON.parse(data.responseText)

				info_block.addClass('error')
				info_block.text(error_obj['error'])
				info_dialog.foundation('reveal', 'open')
				return false

		old_pass_input.val('')
		new_pass_input.val('')

	### CHANGE USER ROLE EVENTS ###
	$('#change_role').on 'click', (event) ->
		event.preventDefault()

		new_role = $('input[name=role]:checked').val()
		$.ajax
			type: 'PATCH'
			url: action_url
			data: {user: {role: new_role, change_role_only: true}}
			success: (data) ->
				info_block.removeClass('error')
				info_block.text('Role changed!')
				info_dialog.foundation('reveal', 'open')
				return true
			error: (data) ->
				error_obj = JSON.parse(data.responseText)

				info_block.addClass('error')
				info_block.text(error_obj['error'])
				info_dialog.foundation('reveal', 'open')
				return false

	### CHANGE BAN STATUS EVENTS ###
	ban_user = (ban) ->
		$.ajax
			type: 'PATCH'
			url: action_url
			data: {user: {banned: ban}}
			success: (data) ->
				banned = data['banned']

				$('#status_ban').prop('disabled', banned)
				$('#status_unban').prop('disabled', !banned)

				if (banned)
					$('#ban_info').show()
					$('#banned_date').text(data['banned_date'])
				else
					$('#ban_info').hide()

				return true
			error: (data) ->
				return false

	$('#status_ban').on 'click', (event) ->
		event.preventDefault()
		ban_user(true)

	$('#status_unban').on 'click', (event) ->
		event.preventDefault()
		ban_user(false)

### REGISTER JQUERY FUNCION ON LOAD AND ON CHANGE ###
$(document).ready(ready)
$(document).on('page:load', ready)