class AttachmentsController < ApplicationController
  before_action :authenticate_user!

	def destroy
		@attachment = ActiveStorage::Attachment.find(params[:id])
	
		@attachment.purge if @attachment.record.user == current_user
	end
end
