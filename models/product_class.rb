require_relative("../db/sql_runner")
require('pry-byebug')

class Product

  attr_reader :id
  attr_accessor :specie, :latin_name, :image, :price, :quantity, :comments

  def initialize ( options )
    @id = nil || options['id'].to_i
    @specie = options['specie']
    @latin_name = options['latin_name']
    @image = options['image']
    @price = options['price']
    @quantity = options['quantity']
    @comments = options['comments']
  end

  def save()
    sql = "
    INSERT INTO products 
    (specie, latin_name, image, price, quantity, comments ) 
    VALUES 
    ('#{ @specie }','#{ @latin_name }','#{ @image }','#{ @price }',#{ @quantity },'#{ @comments }') 
    RETURNING id
    "
    product = SqlRunner.run( sql ).first
    @id = product['id'].to_i
  end

  def self.delete_duplicates()
    #Method to delete duplicates and keep the latest entry 
    sql = "
    DELETE FROM products 
    WHERE id NOT IN (
    SELECT max(id) 
    FROM products 
    GROUP BY specie 
    );
    "
    result = SqlRunner.run( sql )
  end

  def self.get_product_id(specie)
    sql = "
    SELECT id 
    FROM products 
    WHERE specie = '#{specie}' ;
    "
    result = SqlRunner.run( sql )
    product = Product.new(result[0])
    return product.id
  end

  def self.all()
    sql = "SELECT * FROM products"
    return Product.get_many(sql)
  end

  def self.all_instances(specie)
    sql = "SELECT specie FROM products WHERE specie = '#{specie}'"
    results = Product.get_many(sql)
    return results
  end

  def self.find( id )
   sql = "SELECT * FROM products WHERE id=#{id}"
   product = SqlRunner.run( sql )
   result = Product.new( product.first )
 end

 def self.delete_all
   sql = "DELETE FROM products"
   SqlRunner.run( sql )
 end

 def get_price()
  sql = "  SELECT price FROM products WHERE id = '#{@id}';  "
  return SqlRunner.run( sql )[0]['price']
end

  #Refactor of the SqlRunner and return
  def self.get_many(sql)
    products = SqlRunner.run(sql)
    products_objects = products.map { |product| 
      Product.new(product)}
      return products_objects
    end

    def self.update( options )
      sql = "UPDATE products SET
      specie='#{options['specie']}',
      latin_name='#{options['latin_name']}',
      image='#{options['image']}',
      price=#{options['price']},
      quantity=#{options['quantity']},
      comments='#{options['comments']}'
      WHERE id='#{options['id']}'"
      SqlRunner.run( sql )
    end

    def self.destroy( id )
      sql = "DELETE FROM products WHERE id=#{id}"
      SqlRunner.run( sql )
    end
  end