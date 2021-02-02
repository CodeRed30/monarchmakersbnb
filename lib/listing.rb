# frozen_string_literal: true

require_relative 'database_connection'

class Listing
  attr_reader :id, :name, :description, :price_per_night

  def initialize(id:, name:, description:, price_per_night:)
    @id = id
    @name = name
    @description = description
    @price_per_night = price_per_night
  end

  def self.create(name:, description:, price_per_night:)
    result = DatabaseConnection.query("INSERT INTO listing(name, description,
      price_per_night) VALUES('#{name}', '#{description}', '#{price_per_night}')
      RETURNING id, name, description, price_per_night;").first
  
    Listing.new(id: result['id'],
                name: result['name'],
                description: result['description'],
                price_per_night: result['price_per_night'].to_i)
  end

  def self.all
    results = DatabaseConnection.query('select * from listing order by id desc')
    results.map do |row|
      Listing.new(id: row['id'],
                  name: row['name'],
                  description: row['description'],
                  price_per_night: row['price_per_night'].to_i)
    end
  end
end
