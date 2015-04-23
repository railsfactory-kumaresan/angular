window.email_status = ["hard-bounce", "unsub", "spam", "soft-bounce", "invalid"]
jQuery(document).ready(function(){
    // Question create
    //jQuery('#myTabs a:first').tab('show');
    jQuery('#create_email').click(function(){
        window.scroll(0,400);
        setTimeout(function(){
            jQuery('.email_value_error_message').hide();
        },1500);
        return false;
    });

    jQuery("#image_upload").change(function(){
        jQuery("#upload_btn").trigger("click");
    });
    jQuery(".close-cus-info-popup").click(function(){
        jQuery("#user_info_list").dialog("close");
    });
    jQuery(".uploadlogo").click(function(){
        jQuery("#image").slideToggle("slow");
    });
    jQuery("body").delegate("#country","change", function(){
        var country = $("#country").val();
        jQuery.ajax({
            url: "/surveys/states?keywords="+ country,
            type: 'GET',
            success: function(data){        }
        });
    });

    jQuery("#default_sttings").on("click",function(){
        var background ="#fefefe", page_header="#858585", submit_button="#d5d5d7", question_text="#30A4AC", button_text="#FFFFFF", answers ="#636363", font_style ="";
        jQuery("#question_style_background").css({"background-color": background,'color': '#555'});
        jQuery(".white-box").css("background-color",background)
        jQuery("#question_style_background").val(background);
        jQuery("#question_style_page_header").css("background-color",page_header);
        jQuery("#company_name").css("color",page_header);
        jQuery("#question_style_page_header").val(page_header);
        jQuery("#question_style_submit_button").css("background-color",submit_button);
        jQuery("#submit").css("background-color",submit_button);
        jQuery("#question_style_submit_button").val(submit_button);
        jQuery("#question_style_question_text").css("background-color",question_text);
        jQuery("#qs-title").css("color",question_text);
        jQuery("#question_style_question_text").val(question_text);
        jQuery("#question_style_answers").css("background-color",answers);
        jQuery("#answers").css("color",answers);
        jQuery("#question_style_answers").val(answers);
        jQuery(".quesion-left #submit").css("color",'');
        jQuery("#question_style_button_text").css({"background-color": background,'color': '#555'});
        jQuery("#question_style_button_text").val(button_text);
        jQuery("#question_style_font_style").val("Select");
        jQuery(".fileinput-preview img").removeAttr("src");
        jQuery(".fileinput-preview img").attr("src","/assets/responsive/upload-dummy-logo.jpg");
        jQuery(".fileinput-preview img").attr("id","preview_image");
        jQuery(".fileinput-preview img").attr("alt","company logo");
        jQuery(".comp-logo img").removeAttr("src");
        jQuery(".comp-logo img").attr("src","/assets/responsive/upload-dummy-logo.jpg");
        jQuery(".comp-logo img").attr("id","preview_image");
        jQuery(".comp-logo img").attr("alt","company logo");
        jQuery("#logo-image-path").val('');
        jQuery(".img-path-filename-rplc").html('');
       $('<input>').attr({ type: 'hidden', id: 'reset_image',  name: 'reset_image',value: 'true'}).appendTo('form');
    });
});
// window.onload = function() {
//     if(jQuery("#myCanvasContainer").length)
//     {
//         try {
//             TagCanvas.textColour = '#1627DE';
//             TagCanvas.outlineColour = '#D837DA';
//             TagCanvas.depth = 1.0;
//             TagCanvas.Start('myCanvas');

//         } catch(e) {
//             // something went wrong, hide the canvas container
//             document.getElementById('myCanvasContainer').style.display = 'none';
//         }
//     }
// };

function active_qr_code_current_question(id)
{
    jQuery.ajax({
        type: 'GET',
        url: '/share/'+id+'/show_qr',
        success: function(data){
        }
    });
}

function share_sms_div_load(id)
{
    jQuery.ajax({
        type: 'GET',
        url: '/share/'+id+'/show_sms',
        success: function(data){

        }
    });
}

function share_email_div_load(id)
{
    jQuery.ajax({
        type: 'GET',
        url: '/share/'+id+'/show_email',
        success: function(data){

        }
    });
}

function share_make_call_div_load(id)
{
    jQuery.ajax({
        type: 'GET',
        url: '/share/'+id+'/show_call_list',
        success: function(data){

        }
    });
}
//~ kendogrid content loading dynamically
//~ share email popup load
function share_email_popup_load(share_type)
{
    jQuery.ajax({
        type: 'GET',
        url: '/share/customers_data_grid?share='+share_type,
        success: function(data){

        }
    });
    return false;
}


function share_grid_request(type){
    jQuery("#selected_customers, #unselected_customers,#select-all").val('');
    jQuery.ajax({
        type: 'GET',
        url: '/share/customer_data_collection?share_type='+ type,
        dataType : 'script',
        success: function(response){

        }
    });
    return false;
}

function email_body_append_editor(email_content_trim)
{
    if (CKEDITOR.instances['email_text_area'] != undefined){
        if(email_content_trim == "<survey link inserted here automatically>" || email_content_trim == "&lt;survey link inserted here automatically&gt;"){
            CKEDITOR.instances['email_text_area'].setData('We value your feedback. Please take a couple of minutes to respond to this survey <br> &#60;survey link inserted here automatically&#62;')
        }else{
            CKEDITOR.instances['email_text_area'].setData(email_content_trim.replace('<survey link inserted here automatically>', '&lt;survey link inserted here automatically&gt;'));
        }
    }
}
// Reset Grid
function clearGrid() {
    //~ jQuery("form.k-filter-menu button[type='reset']").trigger("click");
    share_email_popup_load();
}

function emailDuplicationCheck(email,id)
{
    var presenceCheck ='';
    jQuery.ajax({
        type: 'GET',
        async: false,
        url: '/customers/email_duplication_check?email='+email+'&id='+id+'',
        success: function(data){
            presenceCheck = data.result;
        }
    });
    return presenceCheck;
}

