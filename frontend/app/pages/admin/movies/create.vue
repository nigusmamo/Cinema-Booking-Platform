<template>
  <div class="pb-16">

    <!-- Back Link -->
    <NuxtLink to="/admin/movies" class="inline-flex items-center gap-2 text-white/30 hover:text-white/60 text-[12px] font-semibold mb-6 transition-all">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"></line>
        <polyline points="12 19 5 12 12 5"></polyline>
      </svg>
      Back to Movies
    </NuxtLink>

    <!-- Title -->
    <h1 class="text-[20px] font-semibold text-white tracking-tight mb-8">Add Movie</h1>

    <!-- Two-panel layout -->
    <div class="grid grid-cols-1 lg:grid-cols-[1fr_300px] gap-8">

      <!-- LEFT PANEL: Form -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6 space-y-6">

        <!-- Error -->
        <div v-if="errorMessage" class="bg-red-500/[0.07] border border-red-500/[0.15] text-red-400 px-4 py-3 rounded-xl text-[12px]">
          {{ errorMessage }}
        </div>

        <form @submit="onSubmit" class="space-y-6">
          <!-- Section label -->
          <p class="text-[10px] font-semibold tracking-[0.22em] uppercase text-white/25">Basic Info</p>

          <!-- Title -->
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Movie Title</label>
            <input v-model="title" type="text" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" :class="{ 'border-red-500/50': errors.title }" placeholder="e.g. Inception">
            <p v-if="errors.title" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.title }}</p>
          </div>

          <!-- Description -->
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Description</label>
            <textarea v-model="description" rows="4" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all resize-none" :class="{ 'border-red-500/50': errors.description }" placeholder="Movie synopsis..."></textarea>
            <p v-if="errors.description" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.description }}</p>
          </div>

          <!-- Duration + Release Date -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Duration (min)</label>
              <input v-model="duration_minutes" type="number" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" :class="{ 'border-red-500/50': errors.duration_minutes }" placeholder="120">
              <p v-if="errors.duration_minutes" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.duration_minutes }}</p>
            </div>
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Release Date</label>
              <input v-model="release_date" type="date" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" :class="{ 'border-red-500/50': errors.release_date }" style="color-scheme: dark;">
              <p v-if="errors.release_date" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.release_date }}</p>
            </div>
          </div>

          <!-- Status + Rating -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Status</label>
              <select v-model="status" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all appearance-none cursor-pointer" :class="{ 'border-red-500/50': errors.status }">
                <option value="now_showing">Now Showing</option>
                <option value="coming_soon">Coming Soon</option>
                <option value="ended">Ended</option>
              </select>
            </div>
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Rating (0–10)</label>
              <input v-model="rating_avg" type="number" step="0.1" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" :class="{ 'border-red-500/50': errors.rating_avg }" placeholder="8.5">
              <p v-if="errors.rating_avg" class="text-red-400/80 text-[10px] mt-1.5">{{ errors.rating_avg }}</p>
            </div>
          </div>

          <!-- Credits section -->
          <div class="border-t border-white/[0.05] pt-6 space-y-6">
            <p class="text-[10px] font-semibold tracking-[0.22em] uppercase text-white/25">Credits</p>

            <!-- Director -->
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Director</label>
              <select v-model="selectedDirector" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all appearance-none cursor-pointer">
                <option value="" disabled>Select a director</option>
                <option v-for="director in allDirectors" :key="director.id" :value="director.id">{{ director.name }}</option>
              </select>
            </div>

            <!-- Genres -->
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Genres</label>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="genre in allGenres"
                  :key="genre.id"
                  type="button"
                  @click="toggleGenre(genre.id)"
                  class="px-3 py-1.5 rounded-lg text-[11px] font-semibold border transition-all"
                  :class="selectedGenres.includes(genre.id)
                    ? 'bg-[#EAB308] border-[#EAB308] text-black'
                    : 'border-white/[0.08] text-white/35 hover:border-white/[0.16]'"
                >
                  {{ genre.name }}
                </button>
              </div>
            </div>

            <!-- Stars -->
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Stars</label>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="star in allStars"
                  :key="star.id"
                  type="button"
                  @click="toggleStar(star.id)"
                  class="px-3 py-1.5 rounded-lg text-[11px] font-semibold border transition-all"
                  :class="selectedStars.includes(star.id)
                    ? 'bg-[#EAB308] border-[#EAB308] text-black'
                    : 'border-white/[0.08] text-white/35 hover:border-white/[0.16]'"
                >
                  {{ star.name }}
                </button>
              </div>
            </div>
          </div>

          <!-- Submit -->
          <button
            type="submit"
            class="w-full inline-flex items-center justify-center gap-2 bg-[#EAB308] text-black py-3 rounded-xl text-[12px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin"></span>
            <span v-else>Save Movie</span>
          </button>
        </form>
      </div>

      <!-- RIGHT PANEL: Image upload -->
      <div class="lg:sticky lg:top-8">
        <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden">
          <div class="px-5 py-4 border-b border-white/[0.05]">
            <p class="text-[11px] font-semibold text-white/50 tracking-widest uppercase">Poster Image</p>
          </div>

          <div
            @click="mainImageInput?.click()"
            @dragover.prevent @drop.prevent="handleDrop($event, 'main')"
            class="cursor-pointer hover:border-[#EAB308]/40 transition-all relative"
          >
            <input type="file" ref="mainImageInput" class="hidden" accept="image/jpeg, image/png" @change="handleFileSelect($event, 'main')">

            <div class="m-4 rounded-xl border-2 border-dashed border-white/[0.08] h-[280px] flex flex-col items-center justify-center relative overflow-hidden group hover:border-[#EAB308]/40 transition-all">
              <div v-if="mainImagePreview" class="absolute inset-0">
                <img :src="mainImagePreview" class="w-full h-full object-cover opacity-70 group-hover:opacity-50 transition" />
                <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition">
                  <span class="bg-black/80 px-4 py-2 rounded-lg text-[11px] font-semibold text-white/70">Change Image</span>
                </div>
              </div>

              <div v-else class="text-center px-6">
                <div class="w-10 h-10 bg-white/[0.04] border border-white/[0.06] rounded-xl flex items-center justify-center mx-auto mb-3 group-hover:border-[#EAB308]/30 group-hover:text-[#EAB308] text-white/20 transition-all">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                    <polyline points="21 15 16 10 5 21"></polyline>
                  </svg>
                </div>
                <p class="text-[12px] font-medium text-white/35 mb-1">Drop poster here</p>
                <p class="text-[10px] text-white/20">JPG or PNG</p>
              </div>
            </div>
          </div>

          <p v-if="!mainImagePreview && isSubmitting && !mainImageFile" class="text-red-400/70 text-[10px] px-5 pb-4">Poster image is required</p>
        </div>
      </div>
    </div>

    <!-- Gallery Images -->
    <div class="mt-6 bg-[#0D0D0D] border border-white/[0.06] rounded-2xl overflow-hidden">
      <div class="px-5 py-4 border-b border-white/[0.05] flex items-center justify-between">
        <div>
          <p class="text-[11px] font-semibold text-white/50 tracking-widest uppercase">Gallery Images</p>
          <p class="text-[10px] text-white/20 mt-0.5">Additional images shown on the movie detail page</p>
        </div>
        <span v-if="galleryFiles.length > 0" class="text-[9px] font-semibold text-white/30 tracking-widest">{{ galleryFiles.length }} selected</span>
      </div>
      <div
        @click="galleryInput?.click()"
        @dragover.prevent @drop.prevent="handleGalleryDrop"
        class="cursor-pointer m-4 rounded-xl border-2 border-dashed border-white/[0.08] p-5 flex items-center gap-4 hover:border-[#EAB308]/30 transition-all group">
        <input type="file" ref="galleryInput" class="hidden" accept="image/jpeg, image/png" multiple @change="handleGallerySelect">
        <div class="w-9 h-9 bg-white/[0.03] border border-white/[0.06] rounded-xl flex items-center justify-center text-white/20 group-hover:border-[#EAB308]/25 group-hover:text-[#EAB308]/60 transition-all flex-shrink-0">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>
          </svg>
        </div>
        <div>
          <p class="text-[12px] font-medium text-white/35">Click or drag to add gallery images</p>
          <p class="text-[10px] text-white/20 mt-0.5">JPG or PNG — multiple allowed</p>
        </div>
      </div>
      <div v-if="galleryPreviews.length > 0" class="px-4 pb-4 grid grid-cols-4 sm:grid-cols-6 gap-2">
        <div v-for="(img, idx) in galleryPreviews" :key="idx" class="relative aspect-video rounded-xl overflow-hidden border border-white/[0.06] group">
          <img :src="img" class="w-full h-full object-cover" />
          <button @click.stop="removeGalleryImage(idx)"
            class="absolute top-1 right-1 w-5 h-5 bg-black/70 rounded-full flex items-center justify-center text-white/70 hover:text-white opacity-0 group-hover:opacity-100 transition-all text-[12px] leading-none">×</button>
        </div>
      </div>
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
  INSERT_MOVIE_IMAGES,
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

