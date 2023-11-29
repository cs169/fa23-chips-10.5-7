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

  def self.create_representative(official, ocdid_temp, title_temp, address_info)
    existing_representative = Representative.find_by(name: official.name, ocdid: ocdid_temp, title: title_temp)
    if existing_representative
      Rails.logger.debug 'Found existing representative'
      return existing_representative
    end
    address_parts = [
      address_info.locationName, address_info.line1, address_info.line2,
      address_info.line3, address_info.city, address_info.state,
      address_info.zip
    ]
    full_address = address_parts.reject(&:blank?).join(', ')
    Representative.create!({
                             name:      official.name,
                             ocdid:     ocdid_temp,
                             title:     title_temp,
                             address:   full_address,
                             party:     official.party,
                             photo_url: official.photoUrl
                           })
  end
end
