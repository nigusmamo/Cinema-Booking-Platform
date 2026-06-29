<template>
  <div class="bg-[#090909] min-h-screen text-white font-sans pb-32">

    <!-- Toast notification -->
    <Transition name="toast">
      <div v-if="toast"
        class="fixed top-5 left-1/2 -translate-x-1/2 z-[200] px-5 py-3 rounded-xl text-[12px] font-semibold shadow-2xl flex items-center gap-2.5 pointer-events-none"
        :class="toast.type === 'error'
          ? 'bg-red-500/90 text-white backdrop-blur-xl'
          : 'bg-[#EAB308] text-black backdrop-blur-xl'">
        <svg v-if="toast.type === 'success'" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
        <svg v-else width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        {{ toast.msg }}
      </div>
    </Transition>

    <!-- Loading -->
    <div v-if="pending" class="h-screen flex items-center justify-center">
      <div class="text-center">
        <div class="w-7 h-7 border border-[#EAB308]/30 border-t-[#EAB308] rounded-full animate-spin mx-auto mb-5"></div>
        <p class="text-white/25 text-[10px] font-medium tracking-[0.32em] uppercase">Loading</p>
      </div>
    </div>

    <div v-else-if="movie">

      <!-- ── HERO ───────────────────────────────────────────── -->
      <div class="relative h-[54vh] w-full overflow-hidden -mt-14 pt-14">

        <!-- Back button -->
        <NuxtLink to="/schedules"
          class="absolute top-[62px] left-6 md:left-16 z-10 w-8 h-8 flex items-center justify-center rounded-lg text-white/50 hover:text-white hover:bg-white/[0.07] transition-all">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
          </svg>
        </NuxtLink>

        <!-- Background -->
        <img :src="movie.main_image" class="absolute inset-0 w-full h-full object-cover opacity-20 blur-sm scale-110" referrerpolicy="no-referrer" />
        <div class="absolute inset-0 bg-gradient-to-r from-[#090909]/95 via-[#090909]/60 to-transparent"></div>
        <div class="absolute inset-0 bg-gradient-to-t from-[#090909] via-[#090909]/20 to-transparent"></div>

        <!-- Content anchored to bottom -->
        <div class="absolute bottom-0 left-0 right-0 px-6 md:px-16 pb-10">
          <div class="max-w-7xl mx-auto flex flex-col md:flex-row gap-7 items-end">

            <!-- Poster -->
            <div class="w-32 md:w-48 aspect-[2/3] rounded-2xl overflow-hidden flex-shrink-0 shadow-2xl border border-white/[0.07] bg-[#111]">
              <img :src="movie.main_image" class="w-full h-full object-cover" referrerpolicy="no-referrer" />
            </div>

            <!-- Title + meta -->
            <div class="pb-1 min-w-0">
              <h1 class="font-modern-luxury font-light leading-[0.88] tracking-[-0.02em] mb-5 truncate"
                  style="font-size: clamp(44px, 6vw, 80px)">
                {{ movie.title }}
              </h1>
              <div class="flex flex-wrap items-center gap-4 text-[12px] mb-4">
                <span class="text-[#EAB308] font-semibold flex items-center gap-1.5">
                  <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                  </svg>
                  {{ displayRating }}
                </span>
                <span class="text-white/35">{{ movie.duration_minutes }} min</span>
                <span class="text-white/35">{{ new Date(movie.release_date).getFullYear() }}</span>
                <div class="flex gap-1.5 flex-wrap">
                  <span v-for="g in movie.movie_genres" :key="g.genre.name"
                    class="border border-white/[0.1] px-3 py-0.5 rounded-full text-[10px] text-white/40 uppercase tracking-wider">
                    {{ g.genre.name }}
                  </span>
                </div>
              </div>
              <!-- Bookmark button -->
              <button
                v-if="isAuthenticated"
                @click="toggleBookmark"
                :disabled="isTogglingBookmark"
                class="inline-flex items-center gap-2 px-4 py-2 rounded-xl border text-[10px] font-semibold tracking-[0.14em] uppercase transition-all duration-200 disabled:opacity-60"
                :class="isBookmarked
                  ? 'border-[#EAB308]/40 bg-[#EAB308]/10 text-[#EAB308]'
                  : 'border-white/[0.12] text-white/40 hover:border-white/25 hover:text-white/70'">
                <svg v-if="isTogglingBookmark" class="animate-spin" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10" stroke-opacity="0.25"/><path d="M12 2a10 10 0 0 1 10 10"/></svg>
                <svg v-else width="12" height="12" viewBox="0 0 24 24" :fill="isBookmarked ? 'currentColor' : 'none'" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>
                </svg>
                {{ isTogglingBookmark ? '…' : isBookmarked ? 'Saved' : 'Bookmark' }}
              </button>
            </div>

          </div>
        </div>
      </div>

      <!-- ── MAIN CONTENT ───────────────────────────────────── -->
      <div class="max-w-7xl mx-auto px-6 md:px-16 mt-12 grid grid-cols-1 lg:grid-cols-3 gap-10 lg:gap-14">

        <!-- Left column: details -->
        <div class="lg:col-span-2 space-y-12">

          <!-- Description -->
          <p class="text-white/40 text-lg md:text-xl font-light leading-relaxed italic">{{ movie.description }}</p>

          <!-- Direction & Stars -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-10">

            <div>
              <div class="flex items-center gap-3 mb-5">
                <span class="text-[9px] font-semibold tracking-[0.32em] text-white/25 uppercase">Direction</span>
                <div class="flex-1 h-px bg-white/[0.05]"></div>
              </div>
              <div class="flex flex-wrap gap-4">
                <div v-for="d in movie.movie_directors" :key="d.director.name" class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full overflow-hidden border border-white/[0.08] bg-[#111] flex-shrink-0">
                    <img :src="d.director.image_url || 'https://ui-avatars.com/api/?name=' + d.director.name + '&background=EAB308&color=000'" class="w-full h-full object-cover" referrerpolicy="no-referrer" />
                  </div>
                  <span class="text-[12px] text-white/55 font-medium">{{ d.director.name }}</span>
                </div>
              </div>
            </div>

            <div>
              <div class="flex items-center gap-3 mb-5">
                <span class="text-[9px] font-semibold tracking-[0.32em] text-white/25 uppercase">Starring</span>
                <div class="flex-1 h-px bg-white/[0.05]"></div>
              </div>
              <div class="flex flex-wrap gap-4">
                <div v-for="s in movie.movie_stars" :key="s.star.name" class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full overflow-hidden border border-white/[0.08] bg-[#111] flex-shrink-0">
                    <img :src="s.star.image_url || 'https://ui-avatars.com/api/?name=' + s.star.name + '&background=EAB308&color=000'" class="w-full h-full object-cover" referrerpolicy="no-referrer" />
                  </div>
                  <span class="text-[12px] text-white/55 font-medium">{{ s.star.name }}</span>
                </div>
              </div>
            </div>

          </div>

          <!-- Gallery -->
          <div v-if="movie.movie_images && movie.movie_images.length > 0">
            <div class="flex items-center gap-3 mb-5">
              <span class="text-[9px] font-semibold tracking-[0.32em] text-white/25 uppercase">Gallery</span>
              <div class="flex-1 h-px bg-white/[0.05]"></div>
            </div>
            <div class="grid grid-cols-3 gap-3">
              <div v-for="img in movie.movie_images.slice(0, 3)" :key="img.id"
                class="aspect-video rounded-xl overflow-hidden border border-white/[0.05] bg-[#111]">
                <img :src="img.image_url" referrerpolicy="no-referrer" class="w-full h-full object-cover hover:scale-105 transition-transform duration-700" />
              </div>
            </div>
          </div>

        </div>

        <!-- Right column: booking panel -->
        <div>
          <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden sticky top-20">

            <!-- Panel header -->
            <div class="px-6 pt-5 pb-4 border-b border-white/[0.05]">
              <h3 class="text-[10px] font-semibold tracking-[0.28em] text-white/30 uppercase">Showtimes</h3>
            </div>

            <!-- Date picker -->
            <div class="px-5 py-4">
              <div class="flex gap-1.5 overflow-x-auto no-scrollbar">
                <div
                  v-for="day in availableDates"
                  :key="day.fullDate"
                  @click="selectedDate = day.fullDate"
                  class="flex-shrink-0 w-[58px] py-3 rounded-xl flex flex-col items-center cursor-pointer transition-all duration-200"
                  :class="selectedDate === day.fullDate
                    ? 'bg-[#EAB308] text-black'
                    : 'text-white/30 hover:text-white/60 hover:bg-white/[0.04]'">
                  <span class="text-[9px] uppercase tracking-widest mb-0.5 font-medium">{{ day.dayLabel }}</span>
                  <span class="text-[13px] font-bold">{{ day.dateNumber }}</span>
                </div>
              </div>
            </div>

            <div class="h-px bg-white/[0.05] mx-5"></div>

            <!-- Time slots + CTA -->
            <div class="p-5">
              <div class="grid grid-cols-2 gap-2 mb-5">
                <button
                  v-for="sched in availableTimes"
                  :key="sched.id"
                  @click="selectedScheduleId = sched.id"
                  class="py-3 rounded-xl border text-[11px] font-semibold tracking-widest uppercase transition-all duration-200"
                  :class="selectedScheduleId === sched.id
                    ? 'border-[#EAB308] text-[#EAB308] bg-[#EAB308]/[0.07]'
                    : 'border-white/[0.08] text-white/35 hover:border-white/[0.18] hover:text-white/60'">
                  {{ formatTime(sched.start_time) }}
                </button>
              </div>

              <button
                @click="goToSeats"
                :disabled="!selectedScheduleId"
                class="w-full bg-[#EAB308] text-black py-4 font-bold text-[11px] tracking-[0.18em] uppercase hover:bg-[#d4a007] transition-colors duration-200 disabled:opacity-20 disabled:cursor-not-allowed rounded-xl">
                Select Seats
              </button>
            </div>

          </div>
        </div>

      </div>

      <!-- ── RATINGS ────────────────────────────────────── -->
      <div class="max-w-7xl mx-auto px-6 md:px-16 mt-10 mb-16">
        <div class="flex items-center gap-4 mb-6">
          <span class="text-[10px] font-semibold tracking-[0.28em] text-white/25 uppercase flex-shrink-0">Ratings & Reviews</span>
          <div class="flex-1 h-px bg-white/[0.05]"></div>
          <span v-if="localRatings.length > 0" class="text-[10px] text-white/20 flex-shrink-0">
            {{ localRatings.length }} {{ localRatings.length === 1 ? 'review' : 'reviews' }}
          </span>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

          <!-- Left: submit rating -->
          <div class="lg:col-span-1">
            <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-5">
              <template v-if="isAuthenticated">
                <p class="text-[10px] font-semibold tracking-[0.22em] text-white/30 uppercase mb-4">
                  {{ userRating ? 'Your Rating' : 'Rate this Film' }}
                </p>
                <!-- Star picker -->
                <div class="flex gap-1.5 mb-4">
                  <button v-for="star in 5" :key="star"
                    @click="myStars = star"
                    @mouseenter="hoverStar = star"
                    @mouseleave="hoverStar = 0"
                    class="transition-colors duration-100">
                    <svg width="22" height="22" viewBox="0 0 24 24"
                      :fill="star <= (hoverStar || myStars) ? '#EAB308' : 'none'"
                      :stroke="star <= (hoverStar || myStars) ? '#EAB308' : 'rgba(255,255,255,0.2)'"
                      stroke-width="1.5">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                </div>
                <!-- Comment -->
                <textarea v-model="myComment" rows="3" placeholder="Share your thoughts… (optional)"
                  class="w-full bg-[#111] border border-white/[0.08] rounded-xl px-4 py-3 text-[12px] text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/40 transition-all resize-none mb-3"></textarea>
                <button
                  @click="submitRating"
                  :disabled="myStars === 0 || isSubmittingRating"
                  class="w-full bg-[#EAB308] text-black py-2.5 rounded-xl font-bold text-[10px] tracking-[0.16em] uppercase hover:bg-[#d4a007] transition-colors disabled:opacity-25 disabled:cursor-not-allowed">
                  {{ isSubmittingRating ? 'Saving…' : (userRating ? 'Update Rating' : 'Submit Rating') }}
                </button>
              </template>
              <template v-else>
                <div class="text-center py-4">
                  <div class="flex justify-center gap-1 mb-3">
                    <svg v-for="s in 5" :key="s" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.12)" stroke-width="1.5">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </div>
                  <p class="text-white/25 text-[11px] mb-3">Sign in to rate this film</p>
                  <NuxtLink to="/auth/login"
                    class="inline-flex items-center gap-1.5 bg-[#EAB308] text-black px-5 py-2 rounded-lg font-bold text-[10px] tracking-[0.14em] uppercase hover:bg-[#d4a007] transition-colors">
                    Sign In
                  </NuxtLink>
                </div>
              </template>
            </div>
          </div>

          <!-- Right: reviews list -->
          <div class="lg:col-span-2">
            <div v-if="localRatings.length > 0" class="space-y-3">
              <div v-for="r in localRatings" :key="r.id"
                class="bg-[#0D0D0D] border border-white/[0.05] rounded-2xl px-5 py-4">
                <div class="flex items-center justify-between mb-2">
                  <div class="flex gap-0.5">
                    <svg v-for="s in 5" :key="s" width="12" height="12" viewBox="0 0 24 24"
                      :fill="s <= r.rating_value ? '#EAB308' : 'none'"
                      :stroke="s <= r.rating_value ? '#EAB308' : 'rgba(255,255,255,0.15)'"
                      stroke-width="1.5">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </div>
                  <span class="text-[9px] text-white/20 font-medium">{{ formatReviewDate(r.created_at) }}</span>
                </div>
                <p v-if="r.comment" class="text-white/45 text-[12px] leading-relaxed italic">{{ r.comment }}</p>
                <p v-else class="text-white/15 text-[11px] italic">No comment</p>
              </div>
            </div>
            <div v-else class="bg-[#0D0D0D] border border-white/[0.05] rounded-2xl px-5 py-10 text-center" >
              <p class="text-white/20 text-[11px] font-medium tracking-[0.2em] uppercase">No reviews yet</p>
              <p class="text-white/10 text-[10px] mt-1">Be the first to rate this film</p>
            </div>
          </div>

        </div>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import {
  GET_MOVIE_DETAILS,
  GET_USER_BOOKMARK, INSERT_BOOKMARK, DELETE_BOOKMARK,
  GET_USER_RATING, INSERT_RATING, UPDATE_RATING
} from '~/graphql/movies'

const route = useRoute()
const movieId = route.params.id as string

const selectedDate = ref('')
const selectedScheduleId = ref('')

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_DETAILS, { id: movieId })
const movie = computed(() => data.value?.movies_by_pk)

