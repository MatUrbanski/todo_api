# frozen_string_literal: true

# {ApplicationSerializer} is base class that contains configuration that is
# used across all serializers for rendering JSON using Oj serializer.
# @see http://www.ohler.com/oj/doc/ Oj Documentation.
class ApplicationSerializer
  # It accepts Hash as an argument, sets instance variables based
  # on his keys and returns a new instance of {ApplicationSerializer}.
  #
  # @param [Hash] object that will be used for setting instance variables that will be available inside serializers.
  def initialize(object)
    object.each_pair do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
  end

  # It generates JSON using Oj serializer dump method.
  #
  # @return [String] which is compliant with the JSON standard.
  def render
    Oj.dump(to_json)
  end
end
