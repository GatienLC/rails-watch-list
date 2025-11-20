# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'httparty'

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all
puts "Destroyed all records"

API_KEY = "8b9f4785166d2c241b0ec5854f091544"

# Fetch top rated movies from TMDB
url = "https://api.themoviedb.org/3/movie/top_rated?api_key=#{API_KEY}"
response = HTTParty.get(url)
movies = response["results"]

puts "Creating movies..."
movies.each do |movie|
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/original#{movie['poster_path']}",
    rating: movie["vote_average"]
  )
  puts "Created movie: #{movie['title']}"
end

puts "Creating lists..."
List.create!(name: "My Favorites")
List.create!(name: "Action")
List.create!(name: "Drama")
puts "Lists created!"
