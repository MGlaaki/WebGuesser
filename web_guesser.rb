require 'sinatra'
require 'sinatra/reloader'

set :SECRET_NUMBER, rand(101)
set :backgroundColor, "white"

class Game
  @@tries = 5
  def initialize (guess, settings)
    @this_guess = guess
    @this_settings = settings
  end

  def checkGuess
    if @this_guess == nil or @this_guess == ""
      return ""
    end

    if @this_guess != @this_guess.to_i.to_s
      return notANumber
    end




    @this_guess = @this_guess.to_i
    diff = (@this_guess - @this_settings.SECRET_NUMBER).abs
    redValue = [0.75 + ((diff.to_f)/100), 1].min



    if diff==0
      @this_settings.set :backgroundColor, "green"
    else
      @this_settings.set :backgroundColor, "rgba(250,0,0,#{redValue})"
    end



    if @this_guess > @this_settings.SECRET_NUMBER
        @@tries -= 1
        if @@tries == 0
          return tooLong
        end
        return @this_guess - @this_settings.SECRET_NUMBER > 5 ? "Way too high ! #{@@tries} tries left." : "Too high ! #{@@tries} tries left."
    elsif @this_guess < @this_settings.SECRET_NUMBER
        @@tries -= 1
        if @@tries == 0
          return tooLong
        end
        return @this_settings.SECRET_NUMBER - @this_guess > 5 ? "Way too low ! #{@@tries} tries left." : "Too low ! #{@@tries} tries left."
    elsif @this_guess == @this_settings.SECRET_NUMBER
        result = "Well played ! Secret number was #{@this_settings.SECRET_NUMBER} ! Want to find the new one ?"
        @@tries = 5
        @this_settings.set :SECRET_NUMBER, rand(101)
        return result
    else
        return ""
    end
  end

  def notANumber
    return "This was not a number ! Please enter a number between 0 and 100."
  end

  def tooLong
    @@tries = 5
    @this_settings.set :SECRET_NUMBER, rand(101)
    return "Too slow ! Start again !"
  end

end

get '/' do
  guess = params["guess"]
  game = Game.new(guess, settings)
  message = game.checkGuess
  erb :index, :locals => {:number => settings.SECRET_NUMBER, :message => message, :backgroundColor => settings.backgroundColor}
end
