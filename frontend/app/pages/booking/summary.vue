<template>
  <div class="min-h-screen bg-[#0D0D0D] text-white py-20 px-4 font-sans text-left">
    <div class="max-w-5xl mx-auto">
      <h1 class="text-3xl font-luxury uppercase italic mb-10 tracking-tighter">
        Booking Summary <span class="text-[#EAB308]">.</span>
      </h1>

      <div v-if="selectedMovie" class="grid grid-cols-1 lg:grid-cols-3 gap-10">
        <div class="lg:col-span-2 space-y-6">
          <div class="bg-[#121212] border border-white/5 p-8 rounded-[40px] flex gap-8 shadow-2xl items-center">
            <img :src="movieInfo?.main_image" class="w-32 h-44 rounded-3xl object-cover border-2 border-white/5 shadow-2xl" referrerpolicy="no-referrer" />
            <div class="flex-1">
              <h2 class="text-3xl font-luxury text-[#EAB308] uppercase mb-2">{{ movieInfo?.title }}</h2>
              <div class="space-y-3">
                <p class="text-xs text-gray-400 font-black uppercase tracking-widest">Confirmed Seats</p>
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
            <div class="border-2 border-[#EAB308] w-fit bg-[#EAB308]/5 px-10 py-6 rounded-3xl">
               <span class="text-2xl font-black text-[#EAB308]">CHAPA</span>
            </div>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="bg-[#EAB308] text-black p-10 rounded-[45px] shadow-2xl space-y-6">
            <h3 class="font-black uppercase italic border-b border-black/10 pb-4 text-xl tracking-tight">Payment</h3>
            <div class="flex justify-between text-2xl font-black italic">
              <span>Total</span>
              <span>{{ totalPrice }} ETB</span>
            </div>
            
            <button 
              @click="payWithChapa" 
              :disabled="isProcessing"
              class="w-full bg-black text-white py-5 rounded-2xl font-black text-sm hover:scale-105 active:scale-95 transition-all shadow-2xl uppercase tracking-widest"
            >
              {{ isProcessing ? 'Initializing...' : 'Confirm & Pay' }}
            </button>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-20 flex flex-col items-center">
        <p class="text-gray-500 mb-8 italic">No booking data found. Please select seats again.</p>
        <button @click="navigateTo('/schedules')" class="bg-[#EAB308] text-black px-12 py-4 rounded-2xl font-black shadow-lg">BACK TO SCHEDULES</button>
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