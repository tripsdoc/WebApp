class Hbl < ApplicationRecord
	attribute :container_number
	attribute :last_day
    has_many :notifications, dependent: :destroy
	has_many :notification_jobs, dependent: :destroy

	validates :inventory_id, presence: true
	validates :hbl_uid, presence: true
	validates :sequence_no, presence: true
end
