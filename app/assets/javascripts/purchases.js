$(document.body).on('change','#select-cc',function(){
  var creditCardId = $('#select-cc option:selected').val();
  window.location.href = "/purchases?credit_card_id=" + creditCardId;
});