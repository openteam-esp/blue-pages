set :job_template, "/usr/local/bin/bash -l -c ':job'" if RUBY_PLATFORM =~ /freebsd/

every :day, :at => '5am' do
  rake 'generate_pdf'
end
