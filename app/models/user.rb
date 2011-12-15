class User < ActiveRecord::Base
  devise :omniauthable, :trackable, :timeoutable

  attr_accessible :category_ids

  has_and_belongs_to_many :categories

  def manageable_categories
    categories.map(&:subtree).flatten
  end

  def categories_tree
    categories.map(&:subtree).map(&:arrange).inject({}) { |a, v| a.merge(v) }
  end

  def display_name
    name
  end

  def self.from_omniauth(hash)
    User.find_or_initialize_by_uid(hash['uid']).tap do |user|
      user.update_attributes hash['info']
    end
  end
end



# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  uid                :string(255)
#  name               :text
#  email              :text
#  nickname           :text
#  first_name         :text
#  last_name          :text
#  location           :text
#  description        :text
#  image              :text
#  phone              :text
#  urls               :text
#  raw_info           :text
#  sign_in_count      :integer         default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

