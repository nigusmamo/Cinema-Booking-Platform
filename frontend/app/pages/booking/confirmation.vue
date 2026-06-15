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
      <div v-if="movieInfo" class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden">

        <div class="flex flex-col md:flex-row">

          <!-- Left: details -->
          <div class="flex-1 p-7">

            <!-- Movie -->
            <div class="flex gap-5 items-start mb-6">
              <img :src="movieInfo.main_image" referrerpolicy="no-referrer"
                class="w-16 h-24 rounded-xl object-cover flex-shrink-0 border border-white/[0.06]" />
              <div class="min-w-0">
                <p class="text-[9px] font-semibold tracking-[0.28em] text-[#EAB308]/70 uppercase mb-1">Now Playing</p>
                <h2 class="font-modern-luxury font-light text-2xl tracking-tight leading-tight">{{ movieInfo.title }}</h2>
              </div>
            </div>

            <!-- Holder + Ref -->
            <div class="grid grid-cols-2 gap-5 mb-5">
              <div>
                <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-1.5">Ticket Holder</p>
                <p class="text-white/80 text-[13px] font-medium">{{ user?.full_name || 'Guest' }}</p>
              </div>
              <div>
                <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-1.5">Reference</p>
                <p class="text-[#EAB308] text-[13px] font-semibold tracking-wide">{{ bookingRef }}</p>
              </div>
            </div>

            <!-- Seats by type -->
            <div class="border-t border-white/[0.05] pt-4 mb-4">
              <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase mb-3">Seats</p>
              <div class="space-y-2.5">
                <div v-for="group in seatGroups" :key="group.type" class="flex items-start gap-3">
                  <span class="text-[9px] font-bold tracking-[0.18em] uppercase w-16 flex-shrink-0 mt-0.5"
                    :class="group.type === 'VIP' ? 'text-[#EAB308]' : group.type === 'Couple' ? 'text-rose-400' : 'text-white/40'">
                    {{ group.type }}
                  </span>
                  <div class="flex gap-1.5 flex-wrap">
                    <span v-for="s in group.seats" :key="s"
                      class="px-2 py-0.5 rounded text-[10px] font-semibold border"
                      :class="group.type === 'VIP'
                        ? 'bg-[#EAB308]/[0.08] border-[#EAB308]/25 text-[#EAB308]'
                        : group.type === 'Couple'
                          ? 'bg-rose-500/[0.08] border-rose-500/25 text-rose-400'
                          : 'bg-white/[0.05] border-white/[0.1] text-white/55'">
                      {{ s }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Total -->
            <div class="border-t border-white/[0.05] pt-4 flex items-center justify-between">
              <p class="text-[9px] font-semibold tracking-[0.28em] text-white/25 uppercase">Total Paid</p>
              <p class="text-white font-bold text-lg">
                {{ totalPrice?.toLocaleString() }}<span class="text-white/30 text-[11px] font-normal ml-1">ETB</span>
              </p>
            </div>
          </div>

          <!-- Tear-off divider -->
          <div class="hidden md:flex flex-col items-center py-4">
            <div class="w-3 h-3 rounded-full bg-[#090909] border border-white/[0.07] -ml-1.5 flex-shrink-0"></div>
            <div class="flex-1 border-l border-dashed border-white/[0.07] mx-auto"></div>
            <div class="w-3 h-3 rounded-full bg-[#090909] border border-white/[0.07] -ml-1.5 flex-shrink-0"></div>
          </div>
          <div class="md:hidden h-px mx-7 border-t border-dashed border-white/[0.07]"></div>

          <!-- Right: QR code -->
          <div class="md:w-52 flex flex-col items-center justify-center p-7 gap-4">
            <div class="w-36 h-36 bg-white rounded-2xl p-2 flex-shrink-0 shadow-[0_0_40px_rgba(234,179,8,0.08)]">
              <img :src="`https://api.qrserver.com/v1/create-qr-code/?size=200x200&ecc=M&data=${encodeURIComponent(qrData)}`"
                class="w-full h-full" />
            </div>
            <div class="text-center space-y-1">
              <p class="text-[9px] text-white/30 font-semibold tracking-[0.22em] uppercase">Scan at entrance</p>
              <p class="text-[8px] text-white/15 font-mono">{{ bookingRef }}</p>
            </div>
          </div>

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
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
            <polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
          Download Ticket
        </button>
      </div>

    </div>
  </div>

  <!-- PRINTABLE TICKET  -->
  <div id="cinema-print-ticket">
    <div class="print-ticket">

      <!-- Header -->
      <div class="print-header">
        <div class="print-logo">
          <span class="print-logo-icon">▶</span>
          <div>
            <div class="print-cinema-name">ETHIO CINEMA HOUSE</div>
            <div class="print-cinema-sub">Official Booking Ticket</div>
          </div>
        </div>
        <div class="print-confirmed-badge">✓ CONFIRMED</div>
      </div>

      <!-- Movie title band -->
      <div class="print-movie-band">
        <div class="print-movie-title">{{ movieInfo?.title }}</div>
        <div class="print-movie-label">Feature Film</div>
      </div>

      <!-- Body: details + QR -->
      <div class="print-body">

        <!-- Left: all ticket details -->
        <div class="print-details">

          <div class="print-row">
            <div class="print-field">
              <div class="print-label">TICKET HOLDER</div>
              <div class="print-value">{{ user?.full_name || 'Guest' }}</div>
            </div>
            <div class="print-field">
              <div class="print-label">BOOKING REFERENCE</div>
              <div class="print-value print-ref">{{ bookingRef }}</div>
            </div>
          </div>

          <div class="print-divider"></div>

          <div class="print-label" style="margin-bottom: 8px">SEAT ALLOCATION</div>
          <div v-for="group in seatGroups" :key="group.type" class="print-seat-row">
            <span class="print-seat-type" :class="`print-type-${group.type.toLowerCase()}`">{{ group.type }}</span>
            <span class="print-seat-list">{{ group.seats.join(', ') }}</span>
          </div>

          <div class="print-divider"></div>

          <div class="print-row">
            <div class="print-field">
              <div class="print-label">VENUE</div>
              <div class="print-value">Ethio Cinema House, Addis Ababa</div>
            </div>
            <div class="print-field print-total-field">
              <div class="print-label">TOTAL PAID</div>
              <div class="print-total">{{ totalPrice?.toLocaleString() }} ETB</div>
            </div>
          </div>

        </div>

        <!-- Tear line -->
        <div class="print-tear"></div>

        <!-- Right: QR -->
        <div class="print-qr-section">
          <img :src="`https://api.qrserver.com/v1/create-qr-code/?size=240x240&ecc=M&data=${encodeURIComponent(qrData)}`"
            class="print-qr-img" />
          <div class="print-qr-caption">Present at the gate</div>
          <div class="print-qr-note">Valid for one-time entry only</div>
        </div>

      </div>

      <!-- Footer -->
      <div class="print-footer">
        <span>Thank you for choosing Ethio Cinema House</span>
        <span class="print-footer-ref">{{ bookingRef }}</span>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { CREATE_BOOKING } from '~/graphql/movies'

const { selectedMovie, selectedSeats, totalPrice, loadBooking, clearBooking } = useBookingStore()
const { user, fetchUser } = useAuth()
const movieInfo = computed(() => selectedMovie.value as any)
const isSaving = ref(true)
const errorMessage = ref('')
const bookingRef = ref('')

const { resolveClient } = useApolloClient()

const getSeatType = (seatId: string): 'VIP' | 'Couple' | 'Standard' => {
  const row = seatId.charAt(0).toUpperCase()
  if (row === 'A') return 'VIP'
  if (row === 'B') return 'Couple'
  return 'Standard'
}

const seatGroups = computed(() => {
  const map: Record<string, string[]> = {}
  selectedSeats.value.forEach(s => {
    const type = getSeatType(s)
    if (!map[type]) map[type] = []
    map[type].push(s)
  })
  return (['VIP', 'Couple', 'Standard'] as const)
    .filter(t => map[t]?.length)
    .map(type => ({ type, seats: map[type] ?? [] }))
})

const qrData = computed(() => {
  const seatsStr = seatGroups.value
    .map(g => `${g.seats.join(',')}(${g.type})`)
    .join(' | ')
  return [
    'ETHIO CINEMA HOUSE',
    `REF: ${bookingRef.value}`,
    `MOVIE: ${movieInfo.value?.title || ''}`,
    `HOLDER: ${user.value?.full_name || 'Guest'}`,
    `SEATS: ${seatsStr}`,
    `TOTAL: ${totalPrice.value?.toLocaleString()} ETB`
  ].join('\n')
})

onMounted(async () => {
  const hasData = loadBooking()
  await fetchUser()

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
            data: selectedSeats.value.map(seatId => ({ seat_id: seatId }))
          }
        }
      },
      context: {
        headers: { Authorization: `Bearer ${authCookie.value}` }
      }
    })

    if (data?.insert_bookings_one) {
      bookingRef.value = data.insert_bookings_one.booking_reference
      clearBooking()
    }
  } catch (err: any) {
    console.error("Save error:", err)
    errorMessage.value = err.message || "Database update failed."
  } finally {
    isSaving.value = false
  }
})

