# oslatex

_oslatex_ is a specialised Word-to-LaTeX converter. Instead of trying to
translate a Word document into a faithful LaTeX representation, _oslatex_
preserves the text, maps Word styles to customisable LaTeX commands and
environments, and intentionally ignores most other formatting. If the Word
document uses styles consistently and sensibly, this process produces a
relatively clean LaTeX document.

_oslatex_ was originally developed as an _ad hoc_ converter for the [Oslo
Studies in Language](https://www.journals.uio.no/index.php/osla) (OSLa), which
uses LaTeX for most typesetting but also accepts Word submissions. If your use
case is similar you may find _oslatex_ useful, but you will have to adapt the
configuration to your needs as the default configuration included with
_oslatex_ was made to fit the OSLa journal's LaTeX classes and Word templates.

## Usage

_oslatex_ can only read `.docx` files. It does not support the older, binary
Word format.

## Configuration

All configuration is currently found in `lib/oslatex/oslatex.json`.

Text is always transferred verbatim (except for abbreviations, which receive
special handling --- see below). Word styles apply either to paragraphs or to
running text. Their mapping to LaTeX is configured in two separate sections of
the configuration file (`paragraph_styles` and `run_styles`).

A small set of formatting instructions that make sense in running text (e.g.
italics, bold face, underlining, overstrike, superscripts and subscripts) can
optionally be mapped to LaTeX in the same way.

To map a paragraph style called `Heading1` to the LaTeX command `\section`, add
the following to `paragraph_styles`:

```json
"paragraph_styles": {
  "Heading1": [null, "\\section"]
}
```

Note that style names in Word are case sensitive.

You can also map certain font features such as `italics`, `bold`, `underline`,
`strikethrough`, `smallcaps`, `superscipt` and `subscript`:

```json
"paragraph_styles": {
  "italics": [null, "\\emph"]
}
```

Colours and highlighting includes the colour value after a hyphen, e.g.
`color-00000`, `highlight-red`.

To map to an environment instead, use the following:

```json
"paragraph_styles": {
  "Quote": [null, "blockquote"]
}
```

Sometimes it is necessary to map a style to a LaTeX command without arguments. To do so, use

```json
"paragraph_styles": {
  "Example": [null, "!ex."]
}
```

To do the same but enclose the LaTeX command and the text inside an environment, use

```json
"paragraph_styles": {
  "ListParagraph": [null, "enumerate!item"]
}
```


The final LaTeX file is generated on the basis of a template
(`lib/oslatex/oslatex.tex.erb`). It is possible to map paragraph styles to
variables, which can then be expanded in the template. The default
configuration and template show several examples of this, e.g. `Title`:

```json
"paragraph_styles": {
  "Title": ["title", ""]
}
```

To ignore a style, map it to `[null, ""]`:

```json
"paragraph_styles": {
  "FootnoteText": [null, ""]
}
```

Mappings for run styles use a simpler syntax:

```json
"run_styles": {
  "italics": "\\emph",
  "FootnoteReference": "",
  "FootnoteNumbering": null
}
```

Mapping to `""` here ignores the styles. Mapping to `null` ignores style and
text contents.

## Bugs

* Multiple embedded levels of font adjustments like italics or bold face
  sometimes confuses the parser. You will see this easily in the LaTeX code as,
  for example, a whole paragraph will be italicised with a single
  non-italicised word when the opposite is the correct.

* _oslatex_ will try to merge adjacent elements with identical styles to create
  a less noisy LaTeX output. This strategy does not always succeed leaving
  multiple identical LaTeX commands adjacent to each other.

* Some abbreviations that are common in English academic writing such as _e.g._
  are automatically converted to `e.g.\@` to get the right spacing in LaTeX.
  This ought to be configurable but for now you will have to change the source
  code if you dislike this or need support for other abbreviations.
