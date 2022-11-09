map_size = Rails.configuration.map_size
min_value = -map_size
max_value = map_size
range = min_value..max_value

range.each do |q|
  range.each do |r|
    if q + r >= min_value && q + r <= max_value
      Cell.create(
        q: q,
        r: r,
        surface: q.zero? && r.zero? ? Cell::GROUND : Cell::WATER,
        flows: { 0 => 20, 1 => 15, 2 => 15, 3 => 20, 4 => 15, 5 => 15 }
      )
    end
  end
end

3.times do
  Cell.where.not(q: 0, r: 0).sample.bottles.create
end
