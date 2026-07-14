<template>
  <div class="bg-[#090909] min-h-screen font-sans text-white">

    <!-- ══════════════════════════════════════════════════════
         HERO — cinematic full-height with fan poster cards
    ══════════════════════════════════════════════════════ -->
    <section ref="heroSection" class="relative h-[90vh] min-h-[620px] flex items-center overflow-hidden">

      <!-- Background: Ken Burns slow zoom for depth -->
      <img
        v-if="allMovies.length > 0"
        :src="allMovies[0]?.main_image"
        referrerpolicy="no-referrer"
        class="hero-bg absolute inset-0 w-full h-full object-cover"
        style="opacity: 0.15; transform-origin: center center"
      />

      <!-- Gradient stack -->
      <div class="absolute inset-0 bg-gradient-to-r from-[#090909] via-[#090909]/88 to-[#090909]/15"></div>
      <div class="absolute inset-0 bg-gradient-to-t from-[#090909] via-[#090909]/10 to-[#090909]/50"></div>
      <div class="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-[#090909]"></div>

      <!-- Content: two-column grid — text left, cards right -->
      <div class="relative z-10 w-full max-w-7xl mx-auto px-6 md:px-14">
        <div class="lg:grid lg:grid-cols-[460px_1fr] items-center">

          <!-- Left: headline + CTA -->
          <div>

            <!-- Eyebrow -->
            <div class="flex items-center gap-3 mb-6">
              <span class="block w-8 h-px bg-[#C49208]/50"></span>
              <span class="text-[8.5px] font-semibold tracking-[0.46em] uppercase text-[#C49208]/55 whitespace-nowrap">
                Ethiopian Cinema House
              </span>
              <span class="block w-5 h-px bg-[#C49208]/18"></span>
            </div>

            <!-- Headline: three lines, distinct weight/style contrast -->
            <h1 class="font-modern-luxury mb-8" style="line-height: 0.88">
              <span
                class="block font-light italic text-white/80"
                style="font-size: clamp(50px, 5.4vw, 76px); letter-spacing: -0.015em"
              >
                Experience
              </span>
              <span
                class="block font-light text-white/[0.14]"
                style="font-size: clamp(50px, 5.4vw, 76px); letter-spacing: -0.015em"
              >
                Cinema Beyond
              </span>
              <span
                class="block font-bold italic hero-gold-glow"
                style="font-size: clamp(68px, 7.5vw, 104px); color: #C49208; letter-spacing: -0.03em; margin-top: 0.06em"
              >
                Reality.
              </span>
            </h1>

            <!-- Description -->
            <p class="text-white/[0.28] text-[13px] font-light leading-[1.8] mb-9 max-w-[270px]">
              Discover new worlds on the big screen. Premium quality at Ethiopian Cinema House.
            </p>

            <!-- CTA -->
            <button
              v-if="allMovies.length > 0 && !isAdmin"
              @click="navigateTo(`/schedules`)"
              class="hero-cta inline-flex items-center gap-3 bg-[#C49208] text-black px-9 py-3.5 text-[11px] font-bold tracking-[0.18em] uppercase hover:bg-[#AE8207] active:scale-[0.97] transition-all duration-200"
            >
              Book Tickets
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
              </svg>
            </button>
          </div>

          <!-- Right: fan of 3 poster cards — absolute within a fixed-height box -->
          <div class="hidden lg:flex items-center justify-center relative h-[560px]">
            <div
              v-for="(m, index) in allMovies.slice(0, 3)"
              :key="m.id"
              class="absolute"
              :style="{
                zIndex: [10, 30, 20][index],
                transform: [
                  'rotate(-7deg) translateX(-198px) scale(0.93)',
                  'scale(1.04)',
                  'rotate(7deg) translateX(198px) translateY(8px) scale(0.93)'
                ][index]
              }"
            >
              <!-- Float wrapper -->
              <div
                :style="{
                  animation: `${index === 1 ? 'heroFloatCenter' : 'heroFloat'} ${[6.4, 5.6, 6.1][index]}s ease-in-out infinite`,
                  animationDelay: `${[0, 0.85, 1.75][index]}s`,
                  willChange: 'transform'
                }"
              >
                <div
                  class="w-[305px] h-[458px] rounded-2xl overflow-hidden group cursor-pointer"
                  :class="index !== 1 ? 'hero-side-card' : 'hero-center-card'"
                >
                  <img
                    :src="m.main_image"
                    referrerpolicy="no-referrer"
                    class="w-full h-full object-cover transition-transform duration-700 ease-out group-hover:scale-[1.07]"
                  />
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </section>

    <div class="sticky top-14 z-30 bg-[#090909] border-b border-white/[0.06]">
      <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center overflow-x-auto no-scrollbar" style="height:54px; gap:0">

          <!-- Date pills -->
          <div class="flex items-center gap-[3px] flex-shrink-0 pr-4">
            <button
              v-for="day in dynamicDays"
              :key="day.fullDate"
              @click="selectedDate = day.fullDate"
              class="flex-shrink-0 flex flex-col items-center justify-center w-[48px] h-9 rounded-lg transition-all duration-150"
              :class="selectedDate === day.fullDate
                ? 'bg-[#EAB308] text-black'
                : 'text-white/30 hover:text-white/65 hover:bg-white/[0.05]'"
            >
              <span class="text-[8px] uppercase tracking-widest font-semibold leading-none mb-[3px]">{{ day.label }}</span>
              <span class="text-[12px] font-bold leading-none">{{ day.dateNumber }}</span>
            </button>
          </div>

          <div class="w-px h-[18px] bg-white/[0.08] flex-shrink-0"></div>

          <!-- Genre -->
          <div class="relative flex-shrink-0 px-4">
            <select
              v-model="selectedGenre"
              class="appearance-none bg-transparent text-[12px] text-white/38 hover:text-white/70 focus:text-white/70 pr-4 cursor-pointer focus:outline-none transition-colors"
            >
              <option value="" class="bg-[#0D0D0D]">All Genres</option>
              <option v-for="g in genres" :key="g.id" :value="g.name" class="bg-[#0D0D0D]">{{ g.name }}</option>
            </select>
            <svg class="absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none text-white/20" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </div>

          <div class="w-px h-[18px] bg-white/[0.06] flex-shrink-0"></div>

          <!-- Director -->
          <div class="relative flex-shrink-0 px-4">
            <select
              v-model="selectedDirector"
              class="appearance-none bg-transparent text-[12px] text-white/38 hover:text-white/70 focus:text-white/70 pr-4 cursor-pointer focus:outline-none transition-colors"
            >
              <option value="" class="bg-[#0D0D0D]">All Directors</option>
              <option v-for="d in directors" :key="d.id" :value="d.name" class="bg-[#0D0D0D]">{{ d.name }}</option>
            </select>
            <svg class="absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none text-white/20" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </div>

          <div class="w-px h-[18px] bg-white/[0.06] flex-shrink-0"></div>

          <!-- Search -->
          <div class="relative flex-1 min-w-[130px] pl-4 pr-2">
            <svg class="absolute left-4 top-1/2 -translate-y-1/2 text-white/[0.16]" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search films…"
              class="w-full bg-transparent pl-5 text-[12px] text-white/50 placeholder:text-white/[0.18] focus:outline-none focus:text-white/70 transition-colors"
            />
          </div>

        </div>
      </div>
    </div>

    <!-- NOW SHOWING — movie grid -->
    <div class="max-w-7xl mx-auto px-6 pt-6 pb-24">

      <!-- Section label + count -->
      <div class="flex items-center gap-4 mb-5">
        <span class="text-[10px] font-semibold tracking-[0.28em] text-white/25 uppercase flex-shrink-0">Now Showing</span>
        <div class="h-px flex-1 bg-white/[0.05]"></div>
        <span v-if="!pending" class="text-[10px] text-white/20 flex-shrink-0">
          {{ filteredMovies.length }} {{ filteredMovies.length === 1 ? 'film' : 'films' }}
        </span>
      </div>

      <!-- Skeleton loader -->
      <div v-if="pending" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 gap-4">
        <div v-for="i in 10" :key="i" class="aspect-[2/3] bg-white/[0.03] animate-pulse rounded-xl"></div>
      </div>

      <!-- Movie grid -->
      <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 gap-4">
        <MovieCard
          v-for="movie in filteredMovies"
          :key="movie.id"
          :title="movie.title"
          :image="movie.main_image"
          :duration="movie.duration_minutes"
          :rating="movie.rating_avg"
          @click="navigateTo(`/movies/${movie.id}`)"
        />
      </div>

      <!-- Empty state -->
      <div v-if="!pending && filteredMovies.length === 0" class="text-center py-20">
        <div class="w-12 h-12 border border-white/[0.07] rounded-xl flex items-center justify-center mx-auto mb-4">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/15">
            <rect x="2" y="7" width="20" height="15" rx="2"/>
            <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/>
          </svg>
        </div>
        <p class="text-white/18 text-[11px] font-medium tracking-[0.24em] uppercase">No films scheduled for this date</p>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { GET_HOME_PAGE_DATA } from '~/graphql/movies'

