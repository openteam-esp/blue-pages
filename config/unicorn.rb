current_dir = File.expand_path('../..', __FILE__)

project = current_dir.split('/').last

settings = YAML.load_file "#{current_dir}/config/settings.yml"

settings['unicorn'] ||= {}
settings['unicorn']['workers'] ||= 2
settings['unicorn']['preload'] = true if settings['unicorn']['preload'] != false
settings['unicorn']['timeout'] ||= 300
settings['unicorn']['prefix'] ||= {}
settings['unicorn']['prefix']['pid'] ||= '/var/run/esp/'
settings['unicorn']['prefix']['logs'] ||= "/var/log/esp/#{project}/"
settings['unicorn']['prefix']['socket'] ||= '/tmp/esp-'
unless settings['unicorn']['prefix']['socket'].start_with? "/"
  settings['unicorn']['prefix']['socket'] = "#{current_dir}/#{settings['unicorn']['prefix']['socket']}"
end

worker_processes  settings['unicorn']['workers']
preload_app       settings['unicorn']['preload']
timeout           settings['unicorn']['timeout']
pid               "#{settings['unicorn']['prefix']['pid']}#{project}.pid"
stderr_path       "#{settings['unicorn']['prefix']['logs']}stderr.log"
stdout_path       "#{settings['unicorn']['prefix']['logs']}stdout.log"
listen            settings['unicorn']['listen'] if settings['unicorn']['listen']
listen            "#{settings['unicorn']['prefix']['socket']}#{project}.sock", :backlog => 64

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
