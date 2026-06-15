<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans">

    <!-- HEADER  -->
    <div class="max-w-7xl mx-auto px-6 pt-12 pb-6">

      <div class="flex items-center gap-5 mb-8">
        <NuxtLink to="/"
          class="w-8 h-8 flex items-center justify-center rounded-lg text-white/30 hover:text-white/70 hover:bg-white/[0.05] transition-all flex-shrink-0">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
          </svg>
        </NuxtLink>
        <span class="text-[10px] font-semibold tracking-[0.28em] text-white/35 uppercase flex-shrink-0">Schedule</span>
        <div class="flex-1 h-px bg-white/[0.05]"></div>
      </div>

      <!-- Date picker -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden">
        <div class="px-5 py-4">
          <div class="flex gap-1.5 overflow-x-auto no-scrollbar">
            <div
              v-for="day in dynamicDays"
              :key="day.fullDate"
              @click="selectedDate = day.fullDate"
              class="flex-shrink-0 w-[60px] py-3 rounded-xl flex flex-col items-center cursor-pointer transition-all duration-200"
              :class="selectedDate === day.fullDate
                ? 'bg-[#EAB308] text-black'
                : 'text-white/30 hover:text-white/60 hover:bg-white/[0.04]'">
              <span class="text-[9px] uppercase tracking-widest mb-0.5 font-medium">{{ day.label }}</span>
              <span class="text-[13px] font-bold">{{ day.dateNumber }}</span>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- CONTENT -->
    <div class="max-w-7xl mx-auto px-6 pb-32">

      <!-- Skeletons -->
      <div v-if="pending" class="space-y-3">
        <div v-for="i in 3" :key="i" class="h-44 bg-white/[0.03] animate-pulse rounded-2xl"></div>
      </div>

      <!-- Movie list -->
      <div v-else-if="filteredMovies.length > 0" class="space-y-3">
        <div
          v-for="movie in filteredMovies"
          :key="movie.id"
          class="group bg-[#0D0D0D] border border-white/[0.05] hover:border-white/[0.1] rounded-2xl overflow-hidden flex flex-col md:flex-row transition-colors duration-300">

          <!-- Poster -->
          <div class="w-full md:w-40 aspect-video md:aspect-[2/3] flex-shrink-0 overflow-hidden">
            <img
              :src="movie.main_image"
              class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700 ease-out"
            />
          </div>

          <!-- Info + actions -->
          <div class="flex-1 flex flex-col justify-between p-6 md:p-7">

            <!-- Top -->
            <div>
              <div class="flex items-center gap-3 mb-3">
                <div class="flex gap-1.5 flex-wrap">
                  <span
                    v-for="g in movie.movie_genres"
                    :key="g.genre.name"
                    class="border border-white/[0.08] px-2.5 py-0.5 rounded-full text-[9px] font-medium text-white/35 uppercase tracking-wider">
                    {{ g.genre.name }}
                  </span>
                </div>
                <span class="text-[#EAB308] text-[11px] font-semibold flex items-center gap-1">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                  </svg>
                  {{ movie.rating_avg }}
                </span>
              </div>
              <h2 class="font-modern-luxury font-light text-3xl md:text-4xl tracking-tight leading-tight mb-2">{{ movie.title }}</h2>
              <p class="text-white/28 text-[13px] leading-relaxed line-clamp-2 italic max-w-xl">{{ movie.description }}</p>
            </div>

            <!-- Bottom: showtimes + book -->
            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-5 mt-5">

              <div>
                <p class="text-[9px] font-semibold tracking-[0.28em] text-white/22 uppercase mb-2.5">Showtimes</p>
                <div class="flex gap-2 flex-wrap">
                  <div
                    v-for="s in getSchedulesForDate(movie)"
                    :key="s.id"
                    class="border border-white/[0.08] px-4 py-2 rounded-xl text-[11px] font-medium text-white/40 hover:border-white/[0.18] hover:text-white/65 transition-colors duration-200 cursor-default">
                    {{ formatTime(s.start_time) }}
                  </div>
                </div>
              </div>

              <button
                @click="navigateTo(`/movies/${movie.id}`)"
                class="flex-shrink-0 inline-flex items-center gap-3 bg-[#EAB308] text-black px-7 py-3 text-[11px] font-bold tracking-[0.18em] uppercase hover:bg-[#d4a007] transition-colors duration-200 rounded-xl">
                Book Now
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                </svg>
              </button>

            </div>
          </div>
        </div>
      </div>

      <!-- Empty state -->
      <div v-else class="text-center py-32">
        <div class="w-14 h-14 border border-white/[0.06] rounded-2xl flex items-center justify-center mx-auto mb-5">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/15">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
            <line x1="16" y1="2" x2="16" y2="6"/>
            <line x1="8" y1="2" x2="8" y2="6"/>
            <line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
        </div>
        <p class="text-white/20 text-[11px] font-medium tracking-[0.22em] uppercase">No screenings today</p>
        <p class="text-white/[0.1] text-[10px] tracking-widest mt-2 uppercase">Select another date to see what's on</p>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_MOVIE_SCHEDULES } from '~/graphql/movies'

const { data, pending } = await useAsyncQuery<any>(GET_MOVIE_SCHEDULES)
const movies = computed(() => data.value?.movies ?? [])

const dynamicDays = computed(() => {
  const daysArray = []
  const dateNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  const today = new Date()

  for (let i = 0; i < 7; i++) {
    const d = new Date()
    d.setDate(today.getDate() + i)
    daysArray.push({
      label: dateNames[d.getDay()],
      dateNumber: d.getDate(),
      fullDate: d.toISOString().split('T')[0]
    })
  }
  return daysArray
})

const selectedDate = ref(new Date().toISOString().split('T')[0])

const getSchedulesForDate = (movie: any) => {
  return movie.schedules.filter((s: any) => s.start_time.startsWith(selectedDate.value))
}

const filteredMovies = computed(() => {
  return movies.value.filter((m: any) => getSchedulesForDate(m).length > 0)
})

const formatTime = (isoString: string) => {
  return new Date(isoString).toLocaleTimeString('en-US', {
    hour: '2-digit', minute: '2-digit'
  })
}
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
</style>
