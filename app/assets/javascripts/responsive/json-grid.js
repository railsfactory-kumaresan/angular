function jsonGridBuild(type, response){
    /* Table Grid Cells */
    tableGrid(response);
    function tableGrid(response){
        if(response){
            var tableHeader = "";
            var gridHeaderStart = "<div class='k-grid-header' style='padding-right: 15px;'><div class='k-grid-header-wrap'><table role='grid'>";
            var gridHeaderEnd = "</table></div></div>";
            for(i = 0;i < response.tableData.header.length;i++)
            {
                tableHeader += "<th role='columnheader' class='k-header'><b>" + response.tableData.header[i] +"</b></th>";
            }
            var checkAll = "<th role='columnheader' class='k-header' style='width: 15px;'><input type='checkbox' class='checkbox chk-box-row chk_trigger_select_all' id='select-all-customer' value=''></th>";
            tableHeader = gridHeaderStart + "<thead><tr>" + checkAll + tableHeader + "</tr></thead>" + gridHeaderEnd;
            var tableBody = "";
            var gridBodyStart = "<div class='k-grid-content' style='height: 278px;'><table role='grid' style='height: auto;'>";
            var gridBodyEnd = "</table></div>";
            for(i = 0;i < response.tableData.rows.length;i++)
            {
                var tableRow = "";
                var checkIndividual = "<td role='gridcell' style='width: 15px;'><input type='checkbox' class='checkbox chk-box-row single-customer' id='single-customer-id' value='"+ response.tableData.options[i] +"'></td>";
                for(j = 0;j < response.tableData.rows[i].length;j++)
                {
                    tableRow +="<td role='gridcell'>" + response.tableData.rows[i][j]+"</td>";
                }
                tableBody +=  "<tr>" + checkIndividual + tableRow + "</tr>";
            }
            tableBody = gridBodyStart + "<tbody>" + tableBody + "</tbody>" + gridBodyEnd;
            $("#json-grid-"+type+"").html(tableHeader + tableBody);
        }
        else{
            var noResult = "<div class='table-responsive'><table class='table-bordered table-striped table-condensed cf no-data'><thead class='cf'><tr><th class='quescol'></th></tr></thead><tbody><tr><td>No Customer found!</td></tr></tbody></table></div>";
            $("#json-grid-"+type+"").html(noResult);
        }
        onDataLoad();
    }

    var selectedCustomer = [];
    var unselectedCustomer = [];
    var table = $("#json-grid-"+ type +"");

    table.on("click", ".single-customer" , singleRow);
    table.on("click", "#select-all-customer" , selectAllRow);

    function singleRow() {
        var isChecked = this.checked;
        var tableHeadings = $("#json-grid-"+ type +"").find('thead > tr th').map(function() { return $(this).text().toLowerCase(); }).get();
        var tableData = $(this).closest("tr").children('td').map(function () { return $(this).text(); }).get();
        var dataItem = {};
        for (var i = 0; i < tableData.length; i++) {
            dataItem[tableHeadings[i]] = tableData[i];
        }
        selectedCustomer = cleanArray($("#selected_customers").val().split(','));
        unselectedCustomer = cleanArray($("#unselected_customers").val().split(','));
        $("#select-all-customer").prop("checked",false);
        if (isChecked) {
            if( type == "email" ){
                if (selectedCustomer.indexOf(dataItem.email) == -1) { selectedCustomer.push(dataItem.email);  }
                $("#selected_customers").val(selectedCustomer);
                /* Remove this from unchecked collection, again if selected */
                unselectedCustomer =  $.grep(unselectedCustomer, function(value) {
                    return value != dataItem.email;
                });
                $("#unselected_customers").val(unselectedCustomer);
            }else{
                if (selectedCustomer.indexOf(dataItem.mobile) == -1) { selectedCustomer.push(dataItem.mobile); }
                $("#selected_customers").val(selectedCustomer);
                /* Remove this from unchecked collection, again if selected */
                unselectedCustomer =  $.grep(unselectedCustomer, function(value) {
                    return value != dataItem.mobile;
                });
                $("#unselected_customers").val(unselectedCustomer);
            }
        }
        else {
            if( type == "email" ){
                selectedCustomer =  $.grep(selectedCustomer, function(value) {
                    return value != dataItem.email;
                });
                $("#selected_customers").val(selectedCustomer);
            }else{
                selectedCustomer =  $.grep(selectedCustomer, function(value) {
                    return value != dataItem.mobile;
                });
                $("#selected_customers").val(selectedCustomer);
            }

            /* unchecked email and mobile numbers */
            if($("#select-all").val() == "true"){
                if(type == "email"){
                    unselectedCustomer.push(dataItem.email);
                    $("#unselected_customers").val(unselectedCustomer);
                }
                else{
                    unselectedCustomer.push(dataItem.mobile);
                    $("#unselected_customers").val(unselectedCustomer);
                }
            }
        }
    }

    function selectAllRow() {
        var isChecked = this.checked;
        if(isChecked){
            $("#select-all").val(true);
            $(".single-customer").prop('checked', true);
            var list = customerList(type);
            selectedCustomer = cleanArray(list);
            $("#selected_customers").val(selectedCustomer);
        }else{
            $("#select-all").val(false);
            $(".single-customer").prop('checked', false);
            selectedCustomer = [];
        }
    }

    function onDataLoad() {
        var customers, checked, unchecked;
        customers = customerList(type);
        checked = cleanArray($("#selected_customers").val().split(','));
        unchecked = cleanArray($("#unselected_customers").val().split(','));
        for(var i = 0; i < customers.length; i++){
            if(checked.indexOf(customers[i]) != -1)
            {
                $(':input[value="'+customers[i]+'"]').attr("checked","checked");
            }else if($("#select-all").val() == "true" && unchecked.length > 0){
                if(unchecked.indexOf(customers[i]) == -1){
                    $(':input[value="'+customers[i]+'"]').attr("checked","checked");
                }
            }else if($("#select-all").val() == "true" && unchecked.length == 0){
                $("#select-all").val(true);
                $(".single-customer").prop('checked', true);
                $("#select-all-customer").prop('checked', true);
            }
        }
    }

    function getDataCollection() {
        var tableHeadings = $("#json-grid-"+ type +"").find('thead > tr th').map(function() { return $(this).text().toLowerCase(); }).get();
        var tableData = $("#json-grid-"+ type +"").find('tbody').find('tr').map(function(){
            return [ $(this).children('td').map(function () { return $(this).text(); }).get() ];
        }).get();
        var collection = [];
        for (var j = 0; j < tableData.length; j++) {
            var obj = {};
            for (var k = 0; k < tableData[j].length; k++) {
                obj[tableHeadings[k]] = tableData[j][k]
            }
            collection.push(obj);
        }
        return collection;
    }

    /* Customer List Information */
    function customerList(type){
        var customers;
        if(type == 'email')
            customers = getDataCollection().map(function(i) { return i.email; });
        else{
            customers = getDataCollection().map(function(i) { return i.mobile; });
        }
        return customers
    }

    /* Ajax Pagination */
    $(function () {
        $('.pagination a').on("click", function () {
            $('#mask').addClass('loading');
            $.get(this.href, null, null, 'script');
            return false;
        });
        $('#mask').removeClass('loading');
    });

    /* Close the email modal box */
    $(".close-cus-list-popup").click(function(){
        hideDialogBox(type);
        selectedCustomer = [];
        unselectedCustomer = [];
        $("#selected_customers, #unselected_customers, #select-all").val('');
    });

    $("#share-question-"+ type).click(function(){
        selectedCustomer = cleanArray($("#selected_customers").val().split(','));
        unselectedCustomer = cleanArray($("#unselected_customers").val().split(','));
        var customers = customerList(type);
        if (jQuery("#select-all-customer").is(":checked"))
        {
            $(".chk-prse-error").hide();
            shareList(type,customers);
            $("#selected_customers").val('');
            $("#unselected_customers").val(cleanArray(unselectedCustomer));
            selectedCustomer = [];
            hideDialogBox(type);
        }
        else if (selectedCustomer.length > 0)
        {
            $(".chk-prse-error").hide();
            shareList(type,selectedCustomer);
            $("#unselected_customers").val(cleanArray(unselectedCustomer));
            selectedCustomer = [];
            hideDialogBox(type);
        }
        else
        {
            shareList(type,null);
        }
    });

    function shareList(type,customers){
      if (customers){
        if(type == 'email')
            $("#email_value").val(cleanArray(customers));
        else if(type == 'sms')
            $("#phone_number_sms").val(cleanArray(customers));
        else
            $("#phone_number").val(cleanArray(customers));
      }else{
          $("#email_value,#phone_number_sms, #phone_number").val("");
          $(".chk-prse-error").show();
      }
    }

    function cleanArray(actual){
        var newArray = [];
        for(var i = 0; i<actual.length; i++){
            if (actual[i]){
                newArray.push(actual[i]);
            }
        }
        return newArray;
    }

    function hideDialogBox(type){
        if(type == 'email')
            $("#customer_list_email").modal('hide');
        else if(type == 'sms')
            $("#customer_list_sms").modal('hide');
        else
            $("#customer_list_voice").modal('hide');
    }

    $("#customer_list_filter").click(function(){
        var params = $("#customer-list").serialize();
        jQuery("#selected_customers, #unselected_customers,#select-all").val('');
        jQuery.ajax({
            type: 'GET',
            url: '/share/customer_data_collection?share_type='+ type,
            data: params,
            dataType : 'script',
            success: function(response){

            }
        });
        return false;
    });
}
