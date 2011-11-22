# encoding: utf-8

require 'spec_helper'

describe CategoriesController do
  render_views

  let(:category) { Fabricate(:category) }
    let(:subdivision) { Fabricate(:subdivision, :parent => category, :title => 'Подразделение') }
      let(:child_subdivision) { Fabricate(:subdivision, :parent => subdivision, :title => 'Вложенное подразеделение') }

  def store_data
    @store_data ||= subdivision.tap do |subdivision|
      Fabricate(:phone, :phoneable => subdivision)
      Fabricate(:item, :subdivision => subdivision, :person_attributes => Fabricate.attributes_for(:person))
    end

    child_subdivision
  end

  describe 'дожен отдаваться JSON' do
    before { store_data }

    it 'GET index' do
      get :index, :format => :json

      expected_hash = {
        'categories' => [
          { 'title' => ' Категория', 'id' => 1 },
          { 'title' => '- Подразделение', 'id' => 2 },
          { 'title' => '-- Вложенное подразеделение', 'id' => 3 }
        ]
      }

      ActiveSupport::JSON.decode(response.body).should == expected_hash
    end

    it 'GET show' do
      get :show, :id => subdivision.id, :format => :json

      expected_hash = {
        'title' => 'Подразделение',
        'address' => '634020, Томская область, г. Томск, пл. Ленина, 2, стр.1',
        'phones' => ['Телефон: (3822) 22-33-44'],
        'items' => [{
          'person' => 'Иванов Иван Иванович',
          'title' => 'Директа',
          'address' => 'кабинет 123'
        }]
      }

      ActiveSupport::JSON.decode(response.body).should == expected_hash
    end

    it 'GET expanded show' do
      get :show, :id => subdivision.id, :expand => true, :format => :json

      expected_hash = {
        'title' => 'Подразделение',
        'address' => '634020, Томская область, г. Томск, пл. Ленина, 2, стр.1',
        'phones' => ['Телефон: (3822) 22-33-44'],
        'items' => [{
          'person' => 'Иванов Иван Иванович',
          'title' => 'Директа',
          'address' => 'кабинет 123'
        }],
        'subdivisions' => [
          {
            'title' => 'Вложенное подразеделение',
            'address' => '634020, Томская область, г. Томск, пл. Ленина, 2, стр.1'
          },
        ]
      }

      ActiveSupport::JSON.decode(response.body).should == expected_hash
    end
  end
end
