# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Representative Profile Page', type: :feature do
  before do
    @representative = Representative.create!(
      name:      'Bowen fan',
      title:     'Representative',
      party:     'Democrat',
      address:   '2546 Warring St, Berkeley, CA, 92081',
      photo_url: 'https://t4.ftcdn.net/jpg/01/43/42/83/360_F_143428338_gcxw3Jcd0tJpkvvb53pfEztwtU9sxsgT.jpg'
    )
  end

  it 'displays representative profile information' do
    visit representative_path(@representative)
    expect(page).to have_content(@representative.name)
    expect(page).to have_content(@representative.title)
    expect(page).to have_content(@representative.party)
    expect(page).to have_content(@representative.address)
  end
end
