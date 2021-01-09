module Super
  module ViewHelper
    module_function

    # For example, calling `classes("always", ["sometimes", condition])` would
    # return the string "always sometimes" or "always"
    def classes(*list)
      result = list.map do |c|
        case c
        when String
          c
        when Array
          if c.size != 2
            raise %(Expected exactly two elements (["class", some_condition]), got: #{c.inspect})
          end

          c.first if c.last
        end
      end

      result.compact.join(" ")
    end
  end
end
