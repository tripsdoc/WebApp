# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
Container.create!(container_prefix: Faker::Lorem.characters(6), container_number:  "0707280", container_uid:  "07072801", 
							schedule_date: 		Time.zone.now,
							unstuff_date:      	Time.zone.now,
							last_day: 			Time.zone.now, 
							f5_unstuff_date:    Time.zone.now,
							f5_last_day:        Time.zone.now)