function emailDuplicationMobile(mobile,id)
{
    var presenceCheck ='';
    jQuery.ajax({
        type: 'GET',
        async: false,
        url: '/customers/mobile_duplication_check?mobile='+mobile+'&id='+id+'',
        success: function(data){
            presenceCheck = data.result;
        }
    });
    return presenceCheck;
}
// Kedo ui build for email sharing
function email_share_kendo_ui_build(share_type,maximum_limit)
{
    jQuery("#maximum_limit").val(maximum_limit);
    var checkedEmail = [];
    var checkedMobile = [];
    var checkedCusIds = [];
    var checkedIds = {};
    var uncheckedCusIds = [];
   var windowTemplate = kendo.template($("#windowTemplate").html());
    jQuery("#chk_trigger_select_all").prop("checked",this.checked);
    //~ jQuery('.append-template-reset-grid-button').html("<input type='button' id='select-all-email-chk' class='button orange select-btn btn-small' value='Add Selected Emails' /><h3 class='error chk-prse-error' style='display:none;text-align:center;'>Select any one option</h3>");
    //~ jQuery('.append-template-chk-button').html("<input type='button' id='reset-grid' onclick='clearGrid(share_type)' class ='btn btn-link select-btn' value='Reset Grid' />");
    //DataSource definition

    dataSource = new kendo.data.DataSource({
        type: "odata",
        transport: {
            read: {
                url: "/customers?share_type="+share_type,
                dataType: "json"
            },
            update: {
                url: function(customer)
                {
                    return "/customers/" + JSON.stringify(customer.models[0].id)
                },
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    type: "PUT",
                    complete: function(e) {
                        $("#grid-"+share_type).data("kendoGrid").dataSource.read();
                    }
                    },
            destroy: {url:  function(customer)
                {
                    return "/customers/" + customer.models[0].id
                    },dataType: "json",type: "DELETE"},
            create: {
                  url: "/customers",
                  dataType: "json",
                  type: "POST",
                  complete: function(e) {
                    $("#grid-"+share_type).data("kendoGrid").dataSource.read();
                   }
                },
            parameterMap: function (options, operation) {
                if (operation !== "read" && operation !== "update" && operation != "destroy" && options.models)
                {
                    return JSON.stringify({ models: options.models[0] });
                }
                else  if ((operation == "update" || operation == "destroy" ) && options.models)
                {
                    return JSON.stringify({ customer: options.models[0] });
                }
                else if (operation == "read") {
                    // Add sorting
                    var sort = new Object();
                    var filter = new Object();
                    if(typeof options.sort !== "undefined" && options.sort !== null) {
                        for(var i = 0; i< options.sort.length; i++) {
                            sort["column"] = options.sort[i].field
                            sort["by"] = options.sort[i].dir
                        }
                    }
                    // Add filtering
                    if(typeof options.filter !== "undefined" && options.filter !== null) {
                        var logic = options.filter.logic;
                        filter = options.filter.filters;
                     }
                    return {
                        top: options.take,
                        skip: options.skip,
                        sort: sort,
                        logic: logic,
                        filter: filter
                    }
                }
            }
        },
        batch: true,
        pageSize: 20,
        serverPaging: true,
        serverFiltering: true,
        serverSorting: true,
        pageable: {
            pageSizes: true,
            buttonCount: 5,
            refresh: true
        },
        schema: {
            errors: function(response) {
                return response.errors;
            },
            data: function (data) {
                return data["value"];
            },
            total: function (data) {
                return data["odata.count"];
            },
            model: {
                id: "id",
                fields: {
                    email: {
                        validation: {
                            email: true,
                            required: true,
                            emailvalidation: function (input) {
                                if (input.is("[name='email']") && input.val() != "")
                                {
                                    var fetchIdVal = jQuery("#current-data-id").val() != null && jQuery("#current-data-id").val() != ""  ? jQuery("#current-data-id").val() : "";
                                    var checkValue = emailDuplicationCheck(input.val(),fetchIdVal);
                                    if (checkValue)
                                    {
                                        input.attr("data-emailvalidation-msg", "Email already exist");
                                        return false
                                    }
                                }
                                return true;
                            }
                        }
                    },
                customer_name: {
                    validation: {
                        customernamevalidation: function (input) {
                            if (input.is("[name='customer_name']") && input.val() != "")
                            {
                                input.attr("data-customernamevalidation-msg", "Name should have at least one alphabet.");
                                return /^(?=.*[a-zA-Z]).+$/.test(input.val());
                            }
                            return true;
                        }
                    }
                },
            mobile: {
                validation: {
                    required: true,
                    mobilevalidation: function (input) {
                        if (input.is("[name='mobile']") && input.val() != "")
                        {
                            input.attr("data-mobilevalidation-msg", "Please enter valid format");
                            return /^(\d{8,15})$/.test(input.val());
                        }
                        return true;
                    },
                    mobilevalidationUnique: function (input) {
                        if (input.is("[name='mobile']") && input.val() != "")
                        {
                            var fetchIdVal = jQuery("#current-data-id").val() != null && jQuery("#current-data-id").val() != ""  ? jQuery("#current-data-id").val() : "";
                            var checkValue = emailDuplicationMobile(input.val(),fetchIdVal);
                            if (checkValue)
                            {
                                input.attr("data-mobilevalidationUnique-msg", "Mobile number already exist");
                                return false;
                            }
                        }
                        return true;
                    }
                }
            },
            id: {},
            age: {
                type: "number",
                validation: {
                    required: true,
                    agevalidation: function(input) {
                        if (input.is("[name='age']") && input.val() != "") {
			if (isNaN(input.val())|| input.val()<1 || input.val() > 99)
				{
                            input.attr("data-agevalidation-msg", "Only positive numeric value up to 2 digits allowed.");
                            return false;
				}
                        }
                        return true;
                    }
                }
            },
            country: {},
            city: {},
            state: {},
            area: {},
            gender: {
                validation: {
                    required: true,
                    gendervalidation: function(input) {
                        if (input.is("[type=radio]") ) {
                            input.attr("data-gendervalidation-msg", "gender is required");
                            return $("input[name='gender']").is(':checked');
                        }
                        return true;
                    }
                }
            },
            country_code: {},status: {}      }
    }
    },
     requestStart: function () {
            kendo.ui.progress($("#loading"), true);
      },
     requestEnd: function () {
            kendo.ui.progress($("#loading"), false);
      },
     autoBind: true
});


  var window = $("#window").kendoWindow({
    title: "Are you sure you want to delete this record?",
    visible: false, //the window will not appear before its .open method is called
    width: "460px",
    height: "140px",
    modal: true
  }).data("kendoWindow");



//Grid definition
if (share_type == 'email_count'){
    /* Duplicate code has written due to custom template condition */
var grid = $("#grid-"+share_type).kendoGrid({
    dataSource: dataSource,
    edit: onEdit,
    pageable: true,
    sortable: true,
    filterable: true,
    height: 400,
    save  : function () {
        this.refresh();
    },
    //define dataBound event handler
    dataBound: onDataBound,
    // toolbar: ["create"],
    toolbar: [{ name      :"create", className :"k-grid-add2" }],
    columns: [
    //define template column with checkbox and attach click event handler
    {
        template: "#if (email_status.indexOf(status) > -1) {# <input type='checkbox'  disabled='disabled' class='checkbox chk-box-row' value= #= id#?#= email# /> #} else {# <input type='checkbox'  class='checkbox chk-box-row' value= #= id#?#= email# /> #}#",
        title: "<input type='checkbox' id='chk_trigger_select_all' class='chk_trigger_select_all' /><input type='hidden' id='select-all' class='chk_select_all' />" ,
        width: "15px" ,
        filterable: false,
        sortable: false,
        editable: false
    },
    {
        field: "email",
        template: "<span class='email-chk'>#= email #</span>",
        title: "Email",
        filterable: {
            ui: filterEmail,
            operators: {
                string: {
                    contains: "Contains"
                }
            } ,
        extra: false
    },
    width: "80px"
}, {
    field: "customer_name",
    title: "Name",
    filterable: {
        ui: filterCustomerName,
        operators: {
            string: {
                contains: "Contains"
            }
        } ,
    extra: false
},
width: "50px"
}, {
    field: "mobile",
    template: "<span class='mobile-num-chk'>#= mobile #</span>",
    title: "Mobile",
    filterable: {
        ui: filterMobile,
        operators: {
            string: {
                contains: "Contains"
            }
        } ,
    extra: false
},
width: "50px"
},{
    field: "age",
    title: "Age",
    width: "40px",
    filterable: {
        ui: function (element) {
            element.kendoNumericTextBox({
                format: "n0"
            });
        }
    }
},{
    field: "gender",
    title: "Gender",
    width: "50px",
    filterable: {
        ui: filterGender,
        extra: false
    }
}, {
    field: "country",
    template: "#if (country_code ){##= country_code.name##} else {##= country##}#",
    title: "Country",
    width: "50px",
    filterable: {
        ui: filterCountry,
        extra: false
    }
}, {
    field: "state",
    title: "State",
    width: "50px",
    filterable: {
        ui: filterState,
        extra: false
    }
},{
    field: "city",
    title: "City",
    width: "50px",
    filterable: {
        ui: filterCity,
        extra: false
    }
},
{
    field: "area",
    title: "Area",
    width: "50px",
    filterable: {
        ui: filterArea,
        extra: false
    }
},
{
    field: "custom_field",
    title: "Custom Field",
    width: "70px",
    filterable: {
        ui: filterCustomField,
        extra: false
    }
},
{
    command:  [{
        name: "edit",
        text: "",
        width: 10,
        imageClass: "k-icon k-edit",
        click: function(e)

        {
            e.preventDefault();
            var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
            if (dataItem.state)
            {
                var stateCodeName = dataItem.state;
                $('#states').append(jQuery('<option>', { value: stateCodeName, text : stateCodeName}).attr("selected","selected"));
                    }
                }
                }, { name: "Delete", mode: "popup", imageClass: "k-icon-delete-row", text: "",
            click: function(e){  //add a click event listener on the delete button
           var tr = $(e.target).closest("tr"); //get the row for deletion
           var data = this.dataItem(tr); //get the row data so it can be referred later
           jQuery("div.k-window-titlebar").css({"font-size": "18px","color": "#fff","background" : "#0191a9", "border-bottom": "1px solid #ffffff","box-shadow": "0 -1px 0 #939393 inset", "padding" : "15px 0", "font-weight":"700"});
           window.content(windowTemplate(data)); //send the row data object to the template and render it
           window.open().center();
         $("body").delegate("#yesButton","click", function(){
            grid.dataSource.remove(data)  //prepare a "destroy" request
             grid.dataSource.sync()  //actually send the request (might be ommited if the autoSync option is enabled in the dataSource)
              window.close();
           })
          $("body").delegate("#noButton","click", function(){
              window.close();
           })
         }   } ],
            title: "&nbsp;",
            width: "30px"
}
],
    edit: function (e) {
        //add a title
        if (e.model.isNew()) {
            $(".k-window-title").text("Add User");
            $(".k-grid-update").html("<span class='k-icon k-update'></span>Create")
        }
//        else {
//            $(".k-window-title").text("Edit User");
//        }
    },
editable: {
    mode: "popup",
    window: {
        title :"Add User"
    },
    template: kendo.template($("#popup-editor").html())
},
filterMenuInit: function(e) {
    if (e.field === "age") {
        var  numeric = e.container.find(("input:eq(1)")).getKendoNumericTextBox();
        if (numeric) {
            numeric.min(0)
        }
        var  numericThree = e.container.find(("input:eq(3)")).getKendoNumericTextBox();
        if (numericThree) {
            numericThree.min(0)
        }
    }
}
}).data("kendoGrid");
}else{
    var grid = $("#grid-"+share_type).kendoGrid({
        dataSource: dataSource,
        edit: onEdit,
        pageable: true,
        sortable: true,
        filterable: true,
        height: 400,
        save  : function () {
            this.refresh();
        },
        //define dataBound event handler
        dataBound: onDataBound,
        // toolbar: ["create"],
        toolbar: [{ name      :"create", className :"k-grid-add2" }],
        columns: [
            //define template column with checkbox and attach click event handler
            {
                template: "<input type='checkbox'  class='checkbox chk-box-row' value= #= id#?#= email# />",
                title: "<input type='checkbox' id='chk_trigger_select_all' class='chk_trigger_select_all' /><input type='hidden' id='select-all' class='chk_select_all' />" ,
                width: "15px" ,
                filterable: false,
                sortable: false,
                editable: false
            },
            {
                field: "email",
                template: "<span class='email-chk'>#= email #</span>",
                title: "Email",
                filterable: {
                    ui: filterEmail,
                    operators: {
                        string: {
                            contains: "Contains"
                        }
                    } ,
                    extra: false
                },
                width: "80px"
            }, {
                field: "customer_name",
                title: "Name",
                filterable: {
                    ui: filterCustomerName,
                    operators: {
                        string: {
                            contains: "Contains",
                            startswith: "Starts with",
                            endswith: "Ends with"
                        }
                    } ,
                    extra: false
                },
                width: "50px"
            }, {
                field: "mobile",
                template: "<span class='mobile-num-chk'>#= mobile #</span>",
                title: "Mobile",
                filterable: {
                    ui: filterMobile,
                    operators: {
                        string: {
                            contains: "Contains"
                        }
                    } ,
                    extra: false
                },
                width: "50px"
            },{
                field: "age",
                title: "Age",
                width: "40px",
                filterable: {
                    ui: function (element) {
                        element.kendoNumericTextBox({
                            format: "n0"
                        });
                    }
                }
            },{
                field: "gender",
                title: "Gender",
                width: "50px",
                filterable: {
                    ui: filterGender,
                    extra: false
                }
            }, {
                field: "country",
                template: "#if (country_code ){##= country_code.name##} else {##= country##}#",
                title: "Country",
                width: "50px",
                filterable: {
                    operators: {
                        string: {
                            eq: "Is equal to",
                            neq: "Is not equal to"
                        }
                    } ,
                    ui: filterCountry,
                    extra: false
                }
            }, {
                field: "state",
                title: "State",
                width: "50px",
                filterable: {
                    ui: filterState,
                    extra: false
                }
            },{
                field: "city",
                title: "City",
                width: "50px",
                filterable: {
                    ui: filterCity,
                    extra: false
                }
            },
            {
                field: "area",
                title: "Area",
                width: "50px",
                filterable: {
                    ui: filterArea,
                    extra: false
                }
            },
            {
                field: "custom_field",
                title: "Custom Field",
                width: "70px",
                filterable: {
                    ui: filterCustomField,
                    extra: false
                }
            },
            {
                command:  [{
                    name: "edit",
                    text: "",
                    width: 10,
                    imageClass: "k-icon k-edit",
                    click: function(e)

                    {
                        e.preventDefault();
                        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
                        if (dataItem.state)
                        {
                            var stateCodeName = dataItem.state;
                            $('#states').append(jQuery('<option>', { value: stateCodeName, text : stateCodeName}).attr("selected","selected"));
                        }
                    }
                }, { name: "Delete", mode: "popup", imageClass: "k-icon-delete-row", text: "",
                    click: function(e){  //add a click event listener on the delete button
                        var tr = $(e.target).closest("tr"); //get the row for deletion
                        var data = this.dataItem(tr); //get the row data so it can be referred later
                        jQuery("div.k-window-titlebar").css({"font-size": "18px","color": "#fff","background" : "#0191a9", "border-bottom": "1px solid #ffffff","box-shadow": "0 -1px 0 #939393 inset", "padding" : "15px 0", "font-weight":"700"});
                        window.content(windowTemplate(data)); //send the row data object to the template and render it
                        window.open().center();
                        $("body").delegate("#yesButton","click", function(){
                            grid.dataSource.remove(data)  //prepare a "destroy" request
                            grid.dataSource.sync()  //actually send the request (might be ommited if the autoSync option is enabled in the dataSource)
                            window.close();
                        })
                        $("body").delegate("#noButton","click", function(){
                            window.close();
                        })
                    }   } ],
                title: "&nbsp;",
                width: "30px"
            }
        ],
        edit: function (e) {
            console.log(e)
            //add a title
            if (e.model.isNew()) {
                $(".k-window-title").text("Add User");
                $(".k-grid-update").html("<span class='k-icon k-update'></span>Create")
            }
//            else {
//                console.log(e.model);
//                $(".k-window-title").text("Edit User");
//            }
        },
        editable: {
            mode: "popup",
            window: {
                title :"Add User"
            },
            template: kendo.template($("#popup-editor").html())
        },
        filterMenuInit: function(e) {
            if (e.field === "age") {
                var  numeric = e.container.find(("input:eq(1)")).getKendoNumericTextBox();
                if (numeric) {
                    numeric.min(0)
                }
                var  numericThree = e.container.find(("input:eq(3)")).getKendoNumericTextBox();
                if (numericThree) {
                    numericThree.min(0)
                }
            }
        }
    }).data("kendoGrid");
}

// Adding Row restrictions
$(".k-grid-add2", grid.element).bind("click", function (ev) {
    var checkVAl = customer_rec_count_check();
    if (checkVAl) {
        return true;
    } else {
        alert("You have used the maximum limit allowed for your plan")
        return false;
    }
});
// Auto focus on first filed
function onEdit(e){
    var arg = e;
    arg.container.data('kendoWindow').bind('activate', function(){
        if(arg.container.find("input[name='id']").val() != ""){
           arg.container.find("input[name='email']").attr("disabled",true);
           arg.container.find("input[name='customer_name']").focus();
        }else{
           arg.container.find("input[name='email']").focus();
        }
    })
}
// filter for gender search
function filterGender(element)  {
    element.kendoDropDownList({
        dataSource: {
            data: ["Male","Female"]
        },
        optionLabel: "--Select Gender-"
    });
}
grid.dataSource.originalFilter = grid.dataSource.filter;
// Replace the original filter function.
grid.dataSource.filter = function () {
    var result = grid.dataSource.originalFilter.apply(this, arguments);
    if (arguments.length > 0) {
        this.trigger("filter", arguments);
    }
    return result;
}

// get filtered data
function getFilteredData()
{
    var dataSource = $("#grid-"+share_type).data("kendoGrid").dataSource;
    var filteredDataSource = new kendo.data.DataSource({
        data: dataSource.data(),
        filter: dataSource.filter()
    });
    filteredDataSource.read();
    return filteredDataSource.view();
}
// Kendo ui Apply filter update all values State, city, Area....
grid.dataSource.bind("filter", function () {
    var collectionApplyData =  getFilteredData();
    // jQuery.parseJSON(JSON.stringify($('#grid').data("kendoGrid").dataSource.view()));
    applyFilterState(collectionApplyData);
    applyFilterCity(collectionApplyData);
    applyFilterArea(collectionApplyData);
} );
// filter for email
function filterEmail(element) {
    var collectionCountry = jQuery.parseJSON(JSON.stringify($('#grid-'+share_type).data("kendoGrid").dataSource.data()))
    var emails = collectionCountry.map(function(i) {
        return i.email;
    });
    element.kendoAutoComplete({
        dataSource: emails
    });
}
// filter for customer name
function filterCustomerName(element) {
    var collectionCountry = jQuery.parseJSON(JSON.stringify($('#grid-'+share_type).data("kendoGrid").dataSource.data()))
    var names = collectionCountry.map(function(i) {
        return i.customer_name;
    });
    element.kendoAutoComplete({
        dataSource: names
    });
}

// filter for mobile
function filterMobile(element) {
    var collectionCountry = jQuery.parseJSON(JSON.stringify($('#grid-'+share_type).data("kendoGrid").dataSource.data()))
    var mobiles = collectionCountry.map(function(i) {
        return i.mobile;
    });
    element.kendoAutoComplete({
        dataSource: mobiles
    });
}
// filter for country
function filterCountry(element) {
    var collectionCountry = jQuery.parseJSON(JSON.stringify($('#grid-'+share_type).data("kendoGrid").dataSource.data()))
    var countries = collectionCountry.map(function(i) {
        return i.country_code;
    });
    var countryFilter = {
        products :countries
    };
    var countryArray = [];
    var countryJson = [];
    var countryName = [];
    $.each(countryFilter.products, function(index, value) {
        if ($.inArray(value.code, countryArray)==-1) {
            countryArray.push(value.code);
            countryName.push(value.name);
            if (value.code != "" && value.name != "")
            {
                item = {}
                item ["code"] = value.code;
                item ["name"] = value.name;
                countryJson.push(item);
            }
        }
    });
//    element.kendoDropDownList({
//        dataSource: {
//            data: countryJson
//        },
//        dataTextField: 'name',
//        dataValueField: 'code',
//        optionLabel: "--Select Country--"
//    });
    element.kendoAutoComplete({
        dataSource: jQuery.unique(countryName)
    });
}
// filter for state
function filterState(element) {
    element.attr("id","state-row");
    var collectionCountry =  jQuery.parseJSON(JSON.stringify(getFilteredData()));
    var states = collectionCountry.map(function(i) {
        return i.state;
    });
    var StateArrayClean = states.filter(function(v){
        return (v!=='' && v != null)
        });
    element.kendoAutoComplete({
        dataSource: jQuery.unique(StateArrayClean)
    });
}
// filter for citry
function filterCity(element) {
    element.attr("id","city-row");
    var collectionCountry =  jQuery.parseJSON(JSON.stringify(getFilteredData()));
    var cities = collectionCountry.map(function(i) {
        return i.city;
    });
    var cityArrayClean = cities.filter(function(v){
        return (v!=='' && v != null)
    });
    element.kendoAutoComplete({
        dataSource: jQuery.unique(cityArrayClean)
    });
}
// filter for Area
function filterArea(element) {
    element.attr("id","area-row");
    var collectionCountry =  jQuery.parseJSON(JSON.stringify(getFilteredData()));
    var areas = collectionCountry.map(function(i) {
        return i.area;
    });
    var areaArrayClean = areas.filter(function(v){
        return (v!=='' && v != null)
        });
    element.kendoAutoComplete({
        dataSource: jQuery.unique(areaArrayClean)
    });
}

function filterCustomField(element) {
    element.attr("id","custom_field-row");
    var collectionCountry =  jQuery.parseJSON(JSON.stringify(getFilteredData()));
    var custom_field = collectionCountry.map(function(i) {
        return i.custom_field;
    });
    var customFieldClean = custom_field.filter(function(v){
        return (v!=='' && v != null)
    });
    element.kendoAutoComplete({
        dataSource: jQuery.unique(customFieldClean)
    });
}
//bind click event to the checkbox
grid.table.on("click", ".checkbox" , selectRow);

grid.table.on("click", ".chk-box-row" , selectUnselectRow);

function selectUnselectRow()
{
    if (this.checked == false)
    {
        var id = jQuery(this)[0];
        if (uncheckedCusIds.indexOf(id.value.split("?")[0]) == -1 ) { uncheckedCusIds.push(parseInt(id.value.split("?")[0])); }
        if(jQuery("#select-all").val() == ""){ jQuery("#select-all").val(jQuery(".chk_trigger_select_all").is(':checked'));}
        jQuery(".chk_trigger_select_all").prop("checked",false);
    }
}
//~ $("body").delegate(".chk-box-row","click", function(){
//~ alert(this.checked);
//~ if (this.checked == false)
//~ {
//~ jQuery("#chk_trigger_select_all").prop("checked",this.checked);
//~ }
//~ })

// Ajax call for check the remaining count

function customer_rec_count_check()
{
    var isAllow = ''
    jQuery.ajax({ type: "POST", url: "/share/check_customer_limit", dataType: "json", async: false,
    success: function(data){
       isAllow = data.count;
     }
    });
 return isAllow;
}

$("body").delegate("#chk_trigger_select_all","click", function(){
    jQuery(".customer-info-lb  input").prop("checked",this.checked);
    if (this.checked)
    {
        jQuery("#select-all").val(true);
        jQuery("#biz_cus_ids").val('');
        if(share_type == "call_count") {jQuery("#call_cus_ids").val('');}
        uncheckedCusIds = [];
        var collectionMobiles = jQuery.parseJSON(JSON.stringify(getFilteredData()));
        var mobiles = collectionMobiles.map(function(i) {
            if (email_status.indexOf(i.status) == -1) {checkedMobile.push(i.mobile);}
        });
        var collectionEmails = jQuery.parseJSON(JSON.stringify(getFilteredData()));
        collectionEmails.map(function(i) {
            if (email_status.indexOf(i.status) == -1) { checkedEmail.push(i.email);}
        });
        var collectionIds = [];
        collectionIds = jQuery.parseJSON(JSON.stringify(getFilteredData()));
        var ids = collectionIds.map(function(i) {
            if (email_status.indexOf(i.status) == -1) {return i.id; }
        });
        ids.map(function(i){
            checkedIds[i] = "true";
        });
    }
    else
    {
        jQuery("#select-all").val(false);
        checkedEmail = [];
        checkedMobile = [];
        checkedIds = {}
    }
});
$("body").delegate("#select-all-email-chk","click", function(){
    var maximum_limit =  jQuery("#maximum_limit").val();
    $('tr.k-state-selected','#grid-'+share_type).removeClass('k-state-selected');
    var checked = [];
    for(var i in checkedIds){
        if(checkedIds[i]){
            checked.push(i);
        }
    }
  if(checked.length > maximum_limit)
  {
   if(maximum_limit != 0)
    {
    msg = "Maximum limit exceeds.You can select only " + maximum_limit + ' customer(s)'
    }
   else
   {
    msg = "You have used the maximum allowed limit for your plan."
   }
    alert(msg);
    return false;
  }

   else
 {
    var multiSelectval = [];
    if (share_type == "email_count")
    {
        var is_email_validated = jQuery("#email_validation").val();
        if (is_email_validated){
        jQuery('.customer-info-lb table tbody tr').filter(':has(:checkbox:checked)').find('span.email-chk').each(function(i, input)
        {
            multiSelectval.push(jQuery(input).text());
        });
        if (jQuery("#chk_trigger_select_all").is(":checked"))
        {
            var collectionEmail = jQuery.parseJSON(JSON.stringify(getFilteredData()));
            var emails = collectionEmail.map(function(i) {
                if (email_status.indexOf(i.status) == -1) {
                    return i.email;
                }
            });
            var biz_cus_ids = collectionEmail.map(function(i) {
                if (email_status.indexOf(i.status) == -1) {
                    return i.id;
                }
            });
            jQuery(".chk-prse-error").hide();
            jQuery("#email_value").val(cleanArray(emails));
            jQuery("#biz_cus_ids").val('');
            jQuery("#unchecked_ids").val(uncheckedCusIds);
            jQuery("#user_info_list").dialog("close");
        }
        else if (checkedEmail.length > 0)
        {
            jQuery(".chk-prse-error").hide();
            jQuery("#email_value").val(checkedEmail);
            jQuery("#unchecked_ids").val(uncheckedCusIds);
            checkedEmail = [];
            checkedCusIds = [];
            jQuery("#user_info_list").dialog("close");
        }
        else
        {
          jQuery("#email_value").val("");
            jQuery(".chk-prse-error").show();
        }
        }
    }
    else if (share_type == "sms_count")
    {
        jQuery('.customer-info-lb table tbody tr').filter(':has(:checkbox:checked)').find('span.mobile-num-chk').each(function(i, input)
        {
            multiSelectval.push(jQuery(input).text());
        });
        if (jQuery("#chk_trigger_select_all").is(":checked"))
        {
            var collectionEmail = jQuery.parseJSON(JSON.stringify(getFilteredData()))
            var mobiles = collectionEmail.map(function(i) {
                  return i.mobile;
            });
            jQuery("#biz_cus_ids").val('');
            jQuery(".chk-prse-error").hide();
            jQuery("#phone_number_sms").val(cleanArray(mobiles));
            jQuery("#unchecked_ids").val(uncheckedCusIds);
            jQuery("#userinfo-sms-share").dialog('close');
        }
        else if (checkedMobile.length > 0)
        {
            jQuery(".chk-prse-error").hide();
            jQuery("#phone_number_sms").val(checkedMobile);
            jQuery("#unchecked_ids").val(uncheckedCusIds);
            checkedMobile = [];
            jQuery("#userinfo-sms-share").dialog('close');
        }
        else
        {
            jQuery("#phone_number_sms").val("");
            jQuery(".chk-prse-error").show();
        }
    }
    else
    {
        jQuery('.customer-info-lb table tbody tr').filter(':has(:checkbox:checked)').find('span.mobile-num-chk').each(function(i, input)
        {
            multiSelectval.push(jQuery(input).text());
        });
        if (jQuery("#chk_trigger_select_all").is(":checked"))
        {
            var collectionEmail = jQuery.parseJSON(JSON.stringify(getFilteredData()))
            var mobiles = collectionEmail.map(function(i) {
                   return i.mobile;
            });
            jQuery("#call_cus_ids").val('');
            jQuery(".chk-prse-error").hide();
            jQuery("#phone_number").val(cleanArray(mobiles));
            jQuery("#unchecked_call_ids").val(uncheckedCusIds);
            jQuery("#userinfo-make-call-share").dialog('close');
        }
        else if (checkedMobile.length > 0)
        {
            jQuery(".chk-prse-error").hide();
            jQuery("#phone_number").val(checkedMobile);
            jQuery("#unchecked_call_ids").val(uncheckedCusIds);
            checkedMobile = [];
            jQuery("#userinfo-make-call-share").dialog('close');
        }
        else
        {
            jQuery("#phone_number").val("");
            jQuery(".chk-prse-error").show();
        }
    }
      }
});

//on click of the checkbox:
function selectRow() {
    var checked = this.checked,
    row = $(this).closest("tr"),
    grid = $("#grid-"+share_type).data("kendoGrid"),
    dataItem = grid.dataItem(row);
    checkedIds[dataItem.id] = checked;
    if (checked) {
        //-select the row
        checkedEmail.push(dataItem.email);
        checkedMobile.push(dataItem.mobile);
        if(jQuery("#select-all").val() == "false" || jQuery("#select-all").val() == ""){
          checkedCusIds.push(dataItem.id);
          jQuery("#biz_cus_ids").val(checkedCusIds);
          if(share_type == "call_count") {jQuery("#call_cus_ids").val(checkedCusIds);}
        }

        /* Remove Unchecked ID, again if selected */
        uncheckedCusIds =  jQuery.grep(uncheckedCusIds, function(value) {
            return value != dataItem.id;
        });
    }
    else {
        //-remove selection
        checkedEmail =  jQuery.grep(checkedEmail, function(value) {
            return value != dataItem.email;
        });
        checkedMobile =  jQuery.grep(checkedMobile, function(value) {
            return value != dataItem.mobile;
        });
        checkedCusIds =  jQuery.grep(checkedCusIds, function(value) {
            return value != dataItem.id;
        });
        jQuery("#biz_cus_ids").val(checkedCusIds);
        if(share_type == "call_count") {jQuery("#call_cus_ids").val(checkedCusIds);}
    }
}

//on dataBound event restore previous selected rows:
function onDataBound(e) {
    jQuery(".customer-info-lb  input").prop("checked", jQuery("#chk_trigger_select_all").is(":checked"));
    var view = this.dataSource.view();
    for(var i = 0; i < view.length;i++){
        if(email_status.indexOf(view[i].status) > -1) { this.tbody.find("tr[data-uid='" + view[i].uid + "']").css('background-color','grey'); }
        if(checkedIds[view[i].id])
        {
            this.tbody.find("tr[data-uid='" + view[i].uid + "']").find(".checkbox").attr("checked","checked");
        }else if(jQuery("#select-all").val() == "true" ){
          if(uncheckedCusIds.indexOf(view[i].id) == -1){
            this.tbody.find("tr[data-uid='" + view[i].uid + "']").find(".checkbox").attr("checked","checked");
          }
        }
    }
}
}

