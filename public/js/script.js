
"use strict";
(function(){

$.ajax({url:"http://localhost:9292/album_status"}).done(function(data){
  if (data.new_album === "no") {
    $('.tool-info').text("No new album :(")
  } else if (data.new_album === "yes"){
    {
      $('.tool-info').text("New album!")
      var data = "New album";
      $.post("http://localhost:9292", function(){data})
    }
  }
})

})();