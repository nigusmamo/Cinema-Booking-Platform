<template>
  <div class="max-w-7xl mx-auto">
    
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-10">
      <div>
        <h1 class="text-4xl font-luxury uppercase italic tracking-tighter mb-2">Manage <span class="text-[#EAB308]">Movies .</span></h1>
        <p class="text-gray-500 text-sm font-bold uppercase tracking-widest">Total: {{ filteredMovies.length }} Movies</p>
      </div>

      <div class="flex flex-col sm:flex-row gap-4 flex-1 max-w-2xl justify-end">
        <div class="relative flex-1 max-w-md">
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Search movies..." 
            class="w-full bg-[#0D0D0D] border border-white/10 pl-12 pr-4 py-3 rounded-xl focus:outline-none focus:border-[#EAB308] text-white transition placeholder:text-gray-600" 
          />
          <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">🔍</span>
        </div>
        <NuxtLink to="/admin/movies/create" class="bg-[#EAB308] text-black px-8 py-3 rounded-xl font-black text-xs hover:scale-105 transition shadow-lg text-center flex items-center justify-center whitespace-nowrap">
          + ADD MOVIE
        </NuxtLink>
      </div>
    </div>

    <!-- Movies Grid -->
    <div v-if="pending" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      <div v-for="i in 8" :key="i" class="bg-[#0D0D0D] border border-white/5 rounded-[35px] h-48 animate-pulse"></div>
    </div>

    <div v-else-if="filteredMovies.length === 0" class="text-center py-20 bg-[#0D0D0D] border border-white/5 rounded-[35px]">
      <p class="text-gray-500 font-bold uppercase tracking-widest">No movies found.</p>
    </div>

    <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 pb-20">
      <AdminMovieCard 
        v-for="movie in filteredMovies" 
        :key="movie.id" 
        :movie="movie" 
        @delete="confirmDelete"
      />
    </div>

    <!-- Delete Confirmation Modal -->
    <AdminDeleteConfirm 
      v-if="showDeleteConfirm" 
      :is-deleting="isDeleting"
      title="Delete Movie"
      message="Are you sure you want to delete this movie? This will also delete all its schedules and bookings. This action cannot be undone."
      @confirm="executeDelete"
      @cancel="showDeleteConfirm = false"
    />
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { GET_ADMIN_MOVIES, DELETE_MOVIE } from '~/graphql/admin'

const searchQuery = ref('')
const { data, pending, refresh } = await useAsyncQuery<any>(GET_ADMIN_MOVIES)
const { resolveClient } = useApolloClient()
const authCookie = useCookie('auth_token')

const movies = computed(() => data.value?.movies || [])

const filteredMovies = computed(() => {
  if (!searchQuery.value) return movies.value
  const query = searchQuery.value.toLowerCase()
  return movies.value.filter((m: any) => m.title.toLowerCase().includes(query))
})

// Delete Logic
const showDeleteConfirm = ref(false)
const isDeleting = ref(false)
const movieToDelete = ref<string | null>(null)

const confirmDelete = (id: string) => {
  movieToDelete.value = id
  showDeleteConfirm.value = true
}

const executeDelete = async () => {
  if (!movieToDelete.value) return
  isDeleting.value = true
  
  try {
    const client = resolveClient()
    await client.mutate({
      mutation: DELETE_MOVIE,
      variables: { id: movieToDelete.value },
      context: { headers: { Authorization: `Bearer ${authCookie.value}` } },
      refetchQueries: [{ query: GET_ADMIN_MOVIES }]
    })
    showDeleteConfirm.value = false
  } catch (err) {
    console.error("Failed to delete movie:", err)
    alert("Failed to delete movie. Please check console.")
  } finally {
    isDeleting.value = false
    movieToDelete.value = null
  }
}
</script>
