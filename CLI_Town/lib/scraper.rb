require 'nokogiri'
require 'open-uri'
class Scraper

    def self.scrape_spell_list(spell_list)
      # empty info holders and html
      alpha = []
      alpha_book = {}
      spell_list_html = Nokogiri::HTML(open(spell_list))
      # scraping for alpha_book keys (Spell A, B, C...)
      spell_list_html.css('h2').each {|segment| alpha << segment.text}
      alpha.each {|alpha| alpha_book[alpha] = []}
      counter = 0
      # scraping for spell names
      while counter < 23
        spell_list_html.css('li ul li').each_with_index do |spell, index|
          if index > 31 && spell.text[0] == alpha[counter][-2]
            alpha_book[alpha[counter]] << spell.text
          end
        end
        alpha_book[alpha[counter]].each {|spell| spell.gsub(/\Wu2019/, "'")}
        counter += 1
      end
      # scraping for spell info url to use in scrape_spell

    end

    def self.scrape_spell(spell)
      # empty info holders and html
      attributes = {}
      descriptors = []
      spell_html = Nokogiri::HTML(open(spell))
      # scraping for name
      name = spell_html.css('h1').text
      # scraping for school, subschool if any, and descriptors if any
      spell_html.css('h4 a').each {|desc| descriptors << desc.text}
      descriptors = descriptors.compact
      school = descriptors[0]
      if descriptors.size == 2
        descriptor = descriptors[1]
      end
      if descriptors.size == 3
        subschool = descriptors[1]
        descriptor = descriptors[2]
      end
      spell_html.css
      # scraping for stat block
    
      
    end

end

end