# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end

      address_info = official.address.first
      rep = create_representative(official, ocdid_temp, title_temp, address_info)
      reps.push(rep)
    end
    reps
  end
end

def self.create_representative(official, ocdid_temp, title_temp, address_info)
  Representative.create!({
                           name:      official.name,
                           ocdid:     ocdid_temp,
                           title:     title_temp,
                           address:   {
                             location_name: address_info.locationName,
                             line1:         address_info.line1,
                             line2:         address_info.line2,
                             line3:         address_info.line3,
                             city:          address_info.city,
                             state:         address_info.state,
                             zip:           address_info.zip
                           },
                           party:     official.party,
                           photo_url: official.photoUrl
                         })
end
