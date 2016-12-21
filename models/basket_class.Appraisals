require_relative("../db/sql_runner")
require('pry-byebug')

class Basket

  attr_reader :id
  attr_accessor :customer_id, :product_id, :quantity
  
  def initialize( options )
    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @product_id = options['product_id'].to_i
    @quantity = options['quantity']
  end

  def save()
    sql = "INSERT INTO basket (customer_id, product_id, quantity)
    VALUES ('#{ @customer_id }', '#{ @product_id }', '#{ @quantity }') RETURNING id"
    basket= SqlRunner.run( sql ).first
    @id = basket['id'].to_i
  end

def self.get_many(sql)
   receipts = SqlRunner.run(sql)
   basket_objects = receipts.map { |receipt| Basket.new (receipt)}
   return basket_objects
 end

def self.delete_all() 
  sql = "DELETE FROM basket"
  SqlRunner.run(sql)
end

def self.delete(customer_id) 
  sql = "DELETE FROM basket WHERE customer_id = #{customer_id}"
  SqlRunner.run(sql)
  return 'Deleted'
end

end