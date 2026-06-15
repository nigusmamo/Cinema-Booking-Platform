<template>
  <button
    class="w-full py-3.5 px-4 bg-[#EAB308] hover:bg-[#d4a007] text-black text-[11px] font-bold tracking-[0.18em] uppercase rounded-xl transition-colors duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
    :disabled="loading"
  >
    <span v-if="loading" class="flex items-center justify-center gap-2">
      <svg class="animate-spin" width="14" height="14" viewBox="0 0 24 24" fill="none">
        <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" stroke-dasharray="30 70" stroke-linecap="round"/>
      </svg>
      Please wait
    </span>
    <slot v-else />
  </button>
</template>

<script setup>
defineProps({
  loading: Boolean
})
</script>
