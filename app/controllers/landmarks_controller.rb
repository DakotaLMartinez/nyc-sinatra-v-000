class LandmarksController < ApplicationController
  
  get "/landmarks" do
    @landmarks = Landmark.all 
    erb :"landmarks/index"
  end
  
  get "/landmarks/new" do 
    erb :"/landmarks/new"
  end
  
  get "/landmarks/:id" do 
    if @landmark = Landmark.find(params[:id])
      erb :"/landmarks/show"
    else
      erb :"/landmarks", locals: { message: "Couldn't find a landmark with a matching id" }
    end
  end
  
  get "/landmarks/:id/edit" do 
    if @landmark = Landmark.find(params[:id])
      erb :"/landmarks/edit"
    else
      erb :"/landmarks", locals: { message: "Couldn't find a landmark with a matching id" }
    end
  end
  
  post "/landmarks" do 
    
    n = params[:landmark][:name]
    year = params[:landmark][:year_completed].to_i
    if year > 0
      @landmark = Landmark.create(name: n, year_completed: year)
       erb :"/landmarks/show"
    end
   
  end
  
  post "/landmarks/:id" do 
    if @landmark = Landmark.find(params[:id])  
      @landmark.name = params[:landmark][:name]
      @landmark.year_completed = params[:landmark][:year_completed].to_i if params[:landmark][:year_completed].to_i > 0
      @landmark.save
      erb :"/landmarks/show"
    else
      erb :"/landmarks"
    end
  end
    
end
