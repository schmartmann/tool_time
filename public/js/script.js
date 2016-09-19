"use strict";
(function(){

$.ajax({url:"http://localhost:9292/album_status"}).done(function(data){
  if (data.new_album === "no") {
    $('.tool-info').text("No new album :(")
    console.log(data.since_last)
    var years = data.since_last.years
    var months = data.since_last.months
    var weeks = data.since_last.weeks
    var days = data.since_last.days
    var hours = data.since_last.hours
    var seconds = data.since_last.seconds
    $("#album-counter").html("<ul><li>Since last album: "+years+" years</li><li>"+months+" months</li><li>"+weeks+" weeks</li><li>"+days+" days</li><li>"+seconds+" seconds</li></ul>")
  } else if (data.new_album === "yes"){
    {
      $('.tool-info').text("New album!")
      var data = "New album";
      $.post("http://localhost:9292", function(){data})
    }
  }
})

})();
