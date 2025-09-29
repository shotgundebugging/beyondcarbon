# frozen_string_literal: true

class EmploymentSample
  def self.read_tsv(path)
    Rails.cache.fetch(["employment_tsv", path.to_s, mtime_key(path)]) do
      File.read(path).lines.map { |line| line.chomp.split("\t") }
    end
  end

  def self.read_dataset(path)
    Rails.cache.fetch(["employment_dataset", path.to_s, mtime_key(path)]) do
      rows = read_tsv(path)
      regions = rows[0][1..]
      sectors = rows[1][1..]
      data_rows = rows[3..]

      dataset = []
      data_rows.each do |r|
        stressor = r[0]
        (1...r.size).each do |j|
          dataset << {
            region: regions[j - 1],
            sector: sectors[j - 1],
            stressor: stressor,
            value: r[j].to_f
          }
        end
      end
      dataset
    end
  end

  def self.available_stressors(path)
    Rails.cache.fetch(["employment_stressors", path.to_s, mtime_key(path)]) do
      rows = read_tsv(path)
      (rows[3..]).map { |r| r[0] }
    end
  end

  def self.available_regions(path)
    Rails.cache.fetch(["employment_regions", path.to_s, mtime_key(path)]) do
      rows = read_tsv(path)
      rows[0][1..]
    end
  end

  def self.for_region_and_stressor(path:, region:, stressor:)
    read_dataset(path)
      .select { |h| h[:region] == region && h[:stressor] == stressor }
      .map { |h| { sector: h[:sector], value: h[:value] } }
  end

  def self.mtime_key(path)
    File.mtime(path).to_i
  end
  private_class_method :mtime_key
end
