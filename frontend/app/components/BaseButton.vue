<template>
  <button
    class="w-full py-3 px-4 bg-primary hover:bg-yellow-600 text-black font-bold rounded-lg transition duration-300 disabled:opacity-50 disabled:cursor-not-allowed"
    :disabled="loading"
  >
    <span v-if="loading">Loading...</span>
    <slot v-else />
  </button>
</template>

<script setup>
defineProps({
  loading: Boolean
})
</script> 