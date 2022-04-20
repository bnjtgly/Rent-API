json.data do
  json.array! @chatrooms.each do |data|
    json.id data.id
    json.title data.title
    # json.sender data.sender.complete_name
    json.message do
      if !data.messages.order(:created_at).last.body.nil?
        json.preview data.messages.order(:created_at).last.body.first(30)
      else
        json.null!
      end
    end
    json.participants data.participants
  end
end
