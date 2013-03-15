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
    if contexts.length > 0
      descendants_conditions = contexts.map{|c| "(categories.ancestry LIKE '#{c.child_ancestry}/%')"}.join(' OR ')
      Category
        .where("(categories.id IN (?)) OR (categories.ancestry IN (?)) OR #{descendants_conditions}", contexts.map(&:id), contexts.map(&:child_ancestry))
        .uniq
    else
      Category.where(:id => nil)
    end
  end

  def context_tree_of(klass)
    context_tree.select{|node| node.is_a?(klass)}
  end
end