function applyFilterState(collectionApplyData)
{
    var states = collectionApplyData.map(function(i) {
        return i.states;
        var stateArrayClean = states.filter(function(v){
            return (v!=='' && v != null)
            });
        jQuery("#state-row").kendoAutoComplete({
            dataSource: jQuery.unique(stateArrayClean)
        });
    });
}
function applyFilterCity(collectionApplyData)
{
    var cities = collectionApplyData.map(function(i) {
        return i.city;
    });
    var cityArrayClean = cities.filter(function(v){
        return (v!=='' && v != null)
    });
    jQuery("#city-row").kendoAutoComplete({
        dataSource: jQuery.unique(cityArrayClean)
    });

}
function applyFilterArea(collectionApplyData)
{
    var areas = collectionApplyData.map(function(i) {
        return i.area;
    });
    var areaArrayClean = areas.filter(function(v){
        return (v!=='' && v != null)
        });
    jQuery("#area-row").kendoAutoComplete({
        dataSource: jQuery.unique(areaArrayClean)
    });
}
function undo(){
    var pre_define=$("#undo").val();
    if(pre_define==""){
    }
    else{
        changed_values=pre_define;
    }
    if (changed_values.length > 0){
        var last_changed=changed_values[changed_values.length-1];
        var chang_val=last_changed.split("-")[0];
        var prev_val=last_changed.split("-")[1];
        var popped_values=[];
        changed_values.pop();
        for(i=0;i<changed_values.length;i++){
            popped_values.push(changed_values[i]);
        }
        changed_values=popped_values;
        if (chang_val == "#question_style_font_style"){
            $(".quesion-left").css("font-family",prev_val);
            $("#question_style_font_style").css("font-family",prev_val);
            $("#question_style_font_style").val(prev_val);
            $('#question_style_background').focus();
        }
        else if (chang_val == "#question_style_background") {
            $("body").css("background-color",prev_val);
            $("#question_style_background").css("background-color",prev_val);
            $("#question_style_background").val(prev_val);
        //~ $('#question_style_background').focus();
        }
        else if (chang_val == "#question_style_page_header"){
            $(".quesion-left #company_name").css("color",prev_val);
            $("#question_style_page_header").css("background-color",prev_val);
            $("#question_style_page_header").val(prev_val);
            $('#question_style_page_header').focus();
        }
        else if (chang_val == "#question_style_question_text"){
            $(".quesion-left #question").css("color",prev_val);
            $("#question_style_question_text").css("background-color",prev_val);
            $("#question_style_question_text").val(prev_val);
            $('#question_style_question_text').focus();
        }
        else if (chang_val == "#question_style_submit_button"){
            $("#submit").css("background-color",prev_val);
            $("#question_style_submit_button").css("background-color",prev_val);
            $("#question_style_submit_button").val(prev_val);
            $('#question_style_submit_button').focus();
        }
        else if (chang_val == "#question_style_button_text"){
            $(".quesion-left #submit").css("color",prev_val);
            $("#question_style_button_text").css("background-color",prev_val);
            $("#question_style_button_text").val(prev_val);
            $('#question_style_button_text').focus();
        }
        else if (chang_val == "#question_style_answers"){
            $(".quesion-left #answers").css("color",prev_val);
            $("#question_style_answers").css("background-color",prev_val);
            $("#question_style_answers").val(prev_val);
            $('#question_style_answers').focus();
        }
        $("#undo").val(changed_values);
    }
    else {
        alert("No More changes to Undo");
    }
}

