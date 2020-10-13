class UploadFilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @uploads = current_user.upload_files.all
  end

  def new
    @upload = current_user.upload_files.build
  end

  def create
    @upload = current_user.upload_files.new(upload_file_params)
    data = params
    if @upload.save 
      ProccessFileJob.perform_later(data, current_user)
      flash[:success] = "File successfully uploaded"
      redirect_to upload_files_path
    else 
      flash[:error] = "File could not be uploaded, please try again"
      redirect_to new_upload_files_path
    end
  end

  private

  def upload_file_params
    params.require(:upload_file).permit(:status, :file_errors, :doc)
  end
  
  
end
