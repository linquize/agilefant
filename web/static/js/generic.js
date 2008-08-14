
function toggleDiv(id)
{
	var div = document.getElementById(id);

	if (div.style.display == "none")
	{
		div.style.display = "";
	}
	else
	{
		div.style.display = "none";
	}
}

function confirmDeleteTask() {
	if (confirm("Really delete task?")) {
		return true;
	} else {
		return false;
	}
}

function confirmDeleteHour() {
	if (confirm("Really delete hour entry?")) {
		return true;
	} else {
		return false;
	}
}

function confirmDeleteBli() {
	if (confirm("Deleting the backlog item will cause all of its tasks and logged effort to be deleted.")) {
		return true;
	} else {
		return false;
	}
}

function confirmDelete() {
	if (confirm("Are you sure?")) {
		return true;
	} else {
		return false;
	}
}

function confirmDeleteTeam() {
	if (confirm("Are you sure to delete the team?")) {
		return true;
	} else {
		return false;
	}
}

function confirmReset() {
	if (confirm("Are you sure you want to reset the original estimate for this backlog item?")) {
		return true;
	} else {
		return false;
	}
}

function deleteBacklogItem(backlogItemId) {
	var confirm = confirmDeleteBli();
	var url = "ajaxDeleteBacklogItem.action";			
	
	if (confirm) {
		$.post(url,{backlogItemId: backlogItemId},function(data) {
			reloadPage();
		});
	}
}

function disableIfEmpty(value, elements) {
	if(value == "") {
		alert("Invalid selection. Select a valid backlog.");
		for(i = 0; i < elements.length; i++){
			document.getElementById(elements[i]).disabled = true;
		}
	} else {
		for(i = 0; i < elements.length; i++){
		document.getElementById(elements[i]).disabled = false;
		}
	}			
}
function validateDateFormat(value) {
	var standardDateFormat = new RegExp("^[ ]*[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])[ ]+([0-1][0-9]|2[0-3]):[0-5][0-9][ ]*$");
	return (standardDateFormat.test(value) ); 
}
function checkDateFormat(field){
	var ret = false;
	var fields = document.getElementsByName(field);
	var value = fields[0].value;
	ret = validateDateFormat( value );
	if(!ret) {
		alert("Invalid date format!");
	}
	return ret;
}
function validateEstimateFormat(value) {
	var hourOnly = new RegExp("^[ ]*[0-9]+h?[ ]*$"); //10h
	var minuteOnly = new RegExp("^[ ]*[0-9]+min[ ]*$"); //10min
	var hourAndMinute = new RegExp("^[ ]*[0-9]+h[ ]+[0-9]+min[ ]*$"); //1h 10min
	var shortFormat = new RegExp("^[0-9]+[.,][0-9]+$"); //1.5 or 1,5
	return (hourOnly.test(value) || minuteOnly.test(value) || hourAndMinute.test(value) || shortFormat.test(value));
}
function checkEstimateFormat(field) {
	var ret = false;
	var fields = document.getElementsByName(field);
	var value = fields[0].value;
	ret = validateEstimateFormat(value);
	if(!ret) {
		alert("Invalid effort format!");
	}
	return ret;
}
function validateSpentEffortById(id,msg) {
	var el = $("#"+id);
	if(el.length == 0) { //allow if item not found
		return true;
	}
	var val = el.val();
	var regex = new RegExp("^[ ]*$");
	if(regex.test(val)) { //allow empty
		return true;
	}
	var ret = validateEstimateFormat(val);
	if(!ret) {
		alert(msg);
	}
	return ret;
}
function showWysiwyg(id) {
	if($("#"+id).is(":visible")) {
		setUpWysiwyg(id);
	}
}
function setUpWysiwyg(id) {
	$("#"+id).wysiwyg({
		controls : {
        separator04 : { visible : true },

        insertOrderedList : { visible : true },
        insertUnorderedList : { visible : true }
    }});
}
function reloadPage()
{
	window.location.reload();
}
function openThemeBusinessModal(parent, target, backlogItemId, themeId, productId) {
	var data = new Object();
	data['backlogItemId'] = backlogItemId;
	data['businessThemeId'] = themeId;
	data['productId'] = productId;
	loadModal(target,data,parent,reloadPage);
}
function openThemeBusinessBliModal(parent, target, backlogItemId, themeId, productId) {
	var data = new Object();
	var cb = function() { }
	data['backlogItemId'] = backlogItemId;
	data['businessThemeId'] = themeId;
	data['productId'] = productId;
	loadModal(target,data,parent,cb);
}
function loadModal(target,request, parent, closeFunc) {
	var container = $('<div class="jqmWindow"><b>Please wait, content loading...</b></div>');
	var bg = $('<div style="background: #000; opacity: 0.3; z-index: 9; position: absolute; top: 0px; left: 0px; filter:alpha(opacity=30);-moz-opacity:.30;">&nbsp;</div>');
	var pos = $("#"+parent).offset();
	container.css("top",pos.top).css("z-index","11");
	bg.appendTo(document.body).show();
	container.appendTo(document.body).show();
	$(window).resize(function() { bg.css("height",$(document).height()).css("width",$(document).width()); });
	$(window).scroll(function() { bg.css("height",$(document).height()).css("width",$(document).width()); });
	$(window).resize();
	var comp = function(data,status) { container.html(data); container.find(".jqmClose").click(function() { container.remove(); bg.remove(); if(closeFunc) { closeFunc()}});}
	var err = function(data,status) { alert("An error occured while processing your request."); container.remove(); bg.remove(); }
	jQuery.ajax({cache: false, type: "POST", error: err, success: comp, data: request, url: target, dataType: "html"});
}