$("body").delegate("#langlist","change", function(){
    jQuery("#language").val(jQuery("#langlist").val());
});

function add_tab_index()
{
    $(":input").each(function (i) {
        $(this).attr('tabindex', i + 1);
    });
}
// Question answer type ajax
$("body").delegate("#single_qst_tab","click", function(){
    single_qst_ajax(true);
// enable_quill_pad();
})
$("body").delegate("#multiple_qst_tab","click", function(){
    multiple_qst_ajax(true);
// enable_quill_pad();
})
$("body").delegate("#yes_no_tab","click", function(){
    yes_no_ajax(true);
})
$("body").delegate("#comment_tab","click", function(){
    comment_ajax(true);
})

$("#question_style_font_style").change(function(){
    var prev_val = $(this).val();
    $(".quesion-left").css("font-family",prev_val);
    $("#question_style_font_style").css("font-family",prev_val);
    $("#question_style_font_style").val(prev_val);
});


function single_qst_ajax(click_status,ques_id) {
    jQuery.ajax({
        url : '/question/single_question?question_id='+ques_id,
        success : function(data) {
            jQuery("#single_answer").html(data);
            reindex();
            single_qst_tab_select_edit();
            enable_button();
            add_delete_button();
            enable_quill_pad();
            if (click_status == true)
            {
                clear_answer_option();
            }
        }
    });
}

