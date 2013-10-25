$(document).on('ready page:load', function() {
	$('#all-products-table').dataTable({
		sPaginationType : "bootstrap",
		bJQueryUI : false,
		bProcessing : true,
		bServerSide : true,
		sAjaxSource : $('#all-products-table').data('source'),
		aoColumnDefs: [
	      { "bSortable": false, "aTargets": [ 0, 7 ] },
	      { "sClass": "hidden-480", "aTargets": [ 3, 4 ] },
	      { "sWidth": "25%", "aTargets": [ 2 ] },
	      { "sWidth": "100px", "aTargets": [ 7 ] }
	    ],
	    aaSorting: [[6,'asc']],
	    fnDrawCallback: function(){ // Injection to modify DOM
	    	$('.dataTables_actions').html(
	    		'<a href="#" data-rel="tooltip" title="Add a new product"><i class="icon-plus-sign purple bigger-130"></i></a>'+
	    		'<a href="#" data-rel="tooltip" title="Batch update products"><i class="icon-pencil blue bigger-130"></i></a>'+
	    		'<a href="#" data-rel="tooltip" title="Add products to stores"><i class="icon-zoom-in grey bigger-130"></i></a>'+
	    		'<a href="#" class="tooltip-error" data-rel="tooltip" title="Batch removal"><i class="icon-trash red bigger-130"></i></a>'
	    	);
	    	$('[data-rel=tooltip]').tooltip();
	    }
	});
}); 