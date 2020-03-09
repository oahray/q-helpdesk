$( document ).ready(() => {
  if ($('#comment-textarea').val() ==  "") {
   $('#submit-comment-btn').prop('disabled', true);
  }

  $('#comment-textarea').keyup(() => {
    if($('#comment-textarea').val() !=  "") {
      $('#submit-comment-btn').attr('disabled', false);    
    }
    else {
      $('#submit-comment-btn').attr('disabled', true);   
    }
  });
});
