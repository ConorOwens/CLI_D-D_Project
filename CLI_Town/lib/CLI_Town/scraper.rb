require_relative "../environment.rb"

class Scraper

    def self.scrape_spell_list(spell_list)
      # empty info holders and html
      alpha = []
      spells = []
      alpha_book = {}
      spell_list_html = Nokogiri::HTML(open(spell_list))
      # scraping for :alpha (Spell A, B, C...)
      spell_list_html.css('h2').each {|segment| alpha << segment.text}
      alpha.each {|alpha| alpha_book[alpha] = []}
      # scraping for :name, :alpha, :url
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
          # correcting for abbreviations
          # abbreviations : bard Brd; cleric Clr; druid Drd; paladin Pal; ranger Rgr; sorcerer Sor; wizard Wiz.
          if class_level[0] == "Clr"
            attributes[:list] << "Cleric"
          elsif class_level[0] == "Brd"
            attributes[:list] << "Bard"
          elsif class_level[0] == "Drd"
            attributes[:list] << "Druid"
          elsif class_level[0] == "Pal"
            attributes[:list] << "Paladin"
          elsif class_level[0] == "Rgr"
            attributes[:list] << "Ranger"
          elsif class_level[0] == "Sor/Wiz"
            attributes[:list] << "Sorcerer"
            attributes[:list] << "Wizard"
          end
          # correcting for domains and sor/wiz not getting 2 level values
          if ["Brd","Clr","Drd","Pal","Rgr"].include?(class_level[0])
          attributes[:level] << class_level[1]
          end
          if class_level[0] == "Sor/Wiz"
            attributes[:level] << class_level[1]
            attributes[:level] << class_level[1]
          end
        end
      end
      # other stats
      attributes[:sr] = stats[-1]
      attributes[:saving_throw] = stats[-2]
      attributes[:duration] = stats[-3]
      attributes[:effect] = stats[-4]
      attributes[:range] = stats[-5]
      attributes[:cast_time] = stats[-6]
      attributes[:components] = stats[-7]
      attributes[:description] = "DESCRIPTION"
    
    attributes
    end
    
  end
