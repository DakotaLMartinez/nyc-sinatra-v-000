class FiguresController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views/") }
  get "/figures" do 
    @figures = Figure.all 
    erb :"/figures/index"
  end
  
  get "/figures/new" do 
    @landmarks = Landmark.all 
    @titles = Title.all
    erb :"/figures/new"
  end
  
  post "/figures" do 
    "#{params}"
    @figure = Figure.create(name: params[:figure][:name])
    # adds titles from title checkboxes
    if params[:figure][:title_ids] && !params[:figure][:title_ids].empty? 
      params[:figure][:title_ids].each do |title_id|
        @figure.figure_titles.create(title: Title.find(title_id))
      end
    end
    # adds titles from create a new title field
    if params[:title][:name]
      @figure.figure_titles.create(title: Title.find_or_create_by(name: params[:title][:name]))
    end
    # adds landmarks from landmark checkboxes
    if params[:figure][:landmark_ids] && !params[:figure][:landmark_ids].empty?
      params[:figure][:landmark_ids].each do |landmark_id|
        landmark = Landmark.find(landmark_id)
        @figure.landmarks << landmark if !@figure.landmarks.include?(landmark)
      end
    end
    # adds landmarks from create a new landmark
    # field
    if params[:landmark][:name]
      landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
      @figure.landmarks << landmark if !@figure.landmarks.include?(landmark)
    end
    if @figure.save
      erb :"/figures/show", locals: { message: "Successfully created figure." }
    else
      erb :"/figures/new", locals: {message: "Something went wrong. Please try again" }
    end
  end
    
end