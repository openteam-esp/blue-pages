# encoding: utf-8
Fabricator(:person) do
  surname 'Иванов'
  name 'Иван'
  patronymic 'Иванович'
end

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  item_id         :integer
#  surname         :string(255)
#  name            :string(255)
#  patronymic      :string(255)
#  birthdate       :date
#  info_path       :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  academic_degree :text
#  academic_rank   :text
#  dossier         :text
#
