class TutorController < ApplicationController






  get '/tutors/signup' do 

    erb :'/tutors/new_tutor'
  end

   post '/tutors/signup' do 
   

      if params[:username] == "" 
        redirect '/tutors/signup'
      elsif params[:password] == ""
        redirect '/tutors/signup'
      elsif params[:name] == ""
        redirect '/tutors/signup'
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
      redirect '/tutors/login'
    elsif @tutor && @tutor.authenticate(params[:password])
 
      session[:tutor_id] = @tutor.id 
      redirect "/tutors/#{@tutor.id}/view"
    else
      redirect '/tutors/login'
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
    redirect '/' if params[:id] != current_user.id.to_s
    redirect '/' if !logged_in?
    erb :'tutors/make_schedule' 
  end

  post '/tutors/schedule' do 
    redirect '/' if !logged_in?

    @tutor = Tutor.find(session[:tutor_id])


    params.each do |key,value|
      value.each do |time|
        Availability.create(day: key, time: time[0], tutor_id: session[:tutor_id])
      end

      
    end
     redirect "/tutors/#{@tutor.id}/view"
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
    Availability.delete_all(tutor_id: @tutor.id)
    binding.pry
    params[:edit].each do |key,value|
      value.each do |time|
        Availability.create(day: key, time: time[0], tutor_id: session[:tutor_id])
      end

    end


    redirect "/tutors/#{@tutor.id}/view"
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