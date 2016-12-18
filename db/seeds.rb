# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

people_names = ["Bruno", "Bergson", "Eri", "Laura", "Camila", "Sei", "Igreja", "Casa"]

people_names.each do |person_name|
  Person.create(name: person_name)
end

Setting.create(parameter: "closingday", value: 29, description: "Dia de fechar fatura")
Setting.create(parameter: "paymentday", value: 11, description: "Dia de pagar fatura")
Setting.create(parameter: "limitcard", value: 15000, description: "Limite cartao")