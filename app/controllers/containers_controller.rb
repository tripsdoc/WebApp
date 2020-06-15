class ContainersController < ApplicationController

  def home
  end

  def index
  end

  def new
  end

  def show
  end

  def process_container
    # Get all containers
    containers = Container.all 

    containers.each do |container|
      # Check which container is 7 days after the unstuff date
        
        if ! container.f5_unstuff_date.nil?
          if container.f5_unstuff_date + 7.days < Time.now
            puts container.container_number
            puts container.f5_unstuff_date

            puts "F5 Unstuff Date is #{container.f5_unstuff_date}" 
            puts "It is more than 7 days, Container #{container.container_number} is deleted"

            container.destroy
          end          
        elsif ! container.unstuff_date.nil?
          if container.unstuff_date + 7.days < Time.now
            puts container.container_number
            puts container.unstuff_date

            puts "Unstuff Date is #{container.unstuff_date}" 
            puts "It is more than 7 days, Container #{container.container_number} is deleted"

            container.destroy  
          end
        end
        
    end    

  end

  def search_hbl
    @cls = 'CLS_AAMIR,CLS_AHAR,ECU,CLS_FMN'
    @hbls = Hbl.where('lower(hbl_uid) = ?', params[:hbl_number].downcase)
    @hbl = Hbl.find_by('lower(hbl_uid) = ?', params[:hbl_number].downcase)

    @search_values = { :hbl_number => params[:hbl_number] }

    @volume = 0.0
    @quantity = 0
    @weight = 0.0
    @date_arr = { pod:"", mquantity:"", mtype:"", mvolume:"", markings:"", remarks:"", container_number:"", last_day:"", client:"", totalAmount:"", isCls:false }

    unless @hbl.blank? 
      @container = Container.find(@hbl.container_id)
      @date_arr['pod'] = @hbl.pod
      @date_arr['mquantity'] = @hbl.mquantity
      @date_arr['mtype'] = @hbl.mtype
      @date_arr['mvolume'] = @hbl.mvolume
      @date_arr['totalAmount'] = ActiveSupport::NumberHelper.number_to_currency(@hbl.total_amount, unit: "$", separator: ".", delimiter: ",", precision: 2) if @hbl.total_amount

      @statushbl = Hbl.find_by('lower(hbl_uid) = ? AND status IS NOT NULL', params[:hbl_number].downcase)

      @weight = @hbl.mweight.to_f
      if @statushbl.present? && @statushbl.status == "LOCAL"
        @volume = @statushbl.mvolume.to_f
        @hbls.each do |data|
          @quantity = @quantity + data.mquantity.to_i
        end
      else
        @hbls.each do |data|
          @volume = @volume + data.mvolume.to_f
          @quantity = @quantity + data.mquantity.to_i
          
        end
      end      

      unless @container.blank?
        @date_arr['client'] = @container.client_id if @container.client_id
        if @container.client_id.present?
          @date_arr['isCls'] = @cls.include? @container.client_id
        end
        @date_arr['container_number'] = @container.container_number
        @date_arr['last_day'] = date_modifier @container.last_day, "%d %b %Y %H:%M" if @container.last_day
      end

      @date_arr['markings'] = @hbl.markings
      @date_arr['remarks'] = @hbl.remarks
    end

    @notification = Notification.new

    respond_to do |format|
			format.html { redirect_to @hbl }
			format.js
    end
    
  end

  def search
    @container = Container.find_by( :container_number => params[:container_number] )

    puts @container

    @search_values = { :container_number => params[:container_number]}

    @date_arr = { schedule_date:"", f5_unstuff_date:"", unstuff_date:"", 
                    f5_last_day:"", last_day:"" , location:"", unstuff_date_msg:"" }

    unless @container.blank?
      
      @date_arr['eta'] = date_modifier(@container.eta, "%d %b %Y %H:%M") if @container.eta

      if @container.unstuff_date || @container.f5_unstuff_date 

        @date_arr['f5_unstuff_date'] = date_modifier @container.f5_unstuff_date if @container.f5_unstuff_date

        @date_arr['f5_last_day'] = date_modifier @container.f5_last_day, "%d %b %Y %H:%M" if @container.f5_last_day

        if @container.unstuff_date
          @date_arr['unstuff_date'] = date_modifier @container.unstuff_date
          @date_arr['last_day'] = date_modifier @container.last_day, "%d %b %Y %H:%M"
          @date_arr['location'] = @container.location
        else
          @date_arr['cod'] = date_modifier(@container.cod, "%d %b %Y %H:%M") if @container.cod
          @date_arr['unstuff_date_msg'] = "Normal Cargo is not unstuff yet"
        end

      elsif @container.schedule_date
        @date_arr['schedule_date'] = date_modifier @container.schedule_date
      end
    end

    @notification = Notification.new

		respond_to do |format|
			format.html { redirect_to @container }
			format.js
		end
  end

  private
    def container_params
      params.require(:container).permit(:container_number)
    end
end
