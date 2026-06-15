<template>
  <div class="mb-4">
    <label v-if="label" class="block text-[11px] font-medium tracking-[0.18em] text-white/35 uppercase mb-2">
      {{ label }}
    </label>
    <input
      :type="type"
      :placeholder="placeholder"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      class="w-full px-4 py-3 bg-transparent border border-white/[0.09] text-white/80 rounded-xl text-[13px] focus:outline-none focus:border-white/[0.22] transition-colors placeholder:text-white/[0.2]"
    />
  </div>
</template>

<script setup>
defineProps({
  label: String,
  type: { type: String, default: 'text' },
  placeholder: String,
  modelValue: String
})
defineEmits(['update:modelValue'])
</script>
