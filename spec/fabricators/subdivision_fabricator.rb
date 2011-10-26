# encoding: utf-8

Fabricator(:subdivision) do
  title "Департамент по защите окружающей среды"
  abbr "ДПЗОС"
  address_attributes { Fabricate.attributes_for(:address) }
end
