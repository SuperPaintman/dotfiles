// See: https://tree-sitter.github.io/tree-sitter/creating-parsers

'use string';

module.exports = grammar({
  name: 'format_string',

  rules: {
    source_file: ($) =>
      choice(
        seq('"', repeat(choice($._content, $._escape, $.placeholder)), '"'),
        seq('`', repeat(choice($._content_raw, $.placeholder)), '`')
      ),

    placeholder: ($) =>
      token.immediate(
        // See: https://github.com/microsoft/vscode/blob/5150ef0ce77ef5516e55af4b8272f25907b55953/extensions/go/syntaxes/go.tmLanguage.json#L587
        /%(\[\d+\])?([\+#\-0\x20]{0,2}((\d+|\*)?(\.?(\d+|\*|(\[\d+\])\*?)?(\[\d+\])?)?))?[vT%tbcdoqxXUbeEfFgGspw]/
      ),

    _content: ($) => token.immediate(prec(1, /[^"\n\\%]+/)),
    _content_raw: ($) => token.immediate(prec(1, /[^`%]+/)),
    _escape: ($) => token.immediate(seq('\\', /./))
  }
});
