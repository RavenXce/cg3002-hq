$(document).on('ready  page:load', function() {
	$('#transaction-upload').ace_file_input({
		no_file : 'No File ...',
		btn_choose : 'Choose',
		btn_change : 'Change',
		droppable : false,
		onchange : null,
		thumbnail : false,
		whitelist : 'txt'
	});
	var allSalesTable = $('#all-sales-table').dataTable({
		sPaginationType : "bootstrap",
		bJQueryUI : false,
		bProcessing : true,
		bServerSide : true,
		sAjaxSource : $('#all-sales-table').data('source'),
		aoColumnDefs : [{
			"bSortable" : false,
			"aTargets" : [0, 6]
		}, {
			"sClass" : "hidden-480",
			"aTargets" : [4, 6]
		}, {
			"sWidth" : "40%",
			"aTargets" : [3]
		}, {
			"sWidth" : "100px",
			"aTargets" : [1,2,5]
		}],
		aaSorting : [[1, 'desc'], [2, 'asc']]
	});
}); 