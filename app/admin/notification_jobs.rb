ActiveAdmin.register NotificationJob do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :message, :is_sent, :send_at, :container_id, :status_output
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :message, :is_sent, :send_at, :container_id, :status_output]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :title, :message, :is_sent
	
	actions :all, except: [:new, :create] #just show

	index do
    selectable_column
    column :id
    column :title
    column :message
    column :is_sent
    column :send_at
    column :created_at
    column :updated_at

    actions
  end

  filter :title
  filter :message
  filter :is_sent
  
end
