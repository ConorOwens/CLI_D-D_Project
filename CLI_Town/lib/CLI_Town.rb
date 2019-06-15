require "CLI_Town/version"
require_relative "../lib/scraper.rb"
require_relative "../lib/spell.rb"
require 'nokogiri'

class CommandLineInterface
  
  def run
    make_spells
    add_spell_attributes
    library
  end

  def make_spells
    spell_list = Scraper.scrape_spell_list('http://www.d20srd.org/indexes/spells.htm')
    Spell.create_from_collection(spell_list)
  end

  def add_spell_attributes
    Spell.all.each do |spell|
      attributes = Scraper.scrape_spell(spell.url)
      spell.add_spell_attributes(attributes)
    end
  end
  
  def library
    puts "You enter a dank and cavernous library, full of the scent of leather, dust, and time. You can feel the magic pulse around you in this rpository of arcane knowledge and research. A single clockwork librarian stand at attention as you enter, turning from his duties clearing cobwebs. He speaks to you in a pleasant monotone with a dul hum underneath his words. 'Welcome. The knowledge held in these halls is free to all. Simply speak aloud your desired knowledge and the spell will make themselves known to you.' The mechanical man clicks and clakcs down one unending hallway paying you no more mind. You are alone in this expanse, and confused. A small pamphlet flies from the shelves and hovers in front of you unfolding itself. It reads 'The library responds to your thoughts and commands, bringing you the tomes you require. This list of commands will bring you the spell knowledge you desire." 
    puts "_____________________________________________________________________"
    puts "Say 'all spells' to see a complete list of castable spells." 
    puts "Say 'spells by letter' to see a list of spells starting with a specific letter. "
    puts "Say 'spells by class' to see a list of spells according to what class can cast them."
    input = gets.strip
    if input == "all spells"
      counter = 1
      puts "A dark and heavy grimoire approaches and reveals its secrets."
      CLI_Town::Spell.all.each do |spell|
        puts "#{counter}. #{spell.name}"
        counter += 1 
      end
      input = gets.strip
    elsif input == "spells by letter"
      puts "A voice whispers down the eternal hallways. 'Which letter would you like to see more closely?'"
      input_alpha = gets.strip
      puts "A scroll unfurls in front of you with spells listed upon it."
      counter = 1
      Spell.all.each do |spell|
        if spell.alpha[-2] == input_alpha
          puts "#{counter}. #{spell.name}"
          counter += 1 
        end
      end
      input = gets.strip
    elsif input == "spells by class"
      puts "Many voices sing out at once. It's hard to understand their commands but as they repeat you can discern them. 'Sorceror? Wizard? Cleric? Druid? Paladin? Bard? Ranger? CHOOSE!"
      input_beta = gets.strip
      puts "The voices quiet, and an ancient and cracked leather book floats slowly towards you with pages opened."
      counter = 1
      Spell.all.each do |spell|
        if spell.classes.include?(input_beta)
          puts "#{counter}. #{spell}"
          counter += 1 
        end
      end
      input = gets.strip
    elsif Spell.all.name.include?(input)
      
    elsif
  end
    
  end

end