function multiple_qst_ajax(click_status,ques_id)
{
    jQuery.ajax({
        url : '/question/multiple_question?question_id='+ques_id,
        success : function(data) {
            jQuery("#multiple_answer").html(data);
            reindex();
            multi_sql_tab_select_edit();
            enable_button();
            add_delete_button();
            enable_quill_pad();
            if (click_status == true)
            {
                clear_answer_option();
            }
        }
    });
}

function yes_no_ajax(click_status,ques_id)
{
    jQuery.ajax({
        url : '/question/yes_no_question?question_id='+ques_id,
        success : function(data) {
            jQuery("#yes_no").html(data);
            reindex();
            yes_no_tab_select_edit();
            if (click_status == true)
            {
                clear_other_check_box();
            }
        }
    });
}

function comment_ajax(click_status)
{
    jQuery.ajax({
        url : '/question/comment_question',
        success : function(data) {
            jQuery("#comment").html(data);
            reindex();
            comment_tab_select_edit();
        }
    });
}

function validate(){

    /* Video photo question condition */
    if ($('#chk_youtub_upload').is(':checked') && $("#embed_url").val() != "" && $("#copy_video_url").val() != ""){
        $("#copy_video_url").val('');
    }

    var question_text = $.trim($('#question_body').val())
    option_arry=[]
    data_arry=[]
    result=[]
    jQuery("#another_answer :text").each(function()
    {
        var option=this.value;
        data_arry.push($.trim(option).toLowerCase());
        if ($.trim(option) == "")
        {
            option_arry.push("true");
        }
        // if ($.trim(option).length > 70)
        // {
           // option_arry.push("true");
	    // option_arry.push("len");
        // }

    })
    //File upload validations
    var checkbox_checked = jQuery("#question_video_upload_checkbox").prop("checked");
    var self_upload_radio = jQuery("#chk_self_upload").is(':checked');
    var youtube_upload = jQuery("#chk_youtub_upload").is(':checked');

    var opt_found = $.inArray('true',option_arry)
    var check_video_upload = check_video_present(checkbox_checked,self_upload_radio,youtube_upload)
    // All fields are blank - Video checked
    var return_create_ques = false;
    if (question_text == "" && (opt_found != -1) && check_video_upload)
    {
        $('.question_error').css("display","block");
        $('.answer_error').css("display","block");
        $('.answer_uni_error').css("display","none");
	//~ //~ $('.answer_length_error').css("display","none");
        Quill.setFocus('question_body');
        return_create_ques = false;
    }
    //All fields are blank - Video not checked
    else if (question_text == "" && (opt_found != -1) && !check_video_upload){
        $('.question_error').css("display","block");
	$('.answer_error').css("display","block");
        $('.answer_uni_error').css("display","none");

        Quill.setFocus('question_body');
        return_create_ques = false;
    }
    // Question is blank and answer is blank - Video not checked
    else if (question_text != "" && (opt_found != -1) && !check_video_upload){
        $('.question_error').css("display","none");
	$('.answer_error').css("display","block");
        //~ $('.answer_length_error').css("display","block");
        $('.answer_uni_error').css("display","none");
        setTimeout(function() {
            Quill.setFocus('single_ans_0');
        });
        return_create_ques = false;
    }
    // Question is not blank and answer is blank - Video checked
    else if (question_text != "" && (opt_found != -1) && check_video_upload){
        $('.question_error').css("display","none");
        $('.answer_error').css("display","block");
        $('.answer_uni_error').css("display","none");
	//~ $('.answer_length_error').css("display","block");
        setTimeout(function() {
            Quill.setFocus('single_ans_0');
        });
        return_create_ques = false;
    }
    // Question is blank and answer is not blank, no duplicate answer - Video not checked
    else if (question_text == "" && !(opt_found != -1) && !hasDuplicates(data_arry) && !check_video_upload)
    {
        $('.question_error').css("display","block");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","none");
	//~ //~ $('.answer_length_error').css("display","none");
        Quill.setFocus('question_body');
        return_create_ques = false;
    }
    // Question is blank and answer is not blank, duplicate answer - Video checked
    else if (question_text == "" && !(opt_found != -1) && hasDuplicates(data_arry) && check_video_upload){
        $('.question_error').css("display","block");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","block");
	//~ //~ $('.answer_length_error').css("display","none");
        return_create_ques = false;
    }
    // Question is blank and answer is not blank, duplicate answer - Video not checked
    else if (question_text == "" && !(opt_found != -1) && hasDuplicates(data_arry) && !check_video_upload){
        $('.question_error').css("display","block");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","block");
	//~ $('.answer_length_error').css("display","none");
        Quill.setFocus('question_body');
        return_create_ques = false;
    }
    // Question is blank and answer is not blank, no duplicate answer - Video checked
    else if (question_text == "" && !(opt_found != -1) && !hasDuplicates(data_arry) && check_video_upload){
        $('.question_error').css("display","block");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","none");
        return_create_ques = false;
    }
    // Question is not blank and answer is not blank, no duplicate answer- Video checked
    else if (question_text != "" && !(opt_found != -1) && !hasDuplicates(data_arry) && check_video_upload){
        $('.question_error').css("display","none");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","none");
	//~ $('.answer_length_error').css("display","none");
        return_create_ques = false;
    }
    // Question is not blank and answer is not blank, duplicate answer- Video checked
    else if (question_text != "" && !(opt_found != -1) && hasDuplicates(data_arry) && check_video_upload){
        $('.question_error').css("display","none");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","block");
	//~ $('.answer_length_error').css("display","none");
        return_create_ques = false;
    }
    // Question not blank and answer is not blank, duplicate answer - Video not checked
    else if (question_text != "" && !(opt_found != -1) && hasDuplicates(data_arry) && !check_video_upload){
        $('.question_error').css("display","none");
        $('.answer_error').css("display","none");
        $('.answer_uni_error').css("display","block");
	//~ $('.answer_length_error').css("display","none");
        return_create_ques = false;
    }
    // Question not blank - Answer is not blank, no duplicate answer - Video not checked
    else{
        $('.question_error').css("display","none");
        $('.answer_error').css("display","none");
        $("#video_error").css("display","none");
        $('.answer_uni_error').css("display","none");
	//~ $('.answer_length_error').css("display","none");
        return_create_ques = true;
    }
    if (return_create_ques == true)
    {
     jQuery(".loading").show();
    }
    else
        jQuery(".loading").hide();
        return return_create_ques;
}

