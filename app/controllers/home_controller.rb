require 'open-uri'

class HomeController < ApplicationController
  def index
    @fax = Fax.new
  end

  def create
    @fax = Fax.new(params[:fax])
    @fax.number = params[:code].gsub("+", "") + params[:ddd] + params[:number]
    @fax.fax = params[:upload]
    respond_to do |wants|
      if @fax.save!
        io = open("#{@fax.fax.url}")
        @pages = PDF::Reader.new(io).page_count
        flash[:notice] = "Fax salvo com sucesso"
        #wants.html { redirect_to "/" }
        wants.js
      end
    end
  end

  def send_fax
    @fax = Fax.find(params[:fax_id])
    respond_to do |wants|
      if @fax
        io = open("#{@fax.fax.url}")
        @phaxio = Phaxio.send_fax(to: "#{@fax.number}", string_data: "#{@fax.fax.url}", string_data_type: "url")
        puts "id: #{@phaxio['message']}"
        @status = Phaxio.get_fax_status(id: @phaxio["faxId"])
        wants.js
      end
    end
  end

  def get_fax_status
    respond_to do |wants|
      @status = Phaxio.get_fax_status(id: params[:fax_id])
    end
  end
end
