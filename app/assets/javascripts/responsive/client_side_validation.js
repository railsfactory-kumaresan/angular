function validateFiles(inputFile) {
    var sizeExceeded = false;
    jQuery.each(inputFile.files, function() {
      if (this.size > parseInt(2097152)) {sizeExceeded=true;};
    });
    var file = inputFile.files[0];
    var ext =file.name.split('.').pop().toLowerCase();
    var extenstion = ['jpg','jpeg','gif','png','pjpeg','x-png']
    if (jQuery.inArray( ext, extenstion ) == -1)
    {
      alert('Invalid image format. Only (.jpg, .png or .gif) file extentions allowed.');
      jQuery(inputFile).val('');
    }
    else if (sizeExceeded)
    {
      alert('Please choose a file less then 2 MB');
      jQuery(inputFile).val('');
    }
    else
    {
     if(inputFile.id != 'logo-image-path')
     {
     jQuery(".loading").show();
     jQuery("#account_attachment").submit();
     }
   }
 }