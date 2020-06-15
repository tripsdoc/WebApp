class NotificationJobsController < ApplicationController

  require 'fcm'

  def new
  end

  def create_hbl_notification_jobs(hbl_id, changed_arr)
    hbl = Hbl.find(hbl_id)

    unless hbl.blank?
      
      puts "Size of change_arr is " + changed_arr.size.to_s

      sort_arr = ['pod', 'mquantity', 'mtype', 'mvolume', 'mweight']
      new_changed_arr = []
      (sort_arr || []).each do |val|
        new_changed_arr << val if changed_arr.include?(val)
      end

      puts "New Changed Array Order is " + new_changed_arr.inspect.to_s

      new_changed_arr.each do |changed_key|
        puts changed_key
        puts hbl.hbl_uid
        puts hbl.id
        puts hbl.inventory_id
        puts "========================="

        notification_job = hbl.notification_jobs.build()

        if changed_key == "pod" && hbl.pod.present?
          _pod = hbl.pod
          notification_job.title = "pod"
          notification_job.message = "HBL #{hbl.hbl_uid} change Port Of Delivery to #{_pod}."

          notification_job.save

        elsif changed_key == "mquantity" && hbl.mquantity.present?
          _mquantity = hbl.mquantity
          notification_job.title = "mquantity"
          notification_job.message = "HBL #{hbl.hbl_uid} Quantity changed into #{_mquantity}."

          notification_job.save

        elsif changed_key == "mtype" && hbl.mquantity.present?
          _mtype = hbl.mtype
          notification_job.title = "mtype"
          notification_job.message = "HBL #{hbl.hbl_uid} Type changed into #{_mtype}."

          notification_job.save

        elsif changed_key == "mvolume" && hbl.mvolume.present?
          _mvolume = hbl.mvolume
          notification_job.title = "mvolume"
          notification_job.message = "HBL #{hbl.hbl_uid} Volume changed into #{_mvolume}."

          notification_job.save

        elsif changed_key == "mweight" && hbl.mweight.present?
          _mweight = hbl.mweight
          notification_job.title = "mweight"
          notification_job.message = "HBL #{hbl.hbl_uid} Weight changed into #{_mweight}."

          notification_job.save
          
        end
      end

    end
  end

  def create_notification_jobs(container_id, changed_arr)

    container = Container.find(container_id)

    unless container.blank?
      
      puts "Size of change_arr is " + changed_arr.size.to_s

      sort_arr = ['eta', 'cod', 'schedule_date', 'unstuff_date', 'last_day', 'f5_unstuff_date', 'f5_last_day']
      new_changed_arr = []
      (sort_arr || []).each do |val|
        new_changed_arr << val if changed_arr.include?(val)
      end

      puts "New Changed Array Order is " + new_changed_arr.inspect.to_s

      new_changed_arr.each do |changed_key|
        puts changed_key
        puts container.container_number
        puts container.id
        puts container.container_uid
        puts "========================="

        notification_job = container.notification_jobs.build()

        if changed_key == "eta" && container.eta.present?
          _eta = date_modifier(container.eta, "%d %b %Y %H:%M")
          _location = container.location
          notification_job.title = "eta"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} Vessel ETA on #{_eta} at #{_location}."

          notification_job.save unless container.cod.present? || container.unstuff_date.present? || container.f5_unstuff_date.present?

        elsif changed_key == "cod" && container.cod.present?
          _cod = date_modifier(container.cod, "%d %b %Y %H:%M")
          _location = container.location
          notification_job.title = "cod"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} Vessel COD on #{_cod} at #{_location}."

          notification_job.save unless container.unstuff_date.present? || container.f5_unstuff_date.present?
          
        elsif changed_key == "schedule_date" && container.schedule_date.present?
          _schedule_date = date_modifier(container.schedule_date)
          _location = container.location

          notification_job.title = "schedule_date"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} schedule on #{_schedule_date} at #{_location}."

          notification_job.save
          
        elsif changed_key == "unstuff_date" && container.unstuff_date.present?
          _unstuff_date = date_modifier(container.unstuff_date)
          _location = container.location

          notification_job.title = "unstuff_date"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} unstuff on #{_unstuff_date} at #{_location}."

          notification_job.save

        elsif changed_key == "last_day" && container.last_day.present?
          _last_day = date_modifier(container.last_day, "%d %b %Y %H:%M")
          _location = container.location

          notification_job.title = "last_day"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} Last Day on #{_last_day}."

          notification_job.save

        elsif changed_key == "f5_unstuff_date" && container.f5_unstuff_date.present?
          _unstuff_date = date_modifier(container.f5_unstuff_date)
          _location = container.location

          notification_job.title = "F5 unstuff_date"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} F5 Unstuff on #{_unstuff_date} at #{_location}."

          notification_job.save
          
        elsif changed_key == "f5_last_day" && container.f5_last_day.present?
          _last_day = date_modifier(container.f5_last_day, "%d %b %Y %H:%M")
          _location = container.location

          notification_job.title = "F5 Last_day"
          notification_job.message = "Container #{container.container_prefix} #{container.container_number} F5 Last Day on #{_last_day}."			

          notification_job.save
        end
      end
    end
  end

  def process_notification_jobs
    notification_jobs = NotificationJob.where(is_sent:false)

    ios_arr = []
    android_arr = []
    
    Array(notification_jobs).each do |notification_job|

      status_output_arr = []
      mode = ""

      unless notification_job.container_id.blank?
        mode = "container"
        container = Container.find(notification_job.container_id)
        notifications = container.notifications.select("DISTINCT ON (device_token) *")
      end

      unless notification_job.hbl_id.blank?
        mode = "hbl"
        hbl = Hbl.find(notification_job.hbl_id)
        notifications = hbl.notifications.select("DISTINCT ON (device_token) *")
      end

      unless notifications.blank?
        _title = "Hup Soon Cheong"

        #Search all notifications
  
        notifications.each do |notification|
  
          _device_token = notification.device_token
          _device_platform = notification.device_platform
          _contact_number = notification.contact_number
  
          if _device_platform.present? && _device_token.present?
            if(_device_platform.casecmp "ios") == 0
              option = {priority: 'high', data: {message: notification_job.message.chomp}, notification: {title: _title, body: notification_job.message.chomp}}
              fcm_processor(_device_token, option)
              ios_arr.push(_device_token)
            elsif (_device_platform.casecmp "android") == 0
              option = {priority: 'high', data: {message: notification_job.message.chomp}, notification: {title: _title, body: notification_job.message.chomp}}
              fcm_processor(_device_token, option)
              android_arr.push(_device_token)
            end
  
            device_obj = Device.where(device_token: _device_token).first_or_initialize
            device_obj.device_platform = _device_platform
            if mode == "container"
              device_obj.notification_items << NotificationItem.new({ container_number: container.container_number, message: notification_job.message.chomp,
                                                                    is_new: false, title: "has been updated", colour: "blue" })
            else
              device_obj.notification_items << NotificationItem.new({ hbl_uid: hbl.hbl_uid, message: notification_job.message.chomp,
                                                                    is_new: false, title: "has been updated", colour: "blue" })
            end
            
            device_obj.save
  
            temp_msg = _device_platform + " => " + _device_token
            status_output_arr << temp_msg
            puts temp_msg
          end
        end
  
        notification_job.is_sent = true
        notification_job.send_at = Time.now
        notification_job.status_output = status_output_arr.map(&:inspect).join('\n') if status_output_arr.size > 0
        notification_job.save
      end

    end

    msg = "ios sent: #{ios_arr.size} --- " + "Android sent: #{android_arr.size}"
    puts msg
  end

  def test_fcm
    fcm_client = FCM.new('AAAAFNUzeEg:APA91bGnPbqxizj3WQxBhLIyQU2MPvuYw6O4iCrGcFlu1BHpAKiPX3_5gHLqMth4ReYPf3hr4wvzExsSkTyf1UE8wvaJ1H6Shza-6FIIUX8xWn0wQ33Hi_AP1X5Df4tJ37yh7wwFK8GS')
    options = {priority: 'high', data: {message: "Message"}, notification: {title: "Hup Soon Cheong", body: "Body", sound: 'default'}}
    user_device_ids=["cs7V6g4SuYw:APA91bGkT6FclZAcn-6fokQK8toBixG1BCQ-g3mCBBoMjQMv3lkWLOlyft6wK_2p6AUiyf3nx-zZTRyz0UWK5qsRtWjz4mNmUF9hLc2RxYJ9KJUA7B6HK48H1QmJCbUPIS6bbqILP1vJ"]
    user_device_ids.each_slice(20) do |device_ids|
      response = fcm_client.send(device_ids, options)
      puts response
    end
  end

  def test_update
    container = Container.find(4)
    container.location = Time.now.to_s
    container.save
  end

  def test_cron 
    container = Container.find(1)
    container.location = Time.now.to_s
    container.save
  end

  private 

  def notification_params
    params.require(:notification).permit(:contact_number)
  end

  def fcm_processor(device_id, option)
    fcm_client = FCM.new('AAAAFNUzeEg:APA91bGnPbqxizj3WQxBhLIyQU2MPvuYw6O4iCrGcFlu1BHpAKiPX3_5gHLqMth4ReYPf3hr4wvzExsSkTyf1UE8wvaJ1H6Shza-6FIIUX8xWn0wQ33Hi_AP1X5Df4tJ37yh7wwFK8GS')
    response = fcm_client.send(device_id, option)
    puts response
  end
end
