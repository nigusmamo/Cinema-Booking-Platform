<template>
  <div class="min-h-screen bg-[#090909] text-white py-10 px-4 font-sans">
    <div class="max-w-6xl mx-auto">
      
      <div class="text-center mb-12">
        <h1 class="text-3xl font-black uppercase tracking-tight italic">Movie Schedule</h1>
      </div>

      <div v-if="pending" class="space-y-8">
        <div v-for="i in 3" :key="i" class="h-64 bg-white/5 animate-pulse rounded-[40px]"></div>
      </div>

      <div v-else-if="movies.length > 0" class="space-y-8">
        <div v-for="movie in movies" :key="movie.id" 
          class="bg-[#121212] border border-white/5 rounded-[40px] flex flex-col md:flex-row gap-8 p-2 pr-8 hover:border-[#EAB308]/20 transition-all duration-700 group overflow-hidden">
          
          <div class="w-full md:w-56 aspect-[3/4] md:aspect-auto md:h-72 rounded-[32px] overflow-hidden shadow-2xl flex-shrink-0 relative">
            <img :src="movie.main_image" class="w-full h-full object-cover group-hover:scale-110 transition duration-700" />
          </div>

          <div class="flex-1 flex flex-col justify-center py-6">
            <div class="flex items-center gap-3 mb-3">
               <span class="text-[10px] font-black text-gray-500 uppercase tracking-widest">
                  <span v-for="g in movie.movie_genres" :key="g.genre.name">{{ g.genre.name }} • </span>
               </span>
               <span class="text-[#EAB308] text-xs font-bold">★ {{ movie.rating_avg }}</span>
            </div>
            <h2 class="text-3xl font-black uppercase tracking-tighter mb-4">{{ movie.title }}</h2>
            <p class="text-gray-500 text-sm leading-relaxed max-w-xl mb-8 line-clamp-2 italic font-medium">
              {{ movie.description }}
            </p>
          </div>

          <div class="flex flex-col justify-center py-10 items-end">
            <button 
              @click="navigateTo(`/movies/${movie.id}`)"
              class="group/btn flex items-center gap-3 bg-[#EAB308] text-black pl-8 pr-4 py-4 rounded-2xl font-black text-xs hover:scale-105 transition-all shadow-xl shadow-[#EAB308]/10"
            >
              BOOK <span class="bg-black/10 p-1 rounded-lg group-hover/btn:translate-x-1 transition-transform">→</span>
            </button>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-32 opacity-30">
        <div class="text-6xl mb-6">📅</div>
        <p class="text-xl font-black uppercase italic tracking-widest">No Movies Scheduled for this date</p>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MOVIE_SCHEDULES } from '~/graphql/movies'

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_SCHEDULES)
const movies = computed(() => data.value?.movies ?? [])

const movieSelections = ref<Record<string, string>>({})

const getLeftSeats = (movieId: string) => {
  const totalSeats = 160;
  const hash = movieId.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
  const bookedSeats = hash % totalSeats;
  return totalSeats - bookedSeats;
}
</script>

<style>
.no-scrollbar::-webkit-scrollbar { display: none; }
</style>