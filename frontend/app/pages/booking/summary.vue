<template>
  <div class="min-h-screen bg-[#0D0D0D] text-white py-20 px-4 font-sans">
    <div class="max-w-5xl mx-auto">
      <h1 class="text-3xl font-black uppercase italic mb-10 tracking-tighter">
        Booking Summary <span class="text-[#EAB308]">.</span>
      </h1>

      <!-- 🌟 መረጃው መኖሩን በደንብ እናረጋግጣለን -->
      <div v-if="selectedMovie" class="grid grid-cols-1 lg:grid-cols-3 gap-10">
        <div class="lg:col-span-2 space-y-6">
          <div class="bg-[#121212] border border-white/5 p-8 rounded-[40px] flex gap-8 shadow-2xl items-center">
              <img v-if="movieInfo" :src="movieInfo.main_image" class="w-32 h-44 rounded-3xl object-cover border-2 border-white/5 shadow-2xl" />            <div class="flex-1">
              <h2 class="text-3xl font-black text-[#EAB308] uppercase mb-2">{{ selectedMovie.title }}</h2>
              <p class="text-gray-500 font-bold mb-6 italic text-sm uppercase tracking-widest">Premium Cinema Ticket</p>
              
              <div class="space-y-3">
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Confirmed Seats</p>
                <div class="flex flex-wrap gap-2">
                  <span v-for="seat in selectedSeats" :key="seat" class="bg-[#EAB308]/10 px-4 py-2 rounded-xl text-sm font-black border border-[#EAB308]/20 text-[#EAB308]">
                    {{ seat }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <div class="bg-[#121212] border border-white/5 p-8 rounded-[40px] shadow-2xl">
            <h3 class="text-white font-black uppercase mb-6 tracking-widest text-xs">Payment Method</h3>
            <div class="flex gap-4">
              <div class="border-2 border-[#EAB308] bg-[#EAB308]/10 px-10 py-6 rounded-3xl flex flex-col items-center gap-2">
                 <span class="text-2xl font-black text-[#EAB308]">CHAPA</span>
                 <span class="text-[10px] text-gray-500 uppercase font-black">Secure Link</span>
              </div>
            </div>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="bg-[#EAB308] text-black p-10 rounded-[45px] shadow-2xl space-y-6">
            <h3 class="font-black uppercase italic border-b border-black/10 pb-4 text-xl">Payment</h3>
            <div class="space-y-4 font-bold">
              <div class="flex justify-between text-sm"><span>Tickets ({{ selectedSeats.length }})</span> <span>{{ totalPrice }} ETB</span></div>
              <div class="h-px bg-black/10 my-4"></div>
              <div class="flex justify-between text-2xl font-black">
                <span>Total</span>
                <span>{{ totalPrice }} ETB</span>
              </div>
            </div>
            <button @click="startPayment" class="w-full bg-black text-white py-5 rounded-2xl font-black text-sm hover:scale-105 active:scale-95 transition-all shadow-2xl uppercase">
              Confirm & Pay
            </button>
          </div>
        </div>
      </div>

      <!-- መረጃው ከሌለ የሚታየው -->
      <div v-else class="text-center py-20 flex flex-col items-center">
        <p class="text-gray-500 mb-8 italic">Data is still loading...</p>
        <button @click="navigateTo('/schedules')" class="bg-[#EAB308] text-black px-12 py-4 rounded-2xl font-black">RESELECT SEATS</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { selectedMovie, selectedSeats, totalPrice, loadBooking } = useBookingStore()

// 🌟 መረጃው መኖሩን ለ TypeScript ለማረጋገጥ ይህንን 'computed' እንጠቀማለን
const movieInfo = computed(() => selectedMovie.value as any)

onMounted(() => {
  loadBooking()
})

const startPayment = () => {
  alert("Redirecting to Chapa...")
}
</script>