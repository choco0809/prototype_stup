module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/javascript/**/*.vue'
  ],
  theme: {
    extend: {
      spacing: {
        '50': '12.5rem',
        '150': '37.5rem',
        '225': '56.25rem',
        '250' : '62.5rem',
        '300': '75rem',
      }
    }
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: [{
      color: {
        'base': '#FFF',
      }
    }, "cupcake"]
  }
}
