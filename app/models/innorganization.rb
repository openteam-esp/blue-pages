class Innorganization < Category
  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :items,    :as => :itemable,    :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :address,   :as => :addressable, :dependent => :destroy
  has_one :chief, :class_name => 'Item', :as => :itemable

  after_initialize :set_address_attributes

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :emails
  accepts_nested_attributes_for :phones

  delegate :attributes, :postcode, :region, :district, :locality, :street, :house, :building,
           :to => :address,
           :prefix => true,
           :allow_nil => true

  has_enums

  searchable do
    string  :sphere,      :multiple => true
    string  :status,      :multiple => true
    text    :address,     :boost => 0.7
    text    :dossier
    text    :production
    text    :title,       :boost => 1.5
    text    :url,         :boost => 0.7
  end

  def json_cms(expand, expand_categories=true)
    {}.tap do |result|
      result['id'] = id
      result['title'] = title
      result['address'] = address.to_s
      result['phones'] = Phone.present_as_str(phones.select{|a| !a.kind_internal? })
      result['emails'] = emails.map(&:address)
      result['url']    = url
      result['dossier'] = dossier
      result['image_url'] = image_url
      result['production'] = production
      result['status'] = status
      result['sphere'] = sphere
      result['items'] = [] if items.any?
      items.each do |item|
        hash = {
          'person' => item.person.to_s,
          'title' => item.title,
          'address' => item.address.to_s,
          'image_url' => item.image_url
        }

        hash.merge!('link' => Rails.application.routes.url_helpers.category_item_path(item.itemable, item)) if item.try(:person).try(:info_path?)

        hash.merge!('phones' => Phone.present_as_str(item.phones.select{|a| !a.kind_internal? })) if item.phones.any?
        hash.merge!('emails' => item.emails.map(&:address)) if item.emails.any?

        result['items'] << hash
      end
    end
  end

  def self.sunspot_results(params, paginate_options)
    search {
      keywords(params[:q])
      order_by(:title) if params[:q].blank?
      paginate paginate_options
      with(:sphere, params[:sphere]) if params[:sphere]
      with(:status, params[:status]) if params[:status]
    }.results
  end

  def self.filters
    {
      'sphere' => Hash[human_enums['sphere'].map { |k,v| [k, [:value => v]].flatten }],
      'status' => Hash[human_enums['status'].map { |k,v| [k, [:value => v]].flatten }]
    }
  end

  private
    def send_messages_on_create
      MessageMaker.make_message 'esp.blue-pages.cms', :index_organization, id
    end

    alias :send_messages_on_update :send_messages_on_create

    def send_messages_on_destroy
      MessageMaker.make_message 'esp.blue-pages.cms', :remove_organization, id
    end
end

# == Schema Information
#
# Table name: categories
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  title          :text
#  abbr           :string(255)
#  url            :text
#  info_path      :text
#  position       :integer
#  weight         :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  kind           :string(255)
#  status         :text
#  sphere         :text
#  production     :text
#  image_url      :text
#

