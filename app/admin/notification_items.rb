ActiveAdmin.register NotificationItem do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :container_number, :message, :device_id, :is_new, :title, :colour
  #
  # or
  #
  # permit_params do
  #   permitted = [:container_number, :message, :device_id, :is_new, :title, :colour]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :is_new, :device_id, :container_number, :title, :colour, 
						:message

  form do |f|

    f.semantic_errors *f.object.errors.keys

    f.inputs "Notification Details" do
    	f.input :is_new
      f.input :device_id, label: 'Device', :as => :select2, :collection => Device.all.collect{ |u| ["#{u.id}, #{u.device_token}", u.id] }
      f.input :container_number
      f.input :hbl_uid
      f.input :title
      f.input :colour
      f.input :message
    end

    f.actions
  end

  filter :device_id
  filter :container_number
  filter :message
  filter :is_new
  filter :title
  filter :colour
  filter :message
  
end
