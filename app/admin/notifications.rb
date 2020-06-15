ActiveAdmin.register Notification do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :contact_number, :device_token, :device_platform, :is_retrieved, :is_activated, :activated_at, :container_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:contact_number, :device_token, :device_platform, :is_retrieved, :is_activated, :activated_at, :container_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :all, except: [:new, :create] #just show

	index do
    selectable_column
    column :id
    column :contact_number
    column :device_token
    column :device_platform
    column "Container" do |container|
      unless container.container_id.blank?
        link_to("Container ##{container.container_id}", admin_container_path(container.container_id)) 
      end
    end
    column "HBL" do |h|
      unless h.hbl_id.blank?
        data = Hbl.find(h.hbl_id).hbl_uid
      end
    end
    #column("Registered Container") {|n| n.container.container_number }
    column :is_retrieved
    column :is_activated
    column :activated_at
    column :created_at
    column :updated_at

    actions
  end

  filter :contact_number
  filter :device_token
  filter :device_platform
  filter :is_activated
  filter :is_retrieved
  
end
