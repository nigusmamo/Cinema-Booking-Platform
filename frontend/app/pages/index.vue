<template>
  <div class="bg-[#0D0D0D] min-h-screen font-sans text-white">
    <section class="relative h-[85vh] flex items-center px-6 md:px-20 overflow-hidden">
      
      <img 
        v-if="allMovies && allMovies.length > 0" 
        :src="allMovies[0]?.main_image" 
        referrerpolicy="no-referrer"
        class="absolute inset-0 w-full h-full object-cover opacity-20 blur-[1px]" 
      />
      
      <div class="absolute inset-0 bg-gradient-to-r from-black via-black/60 to-transparent"></div>
      <div class="absolute inset-0 bg-gradient-to-t from-[#0D0D0D] via-transparent to-transparent"></div>
      
      <div class="relative z-10 max-w-2xl">
        <h1 class="text-7xl md:text-8xl font-black mb-6 leading-[0.85] tracking-tighter text-white uppercase">
          Experience <br/> 
          <span class="text-gray-500 whitespace-nowrap">Cinema Beyond</span> <br/>
          <span class="text-[#EAB308]">Reality</span>
        </h1>
        <p class="text-gray-400 text-lg mb-10 max-w-md font-medium">
          Discover new worlds on the big screen. Feel it in premium quality at Ethiopian Cinema House.
        </p>

        <button 
          v-if="allMovies.length > 0"
          @click="navigateTo(`/schedules`)" 
          class="bg-[#EAB308] text-black px-12 py-4 rounded-xl font-black hover:scale-105 transition-all shadow-[0_0_30px_rgba(234,179,8,0.3)]">
          BOOK TICKETS
        </button>
      </div>
      
      <div class="hidden lg:flex absolute right-[-5%] top-1/2 -translate-y-1/2 gap-0 items-center scale-90">
        <div v-for="(m, index) in allMovies.slice(0, 3)" :key="m.id" 
          class="w-72 h-[480px] rounded-[35px] overflow-hidden border-[6px] border-white/5 shadow-2xl transition-all duration-700"
          :class="[
            index === 0 ? 'rotate-[-12deg] z-10 translate-x-24' : '',
            index === 1 ? 'rotate-0 z-30 scale-110 -translate-y-5 shadow-[0_0_60px_rgba(0,0,0,0.8)]' : '',
            index === 2 ? 'rotate-[12deg] z-20 -translate-x-24 translate-y-5' : ''
          ]">
          <img :src="m.main_image" referrerpolicy="no-referrer" class="w-full h-full object-cover" />
        </div>
      </div>
    </section>

    <div class="max-w-7xl mx-auto px-4 -mt-20 relative z-20">
      <div class="bg-[#121212]/95 backdrop-blur-xl border border-white/5 p-8 rounded-[40px] shadow-2xl">
        
        <div class="flex gap-4 overflow-x-auto py-8 px-6 no-scrollbar">
          <div v-for="day in dynamicDays" :key="day.fullDate"
            @click="selectedDate = day.fullDate" 
            class="flex-shrink-0 w-20 py-4 rounded-[22px] border border-white/5 flex flex-col items-center cursor-pointer transition-all duration-500"
            :class="selectedDate === day.fullDate ? 'bg-gradient-to-b from-[#EAB308] to-[#B48906] text-black font-bold shadow-[0_10px_25px_rgba(234,179,8,0.4)] scale-110' : 'bg-white/5 text-gray-500 hover:bg-white/10'">
            <span class="text-[9px] uppercase tracking-widest mb-1 opacity-70">{{ day.label }}</span>
            <span class="text-lg font-black">{{ day.dateNumber }}</span>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mt-2">
          <div class="relative">
            <select v-model="selectedGenre" class="appearance-none w-full bg-white/5 border border-white/10 text-sm px-6 py-4 rounded-[20px] focus:outline-none focus:border-[#EAB308] text-white cursor-pointer transition">
              <option value="" class="bg-[#121212]">All Genres</option>
              <option v-for="g in genres" :key="g.id" :value="g.name" class="bg-[#121212]">{{ g.name }}</option>
            </select>
            <span class="absolute right-5 top-1/2 -translate-y-1/2 text-[10px] text-[#EAB308] pointer-events-none">▼</span>
          </div>

          <div class="relative">
            <select v-model="selectedDirector" class="appearance-none w-full bg-white/5 border border-white/10 text-sm px-6 py-4 rounded-[20px] focus:outline-none focus:border-[#EAB308] text-white cursor-pointer transition">
              <option value="" class="bg-[#121212]">All Directors</option>
              <option v-for="d in directors" :key="d.id" :value="d.name" class="bg-[#121212]">{{ d.name }}</option>
            </select>
            <span class="absolute right-5 top-1/2 -translate-y-1/2 text-[10px] text-[#EAB308] pointer-events-none">▼</span>
          </div>

          <div class="md:col-span-2 relative">
            <input v-model="searchQuery" type="text" placeholder="Search by title or director..." 
              class="w-full bg-white/5 border border-white/10 pl-14 pr-6 py-4 rounded-[20px] focus:outline-none focus:border-[#EAB308] text-white transition placeholder:text-gray-600" />
            <span class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-500 text-xl">🔍</span>
          </div>
        </div>
      </div>
    </div>

    <div class="max-w-7xl mx-auto px-6 py-24">
      <h2 class="text-3xl font-black uppercase italic mb-16 tracking-tighter">NOW SHOWING <span class="text-[#EAB308]">.</span></h2>
      
      <div v-if="pending" class="grid grid-cols-2 md:grid-cols-4 gap-12">
        <div v-for="i in 4" :key="i" class="aspect-[4/5] bg-white/5 animate-pulse rounded-[32px]"></div>
      </div>

      <div v-else class="grid grid-cols-2 md:grid-cols-4 gap-12 md:gap-16">
        <MovieCard 
            v-for="movie in filteredMovies" 
            :key="movie.id"
            :title="movie.title"
            :image="movie.main_image"
            :duration="movie.duration_minutes"
            :rating="movie.rating_avg"
            @click="navigateTo(`/movies/${movie.id}`)" 
        />
      </div>

      <div v-if="!pending && filteredMovies.length === 0" class="text-center py-20 text-gray-500 italic font-medium">
        No movies found matching your filters for this date.
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_HOME_PAGE_DATA } from '~/graphql/movies'

