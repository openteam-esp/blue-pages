# encoding: utf-8
# == Schema Information
#
# Table name: people
#
#  academic_degree :text
#  academic_rank   :text
#  birthdate       :date
#  created_at      :datetime         not null
#  dossier         :text
#  id              :integer          not null, primary key
#  info_path       :text
#  item_id         :integer
#  name            :string(255)
#  patronymic      :string(255)
#  surname         :string(255)
#  updated_at      :datetime         not null
#


Fabricator(:person) do
  surname 'Иванов'
  name 'Иван'
  patronymic 'Иванович'
end
