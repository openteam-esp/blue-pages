# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.id_generator = Proc.new { |key| "toolbar_#{key}" }

  navigation.active_leaf_class = 'leaf'

  navigation.items do |primary|
    primary.item :categories, I18n.t('toolbar.categories'), admin_categories_path

    primary.dom_id = 'toolbar'
  end

end
