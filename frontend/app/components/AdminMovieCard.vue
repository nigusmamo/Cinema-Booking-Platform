<template>
  <div class="bg-[#0D0D0D] border border-white/5 rounded-[35px] p-4 flex gap-4 hover:border-white/20 transition group shadow-2xl relative overflow-hidden">
    
    <!-- Image -->
    <div class="w-24 h-32 md:w-32 md:h-44 rounded-[24px] overflow-hidden flex-shrink-0 bg-gray-900 border border-white/5">
      <img :src="movie.main_image" class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
    </div>

    <!-- Details -->
    <div class="flex-1 py-2 flex flex-col justify-between min-w-0">
      <div>
        <h3 class="font-black text-xl uppercase leading-tight line-clamp-1 mb-1 truncate">{{ movie.title }}</h3>
        
        <div class="flex flex-wrap items-center gap-2 mb-2 text-[9px] text-gray-500 font-bold tracking-widest uppercase">
          <span>{{ movie.duration_minutes }} MIN</span>
          <span>•</span>
          <span class="text-[#EAB308]">★ {{ movie.rating_avg }}</span>
          <span v-if="movie.movie_directors?.length">
            • DIR: {{ movie.movie_directors[0].director.name }}
          </span>
        </div>

        <div class="flex flex-wrap gap-1 mb-2">
          <span v-for="g in movie.movie_genres?.slice(0, 3)" :key="g.genre.name" class="bg-white/5 px-2 py-0.5 rounded text-[8px] text-gray-400 border border-white/5 uppercase">
            {{ g.genre.name }}
          </span>
        </div>

        <div v-if="movie.movie_stars?.length" class="flex flex-wrap gap-1 mb-2">
          <span v-for="s in movie.movie_stars?.slice(0, 3)" :key="s.star.name" class="text-[9px] text-gray-500 font-bold uppercase">
            {{ s.star.name }}{{ movie.movie_stars.indexOf(s) < Math.min(movie.movie_stars.length, 3) - 1 ? ',' : '' }}
          </span>
          <span v-if="movie.movie_stars?.length > 3" class="text-[9px] text-gray-500">...</span>
        </div>

        <div class="mb-3">
          <span class="px-2 py-0.5 rounded text-[8px] font-black uppercase tracking-widest" :class="movie.status === 'now_showing' ? 'bg-green-500/10 text-green-500' : movie.status === 'coming_soon' ? 'bg-blue-500/10 text-blue-500' : 'bg-gray-500/10 text-gray-500'">
            {{ movie.status.replace('_', ' ') }}
          </span>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-2 mt-auto">
        <NuxtLink :to="`/admin/movies/${movie.id}`" class="bg-white/5 hover:bg-white/10 text-white p-2 rounded-xl transition flex items-center justify-center">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
        </NuxtLink>
        <button @click="$emit('delete', movie.id)" class="bg-red-500/10 hover:bg-red-500/20 text-red-500 p-2 rounded-xl transition">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
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
