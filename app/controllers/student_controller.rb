class StudentController < ApplicationController


 
  get '/students/signup' do 

    erb :'/students/new_student'
  end

   post '/students/signup' do 
    
   

      if params[:username] == "" 
        redirect '/students/signup'
      elsif params[:password] == ""
        redirect '/students/signup'
      elsif params[:name] == ""
        redirect '/students/signup'
      else
        @student = Student.create(username: params[:username], password: params[:password], name: params[:name])
        if @student.save
          session[:student_id] = @student.id
          redirect "/students/#{@student.id}/view"
        else
          redirect '/students/signup'
        end
      end
    
  end

  get '/students/login' do 

    erb :'/students/student_login'
  end

   post '/students/login' do 

  
    @student = Student.find_by(username:  params[:username])
    if params[:username] == "" || params[:password] == ""
      redirect '/students/login'
    elsif @student && @student.authenticate(params[:password])
 
      session[:student_id] = @student.id 
      redirect "/students/#{@student.id}/view"
    else
      redirect '/students/login'
    end
  end

  get '/students/:id/view' do 

    redirect '/' if !logged_in?
   
    redirect '/' if params[:id] != current_user.id.to_s
    @student = Student.find(params[:id])
    @appointments = Appointment.where(student_id: session[:student_id])
 



    erb :'/students/view'
  end

  get '/students/:id/book' do 
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
    @student = Student.find(params[:id])

    @openings = Availability.all

    erb :'/students/book'
  end

  post '/students/:id/book' do 
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
   
    appointments = params[:appointments] 
    appointments.each do |key,value|
      value.each do |keys,values|
        Appointment.create(student_id: session[:student_id], tutor_id: values, day: key, time: keys)
      end
    end

    appointments.each do |key,value|
      value.each do |keys,values|
        Availability.delete_all(day: key, time: keys, tutor_id: values)
       
      end
    end

    redirect "/students/#{session[:student_id]}/view"

  end

  get '/students/:id/cancel' do
    redirect '/' if !logged_in?
    redirect '/' if params[:id] != current_user.id.to_s
    @student = Student.find(session[:student_id])
    @appointments = Appointment.where(student_id: session[:student_id])

    erb :'/students/cancel'
  end

  patch '/students/:id/cancel' do 
    appointments = params[:appointments] 
    appointments.each do |key,value|
      value.each do |keys,values|
        Appointment.delete_all(student_id: session[:student_id], tutor_id: values, day: key, time: keys)
      end
    end

    appointments.each do |key,value|
      value.each do |keys,values|
        Availability.create(tutor_id: values, day: key, time: keys)
      end
    end


    redirect "students/#{session[:student_id]}/view"
  end



  helpers do
    def logged_in?
      !!session[:student_id]
    end

    def current_user
      Student.find(session[:student_id])
    end
  end


end