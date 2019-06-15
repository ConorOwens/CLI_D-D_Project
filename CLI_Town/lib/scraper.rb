require 'nokogiri'
require 'open-uri'
class Scraper

       # alpha_book[alpha[counter]].each {|spell| spell.gsub(/\Wu2019/, "'")}

    def self.scrape_spell_list(spell_list)
      # empty info holders and html
      alpha = []
      spells = []
      alpha_book = {}
      spell_list_html = Nokogiri::HTML(open(spell_list))
      # scraping for :alpha (Spell A, B, C...)
      spell_list_html.css('h2').each {|segment| alpha << segment.text}
      alpha.each {|alpha| alpha_book[alpha] = []}
      # scraping for :names, :alpha, :url
      spell_list_html.css('li ul li').each_with_index do |spell, index|
        if index > 31
          name = spell.text
          url = "http://www.d20srd.org" + spell.css('a').attr('href').value
          alpha.each do |letter|
            if letter[-2] == name[0]
              assign = letter
              spells << {name: name, url: url, alpha: assign} unless spells.include?({name: name, url: url, alpha: assign})
            end
          end
        end
      end
      spells
    end

    def self.scrape_spell(spell)
      # empty info holders and html
      attributes = {list: [], level: []}
      descriptors = []
      stats = []
      spell_html = Nokogiri::HTML(open(spell))
      # scraping for school, subschool if any, and descriptors if any
      spell_html.css('h4 a').each {|desc| descriptors << desc.text}
      descriptors = descriptors.compact
      attributes[:school] = descriptors[0]
      if descriptors.size == 2
        attributes[:descriptor] = descriptors[1]
      end
      if descriptors.size == 3
        attributes[:subschool] = descriptors[1]
        attributes[:descriptor] = descriptors[2]
      end
      # scraping for stat block
      spell_html.css('tr td').each {|stat| stats << stat.text}
      # seperating casting class and level
      stats.each do |stat|
        if ["0","1","2","3","4","5","6","7","8","9"].include?(stat[-1])
          class_level = stat.split(" ")
          attributes[:list] << class_level[0]
          attributes[:level] << class_level[1]
        end
      end
      # other stats
      attributes[:SR] = stats[-1]
      attributes[:saving_throw] = stats[-2]
      attributes[:duration] = stats[-3]
      attributes[:effect] = stats[-4]
      attributes[:range] = stats[-5]
      attributes[:cast_time] = stats[-6]
      attributes[:components] = stats[-7]
    
    attributes
    
    end
  end