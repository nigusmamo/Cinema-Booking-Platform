<template>
  <div v-if="totalPages > 1" class="flex items-center justify-center gap-1.5 mt-8">
    <!-- Prev -->
    <button
      @click="go(modelValue - 1)"
      :disabled="modelValue === 1"
      class="w-8 h-8 flex items-center justify-center rounded-lg bg-white/[0.04] text-white/40 hover:bg-white/[0.08] hover:text-white/80 disabled:opacity-30 disabled:pointer-events-none transition-all"
      aria-label="Previous page"
    >
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="15 18 9 12 15 6"></polyline>
      </svg>
    </button>

    <!-- Page Numbers -->
    <template v-for="(page, i) in pages" :key="i">
      <span v-if="page === '...'" class="w-8 h-8 flex items-center justify-center text-[12px] text-white/25">…</span>
      <button
        v-else
        @click="go(page as number)"
        class="min-w-8 h-8 px-2 flex items-center justify-center rounded-lg text-[12px] font-semibold transition-all"
        :class="page === modelValue
          ? 'bg-[#EAB308] text-black'
          : 'bg-white/[0.04] text-white/40 hover:bg-white/[0.08] hover:text-white/80'"
      >
        {{ page }}
      </button>
    </template>

    <!-- Next -->
    <button
      @click="go(modelValue + 1)"
      :disabled="modelValue === totalPages"
      class="w-8 h-8 flex items-center justify-center rounded-lg bg-white/[0.04] text-white/40 hover:bg-white/[0.08] hover:text-white/80 disabled:opacity-30 disabled:pointer-events-none transition-all"
      aria-label="Next page"
    >
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="9 18 15 12 9 6"></polyline>
      </svg>
    </button>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: number
  totalItems: number
  pageSize: number
}>()

const emit = defineEmits(['update:modelValue'])

const totalPages = computed(() => Math.max(1, Math.ceil(props.totalItems / props.pageSize)))

// Build a compact list of page numbers with ellipsis, e.g. 1 … 4 5 6 … 12
const pages = computed<(number | string)[]>(() => {
  const total = totalPages.value
  const current = props.modelValue
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)

  const result: (number | string)[] = [1]
  const start = Math.max(2, current - 1)
  const end = Math.min(total - 1, current + 1)

  if (start > 2) result.push('...')
  for (let p = start; p <= end; p++) result.push(p)
  if (end < total - 1) result.push('...')

  result.push(total)
  return result
})

const go = (page: number) => {
  if (page < 1 || page > totalPages.value || page === props.modelValue) return
  emit('update:modelValue', page)
}
</script>
