const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

// Use bootstrap (with jquery, popper.js)
const webpack = require('webpack')
environment.plugins.append(
    'Provide',
    new webpack.ProvidePlugin({
        jQuery: 'jquery/dist/jquery',
        Popper: 'popper.js/dist/popper'
    })
)
module.exports = environment
