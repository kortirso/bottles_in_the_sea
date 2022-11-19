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
  Cell.water.sample.bottles.create
end
