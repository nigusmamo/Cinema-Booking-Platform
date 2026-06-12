<template>
  <div class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6">
    <div class="absolute inset-0 bg-black/80 backdrop-blur-sm" @click="$emit('close')"></div>
    <div class="relative bg-[#0D0D0D] border border-white/10 rounded-[35px] shadow-2xl w-full max-h-[90vh] flex flex-col" :class="maxWidthClass">
      
      <!-- Header -->
      <div class="p-6 md:p-8 border-b border-white/5 flex items-center justify-between flex-shrink-0">
        <h2 class="text-2xl font-black uppercase italic tracking-tighter">{{ title }}</h2>
        <button @click="$emit('close')" class="text-gray-500 hover:text-white transition bg-white/5 p-2 rounded-full">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>

      <!-- Body -->
      <div class="p-6 md:p-8 overflow-y-auto flex-1 custom-scrollbar">
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
  width: 8px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.02);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(234, 179, 8, 0.5);
}
</style>
