require( 'sinatra' )
require( 'sinatra/contrib/all' ) if development?
require_relative('controllers/customers_controller')
require_relative('controllers/products_controller')
require_relative('controllers/controller')
require_relative('db/sql_runner.rb')
SqlRunner.reset('db/guppies.sql')
SqlRunner.reset('db/guppies_seeds.sql')

get '/' do
  @products = Product.all()
  erb ( :"/index" )
end

