# encoding: utf-8

require 'spec_helper'

describe Subdivision do
  it { should have_one(:building) }
  it { should have_many(:phones) }

  it { should validate_presence_of :title }

  it { should allow_value('Название на русском языке').for(:title) }
  it { should allow_value('Название на русском языке с буквой ё').for(:title) }
  it { should allow_value('Название со скобками ()').for(:title) }
  it { should allow_value('Название со дефисом -').for(:title) }
  it { should allow_value('Название с «"кавычками"»').for(:title) }

  it { should_not allow_value('English title').for(:title) }
  it { should_not allow_value('Название с цифрами 123').for(:title) }


  describe "#url" do
    it { should normalize_attribute(:url).from('www.ru').to('http://www.ru') }
    it { should allow_value('http://super-puper-mega-site.com').for(:url) }
    it { should allow_value('http://super-puper-mega-site.com/ololo').for(:url) }
    it { should allow_value('http://site.com/путь/к файлу?param=%dd').for(:url) }
    it { should allow_value('http://чётко.рф/ваще').for(:url) }
    it { should allow_value('www.site.com').for(:url) }
    it { should_not allow_value('http://super-puper-mega-site.com%').for(:url) }
    it { should_not allow_value('http://super-puper-mega-site.com_').for(:url) }
    it { should_not allow_value('http://site').for(:url) }
    it { should_not allow_value('http://сайt.рф').for(:url) }
    it { should_not allow_value('http://сайт.ру').for(:url) }
  end
end

# == Schema Information
#
# Table name: subdivisions
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#  position   :integer
#  url        :text
#

