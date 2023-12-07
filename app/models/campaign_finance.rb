require 'net/http'
require 'json'

class CampaignFinance
  API_BASE_URL = 'https://api.propublica.org/campaign-finance/v1/'
  API_KEY = '9lcjslvwVjbqtX0KcQQ3W9rFm316caQQ2T89n4xA'

  def self.top_candidates(cycle, category)
    category = category.downcase.gsub(' ', '-')
    url = URI("#{API_BASE_URL}#{cycle}/candidates/leaders/#{category}.json")

    request = Net::HTTP::Get.new(url)
    request['X-API-Key'] = API_KEY
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: url.scheme == 'https') do |http|
      http.request(request)
    end

    data = JSON.parse(response.body)
    candidates = data['results'].map do |candidate|
      {
        name: candidate['name'],
        party: candidate['party'],
        state: candidate['state'] ? candidate['state'].split('/')[2].gsub('.json', '') : nil
      }
    end

    candidates
  end
end
