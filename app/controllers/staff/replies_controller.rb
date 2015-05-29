class Staff::RepliesController < Staff::Base
  before_action :prepare_message

  def new
    @reply = StaffMessage.new
  end

  #POST
  def confirm
    @reply = StaffMessage.new(staff_message_params)
    if @reply.valid?
      render action: 'confirm'
    else
      flash.now.alert = '入力に誤りがあります。'
      render action: 'new'
    end
  end

  private
  def prepare_message
    @message = CustomerMessage.find(params[:message_id])
  end

  def staff_message_params
    params.require(:staff_message).permit(:subject, :body)
  end
end
