require 'phonedata'
require 'csv'

describe Phonedata do

  it " dat file version should be 2108 " do
    expect(Phonedata.file_version).to eql('2108')
  end

  it " total record should correct " do
    expect(Phonedata.total_record).to eql(454336)
  end

  it " first record offset should correct" do
    expect(Phonedata.first_record_offset).to eql(9889)
  end

  it " find phone " do
    arr_of_rows = CSV.read(File.join(File.dirname(__FILE__), "./phone_data.csv"))
    arr_of_rows.each do |fields|

      r = Phonedata.find(fields[0])
      expect("#{r.phone}-#{r.province}-#{r.city}-#{r.card_type}").to eql("#{fields[0]}-#{fields[1]}-#{fields[2]}-#{fields[3]}")
    end
  end
end