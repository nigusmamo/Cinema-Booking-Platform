<template>
  <div class="min-h-screen bg-[#0D0D0D] text-white py-10 px-4 font-sans flex flex-col items-center justify-center relative overflow-hidden">
    
    <div v-if="isSaving" class="text-center">
      <div class="w-16 h-16 border-4 border-[#EAB308] border-t-transparent rounded-full animate-spin mb-6 mx-auto"></div>
      <h2 class="text-[#EAB308] text-xl font-black uppercase tracking-[0.3em] animate-pulse">Confirming Ticket</h2>
      <p class="text-gray-500 mt-4 italic">Please wait while we secure your seats...</p>
    </div>

    <div v-else-if="errorMessage" class="max-w-md w-full text-center bg-red-500/5 border border-red-500/20 p-10 rounded-[40px]">
      <div class="text-6xl mb-6"></div>
      <h2 class="text-2xl font-black uppercase text-red-500 mb-4">Booking Failed</h2>
      <p class="text-gray-400 mb-8 italic text-sm">{{ errorMessage }}</p>
      <button @click="navigateTo('/schedules')" class="bg-[#EAB308] text-black px-8 py-3 rounded-2xl font-bold">Try Again</button>
    </div>

    <div v-else class="max-w-4xl w-full text-center">
      <h1 class="text-4xl md:text-6xl font-black text-white mb-4 tracking-tighter uppercase italic">
        Booking <span class="text-[#EAB308]">Confirmed!</span>
      </h1>
      <p class="text-gray-400 mb-12">Your tickets are ready. Enjoy the show!</p>

      <div v-if="movieInfo" class="max-w-2xl mx-auto bg-[#121212] border border-white/5 rounded-[40px] overflow-hidden shadow-2xl flex flex-col md:flex-row relative">
          <div class="p-8 flex-1 flex gap-6 items-center border-b md:border-b-0 md:border-r-2 border-dashed border-gray-800">
            <div class="w-28 h-40 rounded-2xl overflow-hidden border-2 border-white/5 flex-shrink-0 bg-gray-900">
              <img :src="movieInfo.main_image" class="w-full h-full object-cover" referrerpolicy="no-referrer" />
            </div>
            <div class="text-left">
              <h2 class="text-xl font-black text-white uppercase mb-3 leading-tight">{{ movieInfo.title }}</h2>
              <div class="space-y-3">
                <div>
                  <p class="text-[9px] text-gray-500 font-black uppercase tracking-widest mb-1">Confirmed Seats</p>
                  <p class="text-white font-black text-base">{{ selectedSeats.join(', ') }}</p>
                </div>
                <div>
                  <p class="text-[9px] text-gray-500 font-black uppercase tracking-widest mb-1">Booking Ref</p>
                  <p class="text-[#EAB308] font-black text-base">{{ bookingRef }}</p>
                </div>
              </div>
            </div>
          </div>
          <div class="p-10 bg-white/5 flex flex-col items-center justify-center w-full md:w-56 gap-4 text-center">
            <div class="w-32 h-32 bg-white rounded-3xl p-3">
              <img :src="`https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${bookingRef}`" class="w-full h-full" />
            </div>
            <p class="text-[8px] text-gray-500 font-black uppercase tracking-widest leading-relaxed">Present this at the gate</p>
          </div>
      </div>

      <div class="mt-12 flex justify-center gap-4">
        <button @click="navigateTo('/')" class="bg-[#EAB308] text-black px-12 py-4 rounded-2xl font-black text-xs uppercase hover:scale-105 transition-all">Back to Home</button>
        <button @click="handlePrint" class="bg-white/5 border border-white/10 text-white px-12 py-4 rounded-2xl font-black text-xs uppercase hover:bg-white/10 transition-all">Download Ticket</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { CREATE_BOOKING } from '~/graphql/movies'

const { selectedMovie, selectedSeats, totalPrice, loadBooking } = useBookingStore()
const movieInfo = computed(() => selectedMovie.value as any)
const isSaving = ref(true)
const errorMessage = ref('')
const bookingRef = ref('')

const { resolveClient } = useApolloClient()

onMounted(async () => {
  const hasData = loadBooking()
  if (!hasData || !selectedMovie.value) {
    isSaving.value = false
    errorMessage.value = "No booking information found."
    return
  }

  try {
    const client = resolveClient()
    const authCookie = useCookie('auth_token')
    const userIdCookie = useCookie('user_id')

    if (!authCookie.value || !userIdCookie.value) {
      throw new Error("User session not found. Please log in.")
    }

const { data, errors } = await client.mutate({
  mutation: CREATE_BOOKING,
  variables: {
    object: {
      schedule_id: movieInfo.value.schedule_id || movieInfo.value.id,
      total_price: totalPrice.value,
      booking_reference: "CINE-" + Math.floor(Math.random() * 900000 + 100000),
      payment_status: "completed",
      booking_seats: {
        data: selectedSeats.value.map(seatId => ({
          seat_id: seatId
        }))
      }
    }
  },
  context: {
    headers: { Authorization: `Bearer ${authCookie.value}` }
  }
})

    if (data?.insert_bookings_one) {
      bookingRef.value = data.insert_bookings_one.booking_reference
    }
  } catch (err: any) {
    console.error("Save error:", err)
    errorMessage.value = err.message || "Database update failed."
  } finally {
    isSaving.value = false
  }
})

const handlePrint = () => { if (import.meta.client) window.print() }
</script>