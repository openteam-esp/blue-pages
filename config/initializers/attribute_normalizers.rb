AttributeNormalizer.configure do |config|
  config.normalizers[:strip_empty_html] = ->(value, options) do
    value.to_s.gsub(%r{<p>\s*</p>}, '')
  end
end
