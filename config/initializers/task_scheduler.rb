require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '5m' do 
    puts Time.now.to_s + " => Process running"
    NotificationJobsController.new.process_notification_jobs
end

scheduler.cron("05 00 * * *") do
    puts Time.now.to_s + " => Process Container that are more than 7 days after DateUnstuff"
    NotificationJobsController.new.test_cron
    #ContainersController.new.process_container
end