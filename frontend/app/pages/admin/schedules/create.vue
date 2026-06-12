<template>
  <div class="max-w-4xl mx-auto pb-20">
    
    <!-- Header -->
    <div class="flex items-center gap-4 mb-8">
      <NuxtLink to="/admin/schedules" class="bg-white/5 p-3 rounded-xl hover:bg-white/10 transition">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
      </NuxtLink>
      <div>
        <h1 class="text-3xl font-black uppercase italic tracking-tighter">Add <span class="text-[#EAB308]">Schedule .</span></h1>
      </div>
    </div>

    <div class="bg-[#0D0D0D] border border-white/5 rounded-[35px] shadow-2xl p-8 md:p-10">
      <form @submit="onSubmit" class="space-y-8">
        
        <div v-if="errorMessage" class="bg-red-500/10 border border-red-500/20 text-red-500 p-4 rounded-xl text-sm font-bold">
          {{ errorMessage }}
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="md:col-span-2">
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Select Movie</label>
            <select v-model="movie_id" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition appearance-none cursor-pointer" :class="{ 'border-red-500': errors.movie_id }">
              <option value="" disabled>Select a movie</option>
              <option v-for="movie in movies" :key="movie.id" :value="movie.id">{{ movie.title }}</option>
            </select>
            <p v-if="errors.movie_id" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.movie_id }}</p>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Start Time</label>
            <input v-model="start_time" type="datetime-local" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" :class="{ 'border-red-500': errors.start_time }" style="color-scheme: dark;">
            <p v-if="errors.start_time" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.start_time }}</p>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">End Time</label>
            <input v-model="end_time" type="datetime-local" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" :class="{ 'border-red-500': errors.end_time }" style="color-scheme: dark;">
            <p v-if="errors.end_time" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.end_time }}</p>
          </div>
        </div>

        <div class="pt-8 flex justify-end">
          <button 
            type="submit" 
            class="bg-[#EAB308] text-black px-12 py-4 rounded-2xl font-black text-sm uppercase tracking-widest hover:scale-105 active:scale-95 transition shadow-xl shadow-[#EAB308]/20 flex items-center justify-center min-w-[200px]"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="w-5 h-5 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
            <span v-else>Save Schedule</span>
          </button>
        </div>

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
