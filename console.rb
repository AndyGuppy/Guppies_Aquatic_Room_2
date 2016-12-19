
require('pry-byebug')
require_relative('./db/sql_runner.rb')
require_relative('./models/customer_class.rb')

#the folloing 2 lines resets the database to defaults
SqlRunner.reset('/db/guppies.sql')
SqlRunner.reset('/db/guppies_seeds.sql')

#create a customer 
# customer1 = Customer.new({'name' => 'Andrew Guppy','address_line_1' => '13 Carleton Avenue','address_line_2' => 'Glenrothes','postcode' => 'KY7 5AW','funds' => 100})
# binding.pry
# customer1.save

