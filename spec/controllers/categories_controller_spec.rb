# encoding: utf-8

require 'spec_helper'

describe CategoriesController do
  render_views

  let(:category) { Fabricate(:category) }
  let(:subdivision) { Fabricate(:subdivision, :parent => category) }

  let(:phone) { Fabricate(:phone, :phoneable => subdivision) }

  let(:item) { Fabricate(:item, :subdivision => subdivision,
                         :person_attributes => Fabricate.attributes_for(:person)) }

  def store_data
    phone; item
  end

  describe 'дожен отдаваться JSON' do
    before { store_data }

    it 'GET index' do
      get :index, :format => :json

      expected_hash = {
        'categories' => [
          { 'title' => ' Категория', 'id' => 1 },
          { 'title' => '- Департамент по защите окружающей среды', 'id' => 2 }
        ]
      }

      ActiveSupport::JSON.decode(response.body).should == expected_hash
    end

    it 'GET show' do
      get :show, :id => subdivision.id, :format => :json

      expected_hash = {
        'title' => 'Департамент по защите окружающей среды',
        'address' => '634020, Томская область, г. Томск, пл. Ленина, 2, стр.1',
        'phones' => 'Телефон: (3822) 22-33-44',
        'items' => {
          'person' => 'Иванов Иван Иванович',
          'title' => 'Директа',
          'address' => 'кабинет 123'
        }
      }

      ActiveSupport::JSON.decode(response.body).should == expected_hash
    end
  end
end
