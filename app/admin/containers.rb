ActiveAdmin.register Container do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :container_uid, :container_prefix, :container_number, :schedule_date, :unstuff_date, :last_day, :f5_unstuff_date, :f5_last_day, :location, :eta, :cod
  #
  # or
  #
  # permit_params do
  #   permitted = [:container_uid, :container_prefix, :container_number, :schedule_date, :unstuff_date, :last_day, :f5_unstuff_date, :f5_last_day, :location, :eta, :cod]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  actions :all, except: [:new, :create] #just show

  index do
    selectable_column
    column :id
    column :container_uid
    column :client_id
    column "Container" do |container| 
      container.container_prefix + " " + container.container_number
    end
    column :schedule_date
    column :unstuff_date
    column :last_day
    column :f5_unstuff_date
    column :f5_last_day
    column :location
    actions
  end

  controller do
    def permitted_params
      # params.permit(:blog => [:name, :description])
      params.permit! # allow all parameters
    end
  end

  show do
		default_main_content
	  panel "HBL" do
	    table_for(container.hbls.order("hbls.sequence_no ASC")) do
        column("Inventory ID") {|order| order.inventory_id }
        column("Sequence No") {|order| order.sequence_no }
        column("HBL") {|order| order.hbl_uid }
        column("POD") {|order| order.pod }
        column("MQuantity") {|order| order.mquantity }
        column("MType") {|order| order.mtype }
        column("MVolume") {|order| order.mvolume }
        column("MWeight") {|order| order.mweight }
	    end
	  end
  end
  
  form do |f|

    f.semantic_errors *f.object.errors.keys

    f.inputs "Container Details" do
      f.input :container_uid
      f.input :container_prefix
      f.input :container_number
      
      f.input :schedule_date, as: :datepicker
      f.input :unstuff_date, as: :datepicker
      f.input :last_day
      f.input :f5_unstuff_date, as: :datepicker
      f.input :f5_last_day
      f.input :location
      f.input :eta
      f.input :cod
      f.input :client_id
    end

    f.actions
  end

  filter :client_id
  filter :container_prefix
  filter :container_number
  filter :schedule_date
  filter :unstuff_date
  filter :last_day
  filter :f5_last_day
  filter :f5_unstuff_date
  filter :location
  filter :eta
  filter :cod

end
