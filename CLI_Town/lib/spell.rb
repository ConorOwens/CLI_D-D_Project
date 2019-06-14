class CLI_Town::Spell
  
attr_accessor :name, :description, :alpha

  @@all = []

  def initialize(spell_hash)
    spell_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(spell_array)
    spell_array.each {|spell_hash| Spell.new(spell_hash)}
  end

  def add_spell_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end
  
end