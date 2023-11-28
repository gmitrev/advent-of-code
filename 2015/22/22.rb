require "set"

class Fighter
  def dead?
    hp <= 0
  end

  def attack!(target)
    damage = [1, dmg - target.armor].max

    target.hp -= damage

    puts "The #{name} deals #{dmg}-#{target.armor} = #{damage} damage; the #{target.name} goes down to #{target.hp} hit points." if ENV["VERBOSE"]
  end
end

class Player < Fighter
  attr_accessor :hp, :items

  def initialize
    @items = []
    @hp = 100
    @items = []
  end

  def dmg
    @items.sum(&:dmg)
  end

  def armor
    @items.sum(&:armor)
  end

  def name
    "player"
  end
end

class Boss < Fighter
  attr_accessor :hp
  attr_reader :dmg, :armor

  def initialize(hp, dmg, armor)
    @hp = hp
    @dmg = dmg
    @armor = armor
  end

  def name
    "boss"
  end
end

Item = Struct.new(:name, :gold, :dmg, :armor)

weapons = [
  Item.new("Dagger", 8, 4, 0),
  Item.new("Shortsword", 10, 5, 0),
  Item.new("Warhammer", 25, 6, 0),
  Item.new("Longsword", 40, 7, 0),
  Item.new("Greataxe", 74, 8, 0)
]

armor_sets = [
  Item.new("Leather", 13, 0, 1),
  Item.new("Chainmail", 31, 0, 2),
  Item.new("Splintmail", 53, 0, 3),
  Item.new("Bandedmail", 75, 0, 4),
  Item.new("Platemail", 102, 0, 5)
]

rings = [
  Item.new("Damage +1", 25, 1, 0),
  Item.new("Damage +2", 50, 2, 0),
  Item.new("Damage +3", 100, 3, 0),
  Item.new("Defense +1", 20, 0, 1),
  Item.new("Defense +2", 40, 0, 2),
  Item.new("Defense +3", 80, 0, 3)
]

sets = Set.new

weapons.each do |weapon|
  sets << [weapon]

  armor_sets.each do |armor_set|
    sets << [weapon, armor_set]

    rings.each do |ring|
      sets << [weapon, armor_set, ring]

      (rings - [ring]).each do |other_ring|
        sets << [weapon, armor_set, ring, other_ring]
      end
    end
  end
end

def play(set)
  player = Player.new
  player.items = set
  boss = Boss.new(103, 9, 2)

  attacker = player
  defender = boss

  loop do
    attacker.attack!(defender)

    break if attacker.dead? || defender.dead?

    attacker, defender = defender, attacker
  end

  boss.dead?
end

sets.sort_by { |s| s.sum(&:gold) }.each do |set|
  victory = play(set)

  if victory
    puts set
    puts "Part 1: #{set.sum(&:gold)}"
    break
  end
end

sets.sort_by { |s| -s.sum(&:gold) }.each do |set|
  victory = play(set)

  if !victory
    puts set
    puts "Part 2: #{set.sum(&:gold)}"
    break
  end
end
