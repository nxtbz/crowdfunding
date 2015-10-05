class ProjectsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	before_action :set_project, only: [:show, :edit, :update, :destroy]

	def index
		@project = Project.all
		@displayed_projects = Project.take(4)
	end

	def show 
		@rewards = @project.rewards
	end


	def new 
		@project = Project.new 
	end

	def create 
		@project = current_user.projects.build(project_params)
			respond_to do |format| 
				if @project.save 
					format.html{ redirect_to @project, notice: "Project was created"}
					format.json{ render :show, status: :ok, location: @project}
				else 
					format.html{ render 'new', notice: "Fill in the missing fields"}
					format.json{ render json: @project.errors, status: :unprocessable_entity }
				end
		end
	end


	def update 
		respond_to do |format| 
			if @project.update(project_params)
				format.html{ redirect_to @project, notice: "Project was created"}
				format.json{ render :show, status: :ok, location: @project}
			else 
				format.html{ render :edit }
				format.json{ render json: @project.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit 
	end

	def destroy 
		@project.destroy 
		respond_to do |format | 
			format.html {redirect_to projects_path, notice: "Project was destroyed"}
			format.json { head :no_content }
		end
	end


	private 

		def project_params
			params.require(:project).permit(:name, :short_description, :description, :image_url, :status, :goal, :expiration_date)
		end

		def set_project
			@project = Project.find(params[:id])
		end


end
