<template>
  <div class="min-h-screen bg-[#090909] text-white py-10 px-4 font-sans overflow-x-hidden">
    
    <div v-if="movie" class="max-w-6xl mx-auto mb-12 flex justify-between items-center border-b border-white/5 pb-8">
      <div class="flex items-center gap-6">
        <img :src="movie.main_image" class="w-16 h-20 rounded-xl object-cover border border-white/10 shadow-2xl" />
        <div>
          <h1 class="text-2xl font-black uppercase tracking-tight italic">{{ movie.title }}</h1>
          <p class="text-gray-500 text-xs mt-1 font-bold tracking-widest uppercase">HALL 01 • PREMIUM EXPERIENCE • ETB</p>
        </div>
      </div>
      <div class="text-right hidden md:block">
        <p class="text-gray-600 text-[10px] font-black uppercase tracking-widest mb-1">Time Remaining</p>
        <h2 class="text-3xl font-mono font-black text-[#EAB308]">09:45</h2>
      </div>
    </div>

    <div class="max-w-fit mx-auto relative mb-24 text-center">
      <div class="w-[300px] md:w-[700px] h-2 bg-gradient-to-r from-transparent via-[#EAB308] to-transparent rounded-full shadow-[0_15px_40px_rgba(234,179,8,0.4)] mx-auto"></div>
      <p class="text-[10px] tracking-[1em] text-gray-700 mt-8 font-black uppercase">SCREEN</p>
    </div>

    <div class="max-w-fit mx-auto space-y-4">
      <div v-for="row in rows" :key="row" class="flex items-center gap-6">
        <span class="text-gray-800 font-black text-sm w-4 text-center">{{ row }}</span>

        <div class="flex gap-2 md:gap-3">
          <template v-for="col in 16" :key="col">
            <div v-if="col === 9" class="w-8 md:w-16"></div>
            
            <SeatItem 
              :label="`${row}${col}`"
              :type="getSeatType(row)"
              :is-booked="isSeatBooked(row, col)"
              :is-selected="selectedSeats.includes(`${row}${col}`)"
              @toggle="toggleSeat(row, col)"
            />
          </template>
        </div>
      </div>

      <div class="flex gap-2 md:gap-3 pl-10">
        <template v-for="col in 16" :key="col">
          <div v-if="col === 9" class="w-8 md:w-16"></div>
          <div class="w-8 md:w-10 text-center text-[9px] font-black text-gray-800">{{ col }}</div>
        </template>
      </div>
    </div>

    <div class="flex flex-wrap justify-center gap-10 mt-16 text-[10px] font-black text-gray-500 uppercase tracking-widest">
      <div class="flex items-center gap-2"><span class="w-3 h-3 bg-white/5 border border-white/10 rounded-sm"></span> Available</div>
      <div class="flex items-center gap-2 text-white"><span class="w-3 h-3 bg-[#EAB308] rounded-sm"></span> Selected</div>
      <div class="flex items-center gap-2"><span class="w-3 h-3 bg-red-900/40 rounded-sm"></span> Booked</div>
      <div class="flex items-center gap-2"><span>👑</span> VIP (Row A)</div>
      <div class="flex items-center gap-2 text-rose-500"><span>❤️</span> Couple (Row B)</div>
    </div>

    <div class="max-w-5xl mx-auto mt-16 mb-20 px-4">
      <div class="bg-[#121212] border border-white/5 p-8 rounded-[40px] shadow-2xl flex flex-col md:flex-row justify-between items-center gap-6">
        <div class="flex gap-10">
          <div>
            <p class="text-gray-600 text-[10px] font-black uppercase mb-3 tracking-widest">Your Selection</p>
            <div class="flex flex-wrap gap-2 max-w-sm">
              <span v-for="s in selectedSeats" :key="s" class="bg-[#EAB308]/10 text-[#EAB308] px-4 py-1.5 rounded-xl text-xs font-black border border-[#EAB308]/20">
                {{ s }}
              </span>
              <span v-if="selectedSeats.length === 0" class="text-gray-600 text-sm italic">No seats selected yet</span>
            </div>
          </div>
          <div class="border-l border-white/10 pl-10">
            <p class="text-gray-600 text-[10px] font-black uppercase mb-1 tracking-widest">Grand Total</p>
            <h2 class="text-4xl font-black text-[#EAB308]">{{ totalPrice }} <span class="text-sm font-bold text-gray-500">ETB</span></h2>
          </div>
        </div>
        
        <button 
          @click="navigateTo('/booking/summary')"
          :disabled="selectedSeats.length === 0"
          class="w-full md:w-auto bg-[#EAB308] text-black px-16 py-5 rounded-2xl font-black text-sm hover:scale-105 active:scale-95 transition-all shadow-2xl shadow-[#EAB308]/20 disabled:opacity-20"
        >
          CONFIRM BOOKING
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MOVIE_DETAILS } from '~/graphql/movies'

const route = useRoute()
const movieId = route.params.id

const { data: movieData } = await useAsyncQuery<any>(GET_MOVIE_DETAILS, { id: movieId })
const movie = computed(() => movieData.value?.movies_by_pk)

const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
const selectedSeats = ref<string[]>([])

const getSeatType = (row: string) => {
  if (row === 'A') return 'vip'
  if (row === 'B') return 'couple'
  return 'standard'
}

const getPrice = (row: string) => {
  if (row === 'A') return 1200 
  if (row === 'B') return 800 
  return 400                  
}

const toggleSeat = (row: string, col: number) => {
  const id = `${row}${col}`
  if (selectedSeats.value.includes(id)) {
    selectedSeats.value = selectedSeats.value.filter(s => s !== id)
  } else {
    selectedSeats.value.push(id)
  }
}

const totalPrice = computed(() => {
  return selectedSeats.value.reduce((total, id) => total + getPrice(id.charAt(0)), 0)
})

const isSeatBooked = (row: string, col: number) => (row === 'E' && col === 7) || (row === 'H' && col === 12)
</script>