class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @tags = Tag.all
  end

  # GET /products/1/edit
  def edit
    tags = @product.tags
    @tags = Tag.where.not(id: tags.pluck(:id))
    @show_available_tags = tags.count != Tag.all.count
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        if params[:product][:tag_ids].present?
          tag_ids = params[:product][:tag_ids].reject(&:empty?)
          create_product_tag_records(tag_ids)
        end
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        tags = @product.tags
        @tags = Tag.where.not(id: tags.pluck(:id))
        @show_available_tags = tags.count != Tag.all.count
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  def update
    respond_to do |format|
      if @product.update(product_params)
        if params[:product][:tag_ids].present?
          tag_ids = params[:product][:tag_ids].reject(&:empty?)
          create_product_tag_records(tag_ids)
        end
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        tags = @product.tags
        @tags = Tag.where.not(id: tags.pluck(:id))
        @show_available_tags = tags.count != Tag.all.count
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
        :name, :description, :brand, :price, tags_attributes: %i[id name description _destroy]
      )
    end

    # Create records for junction table category_tags
    def create_product_tag_records(ids)
      ids.each do |id|
        @product.product_tags.create(tag_id: id)
      end
    end
end
