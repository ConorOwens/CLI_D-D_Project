require 'open-uri'
require 'nokogiri'

class CLI_Town::Scraper

    def self.scrape_monster_list(monster_list)
      monsters = []
      monster_list_html = Nokogiri::HTML(open(monster_list))
      monster_list_html.css('ul.column li a').each do |mon|
        name = mon.text
        url = mon.attr('href')
        monsters << {name: name, url: url}
      end
      monsters
    end

    def self.scrape_monster(url)
      url_html = Nokogiri::HTML(open(url))
      url_html.css('tr th')
    end

    def self.scrape_feats(feats)

    end

    def self.scrape_magic_shop(magic_shop)

    end

    def self.scrape_provisioner(provisioner)

    end

end