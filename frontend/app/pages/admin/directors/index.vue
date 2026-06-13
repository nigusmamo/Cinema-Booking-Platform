<template>
  <div class="max-w-7xl mx-auto">
    
    <!-- Header -->
    <div class="flex items-center justify-between mb-10">
      <div>
        <h1 class="text-4xl font-black uppercase italic tracking-tighter mb-2">Manage <span class="text-[#EAB308]">Directors .</span></h1>
        <p class="text-gray-500 text-sm font-bold uppercase tracking-widest">Total: {{ directors.length }} Directors</p>
      </div>

      <button @click="openModal()" class="bg-[#EAB308] text-black px-8 py-3 rounded-xl font-black text-xs hover:scale-105 transition shadow-lg text-center flex items-center justify-center">
        + ADD DIRECTOR
      </button>
    </div>

    <div v-if="pending" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
      <div v-for="i in 10" :key="i" class="bg-[#0D0D0D] border border-white/5 rounded-[35px] h-48 animate-pulse"></div>
    </div>

    <div v-else-if="directors.length === 0" class="text-center py-20 bg-[#0D0D0D] border border-white/5 rounded-[35px]">
      <p class="text-gray-500 font-bold uppercase tracking-widest">No directors found.</p>
    </div>

    <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6 pb-20">
      <div v-for="director in directors" :key="director.id" class="bg-[#0D0D0D] border border-white/5 rounded-[35px] p-4 flex flex-col items-center hover:border-white/20 transition group shadow-2xl text-center relative overflow-hidden">
        
        <div class="w-24 h-24 rounded-full overflow-hidden mb-4 bg-gray-900 border-2 border-white/10 group-hover:border-[#EAB308] transition duration-500">
          <img v-if="director.image_url" :src="director.image_url" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
          <div v-else class="w-full h-full flex items-center justify-center text-gray-600">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
          </div>
        </div>
        
        <h3 class="font-black text-sm uppercase leading-tight line-clamp-2 mb-4">{{ director.name }}</h3>
        
        <div class="flex gap-2 w-full mt-auto">
          <button @click="openModal(director)" class="flex-1 bg-white/5 hover:bg-white/10 text-white py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition">
            Edit
          </button>
          <button @click="confirmDelete(director.id)" class="bg-red-500/10 hover:bg-red-500/20 text-red-500 p-2 rounded-xl transition">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
          </button>
        </div>
      </div>
    </div>

  </div>

  <!-- Modal for Create/Edit -->
  <AdminModal v-if="showModal" :title="editId ? 'Edit Director' : 'Add Director'" @close="closeModal" max-width="max-w-md">
    <form @submit.prevent="handleSubmit" class="space-y-6">
      
      <div v-if="errorMessage" class="bg-red-500/10 border border-red-500/20 text-red-500 p-4 rounded-xl text-sm font-bold">
        {{ errorMessage }}
      </div>

      <div>
        <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Director Name</label>
        <input v-model="form.name" type="text" required class="w-full bg-black border border-white/10 px-4 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" placeholder="e.g. Christopher Nolan">
      </div>

      <div>
        <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Photo</label>
        <div 
          @click="imageInput?.click()" 
          @dragover.prevent @drop.prevent="handleDrop"
          class="w-full h-40 border-2 border-dashed border-white/10 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-[#EAB308] transition overflow-hidden relative group bg-black"
        >
          <input type="file" ref="imageInput" class="hidden" accept="image/jpeg, image/png" @change="handleFileSelect">
          
          <div v-if="imagePreview" class="absolute inset-0">
            <img :src="imagePreview" class="w-full h-full object-cover opacity-60 group-hover:opacity-40 transition" />
            <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition">
              <span class="bg-black/80 px-4 py-2 rounded-xl text-xs font-bold">Change Image</span>
            </div>
          </div>
          
          <div v-else class="text-center">
            <div class="w-12 h-12 bg-white/5 rounded-full flex items-center justify-center mx-auto mb-2 group-hover:bg-[#EAB308]/10 group-hover:text-[#EAB308] transition">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
            </div>
            <p class="text-xs font-bold">Upload Photo</p>
          </div>
        </div>
      </div>

      <div class="pt-4 flex justify-end">
        <button type="submit" class="bg-[#EAB308] text-black px-8 py-4 rounded-2xl font-black text-xs uppercase tracking-widest hover:scale-105 transition shadow-xl w-full flex items-center justify-center" :disabled="isSubmitting">
          <span v-if="isSubmitting" class="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
          <span v-else>{{ editId ? 'Update' : 'Save' }} Director</span>
        </button>
      </div>
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
