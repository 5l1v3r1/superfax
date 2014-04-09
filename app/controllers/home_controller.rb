class HomeController < ApplicationController
  def index
    @fax = Fax.new
  end

  def create
    @fax = Fax.new(params[:fax])
    @fax.number = params[:code] + params[:ddd] + params[:number]
    @fax.fax = params[:upload]
    respond_to do |wants|
      if @fax.save!
        io = open("#{@fax.fax.url}")
        @pages = PDF::Reader.new(io).page_count
        @phaxio = Phaxio.send_fax(to: "553491456633", string_data: "teste")
        puts "id: #{@phaxio['message']}"
        @status = Phaxio.get_fax_status(id: @phaxio["faxId"])
        puts @status
        flash[:notice] = "Fax salvo com sucesso"
        #wants.html { redirect_to "/" }
        wants.js
      end
    end
  end
end
