module OSLaTeX
  class DocXReader
    def self.open(filename)
      DocXReader.new(filename)
    end

    def initialize(filename)
      @zip_file= Zip::File.open(filename)
    end

    def document_xml
      grab_zipped_file('word/document.xml')
    end

    def footnotes_xml
      grab_zipped_file('word/footnotes.xml')
    end

    private

    def grab_zipped_file(filename)
      documents = @zip_file.glob(filename)

      if documents.length == 1
        documents.first.get_input_stream.read
      else
        nil
      end
    end
  end
end
