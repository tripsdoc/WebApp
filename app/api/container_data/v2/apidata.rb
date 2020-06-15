module ContainerData
    module V2
        class Apidata < Grape::API
            version 'v2', using: :path
            format :json
            prefix :api

            rescue_from ActiveRecord::RecordNotFound do |e|
                rack_response('{ "status": 404, "message": "Not Valid." }', 404)
            end

            resource :container_data do 
                desc "Get a container by id"
                params do
                    requires :id, type: String
                end
                get ':id' do
                    Container.find( params[:id] )
                end

                desc "Create New Container Records"
                params do 
                    requires :container_id, type: String #MSSQL ID {ContainerID}
                    requires :container_prefix, type:String
                    requires :container_number, type:String
                    requires :schedule_date, type:String
                    requires :unstuff_date, type:String
                    requires :last_day, type:String
                    requires :f5_unstuff_date, type:String
                    requires :f5_last_day, type:String
                    requires :location, type:String
                    requires :eta, type:String # Estimated Time Arrival
                    requires :cod, type:String # Completion of Discharge
                end
                post do

                    container = Container.where(container_uid:params['container_id']).first_or_initialize

                    container.container_uid = params['container_id']
                    container.container_prefix = params['container_prefix']
                    container.container_number = params['container_number'].gsub(/\s+/, "") if params['container_number']
                    container.schedule_date = params['schedule_date']
                    container.unstuff_date = params['unstuff_date']
                    container.last_day = params['last_day']
                    container.f5_unstuff_date = params['f5_unstuff_date']
                    container.f5_last_day = params['f5_last_day']
                    container.location = params['location']
                    container.eta = params['eta']
                    container.cod = params['cod']

                    puts params['eta'].inspect
                    puts params['cod'].inspect

                    is_new = container.new_record?
                    changed_arr = container.changed

                    if container.save
                        NotificationJobsController.new.create_notification_jobs(container.id, changed_arr) if changed_arr.size > 0 && !is_new
                    else
                        error!( { "error" => "Validation Error", "detail" => notification.errors.full_messages }, 400 )
                    end

                end
            end
        end
    end
end