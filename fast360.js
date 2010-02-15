jQuery(document).ready(function(){
  var images = [];

  jQuery("li a").each(function(){
    images.push(jQuery(this).attr("href"));
  });

	var flashvars = {};
	var params = {
	  swliveconnect:"true",
	  allowscriptaccess:"always"
	};
	var attributes = {
	  id:"fast360_flash"
	};
	swfobject.embedSWF("/flash/flash360.swf", "fast360", "100%", "100%", "8.0.0", false, flashvars, params, attributes);

  //wait for flash to expose the init function
  var f_slow = setInterval(function(){
    var flash_obj = jQuery("object object")[0];
    if(!flash_obj) flash_obj = jQuery("object")[0];
    if(typeof flash_obj.init_360 == "function"){
      clearInterval(f_slow);
      flash_obj.init_360(images);
    }
  }, 50);
});