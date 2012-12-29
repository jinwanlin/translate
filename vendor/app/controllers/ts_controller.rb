class TsController < ApplicationController

  def translate
    @words = params[:words];
    if @words.present?
      @ts = T.where(:words => @words)
      if @ts.size > 0
        @t = @ts[0];
        @data = @t.meanings
        @t.t_count = 1 if @t.t_count.nil?
        @t.t_count = @t.t_count + 1
        @t.update_attributes(params[:t])
      else
        url = "http://fanyi.youdao.com/openapi.do?keyfrom=remenberwords&key=662876989&type=data&doctype=json&version=1.1&q="+params[:words]
        response = HTTParty.get(url)
        @data = response.body.force_encoding('UTF-8')
        
        @t = T.new
        @t.words = @words
        @t.meanings = @data
        @t.t_count = 1
        @t.save
      end
      
      p "--------------================----------------"
      p @data
      p "--------------================----------------"
    end
    
    @ts = T.all

    respond_to do |format|
      format.html
      format.json { render json: @ts }
    end
  end

  def list
    @ts = T.page(params[:page]).per(1)
    p @ts[0].meanings
  end
  
  # GET /ts
  # GET /ts.json
  def index
    @ts = T.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ts }
    end
  end
  # GET /ts/1
  # GET /ts/1.json
  def show
    @t = T.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @t }
    end
  end

  # GET /ts/new
  # GET /ts/new.json
  def new
    @t = T.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @t }
    end
  end

  # GET /ts/1/edit
  def edit
    @t = T.find(params[:id])
  end

  # POST /ts
  # POST /ts.json
  def create
    @t = T.new(params[:t])

    respond_to do |format|
      if @t.save
        format.html { redirect_to @t, notice: 'T was successfully created.' }
        format.json { render json: @t, status: :created, location: @t }
      else
        format.html { render action: "new" }
        format.json { render json: @t.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ts/1
  # PUT /ts/1.json
  def update
    @t = T.find(params[:id])

    respond_to do |format|
      if @t.update_attributes(params[:t])
        format.html { redirect_to @t, notice: 'T was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @t.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ts/1
  # DELETE /ts/1.json
  def destroy
    @t = T.find(params[:id])
    @t.destroy

    respond_to do |format|
      format.html { redirect_to ts_url }
      format.json { head :no_content }
    end
  end
  
    # GET /ts/1
  # GET /ts/1.json
  def review
    @t = T
    @t = @t.paginate :page => params[:page], :per_page => params[:per_page]
    @data = @t.meanings
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @t }
    end
  end
  
end


