class View
    attr_reader :name
    def initialize()
    end

    def set_player_name
        puts "What is your name?"
        @name = gets.chomp
    end

    def feedback(str)
        puts "Here is your current progress:"
        puts
        puts str
    end

    def intro
        separator
        puts "Welcome to Hangman, #{@name}!!"
        separator
    end

    def outcome(result, word)
        separator
        if result == "win"
            puts "Congratulations, YOU WIN!"
        else
            puts "Sorry, but you ran out of hearts.."
        end
        puts "The word was '#{word}' "
        separator
    end

    def separator
        puts "=" * 60
    end
end




