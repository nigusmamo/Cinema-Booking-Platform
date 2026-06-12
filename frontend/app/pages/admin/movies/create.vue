<template>
  <div class="max-w-4xl mx-auto pb-20">
    
    <!-- Header -->
    <div class="flex items-center gap-4 mb-8">
      <NuxtLink to="/admin/movies" class="bg-white/5 p-3 rounded-xl hover:bg-white/10 transition">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
      </NuxtLink>
      <div>
        <h1 class="text-3xl font-luxury uppercase italic tracking-tighter">Add <span class="text-[#EAB308]">Movie .</span></h1>
      </div>
    </div>

    <div class="bg-[#0D0D0D] border border-white/5 rounded-[35px] shadow-2xl p-8 md:p-10">
      <form @submit="onSubmit" class="space-y-8">
        
        <div v-if="errorMessage" class="bg-red-500/10 border border-red-500/20 text-red-500 p-4 rounded-xl text-sm font-bold">
          {{ errorMessage }}
        </div>

        <!-- Basic Info -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="md:col-span-2">
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Movie Title</label>
            <input v-model="title" type="text" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" :class="{ 'border-red-500': errors.title }" placeholder="e.g. Inception">
            <p v-if="errors.title" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.title }}</p>
          </div>

          <div class="md:col-span-2">
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Description</label>
            <textarea v-model="description" rows="4" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition resize-none" :class="{ 'border-red-500': errors.description }" placeholder="Movie synopsis..."></textarea>
            <p v-if="errors.description" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.description }}</p>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Duration (Minutes)</label>
            <input v-model="duration_minutes" type="number" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" :class="{ 'border-red-500': errors.duration_minutes }" placeholder="120">
            <p v-if="errors.duration_minutes" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.duration_minutes }}</p>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Release Date</label>
            <input v-model="release_date" type="date" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" :class="{ 'border-red-500': errors.release_date }" style="color-scheme: dark;">
            <p v-if="errors.release_date" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.release_date }}</p>
          </div>

          <div>
             <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Status</label>
             <select v-model="status" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition appearance-none cursor-pointer" :class="{ 'border-red-500': errors.status }">
               <option value="now_showing">Now Showing</option>
               <option value="coming_soon">Coming Soon</option>
               <option value="ended">Ended</option>
             </select>
             <p v-if="errors.status" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.status }}</p>
          </div>

          <div>
            <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Rating (0-10)</label>
            <input v-model="rating_avg" type="number" step="0.1" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition" :class="{ 'border-red-500': errors.rating_avg }" placeholder="8.5">
            <p v-if="errors.rating_avg" class="text-red-500 text-[10px] mt-1 uppercase font-bold">{{ errors.rating_avg }}</p>
          </div>

          <!-- RELATIONAL DROPDOWNS -->
          <div class="md:col-span-2 space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Director</label>
                <select v-model="selectedDirector" class="w-full bg-black border border-white/10 px-6 py-4 rounded-2xl focus:outline-none focus:border-[#EAB308] text-white transition appearance-none cursor-pointer">
                  <option value="" disabled>Select a director</option>
                  <option v-for="director in allDirectors" :key="director.id" :value="director.id">{{ director.name }}</option>
                </select>
              </div>
              <div>
                <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Genres</label>
                <div class="flex flex-wrap gap-2">
                  <button 
                    v-for="genre in allGenres" 
                    :key="genre.id"
                    type="button"
                    @click="toggleGenre(genre.id)"
                    class="px-4 py-2 rounded-xl text-xs font-bold border transition"
                    :class="selectedGenres.includes(genre.id) ? 'bg-[#EAB308] text-black border-[#EAB308]' : 'bg-black border-white/10 hover:border-white/30'"
                  >
                    {{ genre.name }}
                  </button>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Stars (Multi-select)</label>
              <div class="flex flex-wrap gap-2">
                <button 
                  v-for="star in allStars" 
                  :key="star.id"
                  type="button"
                  @click="toggleStar(star.id)"
                  class="px-4 py-2 rounded-xl text-xs font-bold border transition"
                  :class="selectedStars.includes(star.id) ? 'bg-[#EAB308] text-black border-[#EAB308]' : 'bg-black border-white/10 hover:border-white/30'"
                >
                  {{ star.name }}
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Poster Upload -->
        <div>
          <label class="block text-[10px] text-gray-500 font-black uppercase tracking-widest mb-2">Main Poster Image</label>
          <div 
            @click="mainImageInput?.click()" 
            @dragover.prevent @drop.prevent="handleDrop($event, 'main')"
            class="w-full h-64 border-2 border-dashed border-white/10 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-[#EAB308] transition overflow-hidden relative group bg-black"
            :class="{ 'border-red-500': !mainImagePreview && isSubmitting && !mainImageFile }"
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
              <p class="text-[10px] text-gray-500 mt-2 uppercase tracking-widest">JPG or PNG</p>
            </div>
          </div>
          <p v-if="!mainImagePreview && isSubmitting && !mainImageFile" class="text-red-500 text-[10px] mt-1 uppercase font-bold">Poster image is required</p>
        </div>

        <!-- Submit -->
        <div class="pt-8 flex justify-end">
          <button 
            type="submit" 
            class="bg-[#EAB308] text-black px-12 py-4 rounded-2xl font-black text-sm uppercase tracking-widest hover:scale-105 active:scale-95 transition shadow-xl shadow-[#EAB308]/20 flex items-center justify-center min-w-[200px]"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="w-5 h-5 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
            <span v-else>Save Movie</span>
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
  UPLOAD_FILE, 
  INSERT_MOVIE,
  GET_ADMIN_FORM_DATA,
  INSERT_MOVIE_GENRES,
  INSERT_MOVIE_DIRECTORS,
  INSERT_MOVIE_STARS,
  GET_ADMIN_MOVIES
} from '~/graphql/admin'

