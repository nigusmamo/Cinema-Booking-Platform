<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans flex flex-col items-center justify-center px-4 py-20">

    <!-- Saving / loading -->
    <div v-if="isSaving" class="text-center">
      <div class="w-8 h-8 border border-[#EAB308]/30 border-t-[#EAB308] rounded-full animate-spin mx-auto mb-5"></div>
      <p class="text-white/30 text-[11px] font-medium tracking-[0.32em] uppercase">Confirming your ticket…</p>
    </div>

    <!-- Error -->
    <div v-else-if="errorMessage" class="max-w-sm w-full text-center bg-[#0D0D0D] border border-red-500/15 rounded-2xl p-10">
      <div class="w-12 h-12 border border-red-500/20 rounded-xl flex items-center justify-center mx-auto mb-5">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-red-400">
          <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
        </svg>
      </div>
      <h2 class="text-white/80 text-lg font-medium mb-2">Booking Failed</h2>
      <p class="text-white/30 text-[13px] mb-7 italic">{{ errorMessage }}</p>
      <button @click="navigateTo('/schedules')"
        class="bg-[#EAB308] text-black px-7 py-3 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-[#d4a007] transition-colors">
        Try Again
      </button>
    </div>

    <!-- Success -->
    <div v-else class="max-w-2xl w-full">

      <!-- Header -->
      <div class="text-center mb-10">
        <div class="w-12 h-12 bg-[#EAB308]/10 border border-[#EAB308]/20 rounded-2xl flex items-center justify-center mx-auto mb-5">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#EAB308" stroke-width="2">
            <polyline points="20 6 9 17 4 12"/>
          </svg>
        </div>
        <h1 class="font-modern-luxury font-light text-4xl md:text-5xl mb-2 tracking-tight">Booking Confirmed</h1>
        <p class="text-white/30 text-[13px]">Your tickets are ready. Enjoy the show.</p>
      </div>

      <!-- Ticket card -->
      <div v-if="movieInfo" class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden flex flex-col md:flex-row">

        <!-- Left: movie info -->
        <div class="flex-1 p-7 flex gap-5 items-start">
          <img :src="movieInfo.main_image" class="w-20 h-28 rounded-xl object-cover flex-shrink-0 border border-white/[0.06]" referrerpolicy="no-referrer" />
          <div>
            <h2 class="font-modern-luxury font-light text-2xl tracking-tight mb-4 leading-tight">{{ movieInfo.title }}</h2>
            <div class="space-y-3">
              <div>
                <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-1">Seats</p>
                <p class="text-white/70 text-[13px] font-medium">{{ selectedSeats.join(', ') }}</p>
              </div>
              <div>
                <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-1">Reference</p>
                <p class="text-[#EAB308] text-[13px] font-semibold">{{ bookingRef }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Dashed divider -->
        <div class="hidden md:block w-px border-l border-dashed border-white/[0.07] my-6"></div>

        <!-- Right: QR code -->
        <div class="md:w-48 flex flex-col items-center justify-center p-7 gap-3 border-t md:border-t-0 border-dashed border-white/[0.07]">
          <div class="w-28 h-28 bg-white rounded-xl p-2 flex-shrink-0">
            <img :src="`https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${bookingRef}`" class="w-full h-full" />
          </div>
          <p class="text-[9px] text-white/25 font-medium tracking-[0.18em] uppercase text-center">Present at the gate</p>
        </div>

      </div>

      <!-- Actions -->
      <div class="flex flex-col sm:flex-row justify-center gap-3 mt-8">
        <button @click="navigateTo('/')"
          class="inline-flex items-center justify-center gap-2 bg-[#EAB308] text-black px-8 py-3.5 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-[#d4a007] transition-colors">
          Back to Home
        </button>
        <button @click="handlePrint"
          class="inline-flex items-center justify-center gap-2 bg-transparent border border-white/[0.1] text-white/50 hover:text-white/80 hover:border-white/20 px-8 py-3.5 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase transition-colors">
          Download Ticket
        </button>
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
