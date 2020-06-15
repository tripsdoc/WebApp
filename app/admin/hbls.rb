ActiveAdmin.register Hbl do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :inventory_id, :hbl_uid, :sequence_no, :sequence_prefix, :pod, :mquantity, :mtype, :mvolume, :mweight, :container_id, :markings, :length, :breadth, :height, :remarks
  #
  # or
  #
  # permit_params do
  #   permitted = [:inventory_id, :hbl_uid, :sequence_no, :sequence_prefix, :pod, :mquantity, :mtype, :mvolume, :mweight, :container_id, :markings, :length, :breadth, :height, :remarks]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :sequence_no, :sequence_prefix, :length, :breadth, :height, :mquantity, :mvolume, 
            :mweight, :pod, :mtype, :remarks, :markings, :status, :total_amount
            
  index do
    selectable_column
    column :id
    column :inventory_id
    column :hbl_uid
    column :sequence_no
    column :sequence_prefix
    column :pod
    column :markings
    column "Container" do |container|
      unless container.container_id.blank?
        link_to("Container ##{container.container_id}", admin_container_path(container.container_id)) 
      end
    end
    column :remarks
    column :total_amount
    actions
  end

  form do |f|

    f.semantic_errors *f.object.errors.keys

    f.inputs "Edit HBL" do
      f.input :sequence_no
      f.input :sequence_prefix
      f.input :pod
      f.input :mquantity
      f.input :mtype
      f.input :mvolume
      f.input :mweight
      f.input :markings
      f.input :length
      f.input :breadth
      f.input :height
      f.input :remarks
      f.input :total_amount, label: "Total Amount"
      f.input :status, label: "InvStatus"
    end

    f.actions
  end

  filter :hbl_uid
  filter :pod
  filter :markings
  filter :remarks
  filter :total_amount, label: 'Total Amount'
  filter :mvolume, label: 'Volume'
  filter :status, label: 'InvStatus'
  filter :mquantity, label: 'Quantity'
  filter :mtype, label: 'Type'
  filter :mweight, label: 'Weight'
  filter :length
  filter :breadth
  filter :height
  
end
