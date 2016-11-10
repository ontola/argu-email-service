# frozen_string_literal: true
namespace :download do
  desc 'Download mail.css from amazon'
  task css: :environment do
    Aws::S3::Client.new.get_object(
      {bucket: 'argu-ci-artifacts', key: 'mail.css'},
      target: 'public/stylesheets/mail.css'
    )
  end
end
