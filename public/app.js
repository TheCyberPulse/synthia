var autorefresh = true;

function set_next_song() {
  $.ajax({
      url : window.location.origin + "/nextsong",
      type: "GET",
      success: function(data, textStatus, jqXHR)
      {
        console.log('Next song loaded.');
        if (autorefresh == true) { location.reload(); }
      },
      error: function (jqXHR, textStatus, errorThrown)
      {
        console.log(jqXHR);
      }
  });
}

$(document).ready(function() {
  $(".delete").click(function() {
      var $item = $(this).closest("tr");
      console.log("Video ID:");
      console.log($item.data("video-id"));
      console.log("Requester:");
      console.log($item.data("requester"));
      url = window.location.origin + "/removesong";
      $.ajax({
          url : url,
          type: "POST",
          dataType: 'json',
          contentType: 'application/json',
          data: JSON.stringify({"requester": $item.data("requester"), "video-id": $item.data("video-id")}),
          success: function(data, textStatus, jqXHR)
          {
            $item.remove();
          },
          error: function (jqXHR, textStatus, errorThrown)
          {
            console.log(jqXHR);
          }
      });
  });

  $("#autorefresh").click(function() {
      $("#autorefresh").toggleClass("autorefresh-on autorefresh-off");
      autorefresh = !autorefresh;
  });
});
