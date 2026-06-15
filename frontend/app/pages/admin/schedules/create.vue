<template>
  <div class="pb-16">

    <!-- Back Link -->
    <NuxtLink to="/admin/schedules" class="inline-flex items-center gap-2 text-white/30 hover:text-white/60 text-[12px] font-semibold mb-6 transition-all">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"></line>
        <polyline points="12 19 5 12 12 5"></polyline>
      </svg>
      Back to Schedules
    </NuxtLink>

    <!-- Title -->
    <h1 class="text-[20px] font-semibold text-white tracking-tight mb-8">Add Schedule <span class="text-[#EAB308]">.</span></h1>

    <!-- Form Card -->
    <div class="max-w-xl bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6">
      <form @submit="onSubmit" class="space-y-6">

        <div v-if="errorMessage" class="bg-red-500/[0.07] border border-red-500/[0.15] text-red-400 px-4 py-3 rounded-xl text-[12px]">
          {{ errorMessage }}
        </div>

        <!-- Movie Select -->
        <div>
          <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Select Movie</label>
          <select v-model="movie_id" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all appearance-none cursor-pointer" :class="{ 'border-red-500/50': errors.movie_id }">
            <option value="" disabled>Select a movie</option>
            <option v-for="movie in movies" :key="movie.id" :value="movie.id">{{ movie.title }}</option>
          </select>
          <p v-if="errors.movie_id" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.movie_id }}</p>
        </div>

        <!-- Start + End Time -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Start Time</label>
            <input v-model="start_time" type="datetime-local" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all" :class="{ 'border-red-500/50': errors.start_time }" style="color-scheme: dark;">
            <p v-if="errors.start_time" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.start_time }}</p>
          </div>
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">End Time</label>
            <input v-model="end_time" type="datetime-local" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all" :class="{ 'border-red-500/50': errors.end_time }" style="color-scheme: dark;">
            <p v-if="errors.end_time" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.end_time }}</p>
          </div>
        </div>

        <!-- Submit -->
        <button
          type="submit"
          class="w-full inline-flex items-center justify-center gap-2 bg-[#EAB308] text-black py-3 rounded-xl text-[12px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all"
          :disabled="isSubmitting"
        >
          <span v-if="isSubmitting" class="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
          <span v-else>Save Schedule</span>
        </button>

      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { useForm, useField } from 'vee-validate'
import {
  INSERT_SCHEDULE,
  GET_ADMIN_FORM_DATA,
  GET_ADMIN_SCHEDULES
} from '~/graphql/admin'

const { resolveClient } = await useApolloClient()
const authCookie = useCookie('auth_token')

// Fetch Form Data
const { data: formData } = await useAsyncQuery<any>(GET_ADMIN_FORM_DATA)
const movies = computed(() => formData.value?.movies || [])

// Validation Rules
const required = (val: any) => !!val || 'This field is required'

interface ScheduleFormValues {
  movie_id: string
  start_time: string
  end_time: string
}

const { handleSubmit, errors } = useForm<ScheduleFormValues>({
  initialValues: {
    movie_id: '',
    start_time: '',
    end_time: ''
  }
})

const { value: movie_id } = useField<string>('movie_id', required)
const { value: start_time } = useField<string>('start_time', required)
const { value: end_time } = useField<string>('end_time', required)

const isSubmitting = ref(false)
const errorMessage = ref('')

const onSubmit = handleSubmit(async (values: ScheduleFormValues) => {
  errorMessage.value = ''
  isSubmitting.value = true

  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }

    // Insert Schedule
    await client.mutate({
      mutation: INSERT_SCHEDULE,
      variables: {
        object: {
          movie_id: values.movie_id,
          start_time: new Date(values.start_time).toISOString(),
          end_time: new Date(values.end_time).toISOString()
        }
      },
      context: { headers },
      refetchQueries: [{ query: GET_ADMIN_SCHEDULES }]
    })

    // Success
    navigateTo('/admin/schedules')

  } catch (err: any) {
    console.error(err)
    errorMessage.value = err.message || "An error occurred while saving the schedule."
  } finally {
    isSubmitting.value = false
  }
})
</script>
