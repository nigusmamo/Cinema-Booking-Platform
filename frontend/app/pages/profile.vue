<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans pb-24">
    <div class="max-w-3xl mx-auto px-6 pt-10">

      <!-- Back -->
      <NuxtLink to="/"
        class="inline-flex items-center gap-2 text-white/25 hover:text-white/60 text-[11px] font-semibold tracking-[0.18em] uppercase mb-10 transition-colors">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
        </svg>
        Home
      </NuxtLink>

      <!-- ── USER CARD ─────────────────────────────────── -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-7 mb-8 flex flex-col sm:flex-row items-start sm:items-center gap-6">

        <!-- Avatar -->
        <div class="w-16 h-16 rounded-2xl bg-[#EAB308] flex items-center justify-center text-black text-2xl font-bold flex-shrink-0 shadow-[0_0_32px_rgba(234,179,8,0.20)]">
          {{ userInitial }}
        </div>

        <!-- Info -->
        <div class="flex-1 min-w-0">
          <h1 class="text-xl font-semibold text-white tracking-tight leading-none mb-1">
            {{ user?.full_name || '—' }}
          </h1>
          <p class="text-white/35 text-[13px] mb-3">{{ user?.email }}</p>
          <div class="flex flex-wrap items-center gap-3">
            <span class="inline-flex items-center gap-1.5 text-[9px] font-semibold tracking-[0.2em] uppercase text-white/25">
              <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
              Member since {{ memberSince }}
            </span>
            <span class="w-px h-3 bg-white/[0.08]"></span>
            <span class="text-[9px] font-semibold tracking-[0.2em] uppercase text-white/25">
              {{ bookings.length }} {{ bookings.length === 1 ? 'Booking' : 'Bookings' }}
            </span>
          </div>
        </div>

        <!-- Logout -->
        <button @click="logout"
          class="flex-shrink-0 inline-flex items-center gap-2 border border-white/[0.08] text-white/35 hover:text-red-400 hover:border-red-500/30 px-4 py-2.5 rounded-xl text-[10px] font-semibold tracking-[0.16em] uppercase transition-all duration-200">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
          Sign Out
        </button>
      </div>

      <!-- ── SAVED MOVIES ───────────────────────────────── -->
      <div v-if="!pending && bookmarks.length > 0">
        <div class="flex items-center gap-4 mb-5">
          <span class="text-[10px] font-semibold tracking-[0.28em] text-white/25 uppercase flex-shrink-0">Saved Movies</span>
          <div class="flex-1 h-px bg-white/[0.05]"></div>
          <span class="text-[10px] text-white/20 flex-shrink-0">{{ bookmarks.length }}</span>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-3 gap-3 mb-10">
          <NuxtLink
            v-for="bm in bookmarks" :key="bm.id"
            :to="`/movies/${bm.movie?.id}`"
            class="group relative bg-[#0D0D0D] border border-white/[0.05] hover:border-white/[0.12] rounded-xl overflow-hidden aspect-[2/3] transition-colors duration-200">
            <img :src="bm.movie?.main_image" referrerpolicy="no-referrer" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700 ease-out" />
            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-3">
              <p class="text-white text-[11px] font-semibold leading-tight truncate">{{ bm.movie?.title }}</p>
              <div class="flex items-center gap-1.5 mt-1">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="#EAB308"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                <span class="text-white/50 text-[9px]">{{ bm.movie?.rating_avg }}</span>
                <span class="text-white/25 text-[9px]">· {{ bm.movie?.duration_minutes }}m</span>
              </div>
            </div>
          </NuxtLink>
        </div>
      </div>

      <!-- ── BOOKING HISTORY ────────────────────────────── -->
      <div class="flex items-center gap-4 mb-5">
        <span class="text-[10px] font-semibold tracking-[0.28em] text-white/25 uppercase flex-shrink-0">Booking History</span>
        <div class="flex-1 h-px bg-white/[0.05]"></div>
      </div>

      <!-- Loading -->
      <div v-if="pending" class="space-y-3">
        <div v-for="i in 3" :key="i" class="h-28 bg-white/[0.03] animate-pulse rounded-2xl"></div>
      </div>

      <!-- Empty state -->
      <div v-else-if="bookings.length === 0" class="text-center py-20">
        <div class="w-14 h-14 border border-white/[0.06] rounded-2xl flex items-center justify-center mx-auto mb-5">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/15">
            <path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v2z"/>
          </svg>
        </div>
        <p class="text-white/20 text-[11px] font-medium tracking-[0.22em] uppercase mb-2">No bookings yet</p>
        <p class="text-white/[0.1] text-[10px] tracking-widest mb-7 uppercase">Your confirmed tickets will appear here</p>
        <NuxtLink to="/schedules"
          class="inline-flex items-center gap-2 bg-[#EAB308] text-black px-7 py-3 rounded-xl font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-[#d4a007] transition-colors">
          Browse Schedules
        </NuxtLink>
      </div>

      <!-- Booking cards -->
      <div v-else class="space-y-3">
        <div
          v-for="booking in bookings"
          :key="booking.id"
          class="group bg-[#0D0D0D] border border-white/[0.05] hover:border-white/[0.10] rounded-2xl overflow-hidden flex transition-colors duration-200">

          <!-- Poster -->
          <div class="w-20 flex-shrink-0 overflow-hidden">
            <img
              :src="booking.schedule?.movie?.main_image"
              referrerpolicy="no-referrer"
              class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700 ease-out" />
          </div>

          <!-- Details -->
          <div class="flex-1 px-5 py-4 min-w-0">
            <div class="flex items-start justify-between gap-3 mb-2">
              <h3 class="font-semibold text-[14px] text-white truncate leading-tight">
                {{ booking.schedule?.movie?.title }}
              </h3>
              <span
                class="flex-shrink-0 text-[8px] font-bold tracking-[0.18em] uppercase px-2.5 py-1 rounded-full"
                :class="booking.payment_status === 'completed'
                  ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20'
                  : 'bg-amber-500/10 text-amber-400 border border-amber-500/20'">
                {{ booking.payment_status }}
              </span>
            </div>

            <p class="text-white/30 text-[11px] mb-2.5">{{ formatShowtime(booking.schedule?.start_time) }}</p>

            <!-- Seats grouped by type -->
            <div class="flex flex-wrap gap-1.5 mb-2.5">
              <template v-for="group in groupSeats(booking.booking_seats)" :key="group.type">
                <span
                  class="text-[9px] font-semibold px-2 py-0.5 rounded border"
                  :class="group.type === 'VIP'
                    ? 'bg-[#EAB308]/[0.07] border-[#EAB308]/20 text-[#EAB308]'
                    : group.type === 'Couple'
                      ? 'bg-rose-500/[0.07] border-rose-500/20 text-rose-400'
                      : 'bg-white/[0.04] border-white/[0.08] text-white/40'">
                  {{ group.type }}: {{ group.seats.join(', ') }}
                </span>
              </template>
            </div>

            <div class="flex items-center justify-between">
              <span class="text-[9px] font-mono text-white/20 tracking-wider">{{ booking.booking_reference }}</span>
              <span class="text-white font-bold text-[13px]">
                {{ Number(booking.total_price).toLocaleString() }}
                <span class="text-white/25 text-[10px] font-normal">ETB</span>
              </span>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MY_PROFILE } from '~/graphql/movies'

