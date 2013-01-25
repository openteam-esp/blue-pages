require 'open-uri'
require 'base64'
require 'progress_bar'

class StorageInfoPath
  attr_accessor :info_path

  def initialize(with_info_path)
    self.info_path = with_info_path.info_path.gsub(%r{^/}, '')
  end

  def content
    json_for(:cmd => :get, :target => target)["content"]
  end

  private

  def target
    @target ||= "r1_#{Base64.urlsafe_encode64(info_path).strip.tr('=', '')}"
  end

  def url_for(params)
    "#{Settings['storage.url']}/api/el_finder/v2?#{params.to_param}"
  end

  def json_for(params)
    JSON.parse open(url_for(params)).read
  end

  class Migrator
    attr_accessor :klass
    def initialize(klass)
      self.klass = klass
    end

    def migrate
      objects_with_info_path.each do |object|
        object.update_column :dossier, StorageInfoPath.new(object).content
        bar.increment!
      end
    end

    def bar
      @bar ||= ProgressBar.new(objects_with_info_path.count)
    end

    def objects_with_info_path
      @objects_with_info_path ||= klass.where('info_path IS NOT NULL')
    end
  end
end
