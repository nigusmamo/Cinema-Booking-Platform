<template>
  <div class="max-w-4xl mx-auto pb-20">
    
    <!-- Header -->
    <div class="flex items-center gap-4 mb-8">
      <NuxtLink to="/admin/movies" class="bg-white/5 p-3 rounded-xl hover:bg-white/10 transition">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
      </NuxtLink>
      <div>
        <h1 class="text-3xl font-luxury uppercase italic tracking-tighter">Edit <span class="text-[#EAB308]">Movie .</span></h1>
      </div>
    </div>

    <div v-if="pendingData" class="flex justify-center py-20">
      <span class="w-10 h-10 border-4 border-[#EAB308]/30 border-t-[#EAB308] rounded-full animate-spin"></span>
    </div>

    <div v-else class="bg-[#0D0D0D] border border-white/5 rounded-[35px] shadow-2xl p-8 md:p-10">
      <form @submit.prevent="handleSubmit" class="space-y-8">
        
        <div v-if="errorMessage" class="bg-red-500/10 border border-red-500/20 text-red-500 p-4 rounded-xl text-sm font-bold">
          {{ errorMessage }}
        </div>

        <!-- Basic Info -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="md:col-span-2">
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Movie Title</label>
            <input v-model="form.title" type="text" required class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" placeholder="e.g. Inception">
          </div>

          <div class="md:col-span-2">
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Description</label>
            <textarea v-model="form.description" required rows="4" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition resize-none" placeholder="Movie synopsis..."></textarea>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Duration (Minutes)</label>
            <input v-model="form.duration_minutes" type="number" required class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" placeholder="120">
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Release Date</label>
            <input v-model="form.release_date" type="date" required class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" style="color-scheme: dark;">
          </div>

          <div>
             <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Status</label>
             <select v-model="form.status" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition appearance-none cursor-pointer">
               <option value="now_showing">Now Showing</option>
               <option value="coming_soon">Coming Soon</option>
               <option value="ended">Ended</option>
             </select>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Rating (0-10)</label>
            <input v-model="form.rating_avg" type="number" step="0.1" required class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" placeholder="8.5">
          </div>
        </div>

        <!-- Poster Upload -->
        <div>
          <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Main Poster Image</label>
          <div 
            @click="mainImageInput?.click()" 
            @dragover.prevent @drop.prevent="handleDrop($event, 'main')"
            class="w-full h-64 border-2 border-dashed border-white/10 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-[#EAB308] transition overflow-hidden relative group bg-black"
          >
            <input type="file" ref="mainImageInput" class="hidden" accept="image/jpeg, image/png" @change="handleFileSelect($event, 'main')">
            
            <div v-if="mainImagePreview" class="absolute inset-0">
              <img :src="mainImagePreview" class="w-full h-full object-cover opacity-60 group-hover:opacity-40 transition" />
              <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition">
                <span class="bg-black/80 px-4 py-2 rounded-xl text-xs font-bold">Change Image</span>
              </div>
            </div>
            
            <div v-else class="text-center">
              <div class="w-16 h-16 bg-white/5 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-[#EAB308]/10 group-hover:text-[#EAB308] transition">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
              </div>
              <p class="text-sm font-bold">Drag & Drop or Click to Upload</p>
              <p class="text-[10px] text-gray-500 mt-2 uppercase tracking-widest">JPG or PNG only</p>
            </div>
          </div>
        </div>

        <!-- RELATIONAL DROPDOWNS -->
        <div class="md:col-span-2 space-y-6 pt-4 border-t border-white/5">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div v-if="!pendingFormData">
              <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Director</label>
              <select v-model="form.selectedDirectorId" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition appearance-none cursor-pointer">
                <option value="" disabled>Select a director</option>
                <option v-for="director in formData?.directors" :key="director.id" :value="director.id">{{ director.name }}</option>
              </select>
            </div>
            <div v-if="!pendingFormData">
              <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Genres</label>
              <div class="flex flex-wrap gap-2">
                <button 
                  v-for="genre in formData?.genres" 
                  :key="genre.id"
                  type="button"
                  @click="toggleRelation('genre_ids', genre.id)"
                  class="px-4 py-2 rounded-xl text-xs font-bold border transition"
                  :class="form.genre_ids.includes(genre.id) ? 'bg-[#EAB308] text-black border-[#EAB308]' : 'bg-black border-white/10 hover:border-white/30'"
                >
                  {{ genre.name }}
                </button>
              </div>
            </div>
          </div>

          <div v-if="!pendingFormData">
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Stars (Multi-select)</label>
            <div class="flex flex-wrap gap-2">
              <button 
                v-for="star in formData?.stars" 
                :key="star.id"
                type="button"
                @click="toggleRelation('star_ids', star.id)"
                class="px-4 py-2 rounded-xl text-xs font-bold border transition"
                :class="form.star_ids.includes(star.id) ? 'bg-[#EAB308] text-black border-[#EAB308]' : 'bg-black border-white/10 hover:border-white/30'"
              >
                {{ star.name }}
              </button>
            </div>
          </div>
        </div>

        <!-- Submit -->
        <div class="pt-8 flex justify-end">
          <button 
            type="submit" 
            class="bg-[#EAB308] text-black px-12 py-4 rounded-2xl font-black text-sm uppercase tracking-widest hover:scale-105 active:scale-95 transition shadow-xl shadow-[#EAB308]/20 flex items-center justify-center min-w-[200px]"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="w-5 h-5 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
            <span v-else>Update Movie</span>
          </button>
        </div>

      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { 
  GET_ADMIN_FORM_DATA, 
  UPLOAD_FILE, 
  UPDATE_MOVIE,
  DELETE_MOVIE_DIRECTORS,
  INSERT_MOVIE_DIRECTORS,
  DELETE_MOVIE_STARS,
  INSERT_MOVIE_STARS,
  DELETE_MOVIE_GENRES,
  INSERT_MOVIE_GENRES,
  GET_MOVIE_BY_ID
} from '~/graphql/admin'