const { data, pending } = await useAsyncQuery<any>(GET_HOME_PAGE_DATA)

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

const selectedGenre = ref('')
const selectedDirector = ref('')
const selectedTech = ref('2D')
const searchQuery = ref('')

const allMovies = computed(() => data.value?.movies ?? [])
const genres = computed(() => data.value?.genres ?? [])
const directors = computed(() => data.value?.directors ?? [])

const filteredMovies = computed(() => {
  if (!allMovies.value) return []

  return allMovies.value.filter((movie: any) => {
    const s = searchQuery.value.toLowerCase()
    
    const matchesSearch = movie.title.toLowerCase().includes(s) || 
      movie.movie_directors?.some((d: any) => d.director.name.toLowerCase().includes(s))
    
    const matchesGenre = selectedGenre.value === '' || 
      movie.movie_genres?.some((g: any) => g.genre.name === selectedGenre.value)
    
    const matchesDirector = selectedDirector.value === '' || 
      movie.movie_directors?.some((d: any) => d.director.name === selectedDirector.value)

    const matchesDate = movie.schedules && movie.schedules.some((sch: any) => {
      return sch.start_time.split('T')[0] === selectedDate.value
    })

    return matchesSearch && matchesGenre && matchesDirector && matchesDate
  })
})
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

select option {
  background: #121212;
  color: white;
  padding: 10px;
}
</style>