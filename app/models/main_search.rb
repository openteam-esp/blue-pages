class MainSearch < Search
  column :term, :text

  private
    def klass
      [Subdivision, Item]
    end
end

# == Schema Information
#
# Table name: searches
#
#  term :text
#

