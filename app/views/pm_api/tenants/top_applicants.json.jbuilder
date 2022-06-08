# frozen_string_literal: true

json.data do
  json.array! @tenant_applications.each do |data|
    json.user do
      json.user_id data[:user_id]
      json.email data[:email]
      json.complete_name data[:complete_name]
      json.avatar data[:avatar]
    end

    json.user_scores do
      json.overall_score "#{data[:overall_score]}%"
      json.scores do
        json.array! data[:user_scores].each do |data|
          json.user_score_id data.id
          json.user_id data.user_id
          json.score_category_type data.ref_score_category_type.display
          json.desc data.desc
          json.score "#{data.score}%"
          json.remark data.remark
        end
      end
    end

  end
end

json.pagy do
  json.merge! @pagination
end