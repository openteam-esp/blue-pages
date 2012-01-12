require 'spec_helper'

describe Person do
  it { should normalize_attribute(:info_path).from('').to(nil) }
end
# == Schema Information
#
# Table name: people
#
#  id         :integer         not null, primary key
#  item_id    :integer
#  surname    :string(255)
#  name       :string(255)
#  patronymic :string(255)
#  birthdate  :date
#  info_path  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

