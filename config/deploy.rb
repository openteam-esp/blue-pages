set :default_stage, :ato

require 'openteam/capistrano/recipes'
require 'whenever/capistrano'

set :shared_children, fetch(:shared_children) + %w[public/government.pdf public/blue_pages.pdf public/family_department.pdf public/zdrav_department.pdf]
