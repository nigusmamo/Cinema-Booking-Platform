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
    <h1 class="text-[20px] font-semibold text-white tracking-tight mb-8">Edit Movie</h1>

    <!-- Loading -->
    <div v-if="pendingData" class="flex justify-center py-20">
      <span class="w-8 h-8 border-2 border-[#EAB308]/20 border-t-[#EAB308] rounded-full animate-spin"></span>
    </div>

    <!-- Two-panel layout -->
    <div v-else class="grid grid-cols-1 lg:grid-cols-[1fr_300px] gap-8">

      <!-- LEFT PANEL: Form -->
      <div class="bg-[#0D0D0D] border border-white/[0.06] rounded-2xl p-6 space-y-6">

        <!-- Error -->
        <div v-if="errorMessage" class="bg-red-500/[0.07] border border-red-500/[0.15] text-red-400 px-4 py-3 rounded-xl text-[12px]">
          {{ errorMessage }}
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Section label -->
          <p class="text-[10px] font-semibold tracking-[0.22em] uppercase text-white/25">Basic Info</p>

          <!-- Title -->
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Movie Title</label>
            <input v-model="form.title" type="text" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" placeholder="e.g. Inception">
          </div>

          <!-- Description -->
          <div>
            <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Description</label>
            <textarea v-model="form.description" required rows="4" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all resize-none" placeholder="Movie synopsis..."></textarea>
          </div>

          <!-- Duration + Release Date -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Duration (min)</label>
              <input v-model="form.duration_minutes" type="number" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" placeholder="120">
            </div>
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Release Date</label>
              <input v-model="form.release_date" type="date" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" style="color-scheme: dark;">
            </div>
          </div>

          <!-- Status + Rating -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Status</label>
              <select v-model="form.status" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all appearance-none cursor-pointer">
                <option value="now_showing">Now Showing</option>
                <option value="coming_soon">Coming Soon</option>
                <option value="ended">Ended</option>
              </select>
            </div>
            <div>
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Rating (0–10)</label>
              <input v-model="form.rating_avg" type="number" step="0.1" required class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all" placeholder="8.5">
            </div>
          </div>

          <!-- Credits section -->
          <div class="border-t border-white/[0.05] pt-6 space-y-6">
            <p class="text-[10px] font-semibold tracking-[0.22em] uppercase text-white/25">Credits</p>

            <!-- Director -->
            <div v-if="!pendingFormData">
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Director</label>
              <select v-model="form.selectedDirectorId" class="w-full bg-[#111111] border border-white/[0.08] rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#EAB308]/50 transition-all appearance-none cursor-pointer">
                <option value="" disabled>Select a director</option>
                <option v-for="director in formData?.directors" :key="director.id" :value="director.id">{{ director.name }}</option>
              </select>
            </div>

            <!-- Genres -->
            <div v-if="!pendingFormData">
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Genres</label>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="genre in formData?.genres"
                  :key="genre.id"
                  type="button"
                  @click="toggleRelation('genre_ids', genre.id)"
                  class="px-3 py-1.5 rounded-lg text-[11px] font-semibold border transition-all"
                  :class="form.genre_ids.includes(genre.id)
                    ? 'bg-[#EAB308] border-[#EAB308] text-black'
                    : 'border-white/[0.08] text-white/35 hover:border-white/[0.16]'"
                >
                  {{ genre.name }}
                </button>
              </div>
            </div>

            <!-- Stars -->
            <div v-if="!pendingFormData">
              <label class="block text-[10px] font-semibold tracking-[0.22em] uppercase text-white/35 mb-2">Stars</label>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="star in formData?.stars"
                  :key="star.id"
                  type="button"
                  @click="toggleRelation('star_ids', star.id)"
                  class="px-3 py-1.5 rounded-lg text-[11px] font-semibold border transition-all"
                  :class="form.star_ids.includes(star.id)
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
            <span v-else>Update Movie</span>
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
            class="cursor-pointer transition-all relative"
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
                <p class="text-[10px] text-white/20">JPG or PNG only</p>
              </div>
            </div>
          </div>
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
        <span v-if="galleryFiles.length > 0" class="text-[9px] font-semibold text-[#EAB308]/60 tracking-widest">{{ galleryFiles.length }} new</span>
      </div>

      <!-- Existing images -->
      <div v-if="existingGallery.length > 0" class="px-4 pt-4">
        <p class="text-[9px] font-semibold tracking-[0.22em] text-white/20 uppercase mb-2">Existing</p>
        <div class="grid grid-cols-4 sm:grid-cols-6 gap-2 mb-4">
          <div v-for="img in existingGallery" :key="img.id" class="relative aspect-video rounded-xl overflow-hidden border border-white/[0.06] group">
            <img :src="img.image_url" class="w-full h-full object-cover" />
            <button @click="deleteGalleryImage(img.id)"
              class="absolute top-1 right-1 w-5 h-5 bg-black/70 rounded-full flex items-center justify-center text-white/70 hover:text-red-400 opacity-0 group-hover:opacity-100 transition-all text-[12px] leading-none">×</button>
          </div>
        </div>
      </div>

      <!-- New images to add -->
      <div
        @click="galleryInput?.click()"
        @dragover.prevent @drop.prevent="handleGalleryDrop"
        class="cursor-pointer mx-4 mb-4 rounded-xl border-2 border-dashed border-white/[0.08] p-5 flex items-center gap-4 hover:border-[#EAB308]/30 transition-all group">
        <input type="file" ref="galleryInput" class="hidden" accept="image/jpeg, image/png" multiple @change="handleGallerySelect">
        <div class="w-9 h-9 bg-white/[0.03] border border-white/[0.06] rounded-xl flex items-center justify-center text-white/20 group-hover:border-[#EAB308]/25 group-hover:text-[#EAB308]/60 transition-all flex-shrink-0">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>
          </svg>
        </div>
        <div>
          <p class="text-[12px] font-medium text-white/35">Add more gallery images</p>
          <p class="text-[10px] text-white/20 mt-0.5">JPG or PNG — multiple allowed</p>
        </div>
      </div>
      <div v-if="galleryPreviews.length > 0" class="px-4 pb-4 grid grid-cols-4 sm:grid-cols-6 gap-2">
        <div v-for="(img, idx) in galleryPreviews" :key="idx" class="relative aspect-video rounded-xl overflow-hidden border border-white/[0.06] group">
          <img :src="img" class="w-full h-full object-cover" />
          <button @click.stop="removeNewGalleryImage(idx)"
            class="absolute top-1 right-1 w-5 h-5 bg-black/70 rounded-full flex items-center justify-center text-white/70 hover:text-white opacity-0 group-hover:opacity-100 transition-all text-[12px] leading-none">×</button>
        </div>
      </div>
      <div v-if="galleryFiles.length > 0" class="px-4 pb-4">
        <button @click="uploadNewGalleryImages"
          :disabled="isUploadingGallery"
          class="w-full bg-white/[0.05] border border-white/[0.08] text-white/50 hover:text-white hover:border-white/20 py-2.5 rounded-xl font-bold text-[10px] tracking-[0.14em] uppercase transition-all disabled:opacity-30">
          {{ isUploadingGallery ? 'Uploading…' : `Upload ${galleryFiles.length} Image${galleryFiles.length > 1 ? 's' : ''}` }}
        </button>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import {
  GET_ADMIN_FORM_DATA,
  UPDATE_MOVIE,
  DELETE_MOVIE_DIRECTORS,
  INSERT_MOVIE_DIRECTORS,
  DELETE_MOVIE_STARS,
  INSERT_MOVIE_STARS,
  DELETE_MOVIE_GENRES,
  INSERT_MOVIE_GENRES,
  INSERT_MOVIE_IMAGES,
  DELETE_MOVIE_IMAGE_BY_ID,
  GET_MOVIE_BY_ID
} from '~/graphql/admin'

