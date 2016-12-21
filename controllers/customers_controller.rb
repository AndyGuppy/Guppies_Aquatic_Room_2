require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/customer_class.rb' )
require_relative( '../models/product_class.rb' )
require_relative( '../models/basket_class.rb' )

#get all customers
get '/customers' do
  @customers = Customer.all()
  erb ( :"customers/index" )
end

#new customer form
get '/customers/new' do
  erb( :"customers/new" )

end

#actually make the customer
post '/customers' do
  @customer = Customer.new(params)
  @customer.save()
  redirect to('/customers')
end


#Check Customer
post '/customers/:pid/custcheck' do
binding.pry
  @product = Product.find(params[:pid])
  @customer = Customer.get_customer_id(params[:name])

  if @customer == "Customer Not Found"
    erb(:"customers/nomember")
  else
    @customer = Customer.find(@customer)
    erb(:"customers/buy")
  end
end

#customer puts product in basket
post '/customers/:pid/:cid/buy' do
  @customer = Customer.find(params[:cid])
  @product = Product.find(params[:pid])
  @quantity = params[:quantity]
#build record to send to basket
@val = {'customer_id' => params[:cid].to_i,'specie' => @product.specie,'price' => @product.price,'quantity' => params[:quantity].to_i}

@basket = Basket.new(@val)
@basket.save()
@basket = Basket.all(params[:cid].to_i)
@total = 0
for basket in @basket
  @total += (basket.price * basket.quantity)
end

erb(:"customers/basket")
end




#delete a pizza by id ( DELETE request)
post '/customers/:id/remove' do
  id = params[:id]
  @customer = Customer.destroy(id)
  redirect to('/customers')
end

post '/customers/:id/cancel' do
  id = params[:id]
  @basket = Basket.delete(id)
  redirect to('/')
end

#find customer to retrieve basket
get '/customers/find' do
  erb( :"customers/finalise" )
end

#find customer to retrieve basket
post ('/customers/custcheck') do
  
  @customer = Customer.get_customer_id(params[:name])

  if @customer == "Customer Not Found"
    erb(:"customers/nomember")
  else
    @customer = Customer.get_customer_id(params[:name])
    
    @customer = Customer.find(@customer)
    @basket = Basket.all(@customer.id)
    @total = 0.0
    for basket in @basket

      @total += (basket.price.to_f * basket.quantity.to_i)
    end
      erb( :"customers/basket" )
  end
end

#find customer to retrieve basket
get '/customers/mybasket' do

  @customer = Customer.get_customer_id(params[:name])
  
  @customer = Customer.find(@customer)
  @basket = Basket.all(@customer.id)
  @total = 0.0
  for basket in @basket
    @total += (basket.price.to_f * basket.quantity.to_i)
  end


    erb( :"customers/basket" )
end


#edit customer form
get '/customers/:id/ammend' do
  @customer = Customer.find(params[:id])
  erb(:"customers/ammend")
end

#update the customer by id ( PUT request)
post '/customers/:id' do
  Customer.update(params)
  redirect to('/customers')

end

post '/customer/:cid/pay' do
  
  @customer_id = params[:cid]
  @basket = Basket.all(@customer_id)
  @total = 0.0
  for basket in @basket
    Product.reduced_by(basket.specie,basket.quantity)
    @total += (basket.price.to_f * basket.quantity.to_i)
  end
  Customer.reduced_by(@customer_id,@total.to_f)
  # @basket = Basket.delete(id)
  erb(:"customers/reciept")
end