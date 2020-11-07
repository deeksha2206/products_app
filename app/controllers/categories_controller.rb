class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
    @products = @category.products
  end

  # GET /categories/new
  def new
    @category = Category.new
    @tags = Tag.all
  end

  # GET /categories/1/edit
  def edit
    @tags = Tag.all
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        if params[:category][:tag_ids].present?
          tag_ids = params[:category][:tag_ids].reject(&:empty?)
          create_category_tag_records(tag_ids)
        end
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        @tags = Tag.all
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    respond_to do |format|
      if @category.update(category_params)
        if params[:category][:tag_ids].present?
          tag_ids = params[:category][:tag_ids].reject(&:empty?)
          create_category_tag_records(tag_ids)
        end
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        @tags = Tag.all
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :description)
    end

    # Create records for junction table category_tags
    def create_category_tag_records(ids)
      old_ids = @category.category_tags.pluck(:tag_id)
      return if old_ids == ids

      remove_ids = old_ids -= ids
      ids -= old_ids
      ids.each do |id|
        @category.category_tags.create(tag_id: id)
      end
      @category.category_tags.where(tag_id: old_ids).destroy_all
    end
end
