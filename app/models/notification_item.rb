class NotificationItem < ApplicationRecord
    belongs_to :device

    validates :title, presence: true
	validates :message, presence: true
end
