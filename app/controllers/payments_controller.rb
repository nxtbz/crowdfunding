class PaymentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_project
	before_action :set_reward
	before_action :set_amount
	before_action :set_client_token


	def new
		@pledge = current_user.pledges.build(payment_params)
		@rewards = @project.rewards

		respond_to do |format| 
			if @reward && @amount.present? && reward.value <= @amount 
				format.html 
			else 
				if @amount.present?
					flash[:error] = "Must be greater then the reward"
				else 
					flash[:error] = "You must provide an amount"
				end
				format.html{ redirect_to new_project_pledge_path(rewards: @reward)}
			end			
		end
	end

	def create
		@pledge = current_user.pledges.build(payment_params)
		respond_to do |format| 
			if @pledge.valid? 
				if current_user.customer_id && Braintree::Customer.find(current_user.customer_id)
					@pledge.save 
					format.html { redirect_to project_path(@project), notice:"Your pledge succeeded"}
				else 
					result = Braintree::Custromer.create(
						:email => current_user.email, 
						:paymen_method_nonce => params[:payment_method_nonce ])
						if result.success? 
							@pledge.save 
							current_user.update(customer_id: result.customer_id)
							format.html { redirect_to project_path(@project), notice: "Your pledge was created" }
						else 
							format.html { render :new }
						end		
				end
			else 
				format.html{ render :new }
			end
	end

	private 


	def set_project 
		@project = Project.find(params[:project_id])
	end 	

	def set_amount 
		@amount = payment_params[:amount].to_i
	end

	def set_reward
		@reward = @project.rewards.find_by_id(payment_params[:reward_id])
	end

	def set_client_token 
		@client_token = Braintree::ClientToken.generate(:customer_id => current_user.custromer_id )
	end

	def payment_params
		params.require(:pledge).permit(:reward_id, :name, :amount, :address, :city, :country, :postal_code)
	end


end