class Notification < ApplicationRecord

	#default_scope -> { order(created_at: :desc) }

    #validates :container_id, presence: true
  
	VALID_CONTACT_NUMBER_REGEX = /\A[689]\d{7}\z/ 

	validates :contact_number, presence: true, format: { with: VALID_CONTACT_NUMBER_REGEX, message: "should be a valid 8 digit Singapore handphone number!" }
end
