import flash.external.ExternalInterface;

Stage.scaleMode = "noScale";
Stage.align = "TL";

var total_images = 0;
var loaded_images_counter = 0;
var loaded_images = [];
var finished_loading = false;
var current_image = 0;
var movement_damp;

ExternalInterface.addCallback("init_360", this, init_360);
function init_360(images){
  total_images = images.length;
  movement_damp = 1.5 * total_images / Stage.width;
  s_load(images, 0, function(){
    activate_movement();
    for(var i = 1; i < images.length; i++){
      s_load(images, i, false);
    }
  });
};

_root.createEmptyMovieClip("rotator",_root.getNextHighestDepth());
_root.attachMovie("loader","loader",_root.getNextHighestDepth());
loader.loader.gotoAndStop(1);
loader._x = Stage.width - loader._width;
loader._y = Stage.height - loader._height - 100;

function s_load(images, i, callback){
	rotator.createEmptyMovieClip("tmpHolder"+i,rotator.getNextHighestDepth());
	rotator.createEmptyMovieClip("timerListener"+i,rotator.getNextHighestDepth());
	var tmpHolder = rotator["tmpHolder"+i];
  loaded_images[i] = false;
	tmpHolder._alpha = 0;
	loadMovie(images[i], tmpHolder);
	rotator["timerListener"+i].onEnterFrame = function(){
		if(tmpHolder.getBytesTotal() > 0 && tmpHolder.getBytesLoaded() >= tmpHolder.getBytesTotal()){
			delete this.onEnterFrame;
		  loaded_images_counter++;
		  loader.loader.gotoAndStop(Math.round(loader.loader._totalframes * (loaded_images_counter / total_images)));
		  if(loaded_images_counter >= total_images){
		    finished_loading = true;
		    loader._visible = false;
	    }
		  loaded_images[i] = true;
			if(i == 0) tmpHolder._visible = true;
		  else tmpHolder._visible = false;
		  tmpHolder._alpha = 100;
			if(typeof(callback) == "function") callback();
		}
	};
}

function activate_movement(){
  onMouseDown = function(){
    var starting_x = _xmouse;
    onMouseMove = function(){
      if(_xmouse < 0 || _xmouse > Stage.width || _ymouse < 0 || _ymouse > Stage.height){
        delete onMouseMove;
        return;
      }
      var diff = Math.round((starting_x - _xmouse) * movement_damp);
      if(Math.abs(diff) > 0){
        var new_image = (current_image + diff + total_images) % total_images;
        
        //allow for missing images by finding the closest one and moving to that one instead (only look up to half way, otherwise it will look like rotation in the wrong direction)
        if(!finished_loading && !loaded_images[new_image]){
      	  var avoid_neg = new_image + total_images;
      	  var look_direction = diff > 0 ? 1 : -1;
        	for(var i = 1; i <= total_images / 2; i++){
        	  var look_ahead = (avoid_neg + (i * look_direction)) % total_images;
        	  if(loaded_images[look_ahead]){
        	    new_image = look_ahead;
        	    break;
        	  }
      	  }
        }
        
        if(finished_loading || new_image != current_image){ //only change if it actually is a new image
          rotator["tmpHolder"+new_image]._visible = true;
          rotator["tmpHolder"+current_image]._visible = false;
          current_image = new_image;
        }
        
        starting_x = _xmouse;
      }
    }
  }

  onMouseUp = function(){
    delete onMouseMove;
  }
}

//onMouseDown = function(){
//	ExternalInterface.call("send_to_js", "text from flash");
//}

/*init_360([
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00003.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00004.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00005.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00006.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00007.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00008.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00009.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00010.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00011.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00012.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00013.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00014.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00015.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00016.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00017.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00018.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00019.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00020.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00021.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00022.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00023.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00024.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00025.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00026.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00027.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00028.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00029.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00030.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00031.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00032.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00033.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00034.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00035.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00000.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00001.jpg',
  'http://localhost/images/Steel_Silver_Metallic/steel_silver_metallic_00002.jpg'
]);*/