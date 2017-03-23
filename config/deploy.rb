require 'openteam/capistrano/deploy'

append :linked_files, %w[
  config/sunspot.yml
  public/government.pdf
  public/blue_pages.pdf
  public/family_department.pdf
  public/zdrav_department.pdf
]

set :slackistrano,
  channel: (Settings['slack.channel'] rescue ''),
  webhook: (Settings['slack.webhook'] rescue '')
