module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  themes: [{
    color: {
      'base': '#FFF'
    }
  }],
  plugins: [require('daisyui')],
  daisyui: {
    themes: [{
      stup: {
        'base': '#FFF',
      }
    }, "cupcake"]
  }
}
