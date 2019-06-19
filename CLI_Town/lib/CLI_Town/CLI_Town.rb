require_relative "../environment.rb"

class Command_Line_Interface
  
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
    puts "You enter a dank and cavernous library, full of the scent of leather, dust, and time. You can feel the magic pulse around you in this repository of arcane knowledge and research. A single clockwork librarian stands at attention as you enter, turning from his duties clearing cobwebs. He speaks to you in a pleasant monotone with a dull hum underneath his words. 'Welcome. The knowledge held in these halls is free to all. Simply speak aloud your desired knowledge and the spells will make themselves known to you.' The mechanical man clicks and clacks down one unending hallway paying you no more mind. You are alone in this expanse, and confused. A small pamphlet flies from the shelves and hovers in front of you unfolding itself. It reads 'The library responds to your thoughts and commands, bringing you the tomes you require. This list of commands will bring you the spell knowledge you desire." 
    puts "_____________________________________________________________________"
    puts "Say 'all spells' to see a complete list of castable spells." 
    puts "Say 'spells by letter' to see a list of spells starting with a specific letter. "
    puts "Say 'spells by class' to see a list of spells available toa specific type of caster."
    puts "Say 'spells by level' to see a list of spells of a given level."
    puts "At any point, say the name of a spell to see more specifics about that spell."
    puts "Say 'exit' to leave this place of knowledge."
    puts "You can say 'commands' at any time to see this list again."
    input = gets.strip
    until input.downcase == "exit"
      if input.downcase == "all spells"
        counter = 1
        puts "A dark and heavy grimoire approaches and reveals its secrets."
        Spell.all.each do |spell|
          puts "#{counter}. #{spell.name}"
          counter += 1 
        end
        input = gets.strip
      elsif input.downcase == "spells by letter"
        puts "A voice whispers down the eternal hallways. 'Which letter would you like to see more closely?'"
        input_alpha = gets.strip
        puts "A scroll unfurls in front of you with spells listed upon it."
        counter = 1
        Spell.all.each do |spell|
          if spell.alpha[-2] == input_alpha.upcase
            puts "#{counter}. #{spell.name}"
            counter += 1 
          end
        end
        input = gets.strip
      elsif input.downcase == "spells by class"
        puts "Many voices sing out at once. It's hard to understand their commands but as they repeat you can discern them. 'Sorceror? Wizard? Cleric?   Druid? Paladin? Bard? Ranger? CHOOSE!'"
        input_beta = gets.strip
        puts "The voices quiet, and an ancient and cracked leather book floats slowly towards you with pages opened."
        counter = 1
        Spell.all.each do |spell|
          if spell.list.include?(input_beta.capitalize)
            puts "#{counter}. #{spell.name}"
            counter += 1 
          end
        end
        input = gets.strip
      elsif input.downcase == "spells by level"
        puts "Nine identical books float in a line towards you. Their covers show numbers in stylized embossing 0 through 9. Which do you reach for?"
        input_gamma = gets.strip
        Spell.all.each do |spell|
          if spell.level.include?(input_gamma)
            counter = 0 
            list_level_combined = []
            until counter == spell.list.size 
              list_level_combined << "#{spell.list[counter]} (#{spell.level[counter]})"
              counter += 1
            end
            puts "#{spell.name} : #{list_level_combined.join(", ")}"
            puts "#{spell.effect}"
            puts"----------"
          end
        end
        input = gets.strip
      elsif Spell.all.find {|spell| spell.name.downcase == input.downcase} != nil
        puts "A single shining parchment darts from between the books. The spell you seek is emblazoned in filligree on it's surface."
        Spell.all.each do |spell|
          if spell.name.downcase == input.downcase
            #attr_accessor :name, :list, :level, :school, :subschool, :descriptor, :components, :cast_time, :range, :effect, :duration, :saving_throw, :SR  , :description, :alpha, :url
            puts "Name: #{spell.name}"
            counter = 0 
            while counter < spell.list.size 
              puts "#{spell.list[counter]} (#{spell.level[counter]})"
              counter += 1
            end
            puts "Class(es): #{spell.list}"
            if spell.school
              puts "School: #{spell.school}"
            end
            if spell.subschool
              puts "Subschool: #{spell.subschool}"
            end
            if spell.descriptor
              puts "Descriptor: #{spell.descriptor}"
            end
            puts "Components: #{spell.components}"
            puts "Casting Time: #{spell.cast_time}"
            puts "Range: #{spell.range}"
            puts "Effect: #{spell.effect}"
            puts "Duration: #{spell.duration}"
            puts "Saving Throw: #{spell.saving_throw}"
            puts "SR: #{spell.sr}"
            puts "________________________"
            spell.description.each {|text| puts "#{text}"}
          end
        end
        input = gets.strip
      elsif input.downcase == "commands"
        puts "Say 'all spells' to see a complete list of castable spells." 
        puts "Say 'spells by letter' to see a list of spells starting with a specific letter. "
        puts "Say 'spells by class' to see a list of spells available toa specific type of caster."
        puts "Say 'spells by level' to see a list of spells of a given level."
        puts "At any point, say the name of a spell to see more specifics about that spell."
        puts "Say 'exit' to leave this place of knowledge."
        puts "You can say 'commands' at any time to see this list again."
        input = gets.strip
      else
        puts "The small pamphlet shakes to get your attention. It now reads 'I'm sorry, I didn't understand that. Say 'commands' at any time to see a list   of commands.'"
        input = gets.strip
      end # end if/elsif
    end # end until loop
     puts "The books close and return to their shelves. You've gained your mote of knowledge and this immeasurable library contains multitudes more than you can comprehend. But your journey was not in vain, and you leave sure you will return again to comprehend another vast mystery."
  end # end library

end # end class
  