class Admin::TopController < ApplicationController
  def index
    #render action: 'index'
    raise IpAddressRejected
  end
end
