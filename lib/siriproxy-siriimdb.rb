require 'cora'
require 'siri_objects'
require 'imdb'

#######
# SiriIMDB is a Siri Proxy plugin that allows Siri to give you recommendations, ratings, and other useful information about anything on IMDB.
# Check the readme file for more detailed usage instructions.
# Created by parm289  - you are free to use, modify, and redistribute as you like, as long as you give the original author credit.
######

class SiriProxy::Plugin::SiriIMDB < SiriProxy::Plugin
  def initialize(config)
  end
  
  def getActors(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	return movie.cast_members
  end
  
  def getLeadActor(movieName)
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	return movieActor
  end
  
  def getRating(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	movieRating = movie.rating()
	return movieRating
  end

  listen_for /how many stars did (.*) get/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	#Search for the movie and get the rating as a string
	movieRating = getRating (movieTitle)
	say "" + movieTitle + " has a rating of " + movieRating + " stars out of 10."
    request_completed
  end
  
  listen_for /should i see (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieRating = getRating(movieTitle)
	movieRatingString = movieRating.to_s
	if (movieRating < 6)
		say "You probably shouldn't see " + movieTitle + ", it only got " + movieRatingString + " stars."
	elsif (movieRating < 8)
		say "I'd recommend seeing " + movieTitle + ", it got " + movieRatingString + " stars."
	elsif (movieRating >= 8)
		say "" + movieTitle + " is a must-see.  It got " + movieRatingString + " stars."
	end
    request_completed
  end

 listen_for /who was in (.*)/i  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", and " + movieActors[2] + " were in " + movieTitle + "."
    request_completed
  end

 listen_for (/who's in (.*)/i)  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", and " + movieActors[2] + " were in " + movieTitle + "."
    request_completed
  end  
  
  listen_for /who is in (.*)/i  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", and " + movieActors[2] + " were in " + movieTitle + "."
    request_completed
  end
  
  listen_for /Who is the lead actor in (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActor = getLeadActor(movieTitle)
	say "The main actor in " + movieTitle + " is " + movieActor + "."
	request_completed
  end
  
  listen_for (/Who's the main actor in (.*)/i) do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	say "The main actor in " + movieTitle + " is " + movieActor + "."
	request_completed
  end
  
  listen_for /Who directed (.+)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDirectors = movie.director()
	say "The director of " + movieTitle + " is " + movieDirectors[0] + "."
	request_completed
  end
  
  listen_for /When was (.*) released/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDate = movie.release_date()
	say "" + movieTitle + " was released on " + movieDate + "."
	request_completed
  end
end
