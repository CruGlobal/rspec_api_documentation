module RspecApiDocumentation
  module Views
    class SlateExample < MarkdownExample
      def initialize(example, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_example"
      end

      def attribute_parameters
        @attribute_parameters ||= parameters
          .select { |param| param[:name].include?('attributes') }
          .map do |param|
          param[:name] = param[:name].sub('attributes.', '')

          param
        end
      end

      def attribute_response_fields
        @attribute_response_fields ||= response_fields
          .select { |param| param[:name].include?('attributes') }
          .map do |param|
          param[:name] = param[:name].sub('attributes.', '')

          param
        end
      end

      def filter_parameters
        @filter_parameters ||= parameters
          .select { |param| param[:name].include?('filter') }
          .map do |param|
          param[:name] = "filter[#{param[:name].sub('filter.', '')}]"

          param
        end
      end

      def relationships_parameters
        @relationships_parameters ||= parameters
          .select { |param| param[:name].include?('relationships') }
          .map do |param|
          param[:name] = param[:name].sub('relationships.', '')

          param
        end
      end

      def relationships_response_fields
        @relationships_response_fields ||= response_fields
          .select { |param| param[:name].include?('relationships') }
          .map do |param|
          param[:name] = param[:name].sub('relationships.', '')

          param
        end
      end

      def data_parameter
        @data_parameter ||= parameters.select do |field|
          field[:name] == 'data' && field.key?(:description)
        end
      end

      def data_response_field
        @data_response_field ||= response_fields.select do |field|
          field[:name] == 'data' && field.key?(:description)
        end
      end

      def has_attribute_parameters?
        !attribute_parameters.empty?
      end

      def has_attribute_response_fields?
        !attribute_response_fields.empty?
      end

      def has_filter_parameters?
        !filter_parameters.empty?
      end

      def has_data_parameter?
        !data_parameter.empty?
      end

      def has_data_response_field?
        !data_response_field.empty?
      end

      def has_relationships_parameters?
        !relationships_parameters.empty?
      end

      def has_relationships_response_fields?
        !relationships_response_fields.empty?
      end

      def has_sort_parameters?
        !sort_parameters.empty?
      end

      def parameters
        @parameters ||= super.map do |parameter|
          parameter.merge({
            required: parameter[:required] == 'true' ? true : ' - ',
            type: parameter[:type] || ' - '
          })
        end
      end

      def response_fields
        @response_fields ||= super.map do |response_field|
          response_field.merge({
            type: response_field[:type] || ' - '
          })
        end
      end

      def sort_parameters
        @sort_parameters ||= parameters
          .select { |param| param[:name].include?('sort') }
          .map do |param|
          param[:name] = "sort[#{param[:name].sub('sort.', '')}]"

          param
        end
      end
    end
  end
end
