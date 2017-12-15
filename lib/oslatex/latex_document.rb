module OSLaTeX
  class LaTeXTemplate
    def initialize(template_filename)
      @template = ERB.new(File.read(template_filename))
      @template.filename = template_filename
      @attributes = nil
    end

    def paragraphs(name)
      case @attributes[name]
      when Array
        @attributes[name]
      when String
        [@attributes[name].strip]
      when NilClass
        STDERR.puts "No values for paragraphs #{name.inspect}".yellow
        ''
      else
        STDERR.puts "Wrong type #{@attributes[name].class} for paragraphs #{name.inspect} (expected Array or nil)".yellow
        ''
      end
    end

    def property_value(name, default = '')
      case @attributes[name]
      when String
        @attributes[name].strip
      when NilClass
        if default
          default
        else
          STDERR.puts "No value for property #{name.inspect}".yellow
        end
      else
        STDERR.puts "Wrong type #{@attributes[name].class} for property #{name.inspect} (expected String or nil)".yellow
        []
      end
    end

    def property_values(name)
      case @attributes[name]
      when Array
        @attributes[name].map(&:strip)
      when String
        [@attributes[name].strip]
      when NilClass
        STDERR.puts "No values for property #{name.inspect}".yellow
        []
      else
        STDERR.puts "Wrong type #{@attributes[name].class} for property #{name.inspect} (expected Array or nil)".yellow
        []
      end
    end

    def eval(attributes)
      @attributes = attributes
      @template.result(binding)
    ensure
      @attributes = nil
    end

    private

    def format_paragraphs(paragraphs, width = 80)
      [*paragraphs].compact.map(&:strip).map do |p|
        # Peek at the text to see if it looks like something whose formatting
        # should be preserved. Otherwise, adjust it to width characters.
        if p[/&/]
          p
        else
          p.length > width ? p.gsub(/(.{1,#{width}})(\s+|$)/, "\\1\n").strip : p
        end
      end * "\n\n"
    end
  end

  class LaTeXDocument
    def initialize
      @attributes = {}
    end

    def add!(name, text)
      case @attributes[name]
      when NilClass
        @attributes[name] = text
      when Array
        @attributes[name] << text
      else
        @attributes[name] = [@attributes[name], text]
      end
    end

    def wrap_text_run(name, text)
      if name.nil? or name == ''
        text
      elsif name[0] == '\\'
        # Try to eliminate empty runs, which often litter Word documents that have been edited a bit
        if text.gsub(/\s+/, ' ') == ' '
          ' '
        elsif text.strip != ''
          s = ''
          s += ' ' if text[/^\s/]
          s += "#{name}{#{text.strip}}"
          s += ' ' if text[/\s$/]
          s
        else
          ''
        end
      elsif name[/^(.*)!(.+)$/]
        environment, command = $1, $2

        if environment.nil? or environment.empty?
          "\\#{command} #{text.strip}\n"
        else
          "\\begin{#{environment}}\n\n\\#{command} #{text.strip}\n\n\\end{#{environment}}\n"
        end
      else
        "\\begin{#{name}}\n#{text.strip}\n\\end{#{name}}"
      end
    end

    def wrap_footnote(paragraphs)
      footnote_text = paragraphs * "\n\n"
      "\\footnote{#{footnote_text}}"
    end

    def save!(template_filename, latex_filename)
      template = LaTeXTemplate.new(template_filename)

      File.open(latex_filename, 'w') do |f|
        latex = template.eval(@attributes)
        f.write(latex)
      end
    end
  end
end
