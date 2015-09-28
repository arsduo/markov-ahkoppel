module Markovian
  class Corpus
    class DictionaryEntry
      attr_reader :word, :count
      def initialize(word)
        @word = word
        @next_words = []
        @previous_words = []
        @count = 0
      end

      def push(word, direction: :forwards)
        # The incoming word will be a Tokeneyes::Word object
        array_for_direction(direction) << word.to_s
        # we don't want to double-count words if we read the text both forward and backward, so
        # only count in the forward direction. (If we encounter a scenario where someone only wants
        # to read in the backward direction, we can deal with that then.)
        @count += 1 if direction == :forwards
      end

      def next_word
        next_words.sample
      end

      def previous_word
        previous_words.sample
      end

      def ==(other)
        self.word == other.word &&
          self.next_words == other.next_words &&
          self.previous_words == other.previous_words
      end

      protected

      # for equality checking
      attr_reader :next_words, :previous_words

      VALID_DIRECTIONS = [:backwards, :forwards]

      def array_for_direction(direction)
        validate_direction(direction)
        direction == :backwards ? previous_words : next_words
      end

      def validate_direction(direction)
        unless VALID_DIRECTIONS.include?(direction)
          raise ArgumentError.new("Invalid direction #{direction.inspect}, valid directions are #{VALID_DIRECTIONS.inspect}")
        end
      end
    end
  end
end