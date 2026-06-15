<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans pb-32">
    <div class="max-w-4xl mx-auto px-6 pt-12">

      <!-- Header -->
      <div class="flex items-center gap-5 mb-10">
        <span class="text-[10px] font-semibold tracking-[0.28em] text-white/35 uppercase flex-shrink-0">Booking Summary</span>
        <div class="flex-1 h-px bg-white/[0.05]"></div>
      </div>

      <div v-if="selectedMovie" class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Left: movie + payment method -->
        <div class="lg:col-span-2 space-y-4">

          <!-- Movie info card -->
          <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6 flex gap-6 items-center">
            <img :src="movieInfo?.main_image" class="w-24 h-36 rounded-xl object-cover flex-shrink-0 border border-white/[0.06]" referrerpolicy="no-referrer" />
            <div class="min-w-0">
              <h2 class="font-modern-luxury font-light text-2xl md:text-3xl tracking-tight mb-4 leading-tight">{{ movieInfo?.title }}</h2>
              <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-2.5">Confirmed Seats</p>
              <div class="flex flex-wrap gap-1.5">
                <span v-for="seat in selectedSeats" :key="seat"
                  class="bg-[#EAB308]/[0.08] border border-[#EAB308]/20 text-[#EAB308] px-3 py-1 rounded-lg text-[11px] font-semibold">
                  {{ seat }}
                </span>
              </div>
            </div>
          </div>

          <!-- Payment method -->
          <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6">
            <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-4">Payment Method</p>
            <div class="inline-flex items-center gap-3 border border-[#EAB308]/25 bg-[#EAB308]/[0.05] px-6 py-4 rounded-xl">
              <span class="text-[#EAB308] text-lg font-bold tracking-wider">CHAPA</span>
            </div>
          </div>

        </div>

        <!-- Right: payment panel -->
        <div>
          <div class="bg-[#EAB308] text-black rounded-2xl p-7 space-y-5">
            <p class="text-[10px] font-bold tracking-[0.22em] uppercase opacity-60 border-b border-black/10 pb-4">Order Total</p>
            <div class="flex items-baseline justify-between">
              <span class="text-4xl font-bold">{{ totalPrice }}</span>
              <span class="text-sm font-semibold opacity-60">ETB</span>
            </div>
            <button
              @click="payWithChapa"
              :disabled="isProcessing"
              class="w-full bg-black text-white py-4 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-black/80 transition-colors duration-200 disabled:opacity-40 disabled:cursor-not-allowed">
              {{ isProcessing ? 'Initializing…' : 'Confirm & Pay' }}
            </button>
          </div>
        </div>

      </div>

      <!-- No data state -->
      <div v-else class="text-center py-32">
        <div class="w-14 h-14 border border-white/[0.06] rounded-2xl flex items-center justify-center mx-auto mb-5">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/15">
            <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
          </svg>
        </div>
        <p class="text-white/25 text-[11px] font-medium tracking-[0.22em] uppercase mb-6">No booking data found</p>
        <button @click="navigateTo('/schedules')"
          class="inline-flex items-center gap-2 bg-[#EAB308] text-black px-7 py-3 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-[#d4a007] transition-colors">
          Back to Schedules
        </button>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { INITIATE_PAYMENT } from '~/graphql/movies'

const { selectedMovie, selectedSeats, totalPrice, loadBooking } = useBookingStore()
const isProcessing = ref(false)
const movieInfo = computed(() => selectedMovie.value as any)

const { user, fetchUser } = useAuth()
const { resolveClient } = useApolloClient()
const authCookie = useCookie('auth_token')

onMounted(async () => {
  loadBooking()

  await fetchUser()
})

const payWithChapa = async () => {
  if (!totalPrice.value || isProcessing.value || !user.value) {
    alert("Please wait until user data is loaded.")
    return
  }

  isProcessing.value = true

  try {
    const client = resolveClient()

    const nameParts = user.value.full_name.split(' ')
    const fName = nameParts[0] || 'Customer'
    const lName = nameParts.slice(1).join(' ') || 'User'

    const { data } = await client.mutate({
      mutation: INITIATE_PAYMENT,
      variables: {
        amount: totalPrice.value.toString(),
        email: user.value.email,
        first_name: fName,
        last_name: lName
      },
      context: {
        headers: { Authorization: `Bearer ${authCookie.value}` }
      }
    })

    if (data?.pay?.checkout_url) {
      window.location.href = data.pay.checkout_url
    }
  } catch (err: any) {
    console.error("Payment error:", err)
    alert("Payment initialization failed. Please try again.")
  } finally {
    isProcessing.value = false
  }
}
</script>
