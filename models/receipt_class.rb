require_relative("../db/sql_runner")
require('pry-byebug')

class Receipt

  attr_reader :id
  attr_accessor :customer_id, :product_id, :purchase_type, :purchase_time, :delivery_time
  
  def initialize( options )
    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @product_id = options['product_id'].to_i
    @purchase_type = options['purchase_type']
    @purchase_time = options['purchase_time']
    @delivery_type = options['delivery_type']
  end

  def save()
    sql = "INSERT INTO receipts (customer_id, product_id, purchase_type, purchase_time, delivery_type)
    VALUES ('#{ @customer_id }', '#{ @product_id }', '#{ @purchase_type }', '#{ @purchase_time }','#{ @delivery_time }') RETURNING id"
    receipt= SqlRunner.run( sql ).first
    @id = receipt['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM receipts"
    return  Receipt.get_many(sql)
  end

  def self.get_many(sql)
   receipts = SqlRunner.run(sql)
   receipts_objects = receipts.map { |receipt| Receipt.new (receipt)}
   return receipts_objects
 end

def self.delete_all() 
  sql = "DELETE FROM receipts"
  SqlRunner.run(sql)
end

def delete() 
  sql = "DELETE FROM receipts WHERE id = #{@id}"
  SqlRunner.run(sql)
  return 'Deleted'
end

def product()
  sql = "SELECT * FROM products WHERE id = #{@product_id};"
  product = SqlRunner.run(sql).first
  return Product.new(product)
end

def customer()
  sql = "SELECT * FROM customers WHERE id = #{@customer_id};"
  customer = SqlRunner.run(sql).first
  return Customer.new(customer)
end

def self.customers(name)
  sql = "
  SELECT id FROM customers WHERE name = '#{name}';
  "

  id = SqlRunner.run( sql )[0]['id']
  puts id
  sql = "
  SELECT c.* FROM customers c
  INNER JOIN tickets t
  ON c.id = t.customer_id 
  WHERE t.customer_id =#{id};
  "
  return Receipt.get_many(sql)
end


end