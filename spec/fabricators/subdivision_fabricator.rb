# encoding: utf-8
# == Schema Information
#
# Table name: categories
#
#  abbr               :string(255)
#  ancestry           :string(255)
#  ancestry_depth     :integer
#  created_at         :datetime         not null
#  dossier            :text
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_url          :text
#  info_path          :text
#  kind               :string(255)
#  position           :integer
#  production         :text
#  slug               :string(255)
#  sphere             :text
#  status             :text
#  title              :text
#  type               :string(255)
#  updated_at         :datetime         not null
#  url                :text
#  weight             :string(255)
#


Fabricator(:subdivision) do
  title "Департамент по защите окружающей среды"
  abbr "ДПЗОС"
  parent { Subdivision.root }
  address_attributes { Fabricate.attributes_for(:address) }
end
