# encoding: utf-8

require 'forgery'
require 'ryba'

Fabricator(:admin_user) do
  email                 { Forgery(:internet).email_address }
  password              { Forgery(:basic).password }
  password_confirmation { |user| user.password }
end
