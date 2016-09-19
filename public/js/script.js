"use strict";
(function(){

$.ajax({url:"http://localhost:9292/album_status"}).done(function(data){
  if (data.new_album === "no") {
    $('.tool-info').text("No new album :(")
  } else if (data.new_album === "yes"){
    {
      $('.tool-info').text("New album!")
    }
  }
})

})();
