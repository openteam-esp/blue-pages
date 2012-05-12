# encoding: utf-8

Fabricator(:phone) do
  kind 'phone'
  number '22-33-44'
  phoneable! { Fabricate :subdivision }
end
