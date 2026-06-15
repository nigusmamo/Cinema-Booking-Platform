<template>
  <div class="fixed inset-0 z-[100] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-black/75 backdrop-blur-md" @click="$emit('close')"></div>
    <div class="relative bg-[#0E0E0E] border border-white/[0.08] rounded-2xl shadow-2xl w-full max-h-[90vh] flex flex-col" :class="maxWidthClass">

      <!-- Header -->
      <div class="px-6 py-5 border-b border-white/[0.05] flex items-center justify-between flex-shrink-0">
        <h2 class="text-[13px] font-semibold tracking-wide text-white">{{ title }}</h2>
        <button @click="$emit('close')" class="w-7 h-7 flex items-center justify-center rounded-lg text-white/30 hover:text-white/70 hover:bg-white/[0.06] transition-all">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>

      <!-- Body -->
      <div class="p-6 overflow-y-auto flex-1 custom-scrollbar">
        <slot />
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  title: {
    type: String,
    required: true
  },
  maxWidth: {
    type: String,
    default: 'max-w-2xl'
  }
})

defineEmits(['close'])

const maxWidthClass = computed(() => {
  return props.maxWidth
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.02);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.08);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(234, 179, 8, 0.4);
}
</style>
