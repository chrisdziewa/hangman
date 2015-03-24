require_relative('./file_reader')
require_relative('./view')
require 'yaml'

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
        reset
    end

    def play
        ask_to_load_game
        until @hearts_left == 0 || @player_wins
            @view.separator
            how_many_hearts

            feedback = get_feedback
            @view.feedback(feedback)

            show_used_letters
            get_guess

            @hearts_left -= 1 if letter_not_found?
            check_player_win
        end
        get_outcome
    end

    def reset
        puts "Alright, let's play!!"
        @file.pick_new_word
        @hearts_left = 6
        @used_letters = []
        @player_wins = false
        play
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
        ask_to_play_again
    end

    def ask_to_play_again
        loop do
            puts "Would you like to play again? (y/n)"
            response = gets.chomp
            next if response == ""
            if response[0].downcase == "y"
                reset
                break
            elsif response[0].downcase == "n"
                puts "Thanks for playing! Goodbye!"
                exit
            end
        end
    end

    def get_saved_game_file
        puts "Previous game loaded!"
        file = File.new('./saved_games/saved_progress.yml', 'r')
        contents = file.read
        data = YAML::load(contents)
    end

    #   secret_word: @file.secret_word,
    #   hearts: @hearts_left,
    #   used_letters: @used_letters,
    #   player_name: @view.name
    # Set current game variables from file contents
    def load_saved_game
        game_data = get_saved_game_file
        @file.secret_word = game_data[:secret_word] || @file.pick_new_word
        @used_letters = game_data[:used_letters] || []
        @hearts_left = game_data[:hearts] || 6
    end

    def ask_to_load_game
        puts "Would you like to load your previous game from the last save? (y/n)"
        response = gets.chomp
        response[0].downcase == 'y' && response != "" ? load_saved_game : return

    end

    def save
        Dir.mkdir('saved_games') unless Dir.exists?('saved_games')
        file_name = 'saved_progress.yml'
        file = make_file(file_name, 'saved_games')
        exit
    end

    def get_data_for_saving
        save_object = {
            secret_word: @file.secret_word,
            hearts: @hearts_left,
            used_letters: @used_letters
        }
    end

    def make_file(name, directory)
        data = get_data_for_saving
        data_string = YAML::dump(data)
        file = File.open('./' + directory + '/' + name, "w") { |f| f.write(data_string)}
    end

    def get_guess
        puts "Please choose a letter from a-z or you can type 'save' to save and exit your current game:"
        loop do
            input = gets.chomp
            if input == 'save'
                save
                break
            end
            if letter_in_used_letters?(input)
                puts "You already used that letter! Pick a new one:"
                next
            elsif valid_letter?(input)
                @used_letters.push(input.downcase)
                return input
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




