require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/product_class.rb' )


#get all products
get '/products' do
  @products = Product.all()
  erb ( :"products/index" )
end

#new product form
get '/products/new' do
erb( :"products/new" )

end

#actually make the product
post '/products' do
@product = Product.new(params)
@product.save()
redirect to('/products')
end

#product view
get ('/products/:id/:referer/view') do
@product = Product.find(params[:id])
@return = params[:referer]
erb(:"products/view")
end

get '/products/:return/return' do
  @return = params[:return]
  case @return
  when 'index'
    redirect to('/')
  when 'products'
      redirect to('/products')
  else
      erb(:"404")
  end
  end

#edit product form
get '/products/:id/ammend' do
@product = Product.find(params[:id])
erb(:"products/ammend")
end

#update the product by id ( PUT request)
post '/products/:id' do
  Product.update(params)
  redirect to('/products')

end

#delete a pizza by id ( DELETE request)
post '/products/:id/remove' do
  id = params[:id]
  @product = Product.destroy(id)
  redirect to('/products')
end