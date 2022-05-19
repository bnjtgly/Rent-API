json.data do
  json.array! @chatrooms.each do |data|
    json.id data.id
    json.title data.title
    json.is_online data.users.where.not(id: current_user.id).first.is_online
    json.message do
      if data.messages.order(created_at: :desc).first
        json.preview data.messages.order(created_at: :desc).first.body
      else
        json.null!
      end
    end
    json.participants data.participants
  end
end
