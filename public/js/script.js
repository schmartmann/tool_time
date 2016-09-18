"use strict";
(function(){

$.ajax({url:"http://localhost:9292/album_status"}).done(function(data){
  if (data.new_album === "no") {
    $('p').text("No new album :(")
  } else if (data.new_album === "yes"){
    {
      $('p').text("New album!")
    }
  }
})

})();
