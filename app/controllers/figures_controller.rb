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
  
  # get "/figures/:slug" do
  #   if @figure = Figure.find_by_slug(params[:slug])
  #     erb :"/figures/show"
  #   else
  #     erb :"/figures", locals: {message: "I didn't find a figure by that name."}
  #   end
  # end
  
  # get "/figures/:slug/edit" do 
  #   if @figure = Figure.find_by_slug(params[:slug])
  #     erb :"/figures/edit"
  #   else
  #     erb :"/figures", locals: { message: "I didn't find a figure matching that id."}
  #   end
  # end
  
  get "/figures/:id" do 
    if @figure = Figure.find(params[:id])
      erb :"/figures/show"
    else
      erb :"/figures", locals: { message: "I didn't find a matching figure."}
    end
  end
  
  get "/figures/:id/edit" do 
    if @figure = Figure.find(params[:id])
      @landmarks = Landmark.all 
      @titles = Title.all
      erb :"/figures/edit"
    else
      erb :"/figures", locals: { message: "I didn't find a matching figure."}
    end
  end
  
  post "/figures/:id" do 
    if @figure = Figure.find(params[:id])
      # updates the figure's name is a new value is given
      if params[:figure][:name] != @figure.name
        @figure.name = params[:figure][:name]
      end
      # adds titles from title checkboxes if the form
      # submission's params look different from the 
      # saved figure object
      if params[:figure][:title_ids] && !params[:figure][:title_ids].empty? && params[:figure][:title_ids] != @figure.title_ids
        # removes any titles not checked upon update
        @figure.figure_titles.each do |fig_title|
          if !params[:figure][:title_ids].include?(fig_title.title_id)
             fig_title.delete 
          end
        end
        # adds any new titles checked upon update
        params[:figure][:title_ids].each do |title_id|
          t = Title.find(title_id)
          @figure.figure_titles.create(title: t) if !@figure.figure_titles.include?(t)
        end
      end
      # adds titles from create a new title field
      if params[:title][:name] && !params[:title][:name].empty?
        title = Title.find_or_create_by(name: params[:title][:name])
        @figure.figure_titles.find_or_create_by(title_id: title.id)
      end
      # adds landmarks from landmark checkboxes if the 
      # params from the form differ from the values
      # of the saved figure's landmarks
      if params[:figure][:landmark_ids] && !params[:figure][:landmark_ids].empty? && params[:figure][:landmark_ids] != @figure.landmark_ids
        # deletes any landmarks no longer associated with 
        # this figure object
        @figure.landmarks.each do |landmark|
          if !params[:figure][:landmark_ids].include?(landmark.id)
            @figure.landmarks.delete(landmark)
          end
        end
        # adds any new landmarks that are now associated
        # with this figure object
        params[:figure][:landmark_ids].each do |landmark_id|
          landmark = Landmark.find(landmark_id)
          @figure.landmarks << landmark if !@figure.landmarks.include?(landmark)
        end
      end
      # adds landmarks from create a new landmark
      # field if the landmark is not already associated
      # with this figure object
      if params[:landmark][:name] && !params[:landmark][:name].empty?
        landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
        @figure.landmarks << landmark if !@figure.landmarks.include?(landmark)
      end
      @figure.save
      erb :"/figures/show", locals: { message: "Successfully saved the figure." }
    else
      erb :"/figures", locals: { message: "I didn't find a matching figure."}
    end
  end
  
  post "/figures" do 
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
      erb :"/figures/show", locals: { message: "Successfully updated figure." }
    else
      erb :"/figures/new", locals: {message: "Something went wrong. Please try again" }
    end
  end
    
end