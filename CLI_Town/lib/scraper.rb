require 'nokogiri'
require 'open-uri'
class CLI_Town::Scraper

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
    end
    
    def self.scrape_spell(spell)
      attributes = {}
      descriptors = []
      spell_html = Nokogiri::HTML(open(spell))
      name = spell_html.css('h1').text
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
      #:name, :classes, :level, :school, :subschool, :descriptor, :components, :cast_time, :range, :effect, :duration, :saving_throw, :SR, :description, :alpha
      
    end

end