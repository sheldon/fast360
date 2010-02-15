var flash_markup = '<div id="fast360"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%"><param name="movie" value="/flash/flash360.swf" /><param name="swliveconnect" value="true" /><param name="allowscriptaccess" value="always" /><!--[if !IE]>--><object type="application/x-shockwave-flash" data="/flash/flash360.swf" width="100%" height="100%"><param name="swliveconnect" value="true" /><param name="allowscriptaccess" value="always" /><!--<![endif]--><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a><!--[if !IE]>--></object><!--<![endif]--></object></div>';

jQuery(document).ready(function(){
  var images = [];

  jQuery("li a").each(function(){
    images.push(jQuery(this).attr("href"));
  });

  jQuery("ul").replaceWith(flash_markup);

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