function removeThemeFromItem(theme_id) {
	jQuery.ajax({url :"removeThemeFromBacklogItem.action", 
		data: {backlogItemId: backlogItemId, businessThemeId: theme_id}, cache: false, type: 'POST',
		success: function(data, status) { 	
			var tmp = selectedThemes;
			selectedThemes = new Array();
			for(var i = 0 ; i < tmp.length; i++) {
				if(tmp[i] != theme_id) {
					selectedThemes.push(tmp[i]);
				}
			}
			renderThemeList();
			$("#businessThemeError").text("");
		}, error: function() {
				$("#businessThemeError").text("Error: Unable to remove theme from backlog item.");
	}});
	$("#businessThemeSaveSuccess").text("");
	$("#businessThemeError").text("");
}
function addThemeToItem() {
	var theme_id = $("#businessThemeSelect").val();
	if(theme_id < 1) {
		alert("Select theme first.");
		return;
	}
	if(jQuery.inArray(theme_id, selectedThemes) > -1) return;
	jQuery.ajax({url: "addThemeToBacklogItem.action", 
		data: {backlogItemId: backlogItemId, businessThemeId: theme_id}, type: 'POST', cache: false,
		success: function(data, status) { 	
				selectedThemes.push(theme_id);
				renderThemeList();
				$("#businessThemeError").text("");
		}, error: function() {
				$("#businessThemeError").text("Error: Unable to add theme to backlog item.");
		}});
	$("#businessThemeSaveSuccess").text("");
	$("#businessThemeError").text("");
}
function renderThemeList() {
	var container = $("#itemThemeList").empty();
	for(var i = 0 ; i < selectedThemes.length; i++) {
		var li = $('<li></li>').appendTo(container);
		$('<a name="'+selectedThemes[i]+'" href="#">'+businessThemes[selectedThemes[i]].name+'</a>')
			.appendTo(li)
			.click(function() { selectEditTheme(this.name); return false;});
		$('<img name="'+selectedThemes[i]+'" title="Remove" alt="Remove" src="static/img/delete_18.png"/>')
			.css("cursor","pointer").appendTo(li)
			.click(function() { removeThemeFromItem(this.name); return false;});
	}
}
function saveTheme() {
	var name = $("#nameField").val();
	var trimmed = name.replace(/^\s+|\s+$/g, '');
	var desc = $("#descField").val();
	var id = $("#businessThemeSelect").val();
	var pid = productId;
	var ename = trimmed; //escape(trimmed);
	var edesc = desc; //escape(desc);
	var active = true;
	//var d = $("#businessThemeModalForm").serializeArray();
	var d = {businessThemeId: id, productId: pid, "businessTheme.name": ename, "businessTheme.description": edesc, "businessTheme.active": active};
	if (name.length > 20) {
		$("#businessThemeSaveSuccess").text("");
		$("#businessThemeError").text("Error: theme name may not be longer than 20 characters.");
		return;
	}
	if (trimmed.length == 0) {
		$("#businessThemeSaveSuccess").text("");
		$("#businessThemeError").text("Error: theme name empty.");
		return;
	}
	jQuery.ajax({url: "ajaxStoreBusinessTheme.action", data: d, type: "POST", cache: false, 
		success: function(data,status) {
			var themeId = parseInt(data);
			if(themeId == NaN) return;
			businessThemes[themeId] = { "desc": desc, "name": name };
			updateThemeSelect(themeId);
			renderThemeList();
			addThemeToItem();
			$("#businessThemeError").text("");
			if (id > 0) {
				$("#businessThemeSaveSuccess").text("Theme was successfully saved.");
			} else {
				$("#businessThemeSaveSuccess").text("Theme was successfully created.");
			}
	}, error: function() {
		$("#businessThemeSaveSuccess").text("");
		$("#businessThemeError").text("Error: unable to save theme.");
	}, dataType: "text"});
}
function updateThemeSelect(setSelected) {
	var select = $("#businessThemeSelect");
	var old = (setSelected == 0) ? select.find(":selected").val() : setSelected;

	select.empty();
	$('<option value="">(create new)</option>').appendTo(select);
	var themeArr = [];
	for(var theme in businessThemes) {
		themeArr.push({id : theme, name: businessThemes[theme].name});
	}
	var sorter = function(a,b) { if(a.name > b.name) { return 1; } else {return -1}};
	themeArr.sort(sorter);
	for(var i = 0; i < themeArr.length; i++) {
		$('<option value="'+themeArr[i].id+'">'+themeArr[i].name+'</option>').appendTo(select);
	}
	if(old > 0) {
		select.find("[value="+old+"]").attr("selected","selected");
	}
	$("#addThemeText").text("Add theme to BLI");
	$("#businessThemeSaveSuccess").text("");
	$("#businessThemeError").text("");
}
function selectEditTheme(theme_id) {
	if(theme_id > 0) {
		$("#nameField").val(businessThemes[theme_id].name);
		$("#descField").val(businessThemes[theme_id].desc);
		//$("#addThemeText").text("Add theme to BLI");
		$("#businessThemeSelect").find("[value="+theme_id+"]").attr("selected","selected");													
	} else {
		$("#nameField").val("");
		$("#descField").val("");
		//$("#addThemeText").text("");
	}
	$("#businessThemeSaveSuccess").text("");
	$("#businessThemeError").text("");
}

