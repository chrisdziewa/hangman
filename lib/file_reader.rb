class FileReader
    attr_reader :word
    def initialize(file_name)
        @file = File.new(file_name, "r")
        # create array of words from file
        @word_list = @file.read.split(/\s+/)
        @file.close
    end

    def secret_word
        @word
    end

    def pick_new_word
        get_random_word
    end

    private

    def invalid_length?(word)
        return word.length < 5 || word.length > 12
    end

    def get_random_word
        loop do
           word = @word_list.sample
           next if invalid_length?(word)
           @word = word
           return
        end
    end
end