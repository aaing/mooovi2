class Scraping
  def self.movie_urls
    links =[]
    agent = Mechanize.new
    next_url = ""

    while true do
      page = agent.get('http://review-movie.herokuapp.com' + next_url)
      elements = page.search('.entry-title a')
      elements.each do |ele|
        links << 'http://review-movie.herokuapp.com' + ele.get_attribute('href')
      end
      next_link = page.at('.pagination .next a')
      break unless next_link
      next_url = next_link.get_attribute('href')
    end

    links.each do |link|
      page = agent.get(link)
      title = page.at('.entry-title').inner_text if page.at('.entry-title').inner_text
      image_url = page.at('.entry-content img').get_attribute('src') if page.at('.entry-content img').get_attribute('src')
      director = page.at('.director span').inner_text if page.at('.director span').inner_text
      detail = page.at('.entry-content p').inner_text if page.at('.entry-content p').inner_text
      open_date = page.at('.date span').inner_text if page.at('.date span').inner_text
      # puts title, image_url, director, detail, open_date
      product = Product.where(title: title).first_or_initialize
      product.image_url = image_url
      product.director = director
      product.detail = detail
      product.open_date = open_date
      product.save
    end
  end
end