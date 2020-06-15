ActiveAdmin.register Device do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :device_token, :device_platform
  #
  # or
  #
  # permit_params do
  #   permitted = [:device_token, :device_platform]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :device_token, :device_platform

  index do
    selectable_column
    column :id
    column "Device Token" do |device|
      truncate(device.device_token, omision: "...", length: 20)
    end
    column :device_platform
    actions
  end
  

  show do
		default_main_content
	  panel "Notification Items" do
	    table_for(device.notification_items.order("notification_items.id DESC")) do
	      column("Container Number") {|order| order.container_number }
	      column("Message") {|order| order.message }
	      column("Date Created") {|order| pretty_format order.created_at }
	    end
	  end
  end
  
  filter :device_token
  filter :device_platform
  
end
