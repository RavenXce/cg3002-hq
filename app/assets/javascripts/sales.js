$(document).on('ready  page:load', function() {
	$('#transaction-upload').ace_file_input({
		no_file : 'No File ...',
		btn_choose : 'Choose',
		btn_change : 'Change',
		droppable : false,
		onchange : null,
		thumbnail : false,
		whitelist:'txt'
	});
});