const route = useRoute()
const movieId = route.params.id as string

const { data: formData, pending: pendingFormData } = await useAsyncQuery<any>(GET_ADMIN_FORM_DATA)
const { resolveClient } = useApolloClient()
const authCookie = useCookie('auth_token')

const form = reactive({
  title: '',
  description: '',
  duration_minutes: null as number | null,
  release_date: '',
  status: 'now_showing',
  rating_avg: 0 as number,
  selectedDirectorId: '' as string,
  star_ids: [] as string[],
  genre_ids: [] as string[]
})

const mainImageFile = ref<File | null>(null)
const mainImagePreview = ref<string | null>(null)
const existingImageUrl = ref<string | null>(null)

const isSubmitting = ref(false)
const errorMessage = ref('')
const mainImageInput = ref<HTMLInputElement | null>(null)
const pendingData = ref(true)

const toggleRelation = (field: 'star_ids' | 'genre_ids', id: string) => {
  if (form[field].includes(id)) {
    form[field] = form[field].filter(item => item !== id)
  } else {
    form[field].push(id)
  }
}

// Fetch Existing Movie Data
onMounted(async () => {
  try {
    const client = resolveClient()
    const { data } = await client.query({
      query: GET_MOVIE_BY_ID,
      variables: { id: movieId },
      fetchPolicy: 'no-cache'
    })
    
    const movie = data?.movies_by_pk
    if (movie) {
      form.title = movie.title
      form.description = movie.description
      form.duration_minutes = movie.duration_minutes
      // Format date for input type="date"
      form.release_date = movie.release_date ? (new Date(movie.release_date).toISOString().split('T')[0] || '') : ''
      form.status = movie.status
      form.rating_avg = movie.rating_avg || 0
      form.selectedDirectorId = movie.movie_directors?.[0]?.director?.id || ''
      mainImagePreview.value = movie.main_image
      existingImageUrl.value = movie.main_image

      form.star_ids = movie.movie_stars?.map((ms: any) => ms.star.id) || []
      form.genre_ids = movie.movie_genres?.map((mg: any) => mg.genre.id) || []
    }
  } catch (err) {
    console.error("Failed to load movie:", err)
    errorMessage.value = "Failed to load movie data."
  } finally {
    pendingData.value = false
  }
})

// File Handling
const processFile = (file: File, type: 'main') => {
  if (!file.type.startsWith('image/')) {
    errorMessage.value = "Only image files are allowed."
    return
  }
  
  if (type === 'main') {
    mainImageFile.value = file
    const reader = new FileReader()
    reader.onload = (e) => { mainImagePreview.value = e.target?.result as string }
    reader.readAsDataURL(file)
  }
}

const handleDrop = (e: DragEvent, type: 'main') => {
  const file = e.dataTransfer?.files[0]
  if (file) processFile(file, type)
}

const handleFileSelect = (e: Event, type: 'main') => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (file) processFile(file, type)
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

    let imageUrl: string = existingImageUrl.value || ''

    // 1. Upload Image via Hasura Action if changed
    if (mainImageFile.value) {
      const base64Data = await fileToBase64(mainImageFile.value)
      const uploadRes = await client.mutate({
        mutation: UPLOAD_FILE,
        variables: {
          base64_data: base64Data,
          filename: mainImageFile.value.name
        },
        context: { headers }
      })
      imageUrl = uploadRes.data?.upload_file?.url
      if (!imageUrl) throw new Error("Image upload failed.")
    }

    // 2. Update Movie
    await client.mutate({
      mutation: UPDATE_MOVIE,
      variables: {
        id: movieId,
        set: {
          title: form.title,
          description: form.description,
          duration_minutes: form.duration_minutes,
          release_date: form.release_date,
          status: form.status,
          rating_avg: form.rating_avg,
          main_image: imageUrl
        }
      },
      context: { headers }
    })

    // 3. Update Relations (Delete existing then Insert new)
    await client.mutate({ mutation: DELETE_MOVIE_DIRECTORS, variables: { movie_id: movieId }, context: { headers } })
    if (form.selectedDirectorId) {
      await client.mutate({
        mutation: INSERT_MOVIE_DIRECTORS,
        variables: { 
          objects: [{
            movie_id: movieId,
            director_id: form.selectedDirectorId
          }]
        },
        context: { headers }
      })
    }

    // Stars
    await client.mutate({ mutation: DELETE_MOVIE_STARS, variables: { movie_id: movieId }, context: { headers } })
    if (form.star_ids.length > 0) {
      await client.mutate({
        mutation: INSERT_MOVIE_STARS,
        variables: { objects: form.star_ids.map(id => ({ movie_id: movieId, star_id: id })) },
        context: { headers }
      })
    }

    // Genres
    await client.mutate({ mutation: DELETE_MOVIE_GENRES, variables: { movie_id: movieId }, context: { headers } })
    if (form.genre_ids.length > 0) {
      await client.mutate({
        mutation: INSERT_MOVIE_GENRES,
        variables: { objects: form.genre_ids.map(id => ({ movie_id: movieId, genre_id: id })) },
        context: { headers }
      })
    }

    // Success, go back to list
    navigateTo('/admin/movies')

  } catch (err: any) {
    console.error(err)
    errorMessage.value = err.message || "An error occurred while updating the movie."
  } finally {
    isSubmitting.value = false
  }
}
</script>
