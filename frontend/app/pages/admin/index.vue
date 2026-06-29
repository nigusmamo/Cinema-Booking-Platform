<template>
  <div class="pb-16">

    <!-- Page Header -->
    <div class="mb-8">
      <p class="text-[10px] font-semibold tracking-[0.3em] text-white/25 uppercase mb-1">Overview</p>
      <h1 class="text-[22px] font-semibold text-white tracking-tight leading-none mb-1">Dashboard</h1>
      <p class="text-[12px] text-white/30">Welcome back{{ user?.full_name ? `, ${user.full_name.split(' ')[0]}` : '' }}</p>
    </div>

    <!-- Stat Cards -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
      <div
        v-for="stat in stats"
        :key="stat.label"
        class="bg-[#0D0D0D] border border-white/[0.05] rounded-2xl p-5 hover:border-white/[0.1] transition-all"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="w-9 h-9 rounded-xl bg-[#EAB308]/[0.08] flex items-center justify-center text-[#EAB308]" v-html="stat.icon"></div>
          <NuxtLink :to="stat.to" class="text-white/15 hover:text-white/40 transition-colors">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="7" y1="17" x2="17" y2="7"></line>
              <polyline points="7 7 17 7 17 17"></polyline>
            </svg>
          </NuxtLink>
        </div>
        <div v-if="pending" class="h-7 w-16 rounded-md bg-white/[0.05] animate-pulse mb-1"></div>
        <p v-else class="text-[26px] font-semibold text-white tracking-tight leading-none mb-1">{{ stat.value.toLocaleString() }}</p>
        <p class="text-[11px] font-medium text-white/35">{{ stat.label }}</p>
      </div>
    </div>

    <!-- Revenue Banner -->
    <div class="bg-[#0D0D0D] border border-white/[0.05] rounded-2xl p-5 mb-8 flex items-center justify-between">
      <div>
        <p class="text-[10px] font-semibold tracking-[0.22em] uppercase text-white/30 mb-1.5">Total Revenue</p>
        <div v-if="pending" class="h-7 w-32 rounded-md bg-white/[0.05] animate-pulse"></div>
        <p v-else class="text-[24px] font-semibold text-white tracking-tight leading-none">
          {{ totalRevenue.toLocaleString() }} <span class="text-white/30 text-[13px] font-normal">ETB</span>
        </p>
      </div>
    </div>

    <!-- Recent Movies -->
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-[14px] font-semibold text-white tracking-tight">Recently Added</h2>
      <NuxtLink to="/admin/movies" class="text-[11px] font-semibold text-[#EAB308] hover:text-[#d4a007] transition-colors">View all</NuxtLink>
    </div>

    <div v-if="pending" class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
      <div v-for="i in 6" :key="i" class="rounded-2xl h-[88px] bg-white/[0.03] animate-pulse"></div>
    </div>

    <div v-else-if="recentMovies.length === 0" class="py-16 flex flex-col items-center justify-center gap-3 bg-[#0D0D0D] border border-white/[0.05] rounded-2xl">
      <p class="text-[12px] text-white/25 font-medium">No movies yet</p>
    </div>

    <div v-else class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
      <NuxtLink
        v-for="movie in recentMovies"
        :key="movie.id"
        :to="`/admin/movies/${movie.id}`"
        class="bg-[#0D0D0D] border border-white/[0.05] rounded-2xl p-3 flex items-center gap-3 hover:border-white/[0.1] transition-all group"
      >
        <img
          :src="movie.main_image || '/placeholder.png'"
          :alt="movie.title"
          class="w-12 h-16 rounded-lg object-cover bg-white/[0.04] flex-shrink-0"
        />
        <div class="min-w-0 flex-1">
          <p class="text-[13px] font-semibold text-white truncate group-hover:text-[#EAB308] transition-colors">{{ movie.title }}</p>
          <p class="text-[11px] text-white/30 mt-0.5 truncate">
            {{ movie.movie_genres?.map((g: any) => g.genre.name).join(', ') || 'Uncategorized' }}
          </p>
          <div class="flex items-center gap-3 mt-1.5">
            <span class="text-[10px] text-white/35">{{ movie.duration_minutes }} min</span>
            <span class="text-[10px] text-white/35">{{ movie.schedules_aggregate?.aggregate?.count || 0 }} schedules</span>
          </div>
        </div>
      </NuxtLink>
    </div>

  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin' })
import { GET_ADMIN_DASHBOARD } from '~/graphql/admin'

const { user } = useAuth()
const { data, pending } = await useAsyncQuery<any>(GET_ADMIN_DASHBOARD)

const icons = {
  movies: '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"></rect><line x1="7" y1="2" x2="7" y2="22"></line><line x1="17" y1="2" x2="17" y2="22"></line><line x1="2" y1="12" x2="22" y2="12"></line><line x1="2" y1="7" x2="7" y2="7"></line><line x1="2" y1="17" x2="7" y2="17"></line><line x1="17" y1="17" x2="22" y2="17"></line><line x1="17" y1="7" x2="22" y2="7"></line></svg>',
  schedules: '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>',
  bookings: '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 9V7a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4z"></path><line x1="13" y1="5" x2="13" y2="19"></line></svg>',
  users: '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>',
}

const stats = computed(() => [
  { label: 'Total Movies', value: data.value?.movies_aggregate?.aggregate?.count || 0, icon: icons.movies, to: '/admin/movies' },
  { label: 'Total Schedules', value: data.value?.schedules_aggregate?.aggregate?.count || 0, icon: icons.schedules, to: '/admin/schedules' },
  { label: 'Total Bookings', value: data.value?.bookings_aggregate?.aggregate?.count || 0, icon: icons.bookings, to: '/admin' },
  { label: 'Total Users', value: data.value?.users_aggregate?.aggregate?.count || 0, icon: icons.users, to: '/admin' },
])

const totalRevenue = computed(() => Number(data.value?.bookings_aggregate?.aggregate?.sum?.total_price || 0))
const recentMovies = computed(() => data.value?.movies || [])
</script>
