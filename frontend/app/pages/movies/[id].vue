<template>
  <div class="bg-[#0D0D0D] min-h-screen text-white font-sans pb-20">
    <div v-if="pending" class="h-screen flex items-center justify-center">
      <p class="text-[#EAB308] animate-pulse font-bold tracking-widest text-sm uppercase">LOADING MOVIE DETAILS...</p>
    </div>

    <div v-else-if="movie">
      <div class="relative h-[50vh] w-full overflow-hidden -mt-20 pt-20">
        <img :src="movie.main_image" class="w-full h-full object-cover opacity-40 blur-sm scale-110" referrerpolicy="no-referrer" />
        <div class="absolute inset-0 bg-gradient-to-t from-[#0D0D0D] via-[#0D0D0D]/60 to-transparent"></div>
        
        <div class="absolute inset-0 flex items-end px-6 md:px-20 pb-10">
          <div class="flex flex-col md:flex-row gap-10 items-end w-full">
            <img :src="movie.main_image" class="w-48 md:w-64 aspect-[4/5] rounded-[32px] shadow-2xl border-4 border-white/5 object-cover bg-gray-900" referrerpolicy="no-referrer" />
            <div class="flex-1 text-left">
              <h1 class="text-4xl md:text-7xl font-black uppercase mb-4 tracking-tighter leading-none">{{ movie.title }}</h1>
              <div class="flex flex-wrap items-center gap-6 text-gray-400 text-sm font-medium">
                <span class="text-[#EAB308] flex items-center gap-1 font-bold">★ {{ movie.rating_avg }}</span>
                <span>🕒 {{ movie.duration_minutes }} min</span>
                <span>📅 {{ new Date(movie.release_date).getFullYear() }}</span>
                <div class="flex gap-2">
                  <span v-for="g in movie.movie_genres" :key="g.genre.name" class="bg-white/5 px-3 py-1 rounded-full text-[11px] text-gray-300 border border-white/5 uppercase">
                    {{ g.genre.name }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-6 md:px-20 mt-12 grid grid-cols-1 lg:grid-cols-3 gap-20">
        <div class="lg:col-span-2 space-y-12 text-left">
          <p class="text-gray-400 leading-relaxed text-xl font-medium italic">{{ movie.description }}</p>
          
          <div class="grid grid-cols-2 gap-10">
            <div>
              <h3 class="text-gray-500 text-[11px] font-black uppercase tracking-[0.2em] mb-4">Director</h3>
              <p v-for="d in movie.movie_directors" :key="d.director.name" class="text-white font-black text-2xl italic tracking-tighter">
                {{ d.director.name }}
              </p>
            </div>
            <div>
              <h3 class="text-gray-500 text-[11px] font-black uppercase tracking-[0.2em] mb-4">Stars</h3>
              <p class="text-white font-bold text-base">
                <span v-for="(s, index) in movie.movie_stars" :key="index">
                  {{ s.star.name }}{{ Number(index) < movie.movie_stars.length - 1 ? ', ' : '' }}
                </span>
              </p>
            </div>
          </div>

          <div v-if="movie.movie_images && movie.movie_images.length > 0">
            <h3 class="text-gray-500 text-[11px] font-black uppercase tracking-[0.2em] mb-6">Gallery</h3>
            <div class="grid grid-cols-3 gap-6">
              <div v-for="img in movie.movie_images.slice(0,3)" :key="img.id" class="aspect-video rounded-[24px] overflow-hidden border border-white/5 shadow-xl bg-gray-900">
                <img :src="img.image_url" referrerpolicy="no-referrer" class="w-full h-full object-cover hover:scale-110 transition duration-700" />
              </div>
            </div>
          </div>
        </div>

        <div class="relative">
          <div class="bg-[#121212] border border-white/5 p-8 rounded-[40px] shadow-2xl sticky top-28">
             <h3 class="text-white font-black uppercase mb-8 tracking-tighter text-xl text-center">AVAILABLE <span class="text-[#EAB308]">SHOWS</span></h3>
             <div class="flex gap-3 overflow-x-auto no-scrollbar py-4 px-2 -mx-2">
                <div v-for="day in availableDates" :key="day.fullDate" 
                    @click="selectedDate = day.fullDate"
                    class="flex-shrink-0 w-20 py-4 rounded-[22px] border border-white/5 text-center cursor-pointer transition-all duration-500"
                    :class="selectedDate === day.fullDate ? 'bg-[#EAB308] text-black font-black shadow-[0_10px_30px_rgba(234,179,8,0.3)] scale-110' : 'bg-white/5 text-gray-500 hover:bg-white/10'">
                    <span class="block text-[10px] uppercase font-bold mb-1 opacity-70">{{ day.dayLabel }}</span>
                    <span class="text-xl font-black">{{ day.dateNumber }}</span>
               </div>
             </div>

             <div class="grid grid-cols-2 gap-4 mb-10">
                <button v-for="sched in availableTimes" :key="sched.id"
                  @click="selectedScheduleId = sched.id"
                  class="py-4 rounded-2xl border font-black text-xs transition-all duration-300 uppercase tracking-widest"
                  :class="selectedScheduleId === sched.id ? 'border-[#EAB308] text-[#EAB308] bg-[#EAB308]/10 shadow-[0_0_15px_rgba(234,179,8,0.1)]' : 'border-white/10 text-gray-400 hover:border-gray-600'">
                  {{ formatTime(sched.start_time) }}
                </button>
             </div>

             <button @click="goToSeats" 
               :disabled="!selectedScheduleId"
               class="w-full bg-[#EAB308] text-black py-5 rounded-[22px] font-black text-sm shadow-xl shadow-[#EAB308]/20 hover:scale-[1.02] active:scale-95 transition-all disabled:opacity-20 disabled:cursor-not-allowed uppercase tracking-widest">
               Select Seats
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

const selectedDate = ref('')
const selectedScheduleId = ref('')

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_DETAILS, {
  id: movieId
})

