<template>
  <div class="pb-16">

    <!-- Page Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
      <div>
        <p class="text-[10px] font-semibold tracking-[0.3em] text-white/25 uppercase mb-1">Creative Team</p>
        <h1 class="text-[22px] font-semibold text-white tracking-tight leading-none mb-1">Directors</h1>
        <p class="text-[12px] text-white/30">{{ filteredDirectors.length }} total directors</p>
      </div>

      <div class="flex items-center gap-3">
        <!-- Search -->
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 text-white/20" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search directors..."
            class="w-60 bg-[#111111] border border-white/[0.08] rounded-xl pl-9 pr-4 py-2.5 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all"
          />
        </div>

        <button
          @click="openModal()"
          class="inline-flex items-center gap-2 bg-[#EAB308] text-black px-5 py-2.5 rounded-lg text-[11px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all"
        >
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          Add Director
        </button>
      </div>
    </div>

    <!-- Skeleton -->
    <div v-if="pending" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-5">
      <div v-for="i in 12" :key="i" class="rounded-2xl h-[180px] bg-white/[0.03] animate-pulse"></div>
    </div>

    <!-- Empty State -->
    <div v-else-if="filteredDirectors.length === 0" class="py-20 flex flex-col items-center justify-center gap-3">
      <div class="w-12 h-12 rounded-2xl bg-white/[0.04] border border-white/[0.06] flex items-center justify-center">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/20">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
          <circle cx="12" cy="7" r="4"></circle>
        </svg>
      </div>
      <p class="text-[12px] text-white/25 font-medium">No directors found</p>
    </div>

    <!-- Director Grid -->
    <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-5">
      <div
        v-for="director in paginatedDirectors"
        :key="director.id"
        class="group bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-5 flex flex-col items-center text-center hover:border-white/[0.12] transition-all duration-300"
      >
        <!-- Photo -->
        <div class="w-16 h-16 rounded-2xl overflow-hidden mb-4 bg-white/[0.03] border border-white/[0.06] group-hover:border-[#EAB308]/30 transition-all">
          <img v-if="director.image_url" :src="director.image_url" class="w-full h-full object-cover">
          <div v-else class="w-full h-full flex items-center justify-center text-white/15">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
              <circle cx="12" cy="7" r="4"></circle>
            </svg>
          </div>
        </div>

        <!-- Name -->
        <p class="text-[12px] font-semibold text-white/80 group-hover:text-white mb-4 line-clamp-2 transition-colors leading-snug">{{ director.name }}</p>

        <!-- Actions -->
        <div class="flex gap-2 w-full mt-auto">
          <button
            @click="openModal(director)"
            class="flex-1 flex items-center justify-center py-2 rounded-lg bg-white/[0.04] hover:bg-white/[0.08] text-white/35 hover:text-white/70 transition-all"
          >
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
            </svg>
          </button>
          <button
            @click="confirmDelete(director.id)"
            class="flex-1 flex items-center justify-center py-2 rounded-lg bg-red-500/[0.06] hover:bg-red-500/[0.14] text-red-500/50 hover:text-red-400 transition-all"
          >
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="3 6 5 6 21 6"></polyline>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <AdminPagination v-model="currentPage" :total-items="filteredDirectors.length" :page-size="pageSize" />

  </div>

  <!-- Modal for Create/Edit -->
  <AdminModal v-if="showModal" :title="editId ? 'Edit Director' : 'Add Director'" @close="closeModal" max-width="max-w-md">
    <form @submit.prevent="handleSubmit" class="space-y-5">

      <div v-if="errorMessage" class="bg-red-500/[0.07] border border-red-500/[0.15] text-red-400 px-4 py-3 rounded-xl text-[12px]">
        {{ errorMessage }}
      </div>

      <div>
        <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Director Name</label>
        <input v-model="form.name" type="text" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" placeholder="e.g. Christopher Nolan">
      </div>

      <div>
        <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Photo</label>
        <div
          @click="imageInput?.click()"
          @dragover.prevent @drop.prevent="handleDrop"
          class="w-full h-40 border-2 border-dashed border-white/[0.08] rounded-xl flex flex-col items-center justify-center cursor-pointer hover:border-[#EAB308]/40 transition-all overflow-hidden relative group bg-[#111111]"
        >
          <input type="file" ref="imageInput" class="hidden" accept="image/jpeg, image/png" @change="handleFileSelect">

          <div v-if="imagePreview" class="absolute inset-0">
            <img :src="imagePreview" class="w-full h-full object-cover opacity-60 group-hover:opacity-40 transition" />
            <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition">
              <span class="bg-black/80 px-4 py-2 rounded-lg text-[11px] font-semibold text-white/70">Change Photo</span>
            </div>
          </div>

          <div v-else class="text-center">
            <div class="w-10 h-10 bg-white/[0.04] border border-white/[0.06] rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:border-[#EAB308]/30 group-hover:text-[#EAB308] text-white/20 transition-all">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                <polyline points="17 8 12 3 7 8"></polyline>
                <line x1="12" y1="3" x2="12" y2="15"></line>
              </svg>
            </div>
            <p class="text-[11px] font-medium text-white/30">Upload Photo</p>
          </div>
        </div>
      </div>

      <button
        type="submit"
        class="w-full inline-flex items-center justify-center gap-2 bg-[#EAB308] text-black py-2.5 rounded-lg text-[11px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all"
        :disabled="isSubmitting"
      >
        <span v-if="isSubmitting" class="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
        <span v-else>{{ editId ? 'Update' : 'Save' }} Director</span>
      </button>
    </form>
  </AdminModal>

  <!-- Delete Confirmation Modal -->
  <AdminDeleteConfirm
    v-if="showDeleteConfirm"
    :is-deleting="isDeleting"
    title="Delete Director"
    message="Are you sure you want to delete this director? This might fail if the director is currently attached to any movies."
    @confirm="executeDelete"
    @cancel="showDeleteConfirm = false"
  />
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import {
  GET_ADMIN_FORM_DATA,
  INSERT_DIRECTOR,
  UPDATE_DIRECTOR,
  DELETE_DIRECTOR,
  UPLOAD_FILE
} from '~/graphql/admin'
import { useQuery, useApolloClient } from '@vue/apollo-composable'

