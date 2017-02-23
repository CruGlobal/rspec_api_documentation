module RspecApiDocumentation
  module Writers

    class SlateWriter < MarkdownWriter
      EXTENSION = 'html.md'
      FILENAME = 'index'

      def self.clear_docs(docs_dir)
        FileUtils.mkdir_p(docs_dir)
        FileUtils.rm Dir[File.join docs_dir, "#{FILENAME}.*"]
      end

      def markup_index_class
        RspecApiDocumentation::Views::SlateIndex
      end

      def markup_example_class
        RspecApiDocumentation::Views::SlateExample
      end

      def write
        File.open(configuration.docs_dir.join("#{FILENAME}.#{extension}"), 'w+') do |file|
          file.write "# #{configuration.api_name}\n\n"

          IndexHelper.sections(index.examples, @configuration).each do |section|
            sorted_examples = sort_by_stripe_order(section[:examples])

            sorted_examples.each do |example|
            # section[:examples].each do |example|
              markup_example = markup_example_class.new(example, configuration)
              file.write markup_example.render
            end
          end

        end
      end

      def extension
        EXTENSION
      end

      private

      def position_from_example_description(description)
        case
        when description.start_with?("Create")
          0
        when description.start_with?("Retrieve")
          1
        when description.start_with?("Update")
          2
        when description.start_with?("Delete")
          3
        when description.start_with?("List")
          4
        when description.start_with?("Bulk create")
          5
        when description.start_with?("Bulk update")
          6
        when description.start_with?("Bulk delete")
          7
        else
          99
        end
      end

      def sort_by_stripe_order(examples)
        stripe_indexed_list = []
        alphabetical_list   = []

        examples.each do |example|
          position = position_from_example_description(example.description)

          if position == 99
            alphabetical_list << example
          else
            stripe_indexed_list[position] = example
          end
        end

        stripe_indexed_list.compact + alphabetical_list.sort_by(&:description)
      end
    end
  end
end
