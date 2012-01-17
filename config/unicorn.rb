worker_processes 2
preload_app true
timeout 300
listen "/tmp/unicorn/esp/blue-pages.sock", :backlog => 64
pid "/var/run/unicorn/esp/blue-pages.pid"
stderr_path "/var/log/unicorn/esp/blue-pages.stderr.log"
stdout_path "/var/log/unicorn/esp/blue-pages.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