const { data, pending } = await useAsyncQuery<any>(GET_HOME_PAGE_DATA)
const { isAdmin } = storeToRefs(useAuthStore())

const heroSection = ref<HTMLElement | null>(null)
let heroObserver: IntersectionObserver | null = null

onMounted(() => {
  if (isAdmin.value) {
    navigateTo('/admin/movies')
  }

  const section = heroSection.value
  if (!section || typeof IntersectionObserver === 'undefined') return

  nextTick(() => {
    const animatedEls = [
      section.querySelector('.hero-bg'),
      ...Array.from(section.querySelectorAll('.hero-center-card, .hero-side-card')),
      ...Array.from(section.querySelectorAll('[style*="animation"]'))
    ].filter((el): el is HTMLElement => el instanceof HTMLElement)

    heroObserver = new IntersectionObserver(
      ([entry]) => {
        if (!entry) return
        const state = entry.isIntersecting ? '' : 'paused'
        animatedEls.forEach(el => { el.style.animationPlayState = state })
      },
      { threshold: 0 }
    )
    heroObserver.observe(section)
  })
})

onUnmounted(() => {
  heroObserver?.disconnect()
})

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

const selectedGenre = ref('')
const selectedDirector = ref('')
const searchQuery = ref('')

const allMovies = computed((): any[] => data.value?.movies ?? [])
const genres = computed(() => data.value?.genres ?? [])
const directors = computed(() => data.value?.directors ?? [])

