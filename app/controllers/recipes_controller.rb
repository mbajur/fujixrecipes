class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update edit new destroy ]
  before_action :set_recipe, only: %i[ show edit update destroy ]
  before_action :set_camera, only: %i[camera]
  before_action :set_sensor, only: %i[sensor]

  # GET /recipes or /recipes.json
  def index
    scope = Recipe.all
                  .order(created_at: :desc)
                  .includes([:sensor, :parent, poster_attachment: :blob, user: { avatar_attachment: :blob }])

    scope = apply_search_query(scope) if params[:q]

    @pagy, @recipes = pagy(scope)
    @saves = find_saves(@recipes)

    if params[:page]
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end

  def search
    redirect_to root_path and return if params[:q].blank?
    scope = Recipe.all
                  .order(created_at: :desc)
                  .includes([:sensor, :parent, poster_attachment: :blob, user: { avatar_attachment: :blob }])

    scope = apply_search_query(scope) if params[:q]

    @pagy, @recipes = pagy(scope)
    @saves = find_saves(@recipes)

    render :index
  end

  def camera
    @recipes = Recipe.all.order(created_at: :desc).includes([:sensor, :parent, poster_attachment: :blob, user: { avatar_attachment: :blob }])
    @scope = @recipes.joins(:sensor).where('sensors.slug': Sensor.compatibility_matrix[@camera.sensor.slug.to_sym]).order(created_at: :desc)
    @pagy, @recipes = pagy(@scope)
    @saves = find_saves(@recipes)
    render :index
  end

  def sensor
    @recipes = Recipe.all.order(created_at: :desc).includes([:sensor, :parent, poster_attachment: :blob, user: { avatar_attachment: :blob }])
    scope = @recipes.joins(:sensor).where('sensors.slug': Sensor.compatibility_matrix[@sensor.slug.to_sym]).order(created_at: :desc)
    @pagy, @recipes = pagy(scope)
    @saves = find_saves(@recipes)

    render :index
  end

  def saved
    @user = User.find_by!(username: params[:user_username])
    scope = @user.saved_recipes.order('saves.id DESC')
    @pagy, @recipes = pagy(scope)
    @saves = find_saves(@recipes)

    respond_to do |format|
      format.html { render 'users/saved' }
      format.turbo_stream { render :index }
    end
  end

  def toggle_save
    authenticate_user!

    @recipe = Recipe.find(params[:recipe_hashid])
    save = @recipe.saves.find_or_initialize_by(user: current_user)
    save.persisted? ? save.destroy : save.save!

    if params[:card]
      render(
        turbo_stream: turbo_stream.replace(
          helpers.dom_id(@recipe, :card),
          partial: 'recipes/recipe_card',
          locals:  {
            recipe: @recipe,
            saves:  find_saves(@recipe)
          }
        )
      )
    else
      redirect_back fallback_location: [@recipe.user, @recipe]
    end
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    scope = Recipe.where.not(id: @recipe.id).order(created_at: :desc).limit(21).includes([:user, :sensor, :parent, poster_attachment: :blob])
    @pagy, @recipes = pagy_countless(scope)
    @saves = find_saves(@recipes)

    if params[:page]
      respond_to do |format|
        format.html
        format.turbo_stream { render 'recipes/index' }
      end
    end
  end

  # GET /recipes/new
  def new
    authenticate_user!
  end

  # GET /recipes/new_local
  def new_local
    authenticate_user!
    @recipe = Recipe.source_type_local.new

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

  # GET /recipes/new_external
  def new_external
    authenticate_user!
    @recipe = Recipe.source_type_external.new
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
    error_action = @recipe.source_type_local? ? :new_local : :new_external

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to user_recipe_url(@recipe.user, @recipe), notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render error_action, status: :unprocessable_entity }
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
    # Remove these two methods once google indexed cameras and sensors properly
    def set_camera
      if params[:slug].to_i.to_s == params[:slug]
        redirect_to camera_path(Camera.find(params[:slug]))
      else
        @camera = Camera.find_by!(slug: params[:slug])
      end
    end

    # Remove these two methods once google indexed cameras and sensors properly
    def set_sensor
      if params[:slug].to_i.to_s == params[:slug]
        redirect_to sensor_path(Sensor.find(params[:slug]))
      else
        @sensor = Sensor.find_by!(slug: params[:slug])
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:hashid])
    end

    def apply_search_query(scope)
      scope
        .joins(:user)
        .where('name ILIKE :query OR users.username ILIKE :query', query: "%#{params[:q]}%")
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
                                     :color_temperature,
                                     :white_balance_red,
                                     :white_balance_blue,
                                     :sensor_id,
                                     :original_author,
                                     :original_url,
                                     :poster,
                                     :photo_1,
                                     :photo_2,
                                     :description,
                                     :name,
                                     :source_type,
                                     :parent_id)
    end
end
