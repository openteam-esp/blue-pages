# encoding: utf-8
Fabricator(:subdivision) do
  title "Департамент по защите окружающей среды"
  abbr "ДПЗОС"
  parent { Subdivision.root }
  address_attributes { Fabricate.attributes_for(:address) }
end

# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  type               :string(255)
#  title              :text
#  abbr               :string(255)
#  url                :text
#  info_path          :text
#  position           :integer
#  weight             :string(255)
#  ancestry           :string(255)
#  ancestry_depth     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  kind               :string(255)
#  status             :text
#  sphere             :text
#  production         :text
#  image_url          :text
#  slug               :string(255)
#  dossier            :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  mode               :text
#  appointments       :text
#
