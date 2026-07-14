<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans">

    <!-- Sticky movie context bar -->
    <div class="sticky top-0 z-30 bg-[#090909]/95 backdrop-blur-xl border-b border-white/[0.05]">
      <div class="max-w-5xl mx-auto px-4 sm:px-6 h-16 flex items-center gap-4">

        <!-- Back -->
        <NuxtLink :to="`/movies/${movie?.id}`"
          class="w-8 h-8 flex items-center justify-center rounded-lg text-white/30 hover:text-white/70 hover:bg-white/[0.05] transition-all flex-shrink-0">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
          </svg>
        </NuxtLink>

        <!-- Poster -->
        <img v-if="movie" :src="movie.main_image"
          class="w-8 h-11 rounded-lg object-cover border border-white/[0.07] flex-shrink-0" />

        <!-- Title + meta -->
        <div v-if="movie" class="min-w-0 flex-1">
          <h1 class="font-semibold text-[14px] text-white truncate leading-none mb-0.5">{{ movie.title }}</h1>
          <p class="text-white/28 text-[10px] font-medium tracking-[0.16em] uppercase">{{ movie.duration_minutes }} min</p>
        </div>

        <!-- Selection count chip -->
        <div class="ml-auto flex-shrink-0">
          <div v-if="selectedSeats.length > 0"
            class="bg-[#EAB308]/[0.10] border border-[#EAB308]/25 text-[#EAB308] text-[10px] font-bold tracking-wider px-3 py-1 rounded-full">
            {{ selectedSeats.length }} seat{{ selectedSeats.length !== 1 ? 's' : '' }}
          </div>
        </div>

      </div>
    </div>

    <!-- Screen indicator -->
    <div class="pt-10 pb-8 text-center">
      <div class="inline-block w-[min(72vw,560px)]">
        <div class="w-full h-[2px] bg-gradient-to-r from-transparent via-white/25 to-transparent rounded-full
                    shadow-[0_4px_22px_rgba(255,255,255,0.08)]"></div>
        <div class="w-[85%] mx-auto h-[1px] mt-1 bg-gradient-to-r from-transparent via-white/[0.06] to-transparent rounded-full"></div>
        <p class="text-[8.5px] tracking-[0.55em] text-white/[0.16] mt-3 uppercase font-medium">Screen</p>
      </div>
    </div>

    <!-- Seat grid — scrollable on narrow viewports -->
    <div class="relative">
      <!-- Gradient fade edges (mobile scroll hint) -->
      <div class="absolute left-0 top-0 bottom-4 w-6 bg-gradient-to-r from-[#090909] to-transparent z-10 pointer-events-none sm:hidden"></div>
      <div class="absolute right-0 top-0 bottom-4 w-6 bg-gradient-to-l from-[#090909] to-transparent z-10 pointer-events-none sm:hidden"></div>

      <!-- Horizontal scroll wrapper -->
      <div class="overflow-x-auto seat-scroll px-2">
        <div class="w-fit mx-auto px-6 sm:px-10 space-y-[7px] pb-2">

          <div v-for="row in rows" :key="row" class="flex items-center gap-3">
            <!-- Row label -->
            <span class="text-white/[0.20] font-semibold text-[10px] w-4 text-right flex-shrink-0 tabular-nums">
              {{ row }}
            </span>

            <!-- Seats in row -->
            <div class="flex gap-[5px]">
              <template v-for="col in 16" :key="col">
                <!-- Aisle gap between col 8 and 9 -->
                <div v-if="col === 9" class="w-4 flex-shrink-0"></div>
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

        </div>
      </div>
    </div>

    <!-- Legend -->
    <div class="max-w-xl mx-auto px-6 mt-10 mb-4">

      <!-- Status legend -->
      <div class="flex items-center justify-center gap-6 sm:gap-8 flex-wrap mb-5">
        <!-- Available -->
        <div class="flex items-center gap-2">
          <div class="w-[18px] h-[17px] bg-white/[0.07] border border-white/[0.12]" style="border-radius: 4px 4px 2px 2px"></div>
          <span class="text-[10px] text-white/35 font-medium">Available</span>
        </div>
        <!-- Selected -->
        <div class="flex items-center gap-2">
          <div class="w-[18px] h-[17px] bg-white border border-white shadow-[0_0_8px_rgba(255,255,255,0.3)]" style="border-radius: 4px 4px 2px 2px"></div>
          <span class="text-[10px] text-white/35 font-medium">Selected</span>
        </div>
        <!-- Taken -->
        <div class="flex items-center gap-2">
          <div class="w-[18px] h-[17px] bg-white/[0.04] border border-white/[0.05]" style="border-radius: 4px 4px 2px 2px"></div>
          <span class="text-[10px] text-white/35 font-medium">Taken</span>
        </div>
      </div>

      <!-- Seat type + price legend -->
      <div class="flex items-center justify-center gap-5 sm:gap-7 flex-wrap border-t border-white/[0.05] pt-4">

        <!-- Standard -->
        <div class="flex items-center gap-2.5">
          <div class="w-[18px] h-[17px] bg-white/[0.07] border border-white/[0.12]" style="border-radius: 4px 4px 2px 2px"></div>
          <div>
            <p class="text-[10px] text-white/45 font-semibold leading-none">Standard</p>
            <p class="text-[9px] text-white/22 mt-0.5">{{ (priceMap['standard'] ?? 0).toLocaleString() }} ETB</p>
          </div>
        </div>

        <!-- VIP -->
        <div class="flex items-center gap-2.5">
          <div class="w-[18px] h-[17px] bg-[#EAB308]/[0.09] border border-[#EAB308]/30 flex items-center justify-center" style="border-radius: 4px 4px 2px 2px">
            <svg width="8" height="8" viewBox="0 0 24 24" fill="rgba(234,179,8,0.7)">
              <path d="M5 16L3 5L8.5 10L12 4L15.5 10L21 5L19 16H5ZM19 19C19 19.5523 18.5523 20 18 20H6C5.44772 20 5 19.5523 5 19V18H19V19Z"/>
            </svg>
          </div>
          <div>
            <p class="text-[10px] text-[#EAB308]/70 font-semibold leading-none">VIP</p>
            <p class="text-[9px] text-white/22 mt-0.5">{{ (priceMap['vip'] ?? 0).toLocaleString() }} ETB</p>
          </div>
        </div>

        <!-- Couple -->
        <div class="flex items-center gap-2.5">
          <div class="w-[18px] h-[17px] bg-rose-500/[0.09] border border-rose-500/30 flex items-center justify-center" style="border-radius: 4px 4px 2px 2px">
            <svg width="8" height="8" viewBox="0 0 24 24" fill="rgba(244,63,94,0.7)">
              <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 2 7.5 2c1.74 0 3.41.81 4.5 2.09C13.09 2.81 14.76 2 16.5 2 19.58 2 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
            </svg>
          </div>
          <div>
            <p class="text-[10px] text-rose-400/70 font-semibold leading-none">Couple</p>
            <p class="text-[9px] text-white/22 mt-0.5">{{ (priceMap['couple'] ?? 0).toLocaleString() }} ETB</p>
          </div>
        </div>

      </div>
    </div>

    <!-- Footer spacer -->
    <div class="h-36 sm:h-28"></div>

    <!-- Auth prompt modal -->
    <Teleport to="body">
      <Transition name="modal">
        <div v-if="showAuthModal" class="fixed inset-0 z-[100] flex items-end sm:items-center justify-center p-4 sm:p-6">
          <!-- Backdrop -->
          <div class="absolute inset-0 bg-black/70 backdrop-blur-sm" @click="showAuthModal = false"></div>

          <!-- Panel -->
          <div class="relative w-full max-w-sm bg-[#0D0D0D] border border-white/[0.08] rounded-2xl overflow-hidden">

            <!-- Top accent -->
            <div class="h-px w-full bg-gradient-to-r from-transparent via-[#EAB308]/50 to-transparent"></div>

            <div class="p-6">
              <!-- Icon -->
              <div class="w-10 h-10 bg-[#EAB308]/10 border border-[#EAB308]/20 rounded-xl flex items-center justify-center mb-4">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#EAB308" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                </svg>
              </div>

              <!-- Text -->
              <h2 class="text-white font-semibold text-[17px] mb-1 leading-snug">Sign in to complete your booking</h2>
              <p class="text-white/35 text-[13px] leading-relaxed mb-5">Create a free account or sign in to confirm your seats. Your selection will be saved.</p>

              <!-- Booking snapshot -->
              <div class="bg-white/[0.03] border border-white/[0.06] rounded-xl p-4 mb-5 space-y-2.5">
                <div class="flex items-center justify-between">
                  <span class="text-[10px] font-semibold tracking-[0.22em] text-white/25 uppercase">Selected Seats</span>
                  <div class="flex gap-1 flex-wrap justify-end max-w-[180px]">
                    <span v-for="s in selectedSeats" :key="s"
                      class="bg-[#EAB308]/[0.08] border border-[#EAB308]/20 text-[#EAB308] px-2 py-0.5 rounded text-[10px] font-semibold">
                      {{ s }}
                    </span>
                  </div>
                </div>
                <div class="h-px bg-white/[0.05]"></div>
                <div class="flex items-center justify-between">
                  <span class="text-[10px] font-semibold tracking-[0.22em] text-white/25 uppercase">Total</span>
                  <span class="text-white font-bold text-[15px]">{{ totalPrice.toLocaleString() }} <span class="text-white/30 text-[11px] font-normal">ETB</span></span>
                </div>
              </div>

              <!-- Actions -->
              <div class="flex flex-col gap-2.5">
                <button @click="goToAuth('/auth/login')"
                  class="w-full bg-[#EAB308] text-black py-3 rounded-xl font-bold text-[11px] tracking-[0.16em] uppercase hover:bg-[#d4a007] transition-colors">
                  Sign In
                </button>
                <button @click="goToAuth('/auth/signup')"
                  class="w-full bg-white/[0.05] border border-white/[0.08] text-white/70 py-3 rounded-xl font-bold text-[11px] tracking-[0.16em] uppercase hover:bg-white/[0.08] hover:text-white transition-colors">
                  Create Account
                </button>
                <button @click="showAuthModal = false"
                  class="w-full text-white/25 py-2 text-[11px] hover:text-white/50 transition-colors">
                  Continue browsing
                </button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- Sticky booking footer -->
    <div class="fixed bottom-0 left-0 right-0 z-50 bg-[#090909]/95 backdrop-blur-xl border-t border-white/[0.06]">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4">

        <!-- Selected seats + total price -->
        <div class="flex items-start gap-6">
          <div class="flex-1 min-w-0">
            <p class="text-[9px] font-semibold tracking-[0.26em] text-white/25 uppercase mb-1.5">Selected Seats</p>
            <div class="flex flex-wrap gap-1.5 max-w-[230px] sm:max-w-xs">
              <span v-for="s in selectedSeats" :key="s"
                class="bg-[#EAB308]/[0.08] border border-[#EAB308]/20 text-[#EAB308] px-2 py-0.5 rounded text-[10px] font-semibold">
                {{ s }}
              </span>
              <span v-if="selectedSeats.length === 0" class="text-white/15 text-[11px]">None selected</span>
            </div>
          </div>

          <div class="border-l border-white/[0.07] pl-6 flex-shrink-0">
            <p class="text-[9px] font-semibold tracking-[0.26em] text-white/25 uppercase mb-1">Total</p>
            <p class="text-[22px] font-bold text-white leading-none">
              {{ totalPrice.toLocaleString() }}<span class="text-[11px] font-medium text-white/30 ml-1">ETB</span>
            </p>
          </div>
        </div>

        <!-- Confirm button -->
        <button
          @click="handleBooking"
          :disabled="selectedSeats.length === 0"
          class="w-full sm:w-auto flex-shrink-0 bg-[#EAB308] text-black px-9 py-3.5 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all duration-200 disabled:opacity-20 disabled:cursor-not-allowed">
          Confirm Booking
        </button>

      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { GET_SCHEDULE_SEATS, GET_BOOKED_SEATS, GET_SEAT_PRICES } from '~/graphql/movies'

