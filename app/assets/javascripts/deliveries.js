$(document).on('ready page:load', function() {
	var allDeliveryItemsTable = $('#all-deliveries-table').dataTable({
		sPaginationType : "bootstrap",
		bJQueryUI : false,
		bProcessing : true,
		bServerSide : true,
		sAjaxSource : $('#all-deliveries-table').data('source'),
		aoColumnDefs : [{
			"bSortable" : false,
			"aTargets" : [0, 7]
		}, {
			"sClass" : "hidden-480",
			"aTargets" : [3, 4, 6]
		}, {
			"sWidth" : "120px",
			"aTargets" : [2,6]
		}, {
			"sWidth" : "100px",
			"aTargets" : [7]
		}, {
			"sWidth" : "16%",
			"aTargets" : [4,5]
		},],
		aaSorting : [[6, 'desc']],
		"fnRowCallback" : function(nRow, aData) {
			$(nRow).data('id', aData[8]);
		},
		fnDrawCallback : function() {// Injection to modify DOM
			$('[data-rel=tooltip]').tooltip();
			$('.delete-delivery').on(ace.click_event, function(e) {
				e.preventDefault();
				$row = $(this).parents('tr');
				bootbox.dialog({
					message : "<span class='bigger-110'>Cancel this delivery?</span>",
					buttons : {
						"delete" : {
							"label" : "Delete!",
							"className" : "btn-sm btn-danger",
							"callback" : function() {
								$.ajax({
									type : 'DELETE',
									url : 'deliveries/' + $row.data('id'),
									data : {
										authenticity_token : AUTH_TOKEN
									},
									success : function(result) {
										allDeliveryItemsTable.fnDraw();
									},
									error : function(jqXHR, status, error) {
									}
								});
							}
						},
						"button" : {
							"label" : "Cancel",
							"className" : "btn-sm"
						}
					}
				});
			});
		}
	});
});

