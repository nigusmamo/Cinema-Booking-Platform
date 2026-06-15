<template>
  <div
    @click="!isBooked && $emit('toggle')"
    class="relative flex flex-col items-center select-none"
    :class="isBooked ? 'cursor-not-allowed' : 'cursor-pointer group'"
  >
    <!-- Seat back -->
    <div
      class="w-[30px] h-[28px] transition-all duration-200 flex items-center justify-center"
      style="border-radius: 5px 5px 3px 3px"
      :class="seatBodyClass"
    >
      <svg v-if="type === 'vip'" width="9" height="9" viewBox="0 0 24 24"
        :class="isBooked ? 'fill-white/10' : isSelected ? 'fill-black' : 'fill-[#EAB308]/65'"
      ><path d="M5 16L3 5L8.5 10L12 4L15.5 10L21 5L19 16H5ZM19 19C19 19.5523 18.5523 20 18 20H6C5.44772 20 5 19.5523 5 19V18H19V19Z"/></svg>

      <svg v-if="type === 'couple'" width="8" height="8" viewBox="0 0 24 24"
        :class="isBooked ? 'fill-white/10' : isSelected ? 'fill-white' : 'fill-rose-400/65'"
      ><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 2 7.5 2c1.74 0 3.41.81 4.5 2.09C13.09 2.81 14.76 2 16.5 2 19.58 2 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
    </div>

    <!-- Seat leg bar -->
    <div class="w-[18px] h-[3px] rounded-full mt-[2px]"
      :class="isBooked ? 'bg-white/[0.04]'
        : isSelected && type === 'vip' ? 'bg-[#EAB308]/40'
        : isSelected && type === 'couple' ? 'bg-rose-500/40'
        : isSelected ? 'bg-white/40'
        : 'bg-white/[0.07]'"
    ></div>

    <!-- Column number -->
    <span class="mt-[3px] text-[7px] leading-none font-medium tabular-nums"
      :class="isBooked ? 'text-white/[0.08]' : isSelected ? 'text-white/50' : 'text-white/[0.15]'"
    >{{ label.slice(1) }}</span>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  type: 'standard' | 'vip' | 'couple'
  isBooked: boolean
  isSelected: boolean
  label: string
}>()

defineEmits(['toggle'])

const seatBodyClass = computed(() => {
  if (props.isBooked) {
    return 'bg-white/[0.04] border border-white/[0.05]'
  }
  if (props.isSelected) {
    if (props.type === 'vip')    return 'bg-[#EAB308] border border-[#EAB308] shadow-[0_0_16px_rgba(234,179,8,0.6)]'
    if (props.type === 'couple') return 'bg-rose-500 border border-rose-500 shadow-[0_0_16px_rgba(244,63,94,0.6)]'
    return 'bg-white border border-white shadow-[0_0_12px_rgba(255,255,255,0.38)]'
  }
  if (props.type === 'vip')    return 'bg-[#EAB308]/[0.09] border border-[#EAB308]/30 group-hover:bg-[#EAB308]/[0.18] group-hover:border-[#EAB308]/55 transition-all'
  if (props.type === 'couple') return 'bg-rose-500/[0.09] border border-rose-500/30 group-hover:bg-rose-500/[0.18] group-hover:border-rose-500/55 transition-all'
  return 'bg-white/[0.07] border border-white/[0.12] group-hover:bg-white/[0.13] group-hover:border-white/[0.24] transition-all'
})
</script>