const { user, userInitial, logout, fetchUser } = useAuth()
const authCookie = useCookie('auth_token')
const { resolveClient } = useApolloClient()

const pending = ref(true)
const bookings = ref<any[]>([])
const bookmarks = ref<any[]>([])

const memberSince = computed(() => {
  if (!user.value?.created_at) return '—'
  return new Date(user.value.created_at).toLocaleDateString('en-US', { month: 'long', year: 'numeric' })
})

onMounted(async () => {
  if (!authCookie.value) {
    navigateTo('/auth/login')
    return
  }
  if (!user.value) await fetchUser()

  try {
    const client = resolveClient()
    const { data } = await client.query({
      query: GET_MY_PROFILE,
      fetchPolicy: 'network-only',
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })
    const me = data?.users?.[0]
    if (me) {
      bookings.value = me.bookings ?? []
      bookmarks.value = me.bookmarks ?? []
    }
  } catch (err) {
    console.error('Profile fetch error:', err)
  } finally {
    pending.value = false
  }
})

const getSeatType = (seatId: string): 'VIP' | 'Couple' | 'Standard' => {
  const row = seatId.charAt(0).toUpperCase()
  if (row === 'A') return 'VIP'
  if (row === 'B') return 'Couple'
  return 'Standard'
}

const groupSeats = (bookingSeats: any[]) => {
  if (!bookingSeats?.length) return []
  const map: Record<string, string[]> = {}
  bookingSeats.forEach(bs => {
    const type = getSeatType(bs.seat_id)
    if (!map[type]) map[type] = []
    map[type].push(bs.seat_id)
  })
  return (['VIP', 'Couple', 'Standard'] as const)
    .filter(t => map[t]?.length)
    .map(type => ({ type, seats: map[type] ?? [] }))
}

const formatShowtime = (isoString: string) => {
  if (!isoString) return '—'
  return new Date(isoString).toLocaleDateString('en-US', {
    weekday: 'short', month: 'short', day: 'numeric', year: 'numeric',
    hour: '2-digit', minute: '2-digit'
  })
}
</script>
