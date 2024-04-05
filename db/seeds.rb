general_group = Kudos::AchievementGroup.create(name: { en: 'General' })
bottles_group = Kudos::AchievementGroup.create(name: { en: 'Bottles' }, parent: general_group)

Kudos::Achievement.create(award_name: 'bottle_create', points: 5, rank: 1, kudos_achievement_group: bottles_group)
Kudos::Achievement.create(award_name: 'bottle_create', points: 50, rank: 2, kudos_achievement_group: bottles_group)
Kudos::Achievement.create(award_name: 'bottle_create', points: 100, rank: 3, kudos_achievement_group: bottles_group)

# forgotten_realms = World.create(
#   name: { en: 'Forgotten Realms', ru: 'Забытые Королевства' },
#   cell_type: World::HEXAGON,
#   map_size: { q: 20, r: 10 }
# )

# (0..forgotten_realms.map_size['q']).each do |q|
#   (0..forgotten_realms.map_size['r']).each do |r|
#     forgotten_realms.cells.create(
#       q: q,
#       r: r,
#       surface: q.zero? || r.zero? ? Cell::GROUND : Cell::WATER,
#       # if flows values sum is less then 100 - there is opportunity that bottle will not change cell (slow flow)
#       flows: q.zero? || r.zero? ? {} : { '0' => 20, '1' => 15, '2' => 15, '3' => 20, '4' => 15, '5' => 15 }
#     )
#   end
# end

earth = World.create(
  name: { en: 'Earth', ru: 'Земля' },
  cell_type: World::SQUARE,
  map_size: { q: 129, r: 99 }
)

earth.cells.create(q: 58, r: 46, surface: Cell::COAST, name: { en: 'Lisboa', ru: 'Лиссабон' })
earth.cells.create(q: 59, r: 45, surface: Cell::COAST, name: { en: 'Porto', ru: 'Порту' })
earth.cells.create(q: 58, r: 44, surface: Cell::COAST, name: { en: 'La Coruna', ru: 'Ла-Корунья' })
earth.cells.create(q: 59, r: 44, surface: Cell::COAST, name: { en: 'Oviedo', ru: 'Овьедо' })
earth.cells.create(q: 60, r: 44, surface: Cell::COAST, name: { en: 'Santander', ru: 'Сантандер' })
earth.cells.create(q: 61, r: 44, surface: Cell::COAST, name: { en: 'Bilbao', ru: 'Бильбао' })
earth.cells.create(q: 61, r: 43, surface: Cell::COAST, name: { en: 'Bordo', ru: 'Бордо' })
earth.cells.create(q: 61, r: 42, surface: Cell::COAST, name: { en: 'Nantes', ru: 'Нант' })
earth.cells.create(q: 60, r: 41, surface: Cell::COAST, name: { en: 'Brest', ru: 'Брест' })
earth.cells.create(q: 61, r: 41, surface: Cell::COAST, name: { en: 'Cherbourg', ru: 'Шербур' })

World.find_each do |world|
  10.times do
    cell = world.cells.water.sample
    cell.bottles.create(created_at_tick: world.ticks, start_cell: cell) if cell
  end
end
