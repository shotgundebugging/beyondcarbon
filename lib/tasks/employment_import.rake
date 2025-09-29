namespace :employment do
  desc "Import employment data from TSV into the database"
  task import: :environment do
    sample_path = Rails.root.join("db/samples/employment_sample.tsv")
    mapping_path = Rails.root.join("db/samples/CountryMappingDESIRE/CountryList-Table 1.tsv")

    puts "Reading country mapping..."
    country_names = CountryMapping.iso2_to_name(mapping_path)

    region_cache = {}
    EmploymentSample.available_regions(sample_path).uniq.each do |code|
      name = country_names[code] || code
      region = Region.find_or_create_by!(code: code) { |r| r.name = name }
      if region.name != name
        region.update!(name: name)
      end
      region_cache[code] = region
    end

    dataset = EmploymentSample.read_dataset(sample_path)

    # Idemmpotent
    EmploymentData.delete_all

    now = Time.current
    rows = dataset.map do |h|
      {
        region_id: region_cache.fetch(h[:region]).id,
        sector: h[:sector],
        stressor: h[:stressor],
        value: h[:value],
        created_at: now,
        updated_at: now
      }
    end

    puts "Inserting #{rows.size} rows..."
    rows.each_slice(1000) { |slice| EmploymentData.insert_all(slice) }
    puts "Done. Imported #{EmploymentData.count} records. Regions: #{Region.count}."
  end
end
