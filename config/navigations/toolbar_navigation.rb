# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.id_generator = Proc.new { |key| "toolbar_#{key}" }

  navigation.active_leaf_class = 'leaf'

  navigation.items do |primary|
    primary.item :categories, I18n.t('toolbar.categories'), manage_categories_path,
      :highlights_on => /^\/manage\/categories/

    primary.item :permissions, I18n.t('permissions.title'), manage_esp_permissions_path if can?(:create, Permission.new)

    primary.item :logout, I18n.t('toolbar.logout'), destroy_user_session_path

    primary.item :user_name, current_user.name

    primary.dom_id = 'toolbar'
  end

end
