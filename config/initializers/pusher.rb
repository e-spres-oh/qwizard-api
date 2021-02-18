require 'pusher'
Pusher.app_id = '1158559'
Pusher.key = Rails.application.credentials.dig(:pusher, :key)
Pusher.secret = Rails.application.credentials.dig(:pusher, :secret)
Pusher.cluster = 'eu'
Pusher.logger = Rails.logger
Pusher.encrypted = true