const { result, loading: pending, refetch } = useQuery(GET_ADMIN_FORM_DATA)
const { resolveClient } = useApolloClient()
const authCookie = useCookie('auth_token')

const directors = computed(() => result.value?.directors || [])

const searchQuery = ref('')
const filteredDirectors = computed(() => {
  if (!searchQuery.value) return directors.value
  const query = searchQuery.value.toLowerCase()
  return directors.value.filter((d: any) => d.name.toLowerCase().includes(query))
})

// Pagination
const pageSize = 18
const currentPage = ref(1)
const paginatedDirectors = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  return filteredDirectors.value.slice(start, start + pageSize)
})

// Reset to first page on search; clamp if the list shrinks (e.g. after delete)
watch(searchQuery, () => { currentPage.value = 1 })
watch(filteredDirectors, (list) => {
  const lastPage = Math.max(1, Math.ceil(list.length / pageSize))
  if (currentPage.value > lastPage) currentPage.value = lastPage
})

// Modal Logic
const showModal = ref(false)
const editId = ref<string | null>(null)
const isSubmitting = ref(false)
const errorMessage = ref('')
const imageInput = ref<HTMLInputElement | null>(null)

const form = reactive({
  name: ''
})

const imageFile = ref<File | null>(null)
const imagePreview = ref<string | null>(null)
const existingImageUrl = ref<string | null>(null)

const openModal = (director?: any) => {
  errorMessage.value = ''
  imageFile.value = null
  if (director) {
    editId.value = director.id
    form.name = director.name
    imagePreview.value = director.image_url
    existingImageUrl.value = director.image_url
  } else {
    editId.value = null
    form.name = ''
    imagePreview.value = null
    existingImageUrl.value = null
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

// File Handling
const processFile = (file: File) => {
  if (!file.type.startsWith('image/')) {
    errorMessage.value = "Only image files are allowed."
    return
  }
  imageFile.value = file
  const reader = new FileReader()
  reader.onload = (e) => { imagePreview.value = e.target?.result as string }
  reader.readAsDataURL(file)
}

const handleDrop = (e: DragEvent) => {
  const file = e.dataTransfer?.files[0]
  if (file) processFile(file)
}

const handleFileSelect = (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (file) processFile(file)
}

const fileToBase64 = (file: File): Promise<string> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(file)
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = error => reject(error)
  })
}

const handleSubmit = async () => {
  errorMessage.value = ''
  isSubmitting.value = true

  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }

    let imageUrl = existingImageUrl.value

    if (imageFile.value) {
      const base64Data = await fileToBase64(imageFile.value)
      const uploadRes = await client.mutate({
        mutation: UPLOAD_FILE,
        variables: { base64_data: base64Data, filename: imageFile.value.name },
        context: { headers }
      })
      imageUrl = uploadRes.data?.upload_file?.url
      if (!imageUrl) throw new Error("Image upload failed.")
    }

    if (editId.value) {
      await client.mutate({
        mutation: UPDATE_DIRECTOR,
        variables: { id: editId.value, name: form.name, image_url: imageUrl },
        context: { headers }
      })
    } else {
      await client.mutate({
        mutation: INSERT_DIRECTOR,
        variables: { name: form.name, image_url: imageUrl },
        context: { headers }
      })
    }

    await refetch()
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
const directorToDelete = ref<string | null>(null)

const confirmDelete = (id: string) => {
  directorToDelete.value = id
  showDeleteConfirm.value = true
}

const executeDelete = async () => {
  if (!directorToDelete.value) return
  isDeleting.value = true

  try {
    const client = resolveClient()
    await client.mutate({
      mutation: DELETE_DIRECTOR,
      variables: { id: directorToDelete.value },
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } }
    })
    await refetch()
    showDeleteConfirm.value = false
  } catch (err: any) {
    console.error("Failed to delete:", err)
    alert("Failed to delete director. They might be linked to a movie.")
  } finally {
    isDeleting.value = false
    directorToDelete.value = null
  }
}
</script>