function check_video_present(add_video,self_video,youtube_video){
    var self_video_value = jQuery("#val").text();
    var youtube_video_value = jQuery("#embed_url").val();
    var check_video_upload;

    var comment_tab = $("#comment_tab").parent().attr('class');  // set true when is active
    var yes_no_tab_validation = $("#yes_no_tab").parent().attr('class'); // set true when is active
    if(add_video && (self_video || youtube_video))
    {
        if(add_video && self_video && self_video_value.length == 0){
            $("#video_error").css("display","block");
            $("#video_error").text("Please choose a video/photo file");
            check_video_upload =  true;
        }else if(add_video && youtube_video && youtube_video_value.length == 0){
            $("#video_error").css("display","block");
            $("#video_error").text("Please provide any youtube URL ");
            check_video_upload =  true;
        }else{
            check_video_upload =  false;
        }

        return check_video_upload
    }
    else{
        var video_check = jQuery("#question_video_upload_checkbox").prop("checked");
        $("#video_error").css("display","block");
        check_video_upload =  video_check ? true : false;
    }
    return check_video_upload
}
//~ function check if the array has duplication value
function hasDuplicates(array) {
    var valuesSoFar = {};
    for (var i = 0; i < array.length; ++i) {
        var value = array[i];
        if (Object.prototype.hasOwnProperty.call(valuesSoFar, value)) {
            return true;
        }
        valuesSoFar[value] = true;
    }
    return false;
}

