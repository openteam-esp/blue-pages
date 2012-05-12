# encoding: utf-8

Fabricator(:item) do
  title "Директа"
  subdivision!
  address_attributes { Fabricate.attributes_for(:address, :office => '123') }
end
