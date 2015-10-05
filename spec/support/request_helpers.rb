module Requests
  module JsonHelpers
    def json_body
      JSON.parse(response.body)
    end
  end
end
