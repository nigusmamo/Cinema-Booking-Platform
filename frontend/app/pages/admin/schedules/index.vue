<template>
  <div class="pb-16">

    <!-- Page Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
      <div>
        <p class="text-[10px] font-semibold tracking-[0.3em] text-white/25 uppercase mb-1">Programming</p>
        <h1 class="text-[22px] font-semibold text-white tracking-tight leading-none mb-1">Schedules</h1>
        <p class="text-[12px] text-white/30">{{ schedules.length }} total schedules</p>
      </div>

      <button
        @click="openModal()"
        class="inline-flex items-center gap-2 bg-[#EAB308] text-black px-5 py-2.5 rounded-lg text-[11px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all self-start sm:self-auto"
      >
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Add Schedule
      </button>
    </div>

    <!-- Loading -->
    <div v-if="pending" class="flex justify-center py-20">
      <span class="w-8 h-8 border-2 border-[#EAB308]/20 border-t-[#EAB308] rounded-full animate-spin"></span>
    </div>

    <!-- Empty State -->
    <div v-else-if="schedules.length === 0" class="py-20 flex flex-col items-center justify-center gap-3">
      <div class="w-12 h-12 rounded-2xl bg-white/[0.04] border border-white/[0.06] flex items-center justify-center">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/20">
          <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
          <line x1="16" y1="2" x2="16" y2="6"></line>
          <line x1="8" y1="2" x2="8" y2="6"></line>
          <line x1="3" y1="10" x2="21" y2="10"></line>
        </svg>
      </div>
      <p class="text-[12px] text-white/25 font-medium">No schedules found</p>
    </div>

    <!-- Schedule List -->
    <div v-else class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden">
      <!-- Column Headers -->
      <div class="px-6 py-3 border-b border-white/[0.05] hidden md:grid md:grid-cols-[80px_1fr_140px_100px_80px] gap-4 text-[10px] font-semibold tracking-[0.2em] uppercase text-white/25">
        <span>Poster</span>
        <span>Film</span>
        <span>Date &amp; Time</span>
        <span>Duration</span>
        <span>Actions</span>
      </div>

      <!-- Rows -->
      <div
        v-for="schedule in schedules"
        :key="schedule.id"
        class="grid grid-cols-[56px_1fr_auto] md:grid-cols-[80px_1fr_140px_100px_80px] gap-4 items-center px-6 py-4 border-b border-white/[0.04] last:border-b-0 hover:bg-white/[0.02] transition-colors"
      >
        <!-- Poster -->
        <div class="w-10 h-14 rounded-lg overflow-hidden flex-shrink-0 bg-white/[0.04]">
          <img :src="schedule.movie.main_image" class="w-full h-full object-cover" />
        </div>

        <!-- Title -->
        <div class="min-w-0">
          <p class="text-[13px] font-semibold text-white line-clamp-1">{{ schedule.movie.title }}</p>
          <p class="text-[11px] text-white/30 mt-0.5 md:hidden">{{ formatDate(schedule.start_time) }}</p>
        </div>

        <!-- Date & Time -->
        <p class="text-[12px] text-white/45 hidden md:block">{{ formatDate(schedule.start_time) }}</p>

        <!-- Duration -->
        <p class="text-[12px] text-white/45 hidden md:block">{{ schedule.movie.duration_minutes }} min</p>

        <!-- Actions -->
        <div class="flex items-center gap-1.5">
          <button
            @click="openModal(schedule)"
            class="w-7 h-7 flex items-center justify-center rounded-lg bg-white/[0.04] hover:bg-white/[0.08] text-white/40 hover:text-white/80 transition-all"
          >
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
            </svg>
          </button>
          <button
            @click="confirmDelete(schedule.id)"
            class="w-7 h-7 flex items-center justify-center rounded-lg bg-red-500/[0.06] hover:bg-red-500/[0.14] text-red-500/50 hover:text-red-400 transition-all"
          >
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="3 6 5 6 21 6"></polyline>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Modal for Create/Edit -->
    <AdminModal v-if="showModal" :title="editId ? 'Edit Schedule' : 'Add Schedule'" @close="closeModal" max-width="max-w-md">
      <form @submit.prevent="handleSubmit" class="space-y-5">

        <div v-if="errorMessage" class="bg-red-500/[0.07] border border-red-500/[0.15] text-red-400 px-4 py-3 rounded-xl text-[12px]">
          {{ errorMessage }}
        </div>

        <div>
          <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Movie</label>
          <select v-model="form.movie_id" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all appearance-none cursor-pointer">
            <option value="" disabled>Select Movie</option>
            <option v-for="m in formData?.movies" :key="m.id" :value="m.id">{{ m.title }}</option>
          </select>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Start Time</label>
            <input v-model="form.start_time" type="datetime-local" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all" style="color-scheme: dark;">
          </div>
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">End Time</label>
            <input v-model="form.end_time" type="datetime-local" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all" style="color-scheme: dark;">
          </div>
        </div>

        <button
          type="submit"
          class="w-full inline-flex items-center justify-center gap-2 bg-[#EAB308] text-black py-2.5 rounded-lg text-[11px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all mt-2"
          :disabled="isSubmitting"
        >
          <span v-if="isSubmitting" class="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
          <span v-else>{{ editId ? 'Update' : 'Save' }} Schedule</span>
        </button>
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