jQuery(function($) {
	var path = window.location.pathname;
	var delivery_id = path.substr( path.lastIndexOf("/") + 1 );
	var grid_selector = "#grid-table";
	var pager_selector = "#grid-pager";
	grid = $(grid_selector).jqGrid({
		url: document.URL+'.json',
		datatype: "json",
		height: 150,
		colNames:[' ', 'Barcode', 'Name', 'Manufacturer', 'Category', 'Cost Price', 'Quantity'],
		colModel:[
			{name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
				formatter:'actions', 
				formatoptions:{ 
					keys:true,					
					delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
					onSuccess:displayMessage
					//,onError:displayError
					//editformbutton:true, editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
				}
			},
			{name:'items.barcode',index:'items.barcode', width:60, editable: false, addable: true},
			{name:'items.product_name',index:'items.product_name', width:200, editable: false},
			{name:'items.manufacturer',index:'items.manufacturer', width:100, editable: false},
			{name:'items.category',index:'items.category', width:100, editable: false},
			{name:'items.cost_price',index:'items.cost_price', width:60, editable: false,editoptions:{size:"3",maxlength:"3"}},
			{name:'quantity',index:'quantity', width:60, editable: true, editoptions:{size:"3",maxlength:"3"}}
		], 
		viewrecords : true,
		rowNum:10,
		rowList:[10,20,30],
		pager : pager_selector,
		altRows: true,
		sortname: 'items.barcode',
		sortorder: 'asc',
		//toppager: true,
		multiselect: false,
		//multikey: "ctrlKey",
		multiboxonly: true,

		loadComplete : function() {
			var table = this;
			setTimeout(function(){
				styleCheckbox(table);				
				updateActionIcons(table);
				updatePagerIcons(table);
				enableTooltips(table);
			}, 0);
		},
		editurl: delivery_id+'/edit_delivery_item',
		caption: "Item Listing",
		autowidth: true
	});
	
	function displayProcessing() {	
		$.gritter.add({
			title : 'Warning',
			text : 'Processing request..',
			sticky: false,
			class_name : 'gritter-warning'
		});
	}
	
	function displayMessage(response){
		$.gritter.add({
			title : 'Status',
			text : response.responseJSON.message,
			sticky: false,
			class_name : 'gritter-success'
		});
		return true;
	}

	//enable search/filter toolbar
	//jQuery(grid_selector).jqGrid('filterToolbar',{defaultSearch:true,stringResult:true})

	//switch element when editing inline
	function aceSwitch( cellvalue, options, cell ) {
		setTimeout(function(){
			$(cell) .find('input[type=checkbox]')
					.wrap('<label class="inline" />')
				.addClass('ace ace-switch ace-switch-5')
				.after('<span class="lbl"></span>');
		}, 0);
	}

	//navButtons
	jQuery(grid_selector).jqGrid('navGrid',pager_selector,
		{ 	//navbar options
			edit: true,
			editicon : 'icon-pencil blue',
			edittitle: "Edit selected item",
			add: true,
			addicon : 'icon-plus-sign purple',
			addtitle: "Add new item",
			del: true,
			delicon : 'icon-trash red',
			deltitle: "Delete selected item",
			search: true,
			searchicon : 'icon-search orange',
			searchtitle: "Search items",
			refresh: true,
			refreshicon : 'icon-refresh green',
			view: true,
			viewicon : 'icon-zoom-in grey',
			viewtitle: "View selected item",
		},
		{
			//edit record form
			closeAfterEdit: true,
			recreateForm: true,
			beforeShowForm : function(e) {
				var form = $(e[0]);
				form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />');
				style_edit_form(form);
			}
		},
		{
			//new record form
			closeAfterAdd: true,
			recreateForm: true,
			viewPagerButtons: false,
			beforeShowForm : function(e) {
				var form = $(e[0]);
				form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />');
				style_edit_form(form);
			},
			// Add fields which are addable but not editable. jQgrid doesn't know a property 'Addable'.
			beforeInitData: function (formid) {
			   colModelIterator(function(col) {
			       if (col.addable) {
			          grid.setColProp(col.name, { editable: true });
			       }
			   });
			},
			// Remove editable option.
			onClose: function (response, postdata, formid) {				
			   colModelIterator(function (col) {
			       if (col.addable) {
			          grid.setColProp(col.name, { editable: false });
			        }
			   });
			}
		},
		{
			//delete record form
			recreateForm: true,
			beforeShowForm : function(e) {
				var form = $(e[0]);
				if(form.data('styled')) return false;
				
				form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />');
				style_delete_form(form);
				
				form.data('styled', true);
			},
			onClick : function(e) {
				alert(1);
			}
		},
		{
			//search form
			recreateForm: true,
			afterShowSearch: function(e){
				var form = $(e[0]);
				form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />');
				style_search_form(form);
			},
			afterRedraw: function(){
				style_search_filters($(this));
			},
			multipleSearch: true,
			/**
			multipleGroup:true,
			showQuery: true
			*/
		},
		{
			//view record form
			recreateForm: true,
			beforeShowForm: function(e){
				var form = $(e[0]);
				form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />');
			}
		}
	);

	function colModelIterator(callback) {
	    var colModel = grid.jqGrid('getGridParam', 'colModel');
	    for (var index in colModel) { callback(colModel[index]); } 
	}
	
	function style_edit_form(form) {
		form.find('#departure_time, #arrival_time').datepicker({format:'yyyy-mm-dd' , autoclose:true});
		form.find('#departure_location, #arrival_location').chosen({ width: "80%" });
		
		
		//update buttons classes
		var buttons = form.next().find('.EditButton .fm-button');
		buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
		buttons.eq(0).addClass('btn-primary').prepend('<i class="icon-ok"></i>');
		buttons.eq(1).prepend('<i class="icon-remove"></i>');
		
		buttons = form.next().find('.navButton a');
		buttons.find('.ui-icon').remove();
		buttons.eq(0).append('<i class="icon-chevron-left"></i>');
		buttons.eq(1).append('<i class="icon-chevron-right"></i>');		
	}

	function style_delete_form(form) {
		var buttons = form.next().find('.EditButton .fm-button');
		buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
		buttons.eq(0).addClass('btn-danger').prepend('<i class="icon-trash"></i>');
		buttons.eq(1).prepend('<i class="icon-remove"></i>');
	}
	
	function style_search_filters(form) {
		form.find('.delete-rule').val('X');
		form.find('.add-rule').addClass('btn btn-xs btn-primary');
		form.find('.add-group').addClass('btn btn-xs btn-success');
		form.find('.delete-group').addClass('btn btn-xs btn-danger');
	}
	function style_search_form(form) {
		var dialog = form.closest('.ui-jqdialog');
		var buttons = dialog.find('.EditTable');
		buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'icon-retweet');
		buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'icon-comment-alt');
		buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'icon-search');
	}
	
	function beforeDeleteCallback(e) {
		var form = $(e[0]);
		if(form.data('styled')) return false;
		
		form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />');
		style_delete_form(form);
		
		form.data('styled', true);
	}
	
	function beforeEditCallback(e) {
		var form = $(e[0]);
		form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />');
		style_edit_form(form);
	}



	//it causes some flicker when reloading or navigating grid
	//it may be possible to have some custom formatter to do this as the grid is being created to prevent this
	//or go back to default browser checkbox styles for the grid
	function styleCheckbox(table) {
	/**
		$(table).find('input:checkbox').addClass('ace')
		.wrap('<label />')
		.after('<span class="lbl align-top" />')


		$('.ui-jqgrid-labels th[id*="_cb"]:first-child')
		.find('input.cbox[type=checkbox]').addClass('ace')
		.wrap('<label />').after('<span class="lbl align-top" />');
	*/
	}
	

	//unlike navButtons icons, action icons in rows seem to be hard-coded
	//you can change them like this in here if you want
	function updateActionIcons(table) {
		/**
		var replacement = 
		{
			'ui-icon-pencil' : 'icon-pencil blue',
			'ui-icon-trash' : 'icon-trash red',
			'ui-icon-disk' : 'icon-ok green',
			'ui-icon-cancel' : 'icon-remove red'
		};
		$(table).find('.ui-pg-div span.ui-icon').each(function(){
			var icon = $(this);
			var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
			if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
		})
		*/
	}
	
	//replace icons with FontAwesome icons like above
	function updatePagerIcons(table) {
		var replacement = 
		{
			'ui-icon-seek-first' : 'icon-double-angle-left bigger-140',
			'ui-icon-seek-prev' : 'icon-angle-left bigger-140',
			'ui-icon-seek-next' : 'icon-angle-right bigger-140',
			'ui-icon-seek-end' : 'icon-double-angle-right bigger-140'
		};
		$('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
			var icon = $(this);
			var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
			
			if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
		});
	}

	function enableTooltips(table) {
		$('.navtable .ui-pg-button').tooltip({container:'body'});
		$(table).find('.ui-pg-div').tooltip({container:'body'});
	}

	//var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');
});