const route = useRoute()
const movieId = route.params.id as string

const { data: formData, pending: pendingFormData } = await useAsyncQuery<any>(GET_ADMIN_FORM_DATA)
const { resolveClient } = useApolloClient()
const { uploadImage } = useUpload()
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

const existingGallery = ref<{ id: string; image_url: string }[]>([])
const galleryFiles = ref<File[]>([])
const galleryPreviews = ref<string[]>([])
const galleryInput = ref<HTMLInputElement | null>(null)
const isUploadingGallery = ref(false)

const handleGallerySelect = (e: Event) => {
  Array.from((e.target as HTMLInputElement).files ?? []).forEach(f => addGalleryFile(f))
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
const removeNewGalleryImage = (idx: number) => {
  galleryFiles.value.splice(idx, 1)
  galleryPreviews.value.splice(idx, 1)
}
const deleteGalleryImage = async (imageId: string) => {
  try {
    const client = resolveClient()
    await client.mutate({ mutation: DELETE_MOVIE_IMAGE_BY_ID, variables: { id: imageId }, context: { headers: { Authorization: `Bearer ${authCookie.value}` } } })
    existingGallery.value = existingGallery.value.filter(i => i.id !== imageId)
  } catch (err) { console.error('Delete gallery image error:', err) }
}
const uploadNewGalleryImages = async () => {
  if (!galleryFiles.value.length) return
  isUploadingGallery.value = true
  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }
    const uploadedUrls: string[] = []
    for (const file of galleryFiles.value) {
      uploadedUrls.push(await uploadImage(file, client))
    }
    if (uploadedUrls.length > 0) {
      await client.mutate({ mutation: INSERT_MOVIE_IMAGES, variables: { objects: uploadedUrls.map(url => ({ movie_id: movieId, image_url: url })) }, context: { headers } })
      existingGallery.value = [...existingGallery.value, ...uploadedUrls.map((url, i) => ({ id: `new-${i}`, image_url: url }))]
      galleryFiles.value = []
      galleryPreviews.value = []
    }
  } catch (err) { console.error('Gallery upload error:', err) }
  finally { isUploadingGallery.value = false }
}

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
      existingGallery.value = movie.movie_images ?? []
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

const handleSubmit = async () => {
  errorMessage.value = ''
  isSubmitting.value = true

  try {
    const client = resolveClient()
    const headers = { Authorization: `Bearer ${authCookie.value}` }

    let imageUrl: string = existingImageUrl.value || ''

    // 1. Upload the main image directly to Cloudinary via a signed upload
    if (mainImageFile.value) {
      imageUrl = await uploadImage(mainImageFile.value, client)
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
