<template>
  <div class="group relative bg-bg-card rounded-xl overflow-hidden border border-gray-800 hover:border-primary/50 transition duration-500">
    <div class="aspect-[6/7] overflow-hidden">
      <img :src="image" referrerpolicy="no-referrer" :alt="title" class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
    </div>
    
    <div class="p-4 bg-gradient-to-t from-black to-transparent">
      <div class="flex items-center gap-2 mb-1">
        <span class="text-text-soft text-xs">{{ duration }} min</span>
      </div>
      <h3 class="font-bold text-lg leading-tight truncate">{{ title }}</h3>
      <p class="text-primary text-sm font-medium mt-1">★ {{ rating }}</p>
      
      <button class="w-full mt-4 py-2 bg-white/10 hover:bg-primary hover:text-black rounded-lg text-sm font-bold transition">
        Book Now
      </button>
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