// Auth
const { isAuthenticated } = useAuth()
const authCookie = useCookie('auth_token')
const userIdCookie = useCookie('user_id')
const { resolveClient } = useApolloClient()

// Toast notification
const toast = ref<{ msg: string; type: 'success' | 'error' } | null>(null)
let toastTimer: ReturnType<typeof setTimeout>
const showToast = (msg: string, type: 'success' | 'error' = 'success') => {
  clearTimeout(toastTimer)
  toast.value = { msg, type }
  toastTimer = setTimeout(() => { toast.value = null }, 3000)
}

// ── BOOKMARK ────────────────────────────────────────
const bookmarkId = ref<string | null>(null)
const isBookmarked = computed(() => !!bookmarkId.value)
const isTogglingBookmark = ref(false)

const fetchBookmarkStatus = async () => {
  if (!authCookie.value || !userIdCookie.value) return
  try {
    const client = resolveClient()
    const { data: bData } = await client.query({
      query: GET_USER_BOOKMARK,
      variables: { movie_id: movieId, user_id: userIdCookie.value },
      fetchPolicy: 'network-only',
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })
    bookmarkId.value = bData?.bookmarks?.[0]?.id ?? null
  } catch (err) {
    console.error('Fetch bookmark error:', err)
  }
}

const toggleBookmark = async () => {
  if (!authCookie.value) return navigateTo('/auth/login')
  isTogglingBookmark.value = true
  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }
    if (bookmarkId.value) {
      await client.mutate({ mutation: DELETE_BOOKMARK, variables: { id: bookmarkId.value }, context: { headers } })
      bookmarkId.value = null
      showToast('Removed from saved movies')
    } else {
      const { data: bData } = await client.mutate({
        mutation: INSERT_BOOKMARK,
        variables: { movie_id: movieId },
        context: { headers }
      })
      bookmarkId.value = bData?.insert_bookmarks_one?.id ?? null
      showToast('Saved to your profile ✓')
    }
  } catch (err: any) {
    console.error('Bookmark error:', err)
    showToast(err?.message ?? 'Failed to update bookmark', 'error')
  } finally {
    isTogglingBookmark.value = false
  }
}

