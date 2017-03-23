require 'openteam/capistrano/deploy'

append :linked_files,
  'config/sunspot.yml',
  'public/blue_pages.pdf',
  'public/family_department.pdf',
  'public/government.pdf',
  'public/zdrav_department.pdf'

set :slackistrano,
  channel: (Settings['slack.channel'] rescue ''),
  webhook: (Settings['slack.webhook'] rescue '')
