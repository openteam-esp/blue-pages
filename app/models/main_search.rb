class MainSearch < Search
  attr_accessible :keywords

  column :keywords, :text

  private
    def klass
      [Subdivision, Item]
    end
end