// ── RATINGS ─────────────────────────────────────────
const userRating = ref<{ id: string; rating_value: number; comment: string } | null>(null)
const myStars = ref(0)
const hoverStar = ref(0)
const myComment = ref('')
const isSubmittingRating = ref(false)

// Local copy of ratings so the list updates immediately on submit
const localRatings = ref<any[]>([])
watch(movie, (val) => {
  if (val?.ratings) localRatings.value = [...val.ratings]
}, { immediate: true })

const fetchUserRating = async () => {
  if (!authCookie.value || !userIdCookie.value) return
  try {
    const client = resolveClient()
    const { data: rData } = await client.query({
      query: GET_USER_RATING,
      variables: { movie_id: movieId, user_id: userIdCookie.value },
      fetchPolicy: 'network-only',
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })
    const existing = rData?.ratings?.[0]
    if (existing) {
      userRating.value = existing
      myStars.value = existing.rating_value
      myComment.value = existing.comment ?? ''
    }
  } catch (err) {
    console.error('Fetch rating error:', err)
  }
}

const submitRating = async () => {
  if (!authCookie.value || myStars.value === 0) return
  isSubmittingRating.value = true
  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }

    if (userRating.value) {
      await client.mutate({
        mutation: UPDATE_RATING,
        variables: { id: userRating.value.id, rating_value: myStars.value, comment: myComment.value || null },
        context: { headers }
      })
      // Update in local list
      const idx = localRatings.value.findIndex(r => r.id === userRating.value!.id)
      if (idx !== -1) {
        localRatings.value[idx] = { ...localRatings.value[idx], rating_value: myStars.value, comment: myComment.value }
      }
      userRating.value = { ...userRating.value, rating_value: myStars.value, comment: myComment.value }
      showToast('Rating updated ✓')
    } else {
      const { data: rData } = await client.mutate({
        mutation: INSERT_RATING,
        variables: { movie_id: movieId, rating_value: myStars.value, comment: myComment.value || null },
        context: { headers }
      })
      const newRating = rData?.insert_ratings_one
      if (newRating) {
        userRating.value = newRating
        localRatings.value.unshift({
          id: newRating.id,
          rating_value: myStars.value,
          comment: myComment.value,
          created_at: new Date().toISOString(),
          user_id: userIdCookie.value
        })
      }
      showToast('Rating submitted ✓')
    }
  } catch (err: any) {
    console.error('Rating error:', err)
    showToast(err?.message ?? 'Failed to submit rating', 'error')
  } finally {
    isSubmittingRating.value = false
  }
}

