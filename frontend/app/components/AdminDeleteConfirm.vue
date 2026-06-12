<template>
  <div class="fixed inset-0 z-[100] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-black/80 backdrop-blur-sm" @click="$emit('cancel')"></div>
    <div class="relative bg-[#0D0D0D] border border-white/10 rounded-[35px] shadow-2xl max-w-md w-full p-8">
      <div class="w-16 h-16 rounded-full bg-red-500/10 flex items-center justify-center mb-6 mx-auto">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
      </div>
      <h3 class="text-2xl font-black uppercase text-center mb-4 tracking-tighter">{{ title }}</h3>
      <p class="text-gray-400 text-sm text-center mb-8 font-medium leading-relaxed">{{ message }}</p>
      
      <div class="flex gap-4">
        <button 
          @click="$emit('cancel')" 
          class="flex-1 bg-white/5 hover:bg-white/10 border border-white/10 text-white py-3 rounded-xl font-black text-xs uppercase tracking-widest transition"
          :disabled="isDeleting"
        >
          Cancel
        </button>
        <button 
          @click="$emit('confirm')" 
          class="flex-1 bg-red-500 hover:bg-red-600 text-white py-3 rounded-xl font-black text-xs uppercase tracking-widest transition flex items-center justify-center"
          :disabled="isDeleting"
        >
          <span v-if="isDeleting" class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
          <span v-else>Delete</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  message: string
  isDeleting?: boolean
}>()

defineEmits(['confirm', 'cancel'])
</script>
