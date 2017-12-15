module OSLaTeX
  class StyleMapping
    def initialize
      @mapping = {
        paragraph_styles: {},
        run_styles: {},
      }
    end

    def load_json!(filename)
      loaded = JSON.load(File.open(filename))

      @mapping.merge!(paragraph_styles: loaded['paragraph_styles'])
      @mapping.merge!(run_styles: loaded['run_styles'])
    end

    def paragraph_style?(style)
      test_style(:paragraph_styles, style)
    end

    def run_style?(style)
      test_style(:run_styles, style)
    end

    def paragraph_style(style)
      get_style(:paragraph_styles, style)
    end

    def run_style(style)
      get_style(:run_styles, style)
    end

    private

    def test_style(key, style)
      @mapping[key].key?(style || '')
    end

    def get_style(key, style)
      @mapping[key][style || '']
    end
  end
end