const galleryFiles = ref<File[]>([])
const galleryPreviews = ref<string[]>([])
const galleryInput = ref<HTMLInputElement | null>(null)

const handleGallerySelect = (e: Event) => {
  const files = Array.from((e.target as HTMLInputElement).files ?? [])
  files.forEach(f => addGalleryFile(f))
}
const handleGalleryDrop = (e: DragEvent) => {
  Array.from(e.dataTransfer?.files ?? []).forEach(f => addGalleryFile(f))
}
const addGalleryFile = (file: File) => {
  if (!file.type.startsWith('image/')) return
  galleryFiles.value.push(file)
  const reader = new FileReader()
  reader.onload = (ev) => galleryPreviews.value.push(ev.target?.result as string)
  reader.readAsDataURL(file)
}
const removeGalleryImage = (idx: number) => {
  galleryFiles.value.splice(idx, 1)
  galleryPreviews.value.splice(idx, 1)
}

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

    // 6. Upload and insert gallery images
    if (galleryFiles.value.length > 0) {
      const uploadedUrls: string[] = []
      for (const file of galleryFiles.value) {
        const b64 = await fileToBase64(file)
        const res = await client.mutate({ mutation: UPLOAD_FILE, variables: { base64_data: b64, filename: file.name }, context: { headers } })
        if (res.data?.upload_file?.url) uploadedUrls.push(res.data.upload_file.url)
      }
      if (uploadedUrls.length > 0) {
        await client.mutate({
          mutation: INSERT_MOVIE_IMAGES,
          variables: { objects: uploadedUrls.map(url => ({ movie_id: movieId, image_url: url })) },
          context: { headers }
        })
      }
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
