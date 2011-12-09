class PathInterpolator
  def self.path(params)
    ActiveSupport::Inflector.transliterate("/#{Subdivision.root}").downcase.gsub(/\s/,'_')
  end
end
