general_group = Kudos::AchievementGroup.create(name: { en: 'General' })
bottles_group = Kudos::AchievementGroup.create(name: { en: 'Bottles' }, parent: general_group)

Kudos::Achievement.create(award_name: 'bottle_create', points: 5, rank: 1, kudos_achievement_group: bottles_group)
Kudos::Achievement.create(award_name: 'bottle_create', points: 50, rank: 2, kudos_achievement_group: bottles_group)
Kudos::Achievement.create(award_name: 'bottle_create', points: 100, rank: 3, kudos_achievement_group: bottles_group)

world = World.create(name: 'Forgotten Realms')

(0..Rails.configuration.map_size[:q]).each do |q|
  (0..Rails.configuration.map_size[:r]).each do |r|
    world.cells.create(
      q: q,
      r: r,
      surface: q.zero? || r.zero? ? Cell::GROUND : Cell::WATER,
      # if flows values sum is less then 100 - there is opportunity that bottle will not change cell (slow flow)
      flows: q.zero? || r.zero? ? {} : { '0' => 20, '1' => 15, '2' => 15, '3' => 20, '4' => 15, '5' => 15 }
    )
  end
end

10.times do
  cell = Cell.water.sample
  cell.bottles.create(created_at_tick: world.ticks, start_cell: cell)
end
