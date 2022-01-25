require 'pg'
require 'csv'
require_relative 'db'

con = DB.new
con.create_tables
con.delete_table_content
con.import_csv_to_table('/home/ubuntu/users1.csv', 'users1')
con.import_csv_to_table('/home/ubuntu/users2.csv', 'users2')
con.import_csv_to_table('/home/ubuntu/pictures.csv', 'pictures')
con.import_csv_to_table('/home/ubuntu/avatars.csv', 'avatars')
con.import_csv_to_table('/home/ubuntu/user_picture.csv', 'user_picture')

puts "Welcome to application."

loop do
  puts "What would you like to do with the user data?"
  puts "Press 1 to view information of the users."
  puts "Press 2 to view information about users' avatars."
  puts "Press 3 to view information about user's pictures."
  puts "Press 0 if you want to stop the work in application"
  answer = gets.chomp
  case answer
  when "1"
    puts con.select_users.entries
  when "2"
    puts con.select_avatars.entries
  when "3"
    puts "Select user."
    user_id = gets.chomp
    puts con.select_pictures(user_id).entries
  when "0"
    break
  else
    puts "The input is invalid."
  end
end