json.data do
  json.flatmates do
    json.array! @flatmates.each do |data|
      json.flatmate_id data.id
      json.full_name data.full_name
    end
  end
end