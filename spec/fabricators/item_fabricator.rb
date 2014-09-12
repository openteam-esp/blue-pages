# encoding: utf-8
Fabricator(:item) do
  title "Директа"
  itemable! { Fabricate :subdivision }
  address_attributes { Fabricate.attributes_for(:address, :office => '123') }
end

# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  itemable_id        :integer
#  title              :text
#  position           :integer
#  weight             :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_url          :string(255)
#  itemable_type      :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#