function reindex(){
    index_count=0;
    jQuery("#another_answer :text").each(function(){
        jQuery(this).parent().parent().parent().removeAttr("id");
        jQuery(this).parent().parent().parent().attr("id","row_count_"+index_count);
        jQuery(this).attr("name","ans["+index_count+"]");
        jQuery(this).attr("id","single_ans_"+index_count);
        index_count=index_count+1;
    });
}

jQuery(function () {
    // jQuery("#chk_youtub_upload").click(function () {
    //     jQuery('#question_update').unbind('submit.transloadit');
    //     jQuery("#exampleInputFile").attr("disabled",true);
    //     jQuery(".optimize-upload").attr("disabled", "disabled");
    //     jQuery("#select-button").attr("disabled", "disabled");
    //     jQuery("#InputAnswer1").removeAttr("disabled");
    //     jQuery("#embed_url").removeAttr("disabled")
    // });
    // jQuery("#chk_self_upload").click(function () {
    //     jQuery("#exampleInputFile").removeAttr("disabled");
    //     jQuery(".optimize-upload").removeAttr("disabled");
    //     jQuery("#select-button").removeAttr("disabled");
    //     jQuery("#InputAnswer1").attr("disabled",true);
    //     //transload();
    //     jQuery('#question_update').unbind('submit.transloadit');
    //     jQuery("#embed_url").attr("disabled","true")
    // });
    jQuery("#prv").click(function () {
        if (jQuery("#question_video_url").val() == "") {
            validate();
        //jQuery('#question_update').unbind('submit.transloadit');
        }
    });

    jQuery('#exampleInputFile').change(function () {
        var ext = this.value.match(/\.(.+)$/)[1];
        ext =  ext.toLowerCase();
        if (jQuery.inArray(ext, ['flv', 'avi', 'mp4', 'mov', 'qt', '3gp', '3g2', 'mpeg', 'tts', 'wm', 'wmv', 'wvx']) == -1) {
            jQuery("#video-error").css("display","block");
            jQuery("#video-error").text("Invalid video file format.  Only .3gp, .mpeg, .mp4, .mov and .avi file extention accepted.");
            jQuery(this).val('');
        }
        else
        {
            transload();
            jQuery("#video-error").css("display","none");
        }
    });
});