const route = useRoute()
const scheduleId = route.query.schedule_id
const booking = useBookingStore()
const { selectedMovie: savedMovie, selectedSeats: savedSeats } = storeToRefs(booking)
const { saveBooking } = booking
const authCookie = useCookie('auth_token')
const showAuthModal = ref(false)

const { data: scheduleData, pending } = await useAsyncQuery<any>(GET_SCHEDULE_SEATS, {
  schedule_id: scheduleId
})

const { data: bookedData } = await useAsyncQuery<any>(GET_BOOKED_SEATS, {
  schedule_id: scheduleId
})

const { data: seatPricesData } = await useAsyncQuery<any>(GET_SEAT_PRICES)

const movie = computed(() => scheduleData.value?.schedules_by_pk?.movie)

const alreadyBookedList = computed(() => {
  return bookedData.value?.booking_seats.map((s: any) => s.seat_id) || []
})

const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
const selectedSeats = ref<string[]>([])

// Restore the in-progress selection when the user navigates back from the summary.
// Reads only the in-memory store (not localStorage), so the selection survives back
// navigation within the session but never sticks across a full reload / new session.
onMounted(() => {
  if (savedMovie.value?.schedule_id === scheduleId && savedSeats.value.length > 0) {
    selectedSeats.value = savedSeats.value.filter((s: string) => !alreadyBookedList.value.includes(s))
  }
})

