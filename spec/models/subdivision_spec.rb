# encoding: utf-8

require 'spec_helper'

describe Subdivision do
  it { should validate_presence_of :title }

  it { should allow_value('Название на русском языкё').for(:title) }
  it { should allow_value('Название со скобками ()').for(:title) }
  it { should allow_value('Название со дефисом -').for(:title) }
  it { should allow_value('Название с «"кавычками"»').for(:title) }

  it { should_not allow_value('English title').for(:title) }
  it { should_not allow_value('Название с цифрами 123').for(:title) }
end
