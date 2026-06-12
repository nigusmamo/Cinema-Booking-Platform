<template>
  <div class="max-w-7xl mx-auto">
    
    <!-- Header -->
    <div class="flex items-center justify-between mb-10">
      <div>
        <h1 class="text-4xl font-luxury uppercase italic tracking-tighter mb-2">Manage <span class="text-[#EAB308]">Schedules .</span></h1>
        <p class="text-gray-500 text-sm font-bold uppercase tracking-widest">Total: {{ schedules.length }} Schedules</p>
      </div>

      <button @click="openModal()" class="bg-[#EAB308] text-black px-8 py-3 rounded-xl font-black text-xs hover:scale-105 transition shadow-lg text-center flex items-center justify-center">
        + ADD SCHEDULE
      </button>
    </div>

    <div v-if="pending" class="flex justify-center py-20">
      <span class="w-10 h-10 border-4 border-[#EAB308]/30 border-t-[#EAB308] rounded-full animate-spin"></span>
    </div>

    <div v-else-if="schedules.length === 0" class="text-center py-20 bg-[#0D0D0D] border border-white/5 rounded-[35px]">
      <p class="text-gray-500 font-bold uppercase tracking-widest">No schedules found.</p>
    </div>

    <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6 pb-20">
      <div v-for="schedule in schedules" :key="schedule.id" class="bg-[#0D0D0D] border border-white/5 rounded-[35px] p-6 flex gap-6 hover:border-white/20 transition group shadow-2xl relative">
        
        <div class="w-20 h-28 rounded-2xl overflow-hidden flex-shrink-0 bg-black">
          <img :src="schedule.movie.main_image" class="w-full h-full object-cover">
        </div>
        
        <div class="flex-1 flex flex-col justify-center">
          <h3 class="text-xl font-black uppercase line-clamp-1 mb-2">{{ schedule.movie.title }}</h3>
          
          <div class="grid grid-cols-2 gap-y-2 gap-x-4 mb-4">
            <div>
              <p class="text-[9px] text-gray-500 font-bold uppercase tracking-widest">Date & Time</p>
              <p class="text-sm font-bold text-white">{{ formatDate(schedule.start_time) }}</p>
            </div>
            <div>
              <p class="text-[9px] text-gray-500 font-bold uppercase tracking-widest">Duration</p>
              <p class="text-sm font-bold text-white">{{ schedule.movie.duration_minutes }} Min</p>
            </div>
          </div>

          <div class="flex gap-2">
            <button @click="openModal(schedule)" class="bg-white/5 hover:bg-white/10 text-white p-2 rounded-xl transition flex items-center justify-center">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
            </button>
            <button @click="confirmDelete(schedule.id)" class="bg-red-500/10 hover:bg-red-500/20 text-red-500 p-2 rounded-xl transition">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Create/Edit -->
    <AdminModal v-if="showModal" :title="editId ? 'Edit Schedule' : 'Add Schedule'" @close="closeModal" max-width="max-w-md">
      <form @submit.prevent="handleSubmit" class="space-y-6">
        
        <div v-if="errorMessage" class="bg-red-500/10 border border-red-500/20 text-red-500 p-4 rounded-xl text-sm font-bold">
          {{ errorMessage }}
        </div>

        <div>
          <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Movie</label>
          <select v-model="form.movie_id" required class="w-full bg-black border border-white/10 px-4 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition">
            <option value="" disabled>Select Movie</option>
            <option v-for="m in formData?.movies" :key="m.id" :value="m.id">{{ m.title }}</option>
          </select>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Start Time</label>
            <input v-model="form.start_time" type="datetime-local" required class="w-full bg-black border border-white/10 px-4 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" style="color-scheme: dark;">
          </div>
          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">End Time</label>
            <input v-model="form.end_time" type="datetime-local" required class="w-full bg-black border border-white/10 px-4 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" style="color-scheme: dark;">
          </div>
        </div>

        <div class="pt-4 flex justify-end">
          <button type="submit" class="bg-[#EAB308] text-black px-8 py-4 rounded-2xl font-black text-xs uppercase tracking-widest hover:scale-105 transition shadow-xl w-full flex items-center justify-center" :disabled="isSubmitting">
            <span v-if="isSubmitting" class="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
            <span v-else>{{ editId ? 'Update' : 'Save' }} Schedule</span>
          </button>
        </div>
      </form>
    </AdminModal>

    <!-- Delete Confirmation Modal -->
    <AdminDeleteConfirm 
      v-if="showDeleteConfirm" 
      :is-deleting="isDeleting"
      title="Delete Schedule"
      message="Are you sure you want to delete this schedule? This will also delete any related bookings."
      @confirm="executeDelete"
      @cancel="showDeleteConfirm = false"
    />
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { 
  GET_ADMIN_SCHEDULES, 
  GET_ADMIN_FORM_DATA, 
  INSERT_SCHEDULE, 
  UPDATE_SCHEDULE, 
  DELETE_SCHEDULE 
} from '~/graphql/admin'

