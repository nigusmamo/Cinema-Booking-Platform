<template>
  <div class="pb-16">

    <!-- Page Header -->
    <div class="mb-8">
      <p class="text-[10px] font-semibold tracking-[0.3em] text-white/25 uppercase mb-1">Configuration</p>
      <h1 class="text-[22px] font-semibold text-white tracking-tight leading-none mb-1">Seat Pricing</h1>
      <p class="text-[12px] text-white/30">Set the ticket price per seat category</p>
    </div>

    <!-- Loading -->
    <div v-if="pending" class="flex justify-center py-20">
      <span class="w-8 h-8 border-2 border-[#EAB308]/20 border-t-[#EAB308] rounded-full animate-spin"></span>
    </div>

    <!-- Pricing cards -->
    <div v-else class="grid grid-cols-1 sm:grid-cols-3 gap-5 max-w-2xl">

      <!-- Standard -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6">
        <div class="w-10 h-10 rounded-xl bg-white/[0.05] border border-white/[0.08] flex items-center justify-center mb-4">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/40">
            <rect x="3" y="3" width="18" height="18" rx="3"/>
          </svg>
        </div>
        <p class="text-[11px] font-semibold text-white/50 tracking-widest uppercase mb-1">Standard</p>
        <p class="text-[10px] text-white/20 mb-5">Rows C – J</p>

        <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Price (ETB)</label>
        <div class="flex gap-2">
          <input
            v-model.number="prices.standard"
            type="number"
            min="0"
            step="50"
            class="flex-1 min-w-0 bg-[#111111] border border-white/[0.08] rounded-xl px-3 py-2.5 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all"
          />
          <button
            @click="save('standard')"
            :disabled="saving.standard"
            class="flex-shrink-0 bg-[#EAB308] text-black px-4 py-2.5 rounded-xl text-[11px] font-bold tracking-wider uppercase hover:bg-[#d4a007] active:scale-[0.97] transition-all disabled:opacity-40"
          >
            <span v-if="saving.standard" class="w-3.5 h-3.5 border-2 border-black/30 border-t-black rounded-full animate-spin inline-block"></span>
            <span v-else>Save</span>
          </button>
        </div>
        <p v-if="saved.standard" class="text-[10px] text-emerald-400 mt-2">Saved</p>
        <p v-if="errors.standard" class="text-[10px] text-red-400 mt-2">{{ errors.standard }}</p>
      </div>

      <!-- VIP -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6">
        <div class="w-10 h-10 rounded-xl bg-[#EAB308]/[0.08] border border-[#EAB308]/25 flex items-center justify-center mb-4">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="rgba(234,179,8,0.7)">
            <path d="M5 16L3 5L8.5 10L12 4L15.5 10L21 5L19 16H5ZM19 19C19 19.5523 18.5523 20 18 20H6C5.44772 20 5 19.5523 5 19V18H19V19Z"/>
          </svg>
        </div>
        <p class="text-[11px] font-semibold text-[#EAB308]/70 tracking-widest uppercase mb-1">VIP</p>
        <p class="text-[10px] text-white/20 mb-5">Row A</p>

        <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Price (ETB)</label>
        <div class="flex gap-2">
          <input
            v-model.number="prices.vip"
            type="number"
            min="0"
            step="50"
            class="flex-1 min-w-0 bg-[#111111] border border-white/[0.08] rounded-xl px-3 py-2.5 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all"
          />
          <button
            @click="save('vip')"
            :disabled="saving.vip"
            class="flex-shrink-0 bg-[#EAB308] text-black px-4 py-2.5 rounded-xl text-[11px] font-bold tracking-wider uppercase hover:bg-[#d4a007] active:scale-[0.97] transition-all disabled:opacity-40"
          >
            <span v-if="saving.vip" class="w-3.5 h-3.5 border-2 border-black/30 border-t-black rounded-full animate-spin inline-block"></span>
            <span v-else>Save</span>
          </button>
        </div>
        <p v-if="saved.vip" class="text-[10px] text-emerald-400 mt-2">Saved</p>
        <p v-if="errors.vip" class="text-[10px] text-red-400 mt-2">{{ errors.vip }}</p>
      </div>

      <!-- Couple -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6">
        <div class="w-10 h-10 rounded-xl bg-rose-500/[0.08] border border-rose-500/25 flex items-center justify-center mb-4">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="rgba(244,63,94,0.7)">
            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 2 7.5 2c1.74 0 3.41.81 4.5 2.09C13.09 2.81 14.76 2 16.5 2 19.58 2 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
          </svg>
        </div>
        <p class="text-[11px] font-semibold text-rose-400/70 tracking-widest uppercase mb-1">Couple</p>
        <p class="text-[10px] text-white/20 mb-5">Row B</p>

        <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Price (ETB)</label>
        <div class="flex gap-2">
          <input
            v-model.number="prices.couple"
            type="number"
            min="0"
            step="50"
            class="flex-1 min-w-0 bg-[#111111] border border-white/[0.08] rounded-xl px-3 py-2.5 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all"
          />
          <button
            @click="save('couple')"
            :disabled="saving.couple"
            class="flex-shrink-0 bg-[#EAB308] text-black px-4 py-2.5 rounded-xl text-[11px] font-bold tracking-wider uppercase hover:bg-[#d4a007] active:scale-[0.97] transition-all disabled:opacity-40"
          >
            <span v-if="saving.couple" class="w-3.5 h-3.5 border-2 border-black/30 border-t-black rounded-full animate-spin inline-block"></span>
            <span v-else>Save</span>
          </button>
        </div>
        <p v-if="saved.couple" class="text-[10px] text-emerald-400 mt-2">Saved</p>
        <p v-if="errors.couple" class="text-[10px] text-red-400 mt-2">{{ errors.couple }}</p>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { GET_SEAT_PRICES, UPDATE_SEAT_PRICE } from '~/graphql/admin'

const { resolveClient } = useApolloClient()
const authCookie = useCookie('auth_token')

const { data, pending } = await useAsyncQuery<any>(GET_SEAT_PRICES)

// Editable price fields — populated entirely from the database
const prices = reactive({ standard: 0, vip: 0, couple: 0 })

watch(data, (val) => {
  if (!val?.seat_prices) return
  val.seat_prices.forEach((p: { type: string; price: number }) => {
    if (p.type in prices) (prices as any)[p.type] = Number(p.price)
  })
}, { immediate: true })

const saving = reactive({ standard: false, vip: false, couple: false })
const saved  = reactive({ standard: false, vip: false, couple: false })
const errors = reactive<Record<string, string>>({ standard: '', vip: '', couple: '' })

const save = async (type: 'standard' | 'vip' | 'couple') => {
  saving[type] = true
  saved[type]  = false
  errors[type] = ''

  try {
    const client = resolveClient()
    await client.mutate({
      mutation: UPDATE_SEAT_PRICE,
      variables: { type, price: prices[type] },
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })
    saved[type] = true
    setTimeout(() => { saved[type] = false }, 2500)
  } catch (err: any) {
    errors[type] = err.message || 'Failed to save.'
  } finally {
    saving[type] = false
  }
}
</script>
