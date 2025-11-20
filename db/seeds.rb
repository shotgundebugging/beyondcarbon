puts "Seeding demo data for Employment…"

Region.delete_all
EmploymentData.delete_all

regions = [
  { code: "USA", name: "United States of America" },
  { code: "GBR", name: "United Kingdom" },
  { code: "FRA", name: "France" },
  { code: "DEU", name: "Germany" },
  { code: "BRA", name: "Brazil" },
  { code: "ZAF", name: "South Africa" },
  { code: "IND", name: "India" },
  { code: "CHN", name: "China" },
  { code: "AUS", name: "Australia" },
  { code: "CAN", name: "Canada" }
]

sectors = [
  "Agriculture", "Manufacturing", "Services", "Tourism", "Energy",
  "Construction", "Transport", "Healthcare", "Education", "Technology"
]

stressors = [
  "Heat Stress", "Sea Level Rise", "Air Pollution", "Automation", "Policy Transition"
]

# Deterministic pseudo-random for nice variety across region/stressor/sector
def pseudo_value(region_idx, stressor_idx, sector_idx)
  base = 5_000 + (region_idx * 700) + (stressor_idx * 500) + (sector_idx * 350)
  wiggle = ((region_idx + 3) * (stressor_idx + 5) * (sector_idx + 7)) % 900
  base + wiggle
end

regions.each_with_index do |r, ri|
  region = Region.create!(r)
  stressors.each_with_index do |s, si|
    sectors.each_with_index do |sec, ci|
      EmploymentData.create!(
        region: region,
        sector: sec,
        stressor: s,
        value: pseudo_value(ri, si, ci)
      )
    end
  end
end

puts "Seeded: #{Region.count} regions, #{EmploymentData.count} employment rows"
