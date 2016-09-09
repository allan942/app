require 'dx/props'
require "uri"

class DesignMethodsController < ApplicationController
  load_and_authorize_resource

  before_action :edit_as_signed_in_user, only: [:edit, :update]
  before_action :create_as_signed_in_user, only: [:create, :new]

  layout 'custom'

  def index
      @design_methods = DesignMethod.where("overview != ?", "No overview available" )
      if params[:sort_order] == "completion"
        @design_methods = DesignMethod.order(completion_score: :desc)
      end
      # Filter bar needs
      @search_filter_hash = MethodCategory.order(:process_order)
      @design_methods_all = DesignMethod.all
      respond_to do |format|
        format.html { render :layout => "wide" }
        format.json { render json: @design_methods_all}
      end
  end


  def new
    @new = true
    @design_method = DesignMethod.new
    render :layout => "custom"
  end

  def edit
    @design_method = DesignMethod.find(params[:id])
    render :layout => "custom"
  end

  def update
    @design_method = DesignMethod.find(params[:id])

    if !(current_user.admin? || current_user.editor?)
      @design_method.hidden = true
    end

    if Rails.env.production?
      file = params[:design_method][:picture]
      @design_method.upload_to_s3(file, request.original_url)
    end

    respond_to do |format|
      if @design_method.update_attributes(params[:design_method])
        @design_method.update_citations
        format.html { redirect_to @design_method, notice: 'Design method was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @design_method.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @design_method = DesignMethod.new(params[:design_method])
    @design_method.owner = current_user

    if !(current_user.admin? || current_user.editor?)
      @design_method.hidden = true
    end

    if Rails.env.production?
      file = params[:design_method][:picture]
      @design_method.upload_to_s3(file, request.original_url)
    end

    respond_to do |format|
      if @design_method.update_attributes(params[:design_method])
        @design_method.update_citations
        format.html { redirect_to @design_method, notice: 'Design method was successfully created.' }
        format.json { render json: @design_method, status: :created, location: @design_method }
      else
        format.html { render action: "new" }
        format.json { render json: @design_method.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    require 'dx/props'
    @props = Dx::Props.load_file 'config/props/design_methods.yml'

    id = params[:id].to_i
    #default to method id #1 TODO remove
    dm = DesignMethod.find(id)
    @method = dm
    if !current_user.nil?
      @collections = current_user.owned_collections
      @collection = Collection.new(params[:collection])
      @collection.owner_id = current_user.id
    end
    # Method likes:
    @method.likes += 1
    @method.save!
    # Method likes end.

    @citations = dm.citations
    @author = dm.owner
    @method.save

    @similar_methods = @method.similar_methods(100,6)
    @similar_case_studies = @method.similar_case_studies(100,6)
    respond_to do |format|
      format.html { render :layout => "custom" }
      format.json {render :json => @method}
    end
  end

  # Confirms that user is logged-in.
  def edit_as_signed_in_user
    unless signed_in?
      flash[:danger] = "Please sign in to edit this design method."
      redirect_to design_method_url
    end
  end

  def clearImage
    @design_method = DesignMethod.find(params[:id])
    @design_method.picture_url = nil
    @design_method.save
    respond_to do |format|
      format.html { redirect_to @design_method, notice: 'Image was successfully removed.' }
    end
  end
  def create_as_signed_in_user
    unless signed_in?
      flash[:danger] = "Please sign in to add a design method."
      redirect_to design_methods_url
    end
  end


  def destroy
    @design_method = DesignMethod.find(params[:id])
    DesignMethod.delete(@design_method)
    respond_to do |format|
        format.html { redirect_to '/design_methods', notice: 'Design method was successfully deleted.' }
    end
  end
end