function ajaxOpenDialog(context, dialogId) {
    jQuery.post("ajaxOpenDialog.action", {
        "contextType": context,
        "objectId": dialogId
        });
}
function ajaxCloseDialog(context, dialogId) {
    jQuery.post("ajaxCloseDialog.action", {
        "contextType": context,
        "objectId": dialogId
        });
}

function closeTabs(context, target, id) {
	ajaxCloseDialog(context, id);
	$('#'+target).find('label.error').hide();
    $("#"+target).toggle();
}

function trim (str) {
    str = str.replace(/^\s+/, '');
    for (var i = str.length - 1; i >= 0; i--) {
        if (/\S/.test(str.charAt(i))) {
            str = str.substring(0, i + 1);
            break;
        }
    }
    return str;
}

function handleTabEvent(target, context, id, tabId) {
	
    var target = $("#" + target);
    if (target.attr("tab-data-loaded")) {
        var tabs = target.find("ul.ajaxWindowTabs");
        var selected = tabs.data('selected.tabs');
        if (target.is(":visible")) {
            if (selected == tabId) {
                ajaxCloseDialog(context, id);
                target.toggle();
            }
            else {
                tabs.tabs('select', tabId);
            }
        }
        else {
            ajaxOpenDialog(context, id);
            target.toggle();
            tabs.tabs('select', tabId);
        }
    }
    else {
        ajaxOpenDialog(context, id);
        
        var targetAction = {
        	"bli": "backlogItemTabs.action",
            "project": "projectTabs.action",
            "businessTheme": "businessThemeTabs.action"
        };
        
        var targetParams = {
        	"bli": {
                backlogItemId: id
            },
            "project": {
                projectId: id
            },            
            "businessTheme": {
                businessThemeId: id
            }
        };
        
        target.load(targetAction[context], targetParams[context], function(data, status) {
         
            target.find('.useWysiwyg').wysiwyg({controls : {separator04 : { visible : true },insertOrderedList : { visible : true },insertUnorderedList : { visible : true }}});
            target.find('ul.ajaxWindowTabs').tabs({ selected: tabId });
            var form = target.find("form");
            form.validate(agilefantValidationRules[context]);
            form.submit(submitDialogForm);
        });
        target.attr("tab-data-loaded","1");
    }
}

function disableElementIfValue(me, handle, ref) {
    if (ref == $(me).val()) {
        $(handle).attr("disabled","disabled");
    }
    else {
        $(handle).removeAttr("disabled");
    }
    return false;
}

function getIterationGoals(backlogId, element) {
    jQuery.getJSON("ajaxGetIterationGoals.action",
        { 'iterationId': backlogId }, function(data, status) {
        var select = $(element);
        
        if (data.length > 0) {
            select.show().empty().val('').next().hide();
            $('<option/>').attr('value','').attr('class','inactive').text('(none)').appendTo(select);
            for (var i = 0; i < data.length; i++) {
                $('<option/>').attr('value',data[i].id).text(data[i].name).appendTo(select);
            }
        }
        else {
            select.hide().empty().val('').next().show();
        }
    });
}
