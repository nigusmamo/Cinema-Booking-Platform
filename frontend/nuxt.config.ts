export default defineNuxtConfig({
  compatibilityDate: '2024-05-14',
  srcDir: 'app/',
  future: { compatibilityVersion: 4 },

  ssr: false,

  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/apollo'
  ],

  apollo: {
    clients: {
      default: {
        httpEndpoint: 'http://localhost:8080/v1/graphql',
        tokenName: 'auth_token'
      }
    }
  },

  css: ['~/assets/css/main.css'],
})