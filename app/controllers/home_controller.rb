require 'open-uri'

class HomeController < ApplicationController

  before_action :protected_from_wrong_domain

  def index
    if params[:fax_id]
      @fax = Fax.find(params[:fax_id])
    else
      @fax = Fax.new
    end
  end

  def create
    @fax = Fax.new(params[:fax])
    @fax.number = params[:code].gsub("+", "") + params[:ddd] + params[:number]
    @fax.fax = params[:upload]
    extension = @fax.fax.file.extension.downcase

    if %w{jpg png jpeg bmp pdf}.include?(extension)
      if @fax.save!
        @pages = 1
        if extension == "pdf"
          io = open("#{@fax.fax.url}")
          @pages = PDF::Reader.new(io).page_count
        end

        amount = @pages * 2 + 0.4;
        @invoice = Invoice.new(:fax_id => @fax.id, :amount => amount)
        @invoice.save

        #flash[:notice] = "Fax salvo com sucesso"
      else
        @fax = nil
      end
    else
      @fax = nil
    end

    respond_to do |wants|
      wants.js
    end
  end

  def send_fax
    @fax = Fax.find(params[:fax_id])
    if @fax
      @phaxio = Phaxio.send_fax(to: "#{@fax.number}", string_data: "#{@fax.fax.url}", string_data_type: "url")

      puts "id: #{@phaxio['message']}"
      @did_work = false

      if @phaxio['message'] == "Fax queued for sending"
        @status = Phaxio.get_fax_status(id: @phaxio["faxId"])
        @did_work = true
      else
        if @phaxio['message'].starts_with?("Number is not formatted correctly")
        else
          @status = @phaxio['message']
        end
      end
    end

    respond_to do |wants|
      wants.js
      wants.html
    end
  end

  def get_fax_status
    respond_to do |wants|
      @status = Phaxio.get_fax_status(id: params[:fax_id])
      wants.js
    end
  end

  def payment
    invoice = Invoice.find_by_fax_id(params[:fax_id])
    payment = PagSeguro::Payment.new("neliojrr@gmail.com", "ECAAC66FF2934DAB88D2AF6A041E868C", id: invoice.id,
                                     redirect_url: "http://superfax.com.br/payment_status?fax_id=#{params[:fax_id]}")
    #payment = PagSeguro::Payment.new("neliojrr@gmail.com", "ECAAC66FF2934DAB88D2AF6A041E868C", id: invoice.id,
    #                                 redirect_url: "http://superfax-102926.sae1.nitrousbox.com/payment_status?fax_id=#{params[:fax_id]}")
    payment.items = [ PagSeguro::Item.new(id: 1, description: "Envio de fax", amount: invoice.amount, quantity: 1) ]

    redirect_to payment.checkout_payment_url
  end

  def payment_status
    @fax = Fax.find(params[:fax_id])
    @invoice = Invoice.find_by_fax_id(params[:fax_id])
    transaction_id = params[:transaction_id]
    status = PagSeguro::Query.new("neliojrr@gmail.com", "ECAAC66FF2934DAB88D2AF6A041E868C",transaction_id)

    respond_to do |wants|
      if status.approved? && @fax
        @status = true
      else
        @status = false
      end
      wants.html
    end
  end

  private

  def protected_from_wrong_domain
    unless request.original_url.include?("superfax.com.br")
      render file: "public/404.html", status => 404
    end
  end
end
