source :rubygems

gem 'ancestry'
gem 'attribute_normalizer'
gem 'cancan'
gem 'compass',                  '~> 0.12.alpha.4'
gem 'configliere'
gem 'curb'
gem 'default_value_for'
gem 'el_vfs_client'
gem 'email_validator'
gem 'esp-ckeditor'
gem 'esp-auth'
gem 'forgery',                                    :require => false
gem 'formtastic'
gem 'has_enum'
gem 'has_scope'
gem 'has_searcher'
gem 'inherited_resources'
gem 'jquery-rails'
gem 'kaminari'
gem 'nested_form',                                :git => 'git://github.com/kfprimm/nested_form'
gem 'nokogiri',                                   :require => false
gem 'prawn',                    '>= 1.0.0.rc1',   :require => false
gem 'rails',                                      :require => false
gem 'russian'
gem 'ryba',                                       :require => false
gem 'sanitize',                                   :require => false
gem 'show_for'
gem 'sunspot_rails'
gem 'whenever',                                   :require => false

group :assets do
  gem 'therubyracer'                                                        unless RUBY_PLATFORM =~ /freebsd/
  gem 'uglifier'
end

group :development do
  gem 'annotate',               '>= 2.4.1.beta1', :require => false
  gem 'hirb',                                     :require => false
  gem 'itslog'
  gem 'sunspot_solr',                             :require => false
end

group :production do
  gem 'hoptoad_notifier'
  gem 'pg',                                       :require => false
  gem 'unicorn',                                  :require => false         unless ENV['SHARED_DATABASE_URL']
end

group :test do
  gem 'fabrication'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'libnotify'
  gem 'rb-inotify'
  gem 'rspec-rails',                              :require => false
  gem 'shoulda-matchers',                         :require => false
  gem 'spork',                  '>= 1.0.0.rc1',   :require => false
  gem 'sqlite3',                                  :require => false
  gem 'sunspot_matchers',                         :require => false
end
