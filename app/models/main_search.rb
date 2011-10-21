class MainSearch < Search
  column :keywords, :text

  private
    def klass
      [Subdivision, Item]
    end
end

# == Schema Information
#
# Table name: searches
#
#  keywords :text
#

