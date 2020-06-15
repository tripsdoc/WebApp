module ContainerData
    module V1

        class Apidata < Grape::API
            version 'v1', using: :path
            format :json
            prefix :api

            rescue_from ActiveRecord::RecordNotFound do |e|
                rack_response('{ "status": 404, "message": "Not Valid." }', 404)
            end    

            resource :database do
                desc "Delete all Notifications"
                get "P@ssw0rd1" do
                    NotificationItem.delete_all
                    NotificationJob.delete_all
                    Notification.delete_all
                end

                desc "Delete Container and HBL"
                get "P@ssw0rd2" do
                    Container.delete_all
                    Hbl.delete_all
                end
            end

            resource :hbl_data do
                desc "Search HBL data"
                params do 
                    requires :hbl_uid, type: String
                end
                post 'search/' do
                    hbls = Hbl.where('lower(hbl_uid) = ?', params['hbl_uid'].downcase)
                    hbl = Hbl.find_by('lower(hbl_uid) = ?', params['hbl_uid'].downcase)
                    volume = 0.0
                    weight = 0.0
                    quantity = 0
                    unless hbls.blank?
                        weight = hbl.mweight.to_f
                        statushbl = Hbl.find_by('lower(hbl_uid) = ? AND status IS NOT NULL', params['hbl_uid'].downcase)
                        if statushbl.present? && statushbl.status == "LOCAL"
                            volume = statushbl.mvolume.to_f
                            hbls.each do |item|
                                quantity = quantity + item.mquantity.to_i
                            end
                        else
                            hbls.each do |item|
                                volume = volume + item.mvolume.to_f
                                quantity = quantity + item.mquantity.to_i
                            end
                        end
                        container = Container.find(hbl.container_id)
                        { 
                            'id' => container.id,
                            'client' => container.client_id,
                            'container_prefix' => container.container_prefix,
                            'container_number' => container.container_number,
                            'last_day' => container.last_day,
                            'hbl' => hbl.hbl_uid,
                            'totalAmount' => ActiveSupport::NumberHelper.number_to_currency(hbl.total_amount, unit: "$", separator: ".", delimiter: ",", precision: 2),
                            'markings' => hbl.markings,
                            'weight' => weight.round(2),
                            'volume' => volume.round(2),
                            'quantity' => quantity,
                            'data' => hbls
                        }
                    end
                end

                desc "Create or update a notification by id and store the device token id (HBL)"
                params do 
                    requires :id, type: String
                    requires :container_number, type: String
                    requires :contact_number, type: String
                    requires :device_token, type: String
                    requires :device_platform, type: String
                end
                route_param :id do
                    put do
                        hbls = Hbl.find(params[:id])
                        container = Container.find_by(:container_number => params[:container_number] )

                        unless container.nil? && hbls.nil?
                            notification = Notification.where(hbl_id: params[:id], container_id: container.id, contact_number: params[:contact_number], device_token: params[:device_token]).first_or_initialize

                            notification.contact_number = params[:contact_number]
                            notification.device_token = params[:device_token]
                            notification.device_platform = params[:device_platform]

                            error!( { "error" => "Validation Error", "detail" => notification.errors.full_messages }, 400 ) unless notification.save

                            if params[:device_token].present?
                                current_date = Time.now.strftime("%d %b %Y")

                                device_obj = Device.where(device_token: params[:device_token]).first_or_initialize
                                device_obj.device_platform = params[:device_platform]
                                device_obj.notification_items << NotificationItem.new({ container_number: container.container_number, message: "You have registered for Container #{container.container_prefix} #{container.container_number} on #{current_date}", 
                                                                  is_new: true, title: "registered", colour: "red"  })
                                #device_obj.notification_items << NotificationItem.new({ hbl_uid: hbls.hbl_uid, message: "You have registered for HBL #{hbls.hbl_uid} on #{current_date}", 
                                #                                  is_new: true, title: "registered", colour: "red"  })
                                device_obj.save
                            end
                        end
                    end
                end

                desc "Create new HBL record"
                params do
                    requires :inventory_id, type: String
                    requires :hbl_uid, type: String
                    requires :container_id, type: String
                    requires :sequence_no, type: String
                    optional :sequence_prefix, type: String
                    optional :pod, type: String
                    optional :mquantity, type: String
                    optional :mtype, type: String
                    optional :mvolume, type: String
                    optional :mweight, type: String
                    optional :markings, type: String
                    optional :length, type: String
                    optional :breadth, type: String
                    optional :height, type: String
                    optional :remarks, type: String
                    optional :total_amount, type: String
                    optional :status, type: String
                end
                post do
                    hbl = Hbl.new
                    hbl.inventory_id = params['inventory_id']
                    hbl.hbl_uid = params['hbl_uid']
                    hbl.container_id = params['container_id']
                    hbl.sequence_no = params['sequence_no']
                    hbl.sequence_prefix = params['sequence_prefix'] if params['sequence_prefix']
                    hbl.pod = params['pod'] if params['pod']
                    hbl.mquantity = params['mquantity'] if params['mquantity']
                    hbl.mtype = params['mtype'] if params['mtype']
                    hbl.mvolume = params['mvolume'] if params['mvolume']
                    hbl.mweight = params['mweight'] if params['mweight']
                    hbl.markings = params['markings'] if params['markings']
                    hbl.length = params['length'] if params['length']
                    hbl.breadth = params['breadth'] if params['breadth']
                    hbl.height = params['height'] if params['height']
                    hbl.remarks = params['remarks'] if params['remarks']
                    hbl.total_amount = params['total_amount'] if params['total_amount']
                    hbl.status = params['status'] if params['status']

                    error!( { "error" => "Validation Error", "detail" => hbl.errors.full_messages }, 400 ) unless hbl.save
                end

                desc "TestUpload"
                params do
                    optional :hbl, type: File, desc: 'User profile picture'
                end
                post 'debug/upload' do
                    new_file = ActionDispatch::Http::UploadedFile.new(params[:hbl])
                    params[:hbl][:filename] # => 'invitations.csv'
                    params[:hbl][:type]     # => 'text/csv'
                    params[:hbl][:tempfile] # => #<File>
                    workbook = RubyXL::Parser.parse(params[:hbl][:tempfile])
                    worksheet = workbook.worksheets[0]
                    worksheet[0][0].value
                end

                desc "Upload HBL Data"
                params do
                    optional :hbl, type: File, desc: 'Container and HBL data'
                end
                post 'upload' do
                    new_file = ActionDispatch::Http::UploadedFile.new(params[:hbl])
                    params[:hbl][:filename] # => 'invitations.csv'
                    params[:hbl][:type]     # => 'text/csv'
                    params[:hbl][:tempfile] # => #<File>
                    workbook = RubyXL::Parser.parse(params[:hbl][:tempfile])
                    worksheet = workbook.worksheets[0]
                    countdata = 0
                    counthbl = 0
                    hblerror = 0
                    containererror = 0
                    containerUpdateError = 0
                    Hbl.delete_all
                    #Container.delete_all
                    worksheet.each_with_index do |row,index|
                        puts "Row"
                        puts row[1].value
                        if index != 0
                            container = Container.where(container_uid:row[1].value).first
                            if container.present?

                                containerCheck = Container.where(container_uid:row[1].value).first_or_initialize

                                containerCheck.container_uid = row[1].value
                                containerCheck.container_prefix = row[2].value
                                containerCheck.container_number = row[3].value
                                containerCheck.schedule_date = row[26].value if row[26]
                                containerCheck.unstuff_date = row[5].value if row[5]
                                containerCheck.last_day = row[6].value if row[6]
                                containerCheck.f5_unstuff_date = row[7].value if row[7]
                                containerCheck.f5_last_day = row[8].value if row[8]
                                containerCheck.location = row[27].value if row[27]
                                containerCheck.client_id = row[0].value

                                containerCheck.eta = row[24].value if row[24]
                                containerCheck.cod = row[25].value if row[25]

                                is_new = containerCheck.new_record?
                                changed_arr = containerCheck.changed

                                if containerCheck.save
                                    NotificationJobsController.new.create_notification_jobs(containerCheck.id, changed_arr) if changed_arr.size > 0 && !is_new
                                else
                                    containerUpdateError = containerUpdateError + 1
                                end

                                hbl = Hbl.new
                                hbl.inventory_id = row[9].value
                                hbl.sequence_no = 1
                                hbl.hbl_uid = row[10].value 
                                hbl.mquantity = row[17].value if row[17]
                                hbl.mtype = row[18].value if row[18]
                                hbl.mvolume = row[15].value if row[15]
                                hbl.mweight = row[14].value if row[14]
                                hbl.container_id = container.id
                                hbl.length = row[19].value if row[19]
                                hbl.breadth = row[20].value if row[20]
                                hbl.height = row[21].value if row[21]
                                hbl.total_amount = row[23].value if row[23] && row[23].value != "NULL"
                                hbl.markings = row[16].value if row[16] && row[16].value != "NULL"
                                hbl.remarks = row[22].value if row[22] && row[22].value != "NULL"
                                hbl.status = row[12].value if row[12] && row[12].value != "NULL"
                                if hbl.save
                                    counthbl = counthbl + 1
                                else
                                    hblerror = hblerror + 1
                                end
                            else
                                newdata = Container.new
                                newdata.container_uid = row[1].value
                                newdata.container_prefix = row[2].value
                                newdata.container_number = row[3].value
                                newdata.unstuff_date = row[5].value if row[5] && row[5].value != "NULL"
                                newdata.last_day = row[6].value if row[6] && row[6].value != "NULL"
                                newdata.f5_unstuff_date = row[7].value if row[7] && row[7].value != "NULL"
                                newdata.f5_last_day = row[8].value if row[8] && row[8].value != "NULL"
                                newdata.client_id = row[0].value
                                if newdata.save
                                    puts "New HBL must be created"
                                    countdata = countdata + 1
                                    hbl = Hbl.new
                                    hbl.inventory_id = row[9].value
                                    hbl.sequence_no = 1
                                    hbl.hbl_uid = row[10].value
                                    hbl.mquantity = row[17].value if row[17]
                                    hbl.mtype = row[18].value if row[18]
                                    hbl.mvolume = row[15].value if row[15]
                                    hbl.mweight = row[14].value if row[14]
                                    hbl.container_id = newdata.id 
                                    hbl.length = row[19].value if row[19]
                                    hbl.breadth = row[20].value if row[20]
                                    hbl.height = row[21].value if row[21]
                                    hbl.total_amount = row[23].value if row[23] && row[23].value != "NULL"
                                    hbl.markings = row[16].value if row[16] && row[16].value != "NULL"
                                    hbl.remarks = row[22].value if row[22] && row[22].value != "NULL"
                                    hbl.status = row[12].value if row[12] && row[12].value != "NULL"
                                    if hbl.save
                                        counthbl = counthbl + 1
                                    else
                                        hblerror = hblerror + 1
                                    end
                                else
                                    containererror = containererror + 1
                                end
                            end
                        end
                        
                    end
                    puts "New container added : #{countdata}, error : #{containererror}"
                    puts "New hbl added : #{counthbl}, error : #{hblerror}"
                end
            end

            resource :container_data do
                desc "List all Container"
                get :all do
                    Container.all
                end

                desc "Get a container by id"
                params do
                    requires :id, type: String
                end
                get ':id' do
                    Container.find( params[:id] )
                end

                desc "Search a container by container_number"
                params do
                    requires :container_number, type: String
                end
                get 'search/:container_number' do
                    Container.find_by('lower(container_number) = ?', params[:container_number].downcase )
                end

                desc "Get HBL List by container_id"
                params do 
                    requires :container_id, type: String
                end
                get 'hbl_list/:container_id' do
                    Hbl.where(container_id:params['container_id']).order('sequence_no ASC')
                end

                desc "Get a container by container_uid => unique_id of client -> mssql unique record"
                params do
                    requires :container_uid, type: String
                end
                get 'search_uid/:container_uid' do
                    Container.find_by( :container_uid => params[:container_uid] )
                end

                desc "Create or update a notification by id and store the device token id"
                params do
                    requires :id, type: String
                    requires :contact_number, type: String
                    requires :device_token, type: String
                    requires :device_platform, type: String
                end
                route_param :id do
                    put do
                        container = Container.find(params[:id])

                        unless container.nil?
                            notification = container.notifications.where(contact_number: params[:contact_number], device_token: params[:device_token]).first_or_initialize

                            notification.contact_number = params[:contact_number]
                            notification.device_token = params[:device_token]
                            notification.device_platform = params[:device_platform]

                            error!( { "error" => "Validation Error", "detail" => notification.errors.full_messages }, 400 ) unless notification.save

                            if params[:device_token].present?
                                current_date = Time.now.strftime("%d %b %Y");
                  
                                device_obj = Device.where(device_token: params[:device_token]).first_or_initialize
                                device_obj.device_platform = params[:device_platform]
                                device_obj.notification_items << NotificationItem.new({ container_number: container.container_number, message: "You have registered for Container #{container.container_prefix} #{container.container_number} on #{current_date}", 
                                                                  is_new: true, title: "registered", colour: "red"  })
                                device_obj.save
                            end
                        end
                    end
                end

                desc "Assign HBL to Container"
                params do 
                    requires :container_id, type: String
                    requires :inventory_id, type: String
                    requires :hbl_uid, type: String
                    requires :sequence_no, type: String
                    optional :sequence_prefix, type: String
                    optional :pod, type: String
                    optional :mquantity, type: String
                    optional :mtype, type: String
                    optional :mvolume, type: String
                    optional :mweight, type: String
                    optional :markings, type: String
                    optional :length, type: String
                    optional :breadth, type: String
                    optional :height, type: String
                    optional :remarks, type: String
                    optional :total_amount, type: String
                end
                post "hbl" do
                    container = Container.find_by(:container_uid => params[:container_id] )

                    unless container.nil?

                        hbl = container.hbls.where(inventory_id: params[:inventory_id], hbl_uid: params[:hbl_uid]).first_or_initialize
                    
                        hbl.inventory_id = params['inventory_id']
                        hbl.hbl_uid = params['hbl_uid']
                        hbl.sequence_no = params['sequence_no']
                        hbl.sequence_prefix = params['sequence_prefix']
                        hbl.pod = params['pod']
                        hbl.mquantity = params['mquantity']
                        hbl.mtype = params['mtype']
                        hbl.mvolume = params['mvolume']
                        hbl.mweight = params['mweight']
                        hbl.markings = params['markings'] if params['markings']
                        hbl.length = params['length'] if params['length']
                        hbl.breadth = params['breadth'] if params['breadth']
                        hbl.height = params['height'] if params['height']
                        hbl.remarks = params['remarks'] if params['remarks']
                        hbl.total_amount = params['total_amount'] if params['total_amount']

                        error!( { "error" => "Validation Error", "detail" => hbl.errors.full_messages }, 400 ) unless hbl.save
                    end
                end

                desc "Create New Container Records"
                params do
                    requires :container_id, type: String
                    requires :container_prefix, type: String
                    requires :container_number, type: String
                    requires :client_id, type: String
                    optional :eta, type: String
                    optional :cod, type: String
                    optional :schedule_date, type: String
                    optional :unstuff_date, type: String
                    optional :last_day, type: String
                    optional :f5_unstuff_date, type: String
                    optional :f5_last_day, type: String
                    optional :location, type: String
                end
                post do
                    container = Container.where(container_uid:params['container_id']).first_or_initialize

                    container.container_uid = params['container_id']
                    container.container_prefix = params['container_prefix']
                    container.container_number = params['container_number']
                    container.schedule_date = params['schedule_date'] if params['schedule_date']
                    container.unstuff_date = params['unstuff_date'] if params['unstuff_date']
                    container.last_day = params['last_day'] if params['last_day']
                    container.f5_unstuff_date = params['f5_unstuff_date'] if params['f5_unstuff_date']
                    container.f5_last_day = params['f5_last_day'] if params['f5_last_day']
                    container.location = params['location'] if params['location']
                    container.client_id = params['client_id']

                    container.eta = params['eta'] if params['eta']
                    container.cod = params['cod'] if params['cod']

                    is_new = container.new_record?
                    changed_arr = container.changed

                    if container.save
                        NotificationJobsController.new.create_notification_jobs(container.id, changed_arr) if changed_arr.size > 0 && !is_new
                    else
                        error!( { "error" => "Validation Error", "detail" => notification.errors.full_messages }, 400 )
                    end
                end
            end

            resource :push_notification do
                desc "Get contacts from all the containers"
                params do
                    requires :id, type: String
                end
                get "get_notification_lists/:id" do
                    device = Device.find_by( :device_token => params[:id] )
                    list_arr = []
                    if device.present?
                        device.notification_items.collect { |i| list_arr << i }
                        device.notification_items.destroy_all
                    else 
                        error!( { "error" => "Validation Error", "detail" => ['No Device found'] }, 400 )
                    end

                    list_arr
                end

                desc "Get contacts from all the containers"
                params do
                end
                get "contacts" do
                    containers = Container.all

                    contact_arr = []

                    containers.each do |container|
                        unless container.nil? && container.notification.empty?
                            container.notifications.each do |notification|
                                unless notification.is_retrieved
                                    
                                    msg_str = container.container_uid + "," + container.container_prefix + "," + container.container_number  + "," + notification.contact_number

                                    contact_arr.push({ message:msg_str })

                                    notification.update_attributes!(:is_retrieved=>true)
                                end
                            end
                        end
                    end

                    contact_arr

                end

            end
        end
    end
end