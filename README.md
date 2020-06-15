# HSC Web APP
* Ruby version `ruby-2.6.5`

# Configuration

## Capistrano Deploy 
Before running `cap production deploy`, add all files to the git. Capistrano will copy all files to the server from there

Add to Gemfile</br>
`gem 'capistrano', '~> 3.11'`</br>
`gem 'capistrano-rails', '~> 1.4'`</br>
`gem 'capistrano-passenger', '~> 0.2.0'`</br>
`gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'`</br>

Run `bundle install` then `cap install STAGES=production`

This will create file `Capfile`, `../config/deploy.rb` and `../config/deploy/production.rb`
### Capfile
Add</br>
`require 'capistrano/rails'`</br>
`require 'capistrano/passenger'`</br>
`require 'capistrano/rbenv'`</br>

`set :rbenv_type, :user`</br>
`set :rbenv_ruby, '2.6.5'` => set to current ruby version

### Deploy.rb
- Set application name and make folder in the server exactly same with the one in this file
- Create git repo and set `repo_url`
- set `deploy_to` to the newly created folder
- Add </br>
`append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'`

### Deploy/production.rb
Define server match with the example configuration

## Error Fixing

### Cannot find platform x64-mingw32 or x86_64-linux
Config for deploy from different platform </br>
`bundle lock --add-platform ruby`</br>
`bundle lock --add-platform x86_64-linux`</br>

### ActiveSupport::MessageEncryptor::InvalidMessage
- Delete master.key and credentials.yml.enc
- Run rails credentials:edit

If not found text editor especially on Windows Platform</br>
`SET EDITOR="notepad_path"`

### jquery-ujs not found when deploy capistrano
Run in Command</br>
`yarn add jquery-ujs`

### Cannot load such file --bundler setup or cannot load/find rake command
Set BUNDLED WITH to match with each other (Current platform and deploy platform must match)

### Postgress (Don't use special characters on username and password)
Example error => `'initialize': the scheme redis does not accept registry part: : (or bad hostname?) (URI::InvalidURIError)`

### `assert_index': No such middleware to insert before: ActionDispatch::Static (RuntimeError)
Disable `config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?`

### Rufus Scheduler won't start or start only several times
Add to nginx.conf or sites-enabled/<app-name> </br>
`rails_app_spawner_idle_time 0;`</br>
`passenger_min_instances 1;`

# Services (job queues, cache servers, search engines, etc.)
### Process Notification Jobs
(Old Method)
-Select all notification jobs where is_sent is false
-Select container that refer from the notification job
-Use distinct to device token from notifications that refer from container

(New Method)
-Select all notification jobs where is_sent is false
-Check what is notification jobs refer to
--if refer to container
--if refer to hbl

# Database Creation
[Refer to db](https://github.com/tripsdoc/Web_APP/blob/master/db/DATABASE.md)

# API and System Receiving Data
[Refer to api](https://github.com/tripsdoc/Web_APP/blob/master/app/api/API.md)