const movie = computed(() => data.value?.movies_by_pk)

const availableDates = computed(() => {
  if (!movie.value?.schedules) return []
  
  const daysMap = new Map()
  const dateNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

  movie.value.schedules.forEach((s: any) => {
    const d = new Date(s.start_time)
    const fullDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    
    if (!daysMap.has(fullDate)) {
      daysMap.set(fullDate, {
        dayLabel: dateNames[d.getDay()],
        dateNumber: d.getDate(),
        fullDate: fullDate
      })
    }
  })
  
  return Array.from(daysMap.values()).sort((a, b) => a.fullDate.localeCompare(b.fullDate))
})

const availableTimes = computed(() => {
  if (!selectedDate.value || !movie.value?.schedules) return []
  return movie.value.schedules.filter((s: any) => {
  const d = new Date(s.start_time)
  const sDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
  return sDate === selectedDate.value
})
})

watch(availableDates, (newDates) => {
  if (newDates.length > 0 && !selectedDate.value) {
    const today = new Date().toISOString().split('T')[0]
    const hasToday = newDates.find(d => d.fullDate === today)
    selectedDate.value = hasToday ? hasToday.fullDate : newDates[0].fullDate
  }
}, { immediate: true })

const formatTime = (timeStr: string) => {
  const d = new Date(timeStr)
  return d.toLocaleTimeString('en-GB', { 
    hour: '2-digit', 
    minute: '2-digit', 
    hour12: true,
    timeZone: 'Africa/Addis_Ababa' 
  })
}

const goToSeats = () => {
  if (selectedScheduleId.value) {
    navigateTo(`/booking/seats?schedule_id=${selectedScheduleId.value}`)
  }
}

useHead({
  title: movie.value ? `${movie.value.title} | Ethiopian Cinema House` : 'Loading Details...'
})
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
</style>