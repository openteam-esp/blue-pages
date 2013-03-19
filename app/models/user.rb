# == Schema Information
#
# Table name: users
#
#  created_at         :datetime         not null
#  current_sign_in_at :datetime
#  current_sign_in_ip :string(255)
#  description        :text
#  email              :text
#  first_name         :text
#  id                 :integer          not null, primary key
#  image              :text
#  last_name          :text
#  last_sign_in_at    :datetime
#  last_sign_in_ip    :string(255)
#  location           :text
#  name               :text
#  nickname           :text
#  phone              :text
#  raw_info           :text
#  sign_in_count      :integer
#  uid                :string(255)
#  updated_at         :datetime         not null
#  urls               :text
#

class User < ActiveRecord::Base
  sso_auth_user

  searchable do
    integer :uid
    integer(:permissions_count) { permissions.count }

    text(:term) { [name, email, nickname].join(' ') }
  end

  has_many :permissions

  has_many :contexts, :through => :permissions, :source => :context, :source_type => 'Category', :uniq => true, :order => 'categories.weight'

  def permissions_for(context)
    permissions.where(:context_id => context.path_ids)
  end

  def roles_for(context)
    permissions_for(context).map(&:role)
  end

  Permission.role.values.each do |role|
    define_method "#{role}_of?" do |context|
      roles_for(context).include?(role)
    end
  end

  def context_tree
    conditions = ["categories.id IN (?)", "categories.ancestry IN (?)"]
    conditions += contexts.map{"categories.ancestry ILIKE ?"}
    Category.where(conditions.join(' OR '),
      contexts.map(&:id),
      contexts.map(&:child_ancestry),
      *contexts.map(&:subtree_condition))
  end
end
