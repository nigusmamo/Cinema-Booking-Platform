<template>
  <div class="fixed inset-0 z-[100] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-black/75 backdrop-blur-md" @click="$emit('cancel')"></div>
    <div class="relative bg-[#0E0E0E] border border-white/[0.08] rounded-2xl shadow-2xl max-w-sm w-full p-7">

      <!-- Icon -->
      <div class="w-10 h-10 rounded-xl bg-red-500/10 flex items-center justify-center mb-5 mx-auto">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
          <line x1="12" y1="9" x2="12" y2="13"></line>
          <line x1="12" y1="17" x2="12.01" y2="17"></line>
        </svg>
      </div>

      <h3 class="text-[14px] font-semibold text-white text-center mb-2 tracking-tight">{{ title }}</h3>
      <p class="text-[12px] text-white/35 text-center leading-relaxed mb-7">{{ message }}</p>

      <div class="flex gap-3">
        <button
          @click="$emit('cancel')"
          class="flex-1 inline-flex items-center justify-center border border-white/[0.08] text-white/40 px-4 py-2.5 rounded-lg text-[11px] font-semibold tracking-widest uppercase hover:border-white/[0.16] hover:text-white/70 transition-all"
          :disabled="isDeleting"
        >
          Cancel
        </button>
        <button
          @click="$emit('confirm')"
          class="flex-1 bg-red-500/90 hover:bg-red-500 text-white py-2.5 rounded-lg text-[11px] font-bold uppercase tracking-widest transition flex items-center justify-center"
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