// Compute average from localRatings for immediate UI feedback after a user submits.
// Falls back to movie.rating_avg (which the DB trigger keeps in sync) when no local data.
const localAvg = computed(() => {
  if (!localRatings.value.length) return null
  const sum = localRatings.value.reduce((a: number, r: any) => a + r.rating_value, 0)
  return (sum / localRatings.value.length).toFixed(1)
})

const displayRating = computed(() => {
  const v = localAvg.value ?? movie.value?.rating_avg
  return v != null ? Number(v).toFixed(1) : '—'
})

const formatReviewDate = (iso: string) =>
  new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })

onMounted(async () => {
  if (authCookie.value) {
    await Promise.all([fetchBookmarkStatus(), fetchUserRating()])
  }
})

// Only schedules from today onward — past dates must not be bookable.
const upcomingSchedules = computed(() => {
  if (!movie.value?.schedules) return []
  const now = new Date()
  const today = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
  return movie.value.schedules.filter((s: any) => {
    const d = new Date(s.start_time)
    const sDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    return sDate >= today
  })
})

const availableDates = computed(() => {
  const daysMap = new Map()
  const dateNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

  upcomingSchedules.value.forEach((s: any) => {
    const d = new Date(s.start_time)
    const fullDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`

    if (!daysMap.has(fullDate)) {
      daysMap.set(fullDate, {
        dayLabel: dateNames[d.getDay()],
        dateNumber: d.getDate(),
        fullDate: fullDate
      })
    }
  })

  return Array.from(daysMap.values()).sort((a, b) => a.fullDate.localeCompare(b.fullDate))
})

const availableTimes = computed(() => {
  if (!selectedDate.value) return []
  return upcomingSchedules.value.filter((s: any) => {
  const d = new Date(s.start_time)
  const sDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
  return sDate === selectedDate.value
})
})

watch(availableDates, (newDates) => {
  if (newDates.length > 0 && !selectedDate.value) {
    const today = new Date().toISOString().split('T')[0]
    const hasToday = newDates.find(d => d.fullDate === today)
    selectedDate.value = hasToday ? hasToday.fullDate : newDates[0].fullDate
  }
}, { immediate: true })

const formatTime = (timeStr: string) => {
  const d = new Date(timeStr)
  return d.toLocaleTimeString('en-GB', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
    timeZone: 'Africa/Addis_Ababa'
  })
}

const goToSeats = () => {
  if (selectedScheduleId.value) {
    navigateTo(`/booking/seats?schedule_id=${selectedScheduleId.value}`)
  }
}

useHead({
  title: movie.value ? `${movie.value.title} | Ethiopian Cinema House` : 'Loading Details...'
})
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

.toast-enter-active, .toast-leave-active { transition: all 0.25s ease; }
.toast-enter-from, .toast-leave-to { opacity: 0; transform: translateX(-50%) translateY(-10px); }
</style>
