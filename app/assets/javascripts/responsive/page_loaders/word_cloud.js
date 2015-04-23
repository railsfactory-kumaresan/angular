function wordcloud_data_load(id)
{
   if(id == 'dashboard')
   {
    url =  "/dashboard/show_dashboard_wordcloud"
   }
   else
   {
    url =  "/question/show_question_wordcloud?slug=" + id
   }
    if (GetURLParameter('request') == "Filter")
      data = {"id" : id,"action" : "index","request" : "Filter", "category" : GetURLParameter('category'), "from_date" : unescape(GetURLParameter('from_date')) , "to_date" : unescape(GetURLParameter('to_date')),"controller" : "dashboard"}
    else
      data =  {"action" : "index","controller" : "dashboard"}
   jQuery.ajax({
      type: "POST",
      url: url,
      dataType: "JSON",
      data : data ,
      success: function(data){
          var word_array = []
          var i = 0
          jQuery.each(data["response"], function(index, element) {
            if(id == 'dashboard')
             {
              link = "question/" + element.split("_")[1]
              element = element.split("_")[0]
              word_array.push({text: index.replace("?",""), weight: element, link: link});
              }
             else
             {
                word_array.push({text: index, weight: element, link: "/word/answers?option="+index+"&slug="+id});
              }
            i++;
           });
          jQuery("#word_cloud_dashboard").jQCloud(word_array);
      }
   });

}
