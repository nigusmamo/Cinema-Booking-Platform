<template>
  <div 
    @click="!isBooked && $emit('toggle')"
    class="relative group cursor-pointer transition-all duration-300 flex flex-col items-center w-8 md:w-10"
    :class="[isBooked ? 'opacity-10 cursor-not-allowed' : 'hover:scale-110']"
  >
    <div v-if="type !== 'standard'" class="absolute -top-3 left-1/2 -translate-x-1/2 z-10 pointer-events-none">
      <svg v-if="type === 'vip'" width="12" height="12" viewBox="0 0 24 24" 
        :class="isSelected ? 'fill-[#EAB308] drop-shadow-[0_0_5px_#EAB308]' : 'fill-gray-600'">
        <path d="M5 16L3 5L8.5 10L12 4L15.5 10L21 5L19 16H5ZM19 19C19 19.5523 18.5523 20 18 20H6C5.44772 20 5 19.5523 5 19V18H19V19Z" />
      </svg>
      <svg v-if="type === 'couple'" width="10" height="10" viewBox="0 0 24 24" 
        :class="isSelected ? 'fill-rose-500 drop-shadow-[0_0_5px_#f43f5e]' : 'fill-gray-600'">
        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 2 7.5 2c1.74 0 3.41.81 4.5 2.09C13.09 2.81 14.76 2 16.5 2 19.58 2 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
      </svg>
    </div>

    <div 
      class="h-8 md:h-9 rounded-t-lg border-2 transition-all duration-500 w-full"
      :class="[
        isSelected ? 'bg-current border-current' : 'bg-white/5 border-white/10',
        type === 'standard' && isSelected ? 'text-white shadow-[0_0_15px_rgba(255,255,255,0.4)]' : '',
        type === 'vip' && isSelected ? 'text-[#EAB308] shadow-[0_0_20px_rgba(234,179,8,0.5)]' : '',
        type === 'couple' && isSelected ? 'text-rose-500 shadow-[0_0_20px_rgba(244,63,94,0.5)]' : '',
        isBooked ? 'bg-red-900/40 border-transparent' : ''
      ]"
    ></div>
    
    <span class="text-[7px] mt-1 font-bold text-gray-700 group-hover:text-white transition-colors">
      {{ label }}
    </span>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  type: 'standard' | 'vip' | 'couple'
  isBooked: boolean
  isSelected: boolean
  label: string
}>()
defineEmits(['toggle'])
</script>