'use strict';

// See: https://prettier.io/docs/en/options.html
// See: https://prettier.io/docs/en/configuration.html

module.exports = {
  printWidth: 80,
  tabWidth: 2,
  semi: true,
  singleQuote: true,
  jsxSingleQuote: true,
  bracketSpacing: true,
  jsxBracketSameLine: true,
  arrowParens: 'always',
  overrides: [
    {
      files: ['*.yml', '.*.yml'],
      options: {
        tabWidth: 4,
        singleQuote: false
      }
    }
  ]
};
