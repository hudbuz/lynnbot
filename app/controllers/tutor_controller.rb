class TutorController < ApplicationController






  get '/tutors/signup' do 

    erb :'/tutors/new_tutor'
  end

   post '/tutors/signup' do 
   

      if params[:username] == "" 
        erb :'/tutors/new_tutor', locals: {message: "You must enter a username."}
      elsif params[:password] == ""
        erb :'/tutors/new_tutor', locals: {message: "You must enter a password."}

      elsif params[:name] == ""
        erb :'/tutors/new_tutor', locals: {message: "You must enter a name."}
        binding.pry
      elsif Tutor.all.find_by(username: params[:username])
        erb :'/students/new_student', locals: {message: "Username already taken."}
      else
        @tutor = Tutor.create(username: params[:username], password: params[:password], name: params[:name])
        if @tutor.save
          session[:tutor_id] = @tutor.id
          redirect "/tutors/#{@tutor.id}/schedule"
        else
          redirect '/tuors/signup'
        end
      end
    
  end

  get '/tutors/login' do 

    erb :'/tutors/tutor_login'
  end

   post '/tutors/login' do 
  
    @tutor = Tutor.find_by(username:  params[:username])
    if params[:username] == "" || params[:password] == ""
      erb :'/tutors/tutor_login', locals: {message: "You must enter a username and a password."}
    elsif @tutor && @tutor.authenticate(params[:password])
 
      session[:tutor_id] = @tutor.id 
      redirect "/tutors/#{@tutor.id}/view"
    else
      erb :'/tutors/tutor_login', locals: {message: "You must enter a valid username and a password."}
    end
  end

  get '/tutors/:id/view' do 

    redirect '/' if params[:id] != current_user.id.to_s
    redirect '/' if !logged_in?

    @tutor = Tutor.find(session[:tutor_id])
     @appointments = Appointment.where(tutor_id: session[:tutor_id])
    erb :'/tutors/view_schedule'
  end

  get '/tutors/:id/schedule' do 
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
    @tutor = Tutor.find(session[:tutor_id])
    erb :'tutors/make_schedule' 
  end

  post '/tutors/:id/schedule' do 
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
    @tutor = Tutor.find(session[:tutor_id])

    if params == {}
      erb :"tutors/make_schedule", locals: {message: "You need to list at least 1 availability if you tryna work.  "}
    else
      @tutor = Tutor.find(session[:tutor_id])


      params.each do |key,value|
        value.each do |time|
          Availability.create(day: key, time: time[0], tutor_id: session[:tutor_id])
        end

        
      end
       redirect "/tutors/#{@tutor.id}/view"
     end
  end

  get '/tutors/:id/edit_schedule' do 
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
   
    @tutor = Tutor.find(params[:id])

    erb :'/tutors/edit_schedule'
  end

  patch '/tutors/:id/edit_schedule' do 
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
    @tutor = Tutor.find(params[:id])

    if params[:edit] == nil
      erb :"/tutors/edit_schedule", locals: {message: "You need to list at least 1 availability if you tryna work.  "}
    else

      @tutor = Tutor.find(params[:id])
      Availability.delete_all(tutor_id: @tutor.id)

      params[:edit].each do |key,value|
        value.each do |time|
          Availability.create(day: key, time: time[0], tutor_id: session[:tutor_id])
        end

      end


      redirect "/tutors/#{@tutor.id}/view"
    end
  end



  get '/logout' do 
    session.clear
    redirect '/'
  end

  helpers do
    def logged_in?
      !!session[:tutor_id]
    end

    def current_user
      Tutor.find(session[:tutor_id])
    end
  end



end