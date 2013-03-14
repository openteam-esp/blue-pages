# encoding: utf-8
# == Schema Information
#
# Table name: phones
#
#  additional_number :string(255)
#  code              :string(255)
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  kind              :string(255)
#  number            :string(255)
#  phoneable_id      :integer
#  phoneable_type    :string(255)
#  updated_at        :datetime         not null
#


Fabricator(:phone) do
  kind 'phone'
  number '22-33-44'
  phoneable! { Fabricate :subdivision }
end
