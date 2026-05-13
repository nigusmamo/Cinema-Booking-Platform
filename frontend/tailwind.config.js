/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
  ],
  theme: {
    extend: {
      colors: {
        'primary': '#EAB308',     
        'bg-main': '#0D0D0D',    
        'bg-card': '#1A1A1A',    
        'text-soft': '#A3A3A3',   
      },
    },
  },
  plugins: [],
}