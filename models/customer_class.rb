require_relative("../db/sql_runner")
require('pry-byebug')

class Customer

  attr_reader :id
  attr_accessor :name, :address_line_1, :address_line_2, :postcode, :funds, :email

  def initialize ( options )
    @id = nil || options['id'].to_i
    @name = options['name']
    @address_line_1 = options['address_line_1']
    @address_line_2 = options['address_line_2']
    @postcode = options['postcode']
    @funds = options['funds']
    @email = options['email']
  end

  def save()
    sql = "
    INSERT INTO customers 
    (name, address_line_1, address_line_2, postcode, funds, email ) 
    VALUES 
    ('#{ @name }','#{ @address_line_1 }','#{ @address_line_2 }','#{ @postcode }',#{ @funds }, '#{ @email }') 
    RETURNING id
    "
    customer = SqlRunner.run( sql ).first
    @id = customer['id'].to_i
  end

  def self.delete_duplicates()
    #Method to delete duplicates and keep the latest entry 
    sql = "
    DELETE FROM customers 
    WHERE id NOT IN (
    SELECT max(id) 
    FROM customers 
    GROUP BY name, postcode  
    ORDER by postcode
    );
    "
    result = SqlRunner.run( sql )
  end

  def self.get_customer_id(name)
    sql = "
    SELECT id 
    FROM customers 
    WHERE name = '#{name}' ;
    "
    result = SqlRunner.run( sql )
    if result.count == 1 
    customer = Customer.new(result[0])
    return customer.id
  else
    if result.count == 0
      return "Customer Not Found"
    else
      return "More than once customer with that name"
    end
  end
  end

  def self.all()
    sql = "SELECT * FROM customers"
    return Customer.get_many(sql)
  end

  def self.all_instances(name)
    sql = "SELECT name FROM customers WHERE name = '#{name}'"
    results = Customer.get_many(sql)
    return results
  end

  def self.find( id )
   sql = "SELECT * FROM customers WHERE id=#{id}"
   customer = SqlRunner.run( sql )
   result = Customer.new( customer.first )
  end

  def self.delete_all
   sql = "DELETE FROM customers"
   SqlRunner.run( sql )
  end

  def get_funds()
    sql = "  SELECT funds FROM customers WHERE id = '#{@id}';  "
    return SqlRunner.run( sql )[0]['funds']
  end

  #Refactor of the SqlRunner and return
  def self.get_many(sql)
    customers = SqlRunner.run(sql)
    customers_objects = customers.map { |customer| 
    Customer.new(customer)}
    return customers_objects
  end

  def self.update( options )
    sql = "UPDATE customers SET
          name='#{options['name']}',
          address_line_1='#{options['address_line_1']}',
          address_line_2='#{options['address_line_2']}',
          postcode='#{options['postcode']}',
          funds=#{options['funds']},
          email = '#{ @email }'
          WHERE id='#{options['id']}';"
    SqlRunner.run( sql )
  end

  def self.destroy( id )
    sql = "DELETE FROM customers WHERE id=#{id};"
    SqlRunner.run( sql )
  end

  def self.reduced_by(id,amount)
    sql = "UPDATE Customers SET
    funds = funds - #{amount.to_f}
    WHERE id =#{id};"
    SqlRunner.run( sql )
end
end