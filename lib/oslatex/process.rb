#!/usr/bin/env ruby

module OSLaTeX
  def self.local_pathname(filename)
    File.join(File.dirname(__FILE__), filename)
  end

  def self.convert_docx(docx_filename, latex_filename, template_filename = nil)
    STDOUT.puts "Converting #{docx_filename} to #{latex_filename}".green

    style_mapping = StyleMapping.new
    style_mapping.load_json!(OSLaTeX::local_pathname('oslatex.json'))
    latex_document = LaTeXDocument.new

    template_filename ||= OSLaTeX::local_pathname('oslatex.tex.erb')

    reader = DocXReader.open(docx_filename)
    document_xml = reader.document_xml
    footnotes_xml = reader.footnotes_xml

    transformer = DocXTransformer.new

    if document_xml
      transformer.document_xml = document_xml
    else
      STDERR.puts "Error reading document.xml from #{docx_filename}".yellow
    end

    if footnotes_xml
      transformer.footnotes_xml = footnotes_xml
    else
      STDERR.puts "Error reading footnotes.xml from #{docx_filename}".yellow
    end

    walker = DocXWalker.new(style_mapping, transformer, STDERR, latex_document)
    walker.walk(STDERR, latex_document)
    latex_document.save!(template_filename, latex_filename)
  end
end
