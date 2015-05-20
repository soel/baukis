class Customer::EntriesController < Customer::Base
  def create
    program = Program.published.find(params[:program_id])
    case Customer::EntryAcceptor.new(currrent_customer).accept(program)
    when :accept
      flash.notice = 'プログラムに申し込みました。'
    when :full
      flash.alert = 'プログラムの申込者数が上限に達しました。'
    when :closed
      flash.alert = 'プログラムの申し込み機関が終了しました。'
    end
    redirect_to [ :customer, program ]
  end

  # PATCH
  def cancel
    program = Program.published.find(params[:program_id])
    entry = program.entries.where(customer_id: current_customer.id).first!
    entry.update_column(:canceled, true)
    flash.notice = 'プログラムへの申し込みをキャンセルしました。'
    redirect_to [ :customer, program ]
  end
end
