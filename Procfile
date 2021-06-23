web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -r ./system/boot.rb
release: rake db:migrate
