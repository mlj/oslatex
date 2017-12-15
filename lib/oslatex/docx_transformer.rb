module OSLaTeX
  class DocXTransformerError < RuntimeError; end

  class DocXTransformer
    DOCUMENT_XSL = File.join(File.dirname(__FILE__), 'document.xsl')
    FOOTNOTES_XSL = File.join(File.dirname(__FILE__), 'footnotes.xsl')

    attr_reader :document
    attr_reader :footnotes

    def initialize
      @document = nil
      @footnotes = {}
    end

    def document_xml=(xml)
      @document = transform(xml, DOCUMENT_XSL, 'document')
    end

    def footnotes_xml=(xml)
      footnotes = transform(xml, FOOTNOTES_XSL, 'footnotes')

      footnotes.children.each do |node|
        case node.name
        when 'footnote'
          n = node.attributes['id'].value
          raise DocXTransformerError, "footnote #{n} already defined" if @footnotes.key?(n)
          @footnotes[n] = node
        else
          raise DocXTransformerError, "unexpected element #{node.name} in footnotes"
        end
      end
    end

    private

    def transform(xml, xsl_filename, root_element_name)
      xml = apply_stylesheet(xml, xsl_filename, root_element_name)
      raise 'invalid XML' if xml.nil?

      hoist_styles!(xml)
      merge_identical_runs!(xml)

      xml
    end

    # Merges adjacent runs with identical styles. Also merges runs with
    # identical styles that are separated by whitespace.
    def merge_identical_runs!(xml)
      i = 0

      while i < xml.children.length
        m = xml.children[i]
        n = i + 1 < xml.children.length ? xml.children[i + 1] : nil

        if n and m.name == 'r' and n.name == 'r' and m['style'] == n['style']
          m.children += n.children
          n.remove
        else
          merge_identical_runs!(m)
          i += 1
        end
      end
    end

    def hoist_styles!(xml)
      xml.children.each do |n|
        case n.name
        when 'r', 'p'
          styles = n.xpath('./style')

          if styles.length > 0
            n['style'] = styles.map { |s| s['value'] }.sort.join(' ')
            styles.each(&:remove)
          end
        end

        hoist_styles!(n)
      end
    end

    def apply_stylesheet(xml, xsl_filename, root_element_name)
      doc = Nokogiri::XML(xml)
      xslt = Nokogiri::XSLT(File.open(xsl_filename))
      xml = xslt.transform(doc)

      xml.root.name == root_element_name ? xml.root : nil
    end
  end
end
