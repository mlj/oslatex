module OSLaTeX
  class DocXWalker
    def initialize(style_mapping, transformer, log_io, latex_document)
      @style_mapping = style_mapping
      @transformer = transformer
      @log_io = log_io
      @latex_document = latex_document
    end

    def walk(log_io, latex_document)
      body =
        @transformer.document.children.map do |n|
          case n.name
          when 'p'
            walk_paragraph_at_base(n)
          when 'table'
            walk_table(log_io, n, latex_document)
          else
            log_io.puts "Unexpected document element name #{n.name.inspect}".yellow
          end
        end
      latex_document.add!(:body, body)
    end

    private

    def get_styles(xml)
      (xml['style'] || '').split(/\s+/)
    end

    def get_mapped_styles(xml)
      get_styles(xml).map do |style|
        if @style_mapping.run_style?(style)
          name = @style_mapping.run_style(style)

          case name
          when '' # ignore, no mapping needed
            nil
          when NilClass # content should be ignored
            return nil
          else
            name
          end
        else
          STDERR.puts "No mapping for run style #{style.inspect}".yellow
        end
      end.compact
    end

    def wrap_styles(xml, text)
      styles = get_mapped_styles(xml)

      if styles
        styles.inject(text) do |t, s|
          @latex_document.wrap_text_run(s, t)
        end
      else
        ''
      end
    end

    # Escape symbols that LaTeX (by default) treats as special symbols
    def escape_text(text)
      text.gsub(/([%\#$_&{}])/, '\\\\\1').gsub('^', '\^{}')
    end

    # Pads common abbreviations
    def pad_abbrevs(text)
      text.gsub(/(etc|vs|cf|i\.e|e\.g)\.(?!,)/, '\1.\@')
    end

    def walk_run(xml)
      text =
        flatten_children(xml) do |n|
          case n.name
          when 'text'
            pad_abbrevs(escape_text(n.inner_text))
          when 'footnote'
            id = n.attributes['n'].value

            if @transformer.footnotes.key?(id)
              footnote_text = walk_footnote(@transformer.footnotes[id])
              @latex_document.wrap_footnote(footnote_text.map(&:strip))
            else
              STDERR.puts "  - undefined footnote #{id}".red
              ''
            end
          when 'drawing', 'picture'
            "\n% TODO: Insert drawing/picture/figure here\n"
          when 'symbol'
            "\n% TODO: Insert symbol here\n"
          end
        end

      wrap_styles(xml, text)
    end

    def map_children(xml, &block)
      xml.children.map do |n|
        s = block.call(n)

        if s
          s
        else
          @log_io.puts "Unexpected element \"#{xml.name}/#{n.name}\"".yellow
          ''
        end
      end
    end

    def flatten_children(xml, &block)
      m = map_children(xml, &block)
      m.join('')
    end

    def walk_tc(xml)
      paragraphs =
        map_children(xml) do |n|
          case n.name
          when 'p'
            walk_paragraph(n)
          end
        end

      paragraphs.map do |p|
        p.gsub(/\s+/, ' ')
      end.join("\n\n")
    end

    # Walk a table row. Returns the table string and a guess at the number of columns in the row.
    def walk_tr(xml)
      i = 0

      s =
        map_children(xml) do |n|
          case n.name
          when 'tc'
            i += 1
            walk_tc(n)
          end
        end.join(' & ')

      [s, i]
    end

    def walk_table(log_io, xml, latex_document)
      j = 0

      first_row, *rest =
        map_children(xml) do |n|
          case n.name
          when 'tr'
            s, i = walk_tr(n)
            j = i if i > j
            "  " + s.gsub(/\s+/, ' ').strip + "\\\\"
          end
        end

      rows = [first_row, rest.join("\n")].join("\n\\midrule\n")

      cols = "l" * j

      "\\begin{tabular}{#{cols}}\n\\toprule\n#{rows}\n\\bottomrule\n\\end{tabular}"
    end

    def walk_paragraph(xml)
      text =
        flatten_children(xml) do |n|
          case n.name
          when 'text'
            n.inner_text
          when 'r'
            walk_run(n)
          end
        end

      # TODO: styles
      text
    end

    def walk_paragraph_at_base(xml)
      text =
        flatten_children(xml) do |n|
          case n.name
          when 'text'
            n.inner_text
          when 'r'
            walk_run(n)
          end
        end

      styles = (xml['style'] || '').split(' ')

      # Some documents have the same style applied multiple times. Not sure if
      # this reverses the action or not; just eliminate duplicates here.
      styles.sort!
      styles.uniq!

      if styles.length > 1
        STDERR.puts "Unable to handle multiple paragraph styles (#{styles.inspect}: #{text.inspect}). Randomly picking one!".red
      end

      style = styles.first

      if @style_mapping.paragraph_style?(style)
        attribute, name = @style_mapping.paragraph_style(style)

        if name.nil?
          text = ''
        elsif name != ''
          text = @latex_document.wrap_text_run(name, text)
        end

        if attribute
          @latex_document.add!(attribute.to_sym, text)
          ''
        else
          text
        end
      else
        STDERR.puts "No mapping for paragraph style #{style.inspect}"
        text
      end
    end

    def walk_footnote(xml)
      xml.children.map do |n|
        case n.name
        when 'p'
          walk_paragraph(n)
        else
          STDERR.puts "Enexpected footnote element #{n.name.inspect}".yellow
          []
        end
      end
    end
  end
end
