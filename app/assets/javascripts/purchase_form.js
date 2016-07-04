var removePersonFields = function(button){
  $("#fieldset-" + button.id).remove();
}

$(document).ready(function(){

  var addPersonElement = document.getElementById('add-person');
  var quantityPeople = 0

  addPersonElement.addEventListener('click', function() {
    var fields = '<div id="fieldset-quantity-people-' + quantityPeople + '"><fieldset class="form-inline"><input id="person_id_' + quantityPeople + '" type="text" hidden="true" name=people[][id]><div class="form-group"><input type="text" class="form-control" name=people[][name] placeholder="Nome" data-autocomplete="purchases/autocomplete_person_name" data-id-element="#person_id_' + quantityPeople + '" > </div><div class="form-group"><div class="input-group"> <div class="input-group-addon">R$</div><input type="number" class="form-control" name=people[][value] placeholder="Valor"></div></div> <button id="quantity-people-' + quantityPeople + '" type="button" onclick="removePersonFields(this)" class="btn btn-primary remove-person">Remover</button></fieldset><br></div>';

    $("#fields-people").append(fields);
    quantityPeople++;
  }, false);

});