module CsvExportable
  extend ActiveSupport::Concern

  require 'csv'

  class_methods do
    def to_csv(data = [])
      CSV.generate(headers: true) do |csv|
        csv << exportable_attributes

        data.each do |record|
          csv << record.csv_data
        end
      end
    end
  end
end
