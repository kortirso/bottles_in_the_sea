(0..20).each do |q|
  (0..10).each do |r|
    Cell.create(
      q: q,
      r: r,
      surface: q.zero? || r.zero? ? Cell::GROUND : Cell::WATER,
      flows: q.zero? || r.zero? ? {} : { 0 => 20, 1 => 15, 2 => 15, 3 => 20, 4 => 15, 5 => 15 }
    )
  end
end

10.times do
  Cell.water.sample.bottles.create
end
