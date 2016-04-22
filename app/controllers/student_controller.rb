class StudentController < ApplicationController


  get '/students/login' do 

    erb :'/students/student_login'
  end

  get '/students/signup' do 

    erb :'/students/new_student'
  end



end