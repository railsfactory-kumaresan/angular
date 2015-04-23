function request_listener()
{
  jQuery.ajax({
    type: 'GET',
    url: '/admin/listeners/request_listner',
    success: function(data){
      if(data.status == 200)
      {
        jQuery('#listener_request').modal('show');
        jQuery('#listener_request').on('shown.bs.modal', function (e) {
          jQuery('#activate_listener_message').replaceWith('<label class="text-center listener-success-text">Congratulation! You will receive confirmation on listener module access within 2 business days...</label>');
        })
        jQuery('#listener_request').on('hidden.bs.modal', function (e) {
          window.location.href = "/"
        })
      }
      else
      {
        jQuery('#listener_request').modal('show');
        jQuery('#listener_request').on('shown.bs.modal', function (e) {
          jQuery('#activate_listener_message').replaceWith('<label class="text-center listener-success-text">You have already requested...</label>');
        })
        jQuery('#listener_request').on('hidden.bs.modal', function (e) {
          window.location.href = "/"
        })
      }
    }
  });
}
function pending_listener_status()
{
   jQuery("#pending_listener").modal('show');
}
function load_kendo_ui(){
  dataSource = new kendo.data.DataSource({
    autoSync: true,
    transport: {
      read:  {
        url: "/admin/listeners",
        dataType: "json",
        type: "GET"
      },
      update: {
        url:  function(e){ return  "/admin/listeners/" + e.models[0].user_id},
        dataType: "json",
        type: "PUT"
      },
      destroy: {
        url: "/admin/listeners",
        dataType: "json",
        type: "DELETE"
      },
      create: {
        url: "/admin/listeners",
        dataType: "json",
        type: "POST"
      },
      parameterMap: function(options, operation) {
        if (operation !== "read" && options.models) {
          return {models: kendo.stringify(options.models)};
        }
      }
    },
    batch: true,
    pageSize: 20,
    schema: {
      model: {
        id: "id",
        fields: {
          id: { editable: false },
          user_id: {editable: false},
          first_name: {editable: false},
          email: { editable: false },
          client_id: { editable: false },
          username: { editable: false},
          password: { editable: false },
          status: { editable: true }
        }
      }
    }
  });

jQuery("#grid").kendoGrid({
  dataSource: dataSource,
  pageable: true,
  scrollable: true,
  sortable: true,
  filterable: true,
  height: 430,
  columns: [
  {template: "<span class='row-number'></span>", title: "S.No", width: "5px" },
  { hidden:true, field: "id"},
  { hidden: true,field: "user_id" },
  { hidden: true,field: "first_name" },
  { field: "client_id", title:"Client ID", width: "25px" },
  { hidden: true, field: "company_name"},
  { field: "email", title: "Sign in Email", width: "20px" },
  { field: "username", title:"UserName", width: "10px" },
  { field: "password", title:"Password", width: "10px" },
  { field: "status", title:"Status", width: "5px" },
  {field: "status",title: "Action",template: jQuery("#idTemplate").html(), width: "10px" }
  ],
  dataBound: function () {
    var rows = this.items();
    jQuery(rows).each(function () {
      var index = jQuery(this).index() + 1;
      var rowLabel = jQuery(this).find(".row-number");
      jQuery(rowLabel).html(index);
    });
  }
})
}

function send_email(user_id,first_name)
{

  jQuery('#send_listener_activation').modal('show');
  jQuery('#activate_list').attr('href','/admin/listeners/'+user_id+'/activate_listener');
  jQuery('#send_listener_activation').on('shown.bs.modal', function (e) {
    jQuery('#email_add').html(first_name);
  })
}

//~ New Listener Module chart Graph building

function chart_graph_build(keywords,traffic_source,results_velocity,new_results,post_per_day,init_val_tra,init_val_res_vel, init_val_new_res)
{
    var chart1 = new DoughnutChart($('#traffic_source'), traffic_source, init_val_tra);
    var chart2 = new DoughnutChart($('#new_results'), new_results, init_val_new_res);
    var chart3 = new DoughnutChart($('#results_velocity'), results_velocity, init_val_res_vel);
    var keywords = keywords
    var stats = post_per_day;

      //~ var stats = {
        //~ "iPad Air": [ 100, 200, 300, 100, 250, 200, 300],
        //~ "A7 chip": [ 10, 100, 123, 240, 300, 100, 120],
        //~ "Rihanna": [ 400, 130, 380, 400, 550, 208, 390],
        //~ "Megan Fox": [ 339, 390, 300, 270, 250, 310, 350]
    //~ }
    var t = new TrendsChart($('#trends_chart'), $('#trends_keywords'), keywords, stats);
}

function wcLowHigh(wchwid)
{
  var href = $("#"+wchwid).attr('href');
  jQuery.get(href);
  return false;
}