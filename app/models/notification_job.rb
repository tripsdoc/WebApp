class NotificationJob < ApplicationRecord

	default_scope -> { order(created_at: :desc) }

    #validates :container_id, presence: true
end
