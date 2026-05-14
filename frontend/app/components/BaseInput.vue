<template>
  <div class="mb-4">
    <label v-if="label" class="block text-sm font-medium text-gray-400 mb-1">
      {{ label }}
    </label>
    <input
      :type="type"
      :placeholder="placeholder"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      class="w-full px-4 py-3 bg-bg-card border border-gray-800 text-white rounded-lg focus:outline-none focus:border-primary transition"
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