const getSeatType = (row: string) => row === 'A' ? 'vip' : (row === 'B' ? 'couple' : 'standard')

// Build a type→price map entirely from the database 
const priceMap = computed<Record<string, number>>(() => {
  const map: Record<string, number> = {}
  const entries: { type: string; price: number }[] = seatPricesData.value?.seat_prices ?? []
  entries.forEach(p => { map[p.type] = Number(p.price) })
  return map
})

const getPrice = (row: string) => priceMap.value[getSeatType(row)] ?? 0

const toggleSeat = (row: string, col: number) => {
  const id = `${row}${col}`
  if (selectedSeats.value.includes(id)) {
    selectedSeats.value = selectedSeats.value.filter(s => s !== id)
  } else {
    selectedSeats.value.push(id)
  }
}

const isSeatBooked = (row: string, col: number) => {
  const seatLabel = `${row}${col}`
  return alreadyBookedList.value.includes(seatLabel)
}

const totalPrice = computed(() => selectedSeats.value.reduce((total, id) => total + getPrice(id.charAt(0)), 0))

const handleBooking = async () => {
  if (selectedSeats.value.length === 0) return

  if (!authCookie.value) {
    showAuthModal.value = true
    return
  }

  if (movie.value) {
    const cleanMovieData = {
      title: movie.value.title,
      main_image: movie.value.main_image,
      id: movie.value.id,
      schedule_id: scheduleId
    }
    saveBooking(cleanMovieData, selectedSeats.value, totalPrice.value)
    await navigateTo('/booking/summary')
  }
}

const goToAuth = (path: string) => {
  if (movie.value) {
    saveBooking(
      { title: movie.value.title, main_image: movie.value.main_image, id: movie.value.id, schedule_id: scheduleId },
      selectedSeats.value,
      totalPrice.value
    )
  }
  booking.redirectAfterLogin = '/booking/summary'
  navigateTo(path)
}
</script>

<style scoped>
/* Hide scrollbar while keeping scroll functionality */
.seat-scroll::-webkit-scrollbar { display: none; }
.seat-scroll { -ms-overflow-style: none; scrollbar-width: none; }

/* Modal transition */
.modal-enter-active, .modal-leave-active { transition: opacity 0.2s ease; }
.modal-enter-active .relative, .modal-leave-active .relative { transition: transform 0.25s ease, opacity 0.2s ease; }
.modal-enter-from, .modal-leave-to { opacity: 0; }
.modal-enter-from .relative { transform: translateY(16px); opacity: 0; }
.modal-leave-to .relative { transform: translateY(8px); opacity: 0; }
</style>
