class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :category_ids

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => { :with => Devise.email_regexp }

  validates_presence_of :name

  validates_presence_of :password, :password_confirmation, :unless => :encrypted_password?

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
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#

