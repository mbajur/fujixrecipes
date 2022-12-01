class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update edit new destroy ]
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all.order(id: :desc)

    if params[:s] && Recipe.sensors.keys.include?(params[:s])
      @recipes = @recipes.where(sensor: params[:s])
    end
  end

  def saved
    @user = User.find_by!(username: params[:user_username])
    @recipes = @user.saved_recipes.order('saves.id DESC')
    render 'users/saved'
  end

  def toggle_save
    authenticate_user!

    recipe = Recipe.find(params[:recipe_hashid])
    save = recipe.saves.find_or_initialize_by(user: current_user)
    save.persisted? ? save.destroy : save.save!

    redirect_back fallback_location: [recipe.user, recipe]
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @other_recipes = Recipe.where.not(id: @recipe.id)
  end

  # GET /recipes/new
  def new
    authenticate_user!
    @recipe = Recipe.new

    if params[:fork_of]
      @recipe.parent = Recipe.find(params[:fork_of])

      @recipe.sensor = @recipe.parent.sensor
      @recipe.film_simulation = @recipe.parent.film_simulation
      @recipe.dynamic_range = @recipe.parent.dynamic_range
      @recipe.highlights = @recipe.parent.highlights
      @recipe.shadows = @recipe.parent.shadows
      @recipe.color = @recipe.parent.color
      @recipe.noise_reduction = @recipe.parent.noise_reduction
      @recipe.sharpening = @recipe.parent.sharpening
      @recipe.clarity = @recipe.parent.clarity
      @recipe.grain_roughness = @recipe.parent.grain_roughness
      @recipe.grain_size = @recipe.parent.grain_size
      @recipe.color_chrome_effect = @recipe.parent.color_chrome_effect
      @recipe.color_chrome_effect_blue = @recipe.parent.color_chrome_effect_blue
      @recipe.white_balance = @recipe.parent.white_balance
      @recipe.white_balance_red = @recipe.parent.white_balance_red
      @recipe.white_balance_blue = @recipe.parent.white_balance_blue
    end
  end

  # GET /recipes/1/edit
  def edit
    authenticate_user!
  end

  # POST /recipes or /recipes.json
  def create
    authenticate_user!

    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to user_recipe_url(@recipe.user, @recipe), notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    authenticate_user!
    if @recipe.update(recipe_params)
      redirect_to user_recipe_url(@recipe.user, @recipe), notice: "Recipe was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:hashid])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:film_simulation,
                                     :dynamic_range,
                                     :highlights,
                                     :shadows,
                                     :color,
                                     :noise_reduction,
                                     :sharpening,
                                     :clarity,
                                     :grain_roughness,
                                     :grain_size,
                                     :color_chrome_effect,
                                     :color_chrome_effect_blue,
                                     :white_balance,
                                     :white_balance_red,
                                     :white_balance_blue,
                                     :sensor,
                                     :original_author,
                                     :original_url,
                                     :poster,
                                     :photo_1,
                                     :photo_2,
                                     :description,
                                     :name,
                                     :parent_id)
    end
end
