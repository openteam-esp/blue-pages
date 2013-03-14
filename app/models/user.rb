class User < ActiveRecord::Base
  sso_auth_user

  searchable do
    integer :uid
    integer(:permissions_count) { permissions.count }

    text(:term) { [name, email, nickname].join(' ') }
  end

  def contexts
    permissions.map(&:context).uniq
  end

  def context_tree
    @context_tree ||= contexts
    .flat_map{|c| c.respond_to?(:subtree) ? c.subtree : c}
    .uniq
  end

  def context_tree_of(klass)
    context_tree.select{|node| node.is_a?(klass)}
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
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

