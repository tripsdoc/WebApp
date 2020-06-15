class Container < ApplicationRecord
    has_many :notifications, dependent: :destroy
	has_many :notification_jobs, dependent: :destroy
	has_many :hbls, dependent: :destroy

	validates :container_number, presence: true
	validates :container_prefix, presence: true
	validates :client_id, presence: true

	accepts_nested_attributes_for :hbls, allow_destroy: true
end
