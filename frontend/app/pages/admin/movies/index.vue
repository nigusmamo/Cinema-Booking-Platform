<template>
  <div class="pb-16">

    <!-- Page Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
      <div>
        <p class="text-[10px] font-semibold tracking-[0.3em] text-white/25 uppercase mb-1">Content Library</p>
        <h1 class="text-[22px] font-semibold text-white tracking-tight leading-none mb-1">Movies</h1>
        <p class="text-[12px] text-white/30">{{ filteredMovies.length }} total entries</p>
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
            placeholder="Search movies..."
            class="w-60 bg-[#111111] border border-white/[0.08] rounded-xl pl-9 pr-4 py-2.5 text-sm text-white placeholder:text-white/20 focus:outline-none focus:border-[#EAB308]/50 transition-all"
          />
        </div>

        <!-- Add Button -->
        <NuxtLink
          to="/admin/movies/create"
          class="inline-flex items-center gap-2 bg-[#EAB308] text-black px-5 py-2.5 rounded-lg text-[11px] font-bold tracking-[0.14em] uppercase hover:bg-[#d4a007] active:scale-[0.98] transition-all"
        >
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          Add Movie
        </NuxtLink>
      </div>
    </div>

    <!-- Skeleton -->
    <div v-if="pending" class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
      <div v-for="i in 6" :key="i" class="rounded-2xl h-[88px] bg-white/[0.03] animate-pulse"></div>
    </div>

    <!-- Empty State -->
    <div v-else-if="filteredMovies.length === 0" class="py-20 flex flex-col items-center justify-center gap-3">
      <div class="w-12 h-12 rounded-2xl bg-white/[0.04] border border-white/[0.06] flex items-center justify-center">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-white/20">
          <rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"></rect>
          <line x1="7" y1="2" x2="7" y2="22"></line>
          <line x1="17" y1="2" x2="17" y2="22"></line>
          <line x1="2" y1="12" x2="22" y2="12"></line>
        </svg>
      </div>
      <p class="text-[12px] text-white/25 font-medium">No movies found</p>
    </div>

    <!-- Movie Grid -->
    <div v-else class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
      <AdminMovieCard
        v-for="movie in paginatedMovies"
        :key="movie.id"
        :movie="movie"
        @delete="confirmDelete"
      />
    </div>

    <!-- Pagination -->
    <AdminPagination v-model="currentPage" :total-items="filteredMovies.length" :page-size="pageSize" />

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

// Pagination
const pageSize = 12
const currentPage = ref(1)
const paginatedMovies = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  return filteredMovies.value.slice(start, start + pageSize)
})

// Reset to first page on search; clamp if the list shrinks (e.g. after delete)
watch(searchQuery, () => { currentPage.value = 1 })
watch(filteredMovies, (list) => {
  const lastPage = Math.max(1, Math.ceil(list.length / pageSize))
  if (currentPage.value > lastPage) currentPage.value = lastPage
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
