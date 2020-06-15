class Device < ApplicationRecord
    has_many :notification_items, dependent: :destroy

	validates :device_token, presence: true
	validates :device_platform, presence: true

	accepts_nested_attributes_for :notification_items, allow_destroy: true
end
