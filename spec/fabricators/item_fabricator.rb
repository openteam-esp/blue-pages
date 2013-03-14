# encoding: utf-8
# == Schema Information
#
# Table name: items
#
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_url          :string(255)
#  itemable_id        :integer
#  itemable_type      :string(255)
#  position           :integer
#  title              :text
#  updated_at         :datetime         not null
#  weight             :string(255)
#


Fabricator(:item) do
  title "Директа"
  itemable! { Fabricate :subdivision }
  address_attributes { Fabricate.attributes_for(:address, :office => '123') }
end
