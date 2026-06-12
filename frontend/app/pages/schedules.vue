<template>
  <div class="min-h-screen bg-[#090909] text-white py-10 px-4 font-sans">
    <div class="max-w-6xl mx-auto">
      
      <div class="text-center mb-16">
        <h1 class="text-4xl md:text-5xl font-luxury uppercase tracking-tighter italic mb-10 leading-none">
          Movie <span class="text-[#EAB308]">Schedule .</span>
        </h1>
        
        <!-- Calendar Filter -->
        <div class="bg-[#121212]/50 backdrop-blur-xl border border-white/5 p-6 rounded-[40px] shadow-2xl inline-block w-full max-w-4xl mx-auto">
          <div class="flex gap-4 overflow-x-auto py-4 px-2 no-scrollbar justify-start md:justify-center">
            <div v-for="day in dynamicDays" :key="day.fullDate"
              @click="selectedDate = day.fullDate" 
              class="flex-shrink-0 w-20 py-4 rounded-[22px] border border-white/5 flex flex-col items-center cursor-pointer transition-all duration-500"
              :class="selectedDate === day.fullDate ? 'bg-gradient-to-b from-[#EAB308] to-[#B48906] text-black font-bold shadow-[0_10px_25px_rgba(234,179,8,0.4)] scale-110' : 'bg-white/5 text-gray-500 hover:bg-white/10'">
              <span class="text-[9px] uppercase tracking-widest mb-1 opacity-70">{{ day.label }}</span>
              <span class="text-lg font-black">{{ day.dateNumber }}</span>
            </div>
          </div>
        </div>
      </div>

      <div v-if="pending" class="space-y-8">
        <div v-for="i in 3" :key="i" class="h-64 bg-white/5 animate-pulse rounded-[40px]"></div>
      </div>

      <div v-else-if="filteredMovies.length > 0" class="space-y-12 pb-20">
        <div v-for="movie in filteredMovies" :key="movie.id" 
          class="bg-[#121212] border border-white/5 rounded-[40px] flex flex-col md:flex-row gap-8 p-3 pr-10 hover:border-[#EAB308]/20 transition-all duration-700 group overflow-hidden shadow-2xl">
          
          <div class="w-full md:w-64 aspect-[3/4] md:aspect-auto md:h-80 rounded-[32px] overflow-hidden shadow-2xl flex-shrink-0 relative">
            <img :src="movie.main_image" class="w-full h-full object-cover group-hover:scale-110 transition duration-700" />
            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition duration-500 flex items-end p-6">
               <p class="text-[10px] font-black uppercase tracking-[0.2em] text-[#EAB308]">Viewing Details</p>
            </div>
          </div>

          <div class="flex-1 flex flex-col justify-center py-6">
            <div class="flex items-center gap-3 mb-4">
               <div class="flex gap-1">
                 <span v-for="g in movie.movie_genres" :key="g.genre.name" class="bg-white/5 border border-white/5 px-3 py-1 rounded-full text-[9px] font-black text-gray-400 uppercase tracking-widest">
                   {{ g.genre.name }}
                 </span>
               </div>
               <span class="text-[#EAB308] text-sm font-black flex items-center gap-1 ml-2">
                 <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                 {{ movie.rating_avg }}
               </span>
            </div>
            
            <h2 class="text-4xl font-black uppercase tracking-tighter mb-4 group-hover:text-[#EAB308] transition duration-500">{{ movie.title }}</h2>
            
            <p class="text-gray-500 text-sm leading-relaxed max-w-xl mb-10 line-clamp-2 italic font-medium opacity-80">
              {{ movie.description }}
            </p>
            
            <!-- Schedule Slots -->
            <div>
              <p class="text-[10px] text-gray-600 font-black uppercase tracking-widest mb-4">Available Showtimes</p>
              <div class="flex gap-3 flex-wrap">
                <div v-for="s in getSchedulesForDate(movie)" :key="s.id" 
                  class="bg-black border border-white/10 px-6 py-3 rounded-2xl text-xs font-black hover:border-[#EAB308] hover:text-[#EAB308] transition cursor-default">
                  {{ formatTime(s.start_time) }}
                </div>
              </div>
            </div>
          </div>

          <div class="flex flex-col justify-center py-10 items-end">
            <button 
              @click="navigateTo(`/movies/${movie.id}`)"
              class="group/btn flex items-center gap-4 bg-[#EAB308] text-black pl-10 pr-6 py-5 rounded-[24px] font-black text-xs hover:scale-105 transition-all shadow-xl shadow-[#EAB308]/10"
            >
              BOOK NOW <span class="bg-black/10 p-2 rounded-xl group-hover/btn:translate-x-1 transition-transform">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
              </span>
            </button>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-32">
        <div class="w-24 h-24 bg-white/5 rounded-full flex items-center justify-center mx-auto mb-8 opacity-20">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
        </div>
        <p class="text-xl font-black uppercase italic tracking-[0.2em] text-gray-700">No Movies Scheduled</p>
        <p class="text-xs font-bold text-gray-800 uppercase tracking-widest mt-2">Check another date for available showtimes</p>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MOVIE_SCHEDULES } from '~/graphql/movies'

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_SCHEDULES)
const movies = computed(() => data.value?.movies ?? [])

const dynamicDays = computed(() => {
  const daysArray = []
  const dateNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  const today = new Date()
  
  for (let i = 0; i < 7; i++) {
    const d = new Date()
    d.setDate(today.getDate() + i)
    daysArray.push({
      label: dateNames[d.getDay()],
      dateNumber: d.getDate(),
      fullDate: d.toISOString().split('T')[0]
    })
  }
  return daysArray
})

const selectedDate = ref(new Date().toISOString().split('T')[0])

const getSchedulesForDate = (movie: any) => {
  return movie.schedules.filter((s: any) => s.start_time.startsWith(selectedDate.value))
}

const filteredMovies = computed(() => {
  return movies.value.filter((m: any) => getSchedulesForDate(m).length > 0)
})

const formatTime = (isoString: string) => {
  return new Date(isoString).toLocaleTimeString('en-US', {
    hour: '2-digit', minute: '2-digit'
  })
}
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
</style>