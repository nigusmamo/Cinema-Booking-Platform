<template>
  <div class="group bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden hover:border-white/[0.12] transition-all duration-300 flex gap-0">

    <!-- Image -->
    <div class="w-[88px] md:w-[112px] flex-shrink-0">
      <img :src="movie.main_image" class="w-full h-full object-cover" />
    </div>

    <!-- Content -->
    <div class="flex-1 p-5 flex flex-col justify-between min-w-0">
      <div>
        <h3 class="text-[13px] font-semibold text-white line-clamp-1 mb-1">{{ movie.title }}</h3>

        <div class="flex items-center gap-2.5 text-[10px] text-white/30 font-medium mb-2">
          <span>{{ movie.duration_minutes }}m</span>
          <span class="text-white/15">·</span>
          <span class="text-[#EAB308]">★ {{ movie.rating_avg }}</span>
          <span v-if="movie.movie_directors?.length" class="text-white/15">·</span>
          <span v-if="movie.movie_directors?.length" class="truncate">{{ movie.movie_directors[0].director.name }}</span>
        </div>

        <div class="flex flex-wrap gap-1 mb-2">
          <span
            v-for="g in movie.movie_genres?.slice(0, 3)"
            :key="g.genre.name"
            class="bg-white/[0.04] border border-white/[0.06] px-2 py-0.5 rounded text-[9px] text-white/35 uppercase tracking-wider"
          >
            {{ g.genre.name }}
          </span>
        </div>

        <span
          class="px-2 py-0.5 rounded text-[9px] font-semibold uppercase tracking-wider"
          :class="movie.status === 'now_showing'
            ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20'
            : movie.status === 'coming_soon'
              ? 'bg-sky-500/10 text-sky-400 border border-sky-500/20'
              : 'bg-white/[0.04] text-white/30 border border-white/[0.06]'"
        >
          {{ movie.status.replace('_', ' ') }}
        </span>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-1.5 mt-auto pt-3 border-t border-white/[0.05]">
        <NuxtLink
          :to="`/admin/movies/${movie.id}`"
          class="w-7 h-7 flex items-center justify-center rounded-lg bg-white/[0.04] hover:bg-white/[0.08] text-white/40 hover:text-white/80 transition-all"
        >
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
          </svg>
        </NuxtLink>
        <button
          @click="$emit('delete', movie.id)"
          class="w-7 h-7 flex items-center justify-center rounded-lg bg-red-500/[0.06] hover:bg-red-500/[0.14] text-red-500/50 hover:text-red-400 transition-all"
        >
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="3 6 5 6 21 6"></polyline>
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  movie: any
}>()

defineEmits(['delete'])

const schedulesCount = computed(() => {
  if (props.movie.schedules_aggregate) {
    return props.movie.schedules_aggregate.aggregate.count
  }
  if (props.movie.schedules) {
    return props.movie.schedules.length
  }
  return 0
})
</script>
