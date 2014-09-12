# encoding: utf-8
Fabricator(:phone) do
  kind 'phone'
  number '22-33-44'
  phoneable! { Fabricate :subdivision }
end

# == Schema Information
#
# Table name: phones
#
#  id                :integer          not null, primary key
#  phoneable_id      :integer
#  phoneable_type    :string(255)
#  kind              :string(255)
#  code              :string(255)
#  number            :string(255)
#  additional_number :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
