require 'cora'
require 'siri_objects'
require 'imdb'

#######
# This is a "hello world" style plugin. It simply intercepts the phrase "text siri proxy" and responds
# with a message about the proxy being up and running (along with a couple other core features). This 
# is good base code for other plugins.
# 
# Remember to add other plugins to the "config.yml" file if you create them!
######

class SiriProxy::Plugin::SiriIMDB < SiriProxy::Plugin
  def initialize(config)
    #if you have custom configuration options, process them here!
  end
  
  def getActors(movieName)
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	return movie.cast_members
  end

  listen_for /how many stars did (.+) get/i do
	movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
    say "Checking the rating of " + movieTitle + "..." #say something to the user!
	
	#Search for the movie and get the rating as a string
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieRating = movie.rating().to_s
    
	say "" + movieTitle + " has a rating of " + movieRating + " stars out of 10."
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  listen_for /should i see (.+)/i do
	movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
	say "Getting info about " + movieTitle + "..."
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieRating = movie.rating()
	movieRatingString = movie.rating().to_s
	if (movieRating < 6)
		say "You probably shouldn't see " + movieTitle + ", it only got " + movieRatingString + " stars."
	
	elsif (movieRating < 8)
		say "I'd recommend seeing " + movieTitle + ", it got " + movieRatingString + " stars."
	
	elsif (movieRating >= 8)
		say movieTitle + " is a must-see.  It got " + movieRatingString + " stars."
	end
  end

 listen_for ((/who was in (.+)/i) or (/who's in (.+)/i) or (/who is in (.+)/i)) do
	movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
    say "Finding the actors in " + movieTitle + "..." #say something to the user!
	
	movieActors = getActors(movieTitle)
	
	say "" + movieActors[0] + ", " + movieActors[1] + ", and " + movieActors[2] + " were in " + movieTitle + "."
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  # listen_for (/who's in (.+)/i) do
	# movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
    # say "Finding the actors in " + movieTitle + "..." #say something to the user!
	
	# movieActors = getActors(movieTitle)
	
	# say "" + movieActors[0] + ", " + movieActors[1] + ", and " + movieActors[2] + " were in " + movieTitle + "."
    # request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  # end
  
  listen_for ((/^(Who is the main actor in) (.+)/i) or (/^(Who's the main actor in) (.+)/i)) do
	movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	say "The main actor in " + movieTitle + " is " + movieActor + "."
	request_completed
  end
  
  listen_for /Who directed (.+)/i do
	movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDirectors = movie.director()
	say "The director of " + movieTitle + " is " + movieDirectors[0] + "."
	request_completed
  end
  
  listen_for /What was the release date of (.+)/i do
	movieTitle = $2.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDate = movie.release_date()
	say "" + movieTitle + " was released on " + movieDate + "."
	request_completed
  end
end