const { data, pending, refresh } = await useAsyncQuery<any>(GET_ADMIN_SCHEDULES)
const { data: formData } = await useAsyncQuery<any>(GET_ADMIN_FORM_DATA)

const { resolveClient } = useApolloClient()
const authCookie = useCookie('auth_token')

const schedules = computed(() => data.value?.schedules || [])

// Modal Logic
const showModal = ref(false)
const editId = ref<string | null>(null)
const isSubmitting = ref(false)
const errorMessage = ref('')

const form = reactive({
  movie_id: '',
  start_time: '',
  end_time: ''
})

const openModal = (schedule?: any) => {
  errorMessage.value = ''
  if (schedule) {
    editId.value = schedule.id
    form.movie_id = schedule.movie.id
    form.start_time = new Date(schedule.start_time).toISOString().slice(0, 16)
    form.end_time = new Date(schedule.end_time).toISOString().slice(0, 16)
  } else {
    editId.value = null
    form.movie_id = ''
    form.start_time = ''
    form.end_time = ''
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const handleSubmit = async () => {
  errorMessage.value = ''
  isSubmitting.value = true
  
  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }

    const payload = {
      movie_id: form.movie_id,
      start_time: new Date(form.start_time).toISOString(),
      end_time: new Date(form.end_time).toISOString()
    }

    if (editId.value) {
      await client.mutate({
        mutation: UPDATE_SCHEDULE,
        variables: { id: editId.value, set: payload },
        context: { headers }
      })
    } else {
      await client.mutate({
        mutation: INSERT_SCHEDULE,
        variables: { object: payload },
        context: { headers }
      })
    }

    await refresh()
    closeModal()
  } catch (err: any) {
    console.error(err)
    errorMessage.value = err.message || "An error occurred."
  } finally {
    isSubmitting.value = false
  }
}

// Delete Logic
const showDeleteConfirm = ref(false)
const isDeleting = ref(false)
const scheduleToDelete = ref<string | null>(null)

const confirmDelete = (id: string) => {
  scheduleToDelete.value = id
  showDeleteConfirm.value = true
}

const executeDelete = async () => {
  if (!scheduleToDelete.value) return
  isDeleting.value = true
  
  try {
    const client = resolveClient()
    await client.mutate({
      mutation: DELETE_SCHEDULE,
      variables: { id: scheduleToDelete.value },
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })
    await refresh()
    showDeleteConfirm.value = false
  } catch (err) {
    console.error("Failed to delete:", err)
    alert("Failed to delete schedule.")
  } finally {
    isDeleting.value = false
    scheduleToDelete.value = null
  }
}

const formatDate = (isoString: string) => {
  return new Date(isoString).toLocaleString('en-US', {
    month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit'
  })
}
</script>
