class TextSanitiser
        attr_accessor :banned_starting_strings # Drop strings that start with these strings
        attr_accessor :banned_ending_strings # Drop strings that end with these strings
        attr_accessor :split_newline # True to split strings based on newline character
        attr_accessor :drop_empty # True to drop empty strings (strings that are just spaces)

        alias_method :split_newline?, :split_newline
        alias_method :drop_empty?, :drop_empty

        def initialize(banned_starting_strings = [], banned_ending_strings = [], split_newline = true, drop_empty = true)
          @banned_starting_strings = banned_starting_strings
          @banned_ending_strings = banned_ending_strings
          @split_newline = split_newline
          @drop_empty = drop_empty
        end

        def clean(string_array)
          string_array = split_newline(string_array) if split_newline?
          string_array = drop_empty(string_array) if drop_empty?
          string_array = drop_banned_starting_strings(string_array) if !banned_starting_strings.empty?
          string_array = drop_banned_ending_strings(string_array) if !banned_ending_strings.empty?
          return string_array
        end

        def split_newline(string_array)
          return string_array.map {|v| v.split("\n") }.flatten
        end

        def drop_empty(string_array)
          return string_array.select {|v| v != v.gsub(/\w/, ' ') }
        end

        def drop_banned_starting_strings(string_array)
          return string_array.select {|v| !v.start_with?(*banned_starting_strings) }
        end

        def drop_banned_ending_strings(string_array)
          return string_array.select {|v| !v.end_with?(*banned_ending_strings) }
        end
end
