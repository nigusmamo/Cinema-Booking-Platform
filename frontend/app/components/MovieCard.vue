<template>
  <div class="group cursor-pointer">
    <div class="relative aspect-[2/3] rounded-2xl overflow-hidden bg-white/[0.03] mb-3">
      <img
        :src="image"
        referrerpolicy="no-referrer"
        :alt="title"
        class="w-full h-full object-cover group-hover:scale-[1.05] transition-transform duration-700 ease-out"
      />
      <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
    </div>
    <div class="px-0.5">
      <h3 class="text-white/80 text-[13px] font-medium leading-snug truncate mb-1">{{ title }}</h3>
      <div class="flex items-center justify-between">
        <span class="text-[#EAB308] text-[11px] font-semibold">★ {{ rating }}</span>
        <span class="text-white/25 text-[11px]">{{ duration }}m</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  image: string
  rating: number
  duration: number
}>()
</script>
