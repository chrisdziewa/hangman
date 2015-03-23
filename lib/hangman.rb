require_relative('./file_reader')
require_relative('./view')

# For reading wordlist from file
file = FileReader.new("words.txt")
view = View.new

class GameEngine
    attr_accessor :hearts_left
    def initialize(file, view)
        @file = file
        @view = view
        @view.set_player_name
        @view.intro
        @file.pick_new_word
        @hearts_left = 6
        @used_letters = []
        @player_wins = false
        play
    end

    def play
        # intial empty feedback
        feedback =  " _ " * @file.secret_word.length
        @view.feedback(feedback)
        until @hearts_left == 0 || @player_wins
            @view.separator
            show_used_letters

            get_guess
            feedback = get_feedback
            @view.feedback(feedback)

            @hearts_left -= 1 if letter_not_found?
            how_many_hearts
            check_player_win
        end
        get_outcome
    end

    def check_player_win
        @file.secret_word.split("").each_with_index do |letter, index|
            return false if !@used_letters.include?(letter)
        end
        @player_wins = true
        return true
    end

    def how_many_hearts
        puts
        puts "You have #{@hearts_left} hearts left"
        puts
    end

    def letter_not_found?
        return true if !@file.secret_word.include?(@used_letters[-1])
    end

    def get_outcome
        word = @file.secret_word
        result = @player_wins == true  ? "win" : "lose"
        @view.outcome(result, word)
    end

    def get_guess
        puts "Please choose a letter from a-z:"
        loop do
            letter = gets.chomp
            if letter_in_used_letters?(letter)
                puts "You already used that letter! Pick a new one:"
                next
            elsif valid_letter?(letter)
                @used_letters.push(letter.downcase)
                return letter
                break
            else
                puts "That isn't a valid letter! a-z only:"
                next
            end
        end
    end

    def show_used_letters
        puts "These are the letters you have already tried: "
        puts @used_letters.to_s
    end

    # Creates a feedback string by iterating through used letters and fills in correct spots
    def get_feedback
        feedback_string = ""
        @file.secret_word.split("").each_with_index do |letter, index|
            feedback_string +=
                if @used_letters.include?(letter.downcase)
                    " #{letter} "
                else
                    " _ "
                end
        end
        feedback_string
    end

    def letter_in_used_letters?(letter)
        @used_letters.include?(letter)
    end

    def valid_letter?(letter)
        letter =~ /^[a-z]$/i
    end
end

game = GameEngine.new(file, view)




