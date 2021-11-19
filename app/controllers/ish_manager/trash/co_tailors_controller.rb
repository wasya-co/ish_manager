
class IshManager::CoTailorsController < IshManager::ApplicationController

  def home
    authorize! :home, ::CoTailors
    @products = ::CoTailors::Product.all
  end

  def create_product
    authorize! :create, ::CoTailors::Product
    @product = ::CoTailors::Product.new params[:co_tailors_product].permit!
    if @product.save
      flash[:notice] = 'Created product'
    else
      flash[:alert] = 'Cannot create product: ', @product.errors.messages.to_s
    end
    redirect_to :action => 'home'
  end

  def update_product
    @product = ::CoTailors::Product.find params[:id]
    authorize! :update, @product
    if @product.update_attributes params[:co_tailors_product].permit!
      flash[:notice] = 'updated product'
    else
      flash[:alert] = 'Cannot update product: ', @product.errors.messages.to_s
    end
    redirect_to :action => 'home'
  end


end

