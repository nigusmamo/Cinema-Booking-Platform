<template>
  <div class="bg-[#0D0D0D] min-h-screen text-white font-sans pb-20">
    <div v-if="pending" class="h-screen flex items-center justify-center">
      <p class="text-[#EAB308] animate-pulse font-bold tracking-widest text-sm">LOADING MOVIE DETAILS...</p>
    </div>

    <div v-else-if="movie">
      <div class="relative h-[65vh] w-full overflow-hidden">
        <img :src="movie.main_image" class="w-full h-full object-cover opacity-40 blur-sm scale-110" />
        <div class="absolute inset-0 bg-gradient-to-t from-[#0D0D0D] via-[#0D0D0D]/60 to-transparent"></div>
        
        <div class="absolute inset-0 flex items-end px-6 md:px-20 pb-10">
          <div class="flex flex-col md:flex-row gap-10 items-end w-full">
            <img :src="movie.main_image" class="w-48 md:w-64 aspect-[4/5] rounded-[32px] shadow-2xl border-4 border-white/5 object-cover" />
            <div class="flex-1">
              <h1 class="text-4xl md:text-7xl font-black uppercase mb-4 tracking-tighter leading-none">{{ movie.title }}</h1>
              <div class="flex flex-wrap items-center gap-6 text-gray-400 text-sm font-medium">
                <span class="text-[#EAB308] flex items-center gap-1 font-bold">
                  ★ {{ movie.rating_avg }} 
                  <span class="text-gray-500 text-[10px] font-medium ml-1">(12.5K reviews)</span>
                </span>
                <span class="flex items-center gap-2">🕒 {{ movie.duration_minutes }} min</span>
                <span class="border border-gray-700 px-2 py-0.5 rounded text-[10px] tracking-widest font-black text-gray-300">PG-13</span>
                <span class="flex items-center gap-2">📅 {{ new Date(movie.release_date).getFullYear() }}</span>
                <div class="flex gap-2">
                  <span v-for="g in movie.movie_genres" :key="g.genre.name" class="bg-white/5 px-3 py-1 rounded-full text-[11px] text-gray-300 border border-white/5">
                    {{ g.genre.name }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-6 md:px-20 mt-12 grid grid-cols-1 lg:grid-cols-3 gap-16">
        <div class="lg:col-span-2 space-y-12">
          <p class="text-gray-400 leading-relaxed text-xl font-medium">{{ movie.description }}</p>
          
          <div class="grid grid-cols-2 gap-10">
            <div>
              <h3 class="text-gray-500 text-[11px] font-black uppercase tracking-[0.2em] mb-4">Director</h3>
              <p v-for="d in movie.movie_directors" :key="d.director.name" class="text-white font-black text-2xl italic tracking-tighter">
                {{ d.director.name }}
              </p>
            </div>
            <div>
              <h3 class="text-gray-500 text-[11px] font-black uppercase tracking-[0.2em] mb-4">Stars</h3>
              <p class="text-white font-bold text-base leading-relaxed">
                <span v-for="(s, index) in movie.movie_stars" :key="index">
                  {{ s.star.name }}{{ Number(index) < movie.movie_stars.length - 1 ? ', ' : '' }}
                </span>
              </p>
            </div>
          </div>

          <div v-if="movie.movie_images && movie.movie_images.length > 0">
            <h3 class="text-gray-500 text-[11px] font-black uppercase tracking-[0.2em] mb-6">Gallery</h3>
            <div class="grid grid-cols-3 gap-6">
              <div v-for="img in movie.movie_images.slice(0,3)" :key="img.id" class="aspect-video rounded-[24px] overflow-hidden border border-white/10 shadow-2xl">
                <img :src="img.image_url" class="w-full h-full object-cover hover:scale-110 transition duration-700" />
              </div>
            </div>
          </div>
        </div>

        <div class="relative">
          <div class="bg-[#121212] border border-white/5 p-8 rounded-[40px] shadow-2xl sticky top-28">
             <h3 class="text-white font-black uppercase italic mb-8 tracking-tighter text-xl">AVAILABLE SHOWS</h3>
             
             <div class="flex gap-3 overflow-x-auto no-scrollbar py-4 px-2 -mx-2">
                <div v-for="day in ['Mon 11', 'Tue 12', 'Wed 13']" :key="day" 
                    @click="selectedDate = day"
                    class="flex-shrink-0 w-20 py-4 rounded-[22px] border border-white/5 text-center cursor-pointer transition-all duration-500"
                    :class="selectedDate === day ? 'bg-[#EAB308] text-black font-black shadow-[0_10px_20px_rgba(234,179,8,0.3)] scale-110' : 'bg-white/5 text-gray-500 hover:bg-white/10'">
                    <span class="block text-[10px] uppercase font-bold mb-1 opacity-70">{{ day.split(' ')[0] }}</span>
                    <span class="text-xl font-black">{{ day.split(' ')[1] }}</span>
               </div>
             </div>
             <div class="grid grid-cols-2 gap-4 mb-10">
                <button v-for="time in ['10:00 AM', '01:30 PM', '04:45 PM', '08:15 PM']" :key="time"
                  @click="selectedTime = time"
                  class="py-4 rounded-2xl border font-black text-xs transition-all duration-300"
                  :class="selectedTime === time ? 'border-[#EAB308] text-[#EAB308] bg-[#EAB308]/10 shadow-[0_0_15px_rgba(234,179,8,0.1)]' : 'border-white/10 text-gray-400 hover:border-gray-600'">
                  {{ time }}
                </button>
             </div>

             <button @click="navigateTo(`/booking/seats?id=${movie.id}`)" 
               class="w-full bg-[#EAB308] text-black py-5 rounded-[22px] font-black text-sm shadow-xl shadow-[#EAB308]/20 hover:scale-[1.02] active:scale-95 transition-all">
               SELECT SEATS
             </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MOVIE_DETAILS } from '~/graphql/movies'

const route = useRoute()
const movieId = route.params.id

const selectedDate = ref('Wed 13')
const selectedTime = ref('04:45 PM')

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_DETAILS, {
  id: movieId
})

const movie = computed(() => data.value?.movies_by_pk)

useHead({
  title: movie.value ? `${movie.value.title} | Ethiopian Cinema House` : 'Movie Details'
})
</script>

<style>
.no-scrollbar::-webkit-scrollbar { display: none; }
</style>