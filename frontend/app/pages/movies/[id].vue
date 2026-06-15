<template>
  <div class="bg-[#090909] min-h-screen text-white font-sans pb-32">

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
              <div class="flex flex-wrap items-center gap-4 text-[12px]">
                <span class="text-[#EAB308] font-semibold flex items-center gap-1.5">
                  <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                  </svg>
                  {{ movie.rating_avg }}
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
    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MOVIE_DETAILS } from '~/graphql/movies'

const route = useRoute()
const movieId = route.params.id

const selectedDate = ref('')
const selectedScheduleId = ref('')

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_DETAILS, {
  id: movieId
})

const movie = computed(() => data.value?.movies_by_pk)

const availableDates = computed(() => {
  if (!movie.value?.schedules) return []

  const daysMap = new Map()
  const dateNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

  movie.value.schedules.forEach((s: any) => {
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
  if (!selectedDate.value || !movie.value?.schedules) return []
  return movie.value.schedules.filter((s: any) => {
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
</style>
