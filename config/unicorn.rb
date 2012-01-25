project = File.expand_path('../..', __FILE__).split('/').last

worker_processes 2
preload_app true
timeout 300
listen "/tmp/unicorn-esp-#{project}.sock", :backlog => 64
pid "/var/run/unicorn/esp/#{project}.pid"
stderr_path "/var/log/unicorn/esp/#{project}.stderr.log"
stdout_path "/var/log/unicorn/esp/#{project}.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
