class User < ActiveRecord::Base
  devise :omniauthable, :trackable, :timeoutable

  attr_accessible :name, :email, :nickname, :first_name, :last_name, :location, :description, :image, :phone, :urls, :raw_info

  has_many :permissions

  has_many :categories, :through => :permissions, :source => :context, :uniq => true

  searchable do
    text :name, :email, :nickname, :phone
  end

  def categories_for(role)
    categories.where(:permissions => {:role => role})
  end

  def categories_subtree
    categories_subtree_for(Permission.enums[:role])
  end

  def categories_subtree_for(role)
    categories_for(role).map(&:subtree).flatten.uniq
  end

  def available_contexts
    categories_subtree_for(:manager)
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

