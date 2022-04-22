class AppearanceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(current_user, data)
    AppearanceChannel.broadcast_to(current_user, data)
  end
end
