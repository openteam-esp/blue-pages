# encoding: utf-8

ActiveAdmin.setup do |config|

  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = 'Телефонный справочник'

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  # config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Recommended image height is 21px to properly fit in the header
  #
  # config.site_title_image = "/images/logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = :authenticate_admin_user!


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = :current_admin_user


  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  # config.logout_link_path = :destroy_admin_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get


  # == Admin Comments
  #
  # Admin comments allow you to add comments to any model for admin use
  #
  # Admin comments are enabled by default in the default
  # namespace only. You can turn them on in a namesapce
  # by adding them to the comments array.
  #
  # Default:
  # config.allow_comments_in = [:admin]


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources from here.
  #
  # config.before_filter :do_something_awesome


  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'
end

module ActiveAdmin
  module ViewHelpers
    module BreadcrumbHelper
      def breadcrumb_links(path=nil)
        # Returns an array of links to use in a breadcrumb
        path ||= request.fullpath.dup
        path.gsub!(/^(.*)\?.*/, '\1')
        path.gsub!(/parent_subdivision/, 'subdivision')
        path += "/new" if params[:action] == 'create'
        path += "/edit" if params[:action] == 'update'
        parts = path.gsub(/^\//, '').split('/')
        last = "#{parts.pop}_#{parts[-1].singularize}" if parts.last =~ /new/
        last = "#{parts.pop}_#{parts[-2].singularize}" if parts.last =~ /edit/
        crumbs = []
        parts.each_with_index do |part, index|
          name = ""
          if part =~ /^\d/ && parent = parts[index - 1]
            begin
              parent_class = parent.singularize.camelcase.constantize
              obj = parent_class.find(part.to_i)
              name = obj.display_name if obj.respond_to?(:display_name)
            rescue
            end
          end
          name = part.titlecase if name == ""
          begin
            crumbs << link_to( I18n.translate!("activerecord.models.#{part.singularize}"), "/" + parts[0..index].join('/'))
          rescue I18n::MissingTranslationData
            obj.ancestors.each do | ancestor |
              crumbs << link_to(ancestor.display_name, [:admin, ancestor])
            end if obj && obj.respond_to?(:ancestors)
            crumbs << link_to( name, "/" + parts[0..index].join('/'))
          end
        end
        crumbs << link_to(I18n.t("active_admin.#{last}"), request.fullpath) if last
        crumbs
      end
    end
  end

  module Views
    module Pages
      class New < Base
        def title
          I18n.t("active_admin.new_#{active_admin_config.underscored_resource_name}")
        end
      end
      class Edit < Base
        def title
          I18n.t("active_admin.edit_#{active_admin_config.underscored_resource_name}")
        end
      end
    end
  end

  ResourceController.class_eval do
    protected
      def current_ability
        @current_ability ||= AdminAbility.new(current_admin_user)
      end
  end
end
