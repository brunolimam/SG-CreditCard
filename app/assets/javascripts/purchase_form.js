var removePersonFields = function(button){
  $("#fieldset-" + button.id).remove();
}

$(document).ready(function(){

  var valuePurchaseField = document.getElementById('purchase-value');
  var addPersonElement = document.getElementById('add-person');
  var quantityPeople = 0

  addPersonElement.addEventListener('click', function() {

    totalValue = 0;
    for (var i = 0; i < quantityPeople; i++) {
      totalValue+=parseFloat(document.getElementById('value-person-' + i + '').value);
      console.log(totalValue);
    }

    var nextValue = valuePurchaseField.value-totalValue;
    var fields = '<div id="fieldset-quantity-people-' + quantityPeople + '"><fieldset class="form-inline"><input id="person_id_' + quantityPeople + '" type="text" hidden="true" name=people[][id]><div class="form-group"><input type="text" class="form-control" name=people[][name] placeholder="Nome" data-autocomplete="purchases/autocomplete_person_name" data-id-element="#person_id_' + quantityPeople + '" > </div><div class="form-group"><div class="input-group"> <div class="input-group-addon">R$</div><input type="text" id="value-person-' + quantityPeople + '" class="form-control" name=people[][value] placeholder="Valor" value=' + nextValue +'></div></div> <button id="quantity-people-' + quantityPeople + '" type="button" onclick="removePersonFields(this)" class="btn btn-primary remove-person">Remover</button></fieldset><br></div>';

    $("#fields-people").append(fields);
    quantityPeople++;
  }, false);

});