module SmsConcern
  include HTTParty

  private

  def send_sms(to, message_body, from = nil)
    ap "TO: #{to}"
    ap "FROM: #{from}"
    ap "MESSAGE: #{message_body}"

    headers = { 'Content-Type' => 'application/x-www-form-urlencoded', :charset => 'utf-8' }

    if to[0..2].eql?('+63')
      ap 'PH NUMBER'

      payload = {
        to: to,
        message: message_body
      }
    else
      ap 'NOT PH NUMBER'

      payload = {
        from: (from || 'Rento').to_s,
        to: to,
        message: message_body
      }
    end

    url = ENV.fetch('BLOWERIO_URL') { SrTenantApplicationApi.credentials[:blowerio_url] }

    response = HTTParty.post("#{url}messages",
                             { body: payload, headers: headers })

    if response.success?
      # TODO: Create new table database to store sms logs
      ap response.parsed_response
      ap 'Create logs for success'

      true
    else
      error_response = JSON.parse(response.parsed_response)
      ap error_response['message'].strip
      ap 'Create logs for failed reason'

      false
    end
  rescue StandardError => e
    ap "SMS NOTIFICATION ERROR message: #{e.message}"
    ap "SMS NOTIFICATION ERROR inspect: #{e.inspect}"
    ap "SMS NOTIFICATION ERROR backtrace: #{e.backtrace}"

    false
  end
end
