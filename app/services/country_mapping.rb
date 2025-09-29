# frozen_string_literal: true

class CountryMapping
  def self.iso2_to_name(path)
    rows = File.read(path).split(/\r?\n/)
    header = rows.shift
    cols = header.split("\t")
    iso2_idx = cols.index("ISO2")
    name_idx = cols.index("Name")

    mapping = {}
    rows.each do |line|
      next if line.strip.empty?
      c = line.split("\t")
      iso2 = c[iso2_idx].to_s.strip
      name = c[name_idx].to_s.strip
      next if iso2.empty? || name.empty?
      mapping[iso2] ||= name
    end
    mapping
  end
end