const filteredMovies = computed(() => {
  if (!allMovies.value) return []

  return allMovies.value.filter((movie: any) => {
    const s = searchQuery.value.toLowerCase()

    const matchesSearch = movie.title.toLowerCase().includes(s) ||
      movie.movie_directors?.some((d: any) => d.director.name.toLowerCase().includes(s))

    const matchesGenre = selectedGenre.value === '' ||
      movie.movie_genres?.some((g: any) => g.genre.name === selectedGenre.value)

    const matchesDirector = selectedDirector.value === '' ||
      movie.movie_directors?.some((d: any) => d.director.name === selectedDirector.value)

    const matchesDate = movie.schedules && movie.schedules.some((sch: any) => {
      return sch.start_time.split('T')[0] === selectedDate.value
    })

    return matchesSearch && matchesGenre && matchesDirector && matchesDate
  })
})
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

select option {
  background: #0D0D0D;
  color: rgba(255, 255, 255, 0.65);
}

.hero-bg {
  animation: kenBurns 22s ease-in-out infinite;
  will-change: transform;
}
@keyframes kenBurns {
  0%, 100% { transform: scale(1.10); }
  50%       { transform: scale(1.18); }
}

@keyframes heroFloat {
  0%, 100% { transform: translateY(0px); }
  50%       { transform: translateY(-16px); }
}

@keyframes heroFloatCenter {
  0%, 100% { transform: translateY(0px) rotateZ(0deg); }
  50%       { transform: translateY(-24px) rotateZ(0.4deg); }
}

.hero-side-card {
  opacity: 0.82;
  box-shadow:
    0 28px 70px rgba(0, 0, 0, 0.75),
    0  0  55px rgba(196, 146, 8, 0.07);
  transition: opacity 0.4s ease, filter 0.4s ease;
}
.hero-side-card:hover {
  opacity: 1;
  filter: drop-shadow(0 0 45px rgba(196, 146, 8, 0.16));
}

.hero-center-card {
  box-shadow:
    0 48px 110px rgba(0, 0, 0, 0.95),
    0  0   0  1px rgba(196, 146, 8, 0.30),
    0  0  90px rgba(196, 146, 8, 0.20);
  animation: coronaPulse 4.8s ease-in-out infinite;
  will-change: opacity;
}
@keyframes coronaPulse {
  0%, 100% { opacity: 0.90; }
  50%       { opacity: 1; }
}

.hero-gold-glow {
  text-shadow:
    0 0 45px rgba(196, 146, 8, 0.38),
    0 0 100px rgba(196, 146, 8, 0.16);
}

.hero-cta {
  box-shadow:
    0 0 0  1px rgba(196, 146, 8, 0.38),
    0 8px 32px rgba(196, 146, 8, 0.24);
}
.hero-cta:hover {
  box-shadow:
    0 0 0  1px rgba(196, 146, 8, 0.58),
    0 8px 44px rgba(196, 146, 8, 0.34);
}
</style>