const handlePrint = () => {
  if (import.meta.client) window.print()
}
</script>

<style>
/* Print: hide everything except the ticket */
@media print {
  body * { visibility: hidden !important; }
  #cinema-print-ticket,
  #cinema-print-ticket * { visibility: visible !important; }
  #cinema-print-ticket {
    position: fixed;
    inset: 0;
    display: flex !important;
    align-items: center;
    justify-content: center;
    background: #fff;
    padding: 24px;
  }
}
</style>

<style scoped>
/* Screen: hide the print ticket */
#cinema-print-ticket { display: none; }

/* ── Print ticket styles ───────────────────────────── */
.print-ticket {
  width: 720px;
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  font-family: 'Arial', sans-serif;
  box-shadow: 0 4px 40px rgba(0,0,0,0.15);
  color: #111;
}

.print-header {
  background: #111;
  padding: 18px 28px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.print-logo { display: flex; align-items: center; gap: 12px; }
.print-logo-icon { font-size: 22px; color: #EAB308; }
.print-cinema-name { color: #fff; font-size: 14px; font-weight: 700; letter-spacing: 0.18em; }
.print-cinema-sub { color: rgba(255,255,255,0.35); font-size: 9px; letter-spacing: 0.22em; text-transform: uppercase; margin-top: 2px; }
.print-confirmed-badge {
  background: #EAB308;
  color: #000;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.16em;
  padding: 5px 12px;
  border-radius: 6px;
}

.print-movie-band {
  background: #1a1a1a;
  padding: 16px 28px;
  border-bottom: 3px solid #EAB308;
}
.print-movie-title { color: #fff; font-size: 22px; font-weight: 300; letter-spacing: -0.01em; }
.print-movie-label { color: rgba(255,255,255,0.3); font-size: 9px; letter-spacing: 0.26em; text-transform: uppercase; margin-top: 3px; }

.print-body {
  display: flex;
  background: #fff;
}

.print-details { flex: 1; padding: 24px 28px; }

.print-row { display: flex; gap: 32px; margin-bottom: 16px; }
.print-field { flex: 1; }
.print-label {
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.28em;
  text-transform: uppercase;
  color: #999;
  margin-bottom: 4px;
}
.print-value { font-size: 13px; font-weight: 600; color: #111; }
.print-ref { color: #b8860b; font-family: monospace; font-size: 14px; }
.print-total-field { text-align: right; }
.print-total { font-size: 20px; font-weight: 800; color: #111; }

.print-divider { height: 1px; background: #eee; margin: 16px 0; }

.print-seat-row { display: flex; align-items: center; gap: 12px; margin-bottom: 8px; }
.print-seat-type {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  width: 60px;
  flex-shrink: 0;
  padding: 3px 7px;
  border-radius: 4px;
  text-align: center;
}
.print-type-vip { background: #fef3c7; color: #92400e; }
.print-type-couple { background: #ffe4e6; color: #9f1239; }
.print-type-standard { background: #f3f4f6; color: #374151; }
.print-seat-list { font-size: 12px; font-weight: 600; color: #333; letter-spacing: 0.04em; }

.print-tear {
  width: 1px;
  background: repeating-linear-gradient(to bottom, #ddd 0px, #ddd 6px, transparent 6px, transparent 12px);
  margin: 16px 0;
  flex-shrink: 0;
}

.print-qr-section {
  width: 180px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24px 20px;
  background: #fafafa;
}
.print-qr-img { width: 130px; height: 130px; border-radius: 8px; }
.print-qr-caption { font-size: 9px; font-weight: 700; letter-spacing: 0.18em; text-transform: uppercase; color: #555; margin-top: 12px; text-align: center; }
.print-qr-note { font-size: 8px; color: #aaa; margin-top: 4px; text-align: center; }

.print-footer {
  background: #f9f9f9;
  border-top: 1px solid #eee;
  padding: 12px 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 9px;
  color: #aaa;
  letter-spacing: 0.1em;
}
.print-footer-ref { font-family: monospace; color: #ccc; }
</style>
