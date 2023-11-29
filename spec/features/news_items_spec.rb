# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'News Items Page', type: :feature do
  let(:representative) do
    Representative.create!(
      name:      'Bowen Fan',
      title:     'Representative',
      party:     'Democrat',
      address:   '2546 Warring St, Berkeley, CA, 92081',
      photo_url: 'https://t4.ftcdn.net/jpg/01/43/42/83/360_F_143428338_gcxw3Jcd0tJpkvvb53pfEztwtU9sxsgT.jpg'
    )
  end

  let(:news_item) do
    NewsItem.create!(
      title:          'Sample News',
      description:    'This is a sample news content.',
      representative: representative,
      link:           'www.google.com'
    )
  end

  before do
    news_item # Create a news item before each test
  end

  it 'displays news item title and content' do
    visit representative_news_items_path(representative)

    expect(page).to have_content(news_item.title)
    expect(page).to have_content(news_item.description)
  end

  it 'displays a link to view the representative profile' do
    visit representative_news_items_path(representative)

    expect(page).to have_link('Bowen Fan', href: representative_path(representative))
  end
end