const { resolveClient } = await useApolloClient()
const authCookie = useCookie('auth_token')

// Fetch Form Data
const { data: formData } = await useAsyncQuery<any>(GET_ADMIN_FORM_DATA)
const allGenres = computed(() => formData.value?.genres || [])
const allDirectors = computed(() => formData.value?.directors || [])
const allStars = computed(() => formData.value?.stars || [])

const selectedGenres = ref<string[]>([])
const selectedDirector = ref<string>('')
const selectedStars = ref<string[]>([])

const toggleGenre = (id: string) => {
  if (selectedGenres.value.includes(id)) {
    selectedGenres.value = selectedGenres.value.filter(g => g !== id)
  } else {
    selectedGenres.value.push(id)
  }
}

const toggleStar = (id: string) => {
  if (selectedStars.value.includes(id)) {
    selectedStars.value = selectedStars.value.filter(s => s !== id)
  } else {
    selectedStars.value.push(id)
  }
}

// Validation Rules
const required = (val: any) => !!val || 'This field is required'
const isNumber = (val: any) => !isNaN(Number(val)) || 'Must be a number'
const ratingRange = (val: any) => (Number(val) >= 0 && Number(val) <= 10) || 'Rating must be between 0 and 10'

interface MovieFormValues {
  title: string
  description: string
  duration_minutes: number
  release_date: string
  status: string
  rating_avg: number
}

const { handleSubmit, errors } = useForm<MovieFormValues>({
  initialValues: {
    title: '',
    description: '',
    duration_minutes: 120,
    release_date: '',
    status: 'now_showing',
    rating_avg: 0
  }
})

const { value: title } = useField<string>('title', required)
const { value: description } = useField<string>('description', required)
const { value: duration_minutes } = useField<number>('duration_minutes', (val) => required(val) === true ? isNumber(val) : required(val))
const { value: release_date } = useField<string>('release_date', required)
const { value: status } = useField<string>('status', required)
const { value: rating_avg } = useField<number>('rating_avg', (val) => required(val) === true ? ratingRange(val) : required(val))

const mainImageFile = ref<File | null>(null)
const mainImagePreview = ref<string | null>(null)

const isSubmitting = ref(false)
const errorMessage = ref('')
const mainImageInput = ref<HTMLInputElement | null>(null)

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

const onSubmit = handleSubmit(async (values: MovieFormValues) => {
  errorMessage.value = ''
  
  if (!mainImageFile.value) {
    return
  }

  isSubmitting.value = true
  
  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }

    // 1. Upload Image via Hasura Action
    const base64Data = await fileToBase64(mainImageFile.value)
    
    const uploadRes = await client.mutate({
      mutation: UPLOAD_FILE,
      variables: {
        base64_data: base64Data,
        filename: mainImageFile.value.name
      },
      context: { headers }
    })
    
    const imageUrl = uploadRes.data?.upload_file?.url
    if (!imageUrl) throw new Error("Image upload failed.")

    // 2. Insert Movie
    const now = new Date().toISOString()
    const movieRes = await client.mutate({
      mutation: INSERT_MOVIE,
      variables: {
        object: {
          title: values.title,
          description: values.description,
          duration_minutes: values.duration_minutes,
          release_date: values.release_date,
          status: values.status,
          rating_avg: values.rating_avg,
          main_image: imageUrl,
          created_at: now,
          updated_at: now
        }
      },
      context: { headers },
      refetchQueries: [{ query: GET_ADMIN_MOVIES }]
    })

    const movieId = movieRes.data?.insert_movies_one?.id
    if (!movieId) throw new Error("Movie insertion failed.")

    // 3. Insert Movie Genres
    if (selectedGenres.value.length > 0) {
      await client.mutate({
        mutation: INSERT_MOVIE_GENRES,
        variables: {
          objects: selectedGenres.value.map(genreId => ({
            movie_id: movieId,
            genre_id: genreId
          }))
        },
        context: { headers }
      })
    }

    // 4. Insert Movie Director
    if (selectedDirector.value) {
      await client.mutate({
        mutation: INSERT_MOVIE_DIRECTORS,
        variables: {
          objects: [{
            movie_id: movieId,
            director_id: selectedDirector.value
          }]
        },
        context: { headers }
      })
    }

    // 5. Insert Movie Stars
    if (selectedStars.value.length > 0) {
      await client.mutate({
        mutation: INSERT_MOVIE_STARS,
        variables: {
          objects: selectedStars.value.map(starId => ({
            movie_id: movieId,
            star_id: starId
          }))
        },
        context: { headers }
      })
    }

    // Success
    navigateTo('/admin/movies')

  } catch (err: any) {
    console.error(err)
    errorMessage.value = err.message || "An error occurred while saving the movie."
  } finally {
    isSubmitting.value = false
  }
})
</script>
