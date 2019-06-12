require 'nokogiri'
require 'open-uri'
class Scraper

    def self.scrape_monster_list(monster_list)
      monsters = []
      monster_list_html = Nokogiri::HTML(open(monster_list))
      monster_list_html.css('ul.column li a').each do |mon|
        name = mon.text
        url = 'http://www.d20srd.org' + mon.attr('href')
        monsters << {name: name, url: url}
      end
      monsters
    end

    def self.scrape_monster(url)
    #22 stat blocks
      url_html = Nokogiri::HTML(open(url))
      stat_types = []
      stats = []
      hash = {}
      url_html.css('tr th').each {|x| stat_types << x.text}
      stat_types.reject! {|x| x.empty?}
      i = stat_types.find_index("Size/Type:")
      stat_types[i..stat_types.size].each {|stat| hash[stat] = 1}
      url_html.css('tr td a').each {|x| stats << x.text}
      stats
    end

    def self.scrape_spell_list(spell_list)
      alpha = []
      alpha_book = {}
      spell_list_html = Nokogiri::HTML(open(spell_list))
      spell_list_html.css('h2').each {|segment| alpha << segment.text}
      alpha
      alpha.each {|alpha| alpha_book[alpha] = []}
      counter = 0
      while counter < 23
        spell_list_html.css('li ul li').each_with_index do |spell, index|
          if index > 31 && spell.text[0] == alpha[counter][-2]
            alpha_book[alpha[counter]] << spell.text
          end
        end
        alpha_book[alpha[counter]].each {|spell| spell.gsub(/\Wu2019/, "'")}
        counter += 1
      end
      #31, 1248
      #spell_list_html.css('li ul li').text
      alpha_book["Spells (C)"]
    end

    def self.scrape_magic_shop(magic_shop)

    end

    def self.scrape_provisioner(provisioner)

    end

end