//hide add button
jQuery('#question_answer_type_id').change(function () {
    var answer = jQuery('#question_answer_type_id').val();
    if (answer == "Yes/no" || answer == "Comments")
        jQuery('#add_ans').hide();
    else
        jQuery('#add_ans').show();
});

jQuery(document).ready(function () {

    // Question Video functionalities
    jQuery(".question_video_browse").click(function () {
        $("#question_video_url").click();
        return false;
    });

    jQuery("#question_video_url").change(function () {
        jQuery(".question_video_input").val(jQuery("#question_video_url").val());
    });

    // Question video attachment image click option
    jQuery(".video-upload-content .qr-file-attach").click(function () {
        return false;
    })

    // Question video select option
    jQuery("input[type='radio']").click(function () {
        var another_class_name;
        var input_class_name = "div." + jQuery(this).attr('class');
        if (jQuery(this).attr("class") == "embed-url") {
            another_class_name = "div.self-upload";
            jQuery("#question_video_url").val("");
        } else {
            another_class_name = "div.embed-url";
            $("#question_embed_url").val("");
        }
        //jQuery(input_class_name).toggle();
        jQuery(another_class_name).toggle();
    });
// To show/hide add button
});
function transload(){
    jQuery('#question_update').transloadit({
        wait: true,
        params: {
            auth: {
                key: "bf80b2b12ae0658bc9ca18514f52245a"
            },
            template_id: "d77d1042cb9683ff936d6172c8310450"
        }
    });
}

function call_click(){
    jQuery("#select_default").select();
}



$("#custom_button").click(function(){
    $("#custom").slideToggle("slow");
});


function validate_image_type()
{
    if ($('#image_upload').val() == "")
    {
        new Messi('Please select a Company Logo', {
            title : null,
            autoclose : 1700,
            buttons: false
        }, {
            center : true,
            viewport : {
                top : '760px',
                left : '0px'
            }
        });
        return false;
    }

}

// function readURL(input){
//     var img_ext= $('#image_upload').val().match(/\.(.+)$/)[1];
//     img_ext =  img_ext.toLowerCase();
//     if (jQuery.inArray(img_ext, ['jpeg', 'jpg', 'png', 'gif']) == -1) {
//         new Messi('File type is not allowed (only jpeg/png/gif images)', {
//             title : null,
//             autoclose : 1700,
//             buttons: false
//         }, {
//             center : true,
//             viewport : {
//                 top : '760px',
//                 left : '0px'
//             }
//         });
//         jQuery('#image_upload').val('');
//     }

//     var ext = $('#image').val().split('.').pop().toLowerCase();

//     if (input.files && input.files[0]) {
//         var reader = new FileReader();
//         reader.onload = function(e){
//             $('#preview_image').attr('src', e.target.result).width(80).height(80);
//         }
//         reader.readAsDataURL(input.files[0]);
//     }

// }


function change_file(){
    var val1 = $("#new").val();
    $("#old").val(val1);
    return false
}


function home_link(){
    window.location.href = "/videos";
}

jQuery("#active_btn").click(function(){
    jQuery.ajax({
        type: 'GET',
        url: '/qrquestion_active?question_id='+jQuery('input:radio[name=age]:checked').val(),
        success: function(data){
            jQuery("#success").text("Successfully Updated").show();
            setTimeout('parent.jQuery.fancybox.close();', 2000);

        }
    });
});

function status_activate(ques_slug){
    jQuery.ajax({
        type: 'POST',
        url: '/question/question_status_change',
        data: {
            question_id: ques_slug,
            ajax: true
        },
        success: function(data){
            if(data.status =="Success")
            {
                jQuery('#inactive_status').text('');
                jQuery('#activate_status').removeClass('label-info');
                jQuery("#activate_status").addClass('label-success')
                jQuery("#activate_status").text("Active");
                jQuery('#compose_qst').attr('href','javascript:void(0)');
                jQuery('#compose_qst').css('cursor','default');
            }
        }
    });
}

jQuery('a.close_flash').click(function () {
    jQuery('.success').fadeOut('slow', function() {
        // Animation complete.
        });
});

function confirmAction(){
    var confirmed = confirm("Are you sure to Deactivate this question?");
    return confirmed;
}

function send_email(ques_id) {

    var email = jQuery("#email_value").val();
    if (email !== "" && email !== "Click to add email address") {  // If something was entered
        if (!isValidEmailAddress(email)) {
            jQuery(".email_value_error_message").show(); //error message
            return false;
        } else {
            jQuery(".email_value_error_message").hide();
            return share_email(id =ques_id);
        }
    } else {
        jQuery(".email_value_error_message").show();
        return false;
    }
}

function isValidEmailAddress(emailAddress) {
    var email_array = emailAddress.split(',')
    var pattern = new RegExp(/^(("[\w-+\s]+")|([\w-+]+(?:\.[\w-+]+)*)|("[\w-+\s]+")([\w-+]+(?:\.[\w-+]+)*))(@((?:[\w-+]+\.)*\w[\w-+]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][\d]\.|1[\d]{2}\.|[\d]{1,2}\.))((25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\.){2}(25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\]?$)/i);
    for (i = 0; i < email_array.length; ++i) {
        return pattern.test(email_array[i]);
    }
};

$('#accordion').on('show.bs.collapse', function() {
    var check = $(".panel-collapse").siblings(".panel-heading").children("h4").children("a").children("span");
    if (check.hasClass("arrow-down")) {
        check.removeClass("arrow-down").addClass("arrow-right");
    }
});

$('#accordion').on('shown.bs.collapse', function() {
    var active_check = $(".panel-collapse.in").siblings(".panel-heading").children("h4").children("a").children("span");
    active_check.toggleClass("arrow-right arrow-down");
});

function enable_button()
{
    reindex();
    var count = jQuery("#another_answer :text").length;
    if (count >= 4) {
        jQuery('#add_another_button').hide();
    }
    else {
        jQuery('#add_another_button').show();
    }
}
function remove_column(count)
{
    var text_box_count = jQuery("#another_answer :text").length;
    if (text_box_count >2)
    {
        jQuery('#row_count_'+count).remove();
        enable_button();
        enable_quill_pad();
        add_delete_button();
    }
}
function add_delete_button()
{
    reindex();
    var total_text_count = jQuery("#another_answer :text").length;
    if ( total_text_count >2 )
    {
        index_count = 0;
        jQuery(".tab-content #another_answer :text").each(function(){
            $("#row_count_"+index_count).find('.remove_button').remove();
            $("#row_count_"+index_count).append('<div class="col-lg-2 col-md-3 col-sm-3 remove_button"><div class="add-remove-btns"><a href="javascript:void(0);" onclick=remove_column("'+index_count+'");><span class="glyphicon glyphicon-remove-sign"></span></a></div></div>');
            index_count = index_count + 1
        });
    }
    else
    {
        jQuery('.remove_button').remove();
    }
}
function cleanArray(actual){
    var newArray = new Array();
    for(var i = 0; i<actual.length; i++){
        if (actual[i]){
            newArray.push(actual[i]);
        }
    }
    return newArray;
}