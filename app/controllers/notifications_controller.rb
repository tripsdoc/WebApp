class NotificationsController < ApplicationController
  def create
    unless params[:container_id].blank?
      @container = Container.find(params[:container_id])

      @notification = @container.notifications.where(contact_number: notification_params[:contact_number]).first_or_initialize(notification_params)
      @notification.save
    end
    
    unless params[:hbl_id].blank?
      @hbl = Hbl.find(params[:hbl_id])

      @notification = @hbl.notifications.where(contact_number: notification_params[:contact_number]).first_or_initialize(notification_params)
      @notification.save
    end

    respond_to do |format|
      format.html { redirect_to @notification }
      format.js
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:contact_number)
  end
end
