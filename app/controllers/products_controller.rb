class ProductsController < RankingController
  before_action :authenticate_user!, only: :search
  def index
    @products = Product.order('id ASC').limit(20)
  end

  def search
    @products = Product.where("title LIKE ?", "%#{params[:keyword]}%").limit(20)
    respond_to do |format|
     format.html
     format.json
   end
  end

  def show
    @product = Product.find(params[:id])
  end
  
end
