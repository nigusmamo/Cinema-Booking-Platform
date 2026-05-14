// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-05-14',

  future: {
    compatibilityVersion: 4, 
  },

  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/apollo'
  ],

  apollo: {
    clients: {
      default: {
        httpEndpoint: 'http://localhost:8080/v1/graphql',
      }
    }
  },

  css: ['~/assets/css/main.css'],
  devtools: { enabled: true }
})