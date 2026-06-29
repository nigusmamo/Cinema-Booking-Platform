<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans flex relative">

    <!-- Mobile Sidebar Toggle -->
    <button @click="isSidebarOpen = !isSidebarOpen" class="md:hidden fixed top-4 right-4 z-50 bg-[#EAB308] text-black p-2.5 rounded-xl shadow-2xl">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="3" y1="12" x2="21" y2="12"></line>
        <line x1="3" y1="6" x2="21" y2="6"></line>
        <line x1="3" y1="18" x2="21" y2="18"></line>
      </svg>
    </button>

    <!-- Sidebar Overlay -->
    <div v-if="isSidebarOpen" @click="isSidebarOpen = false" class="md:hidden fixed inset-0 bg-black/80 z-40 backdrop-blur-sm"></div>

    <!-- Sidebar -->
    <aside
      class="w-[232px] bg-[#0D0D0D] border-r border-white/[0.05] flex flex-col fixed h-full z-50 transition-transform duration-300"
      :class="isSidebarOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'"
    >
      <!-- Logo -->
      <div class="px-5 py-6 border-b border-white/[0.05]">
        <NuxtLink to="/admin" class="flex items-center gap-3">
          <div class="w-8 h-8 bg-[#EAB308] rounded-lg flex items-center justify-center flex-shrink-0">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"></rect>
              <line x1="7" y1="2" x2="7" y2="22"></line>
              <line x1="17" y1="2" x2="17" y2="22"></line>
              <line x1="2" y1="12" x2="22" y2="12"></line>
              <line x1="2" y1="7" x2="7" y2="7"></line>
              <line x1="2" y1="17" x2="7" y2="17"></line>
              <line x1="17" y1="17" x2="22" y2="17"></line>
              <line x1="17" y1="7" x2="22" y2="7"></line>
            </svg>
          </div>
          <div>
            <div class="text-[13px] font-bold tracking-tight leading-none">
              <span class="text-[#EAB308]">ETHIO</span><span class="text-white"> CINEMA</span>
            </div>
            <div class="text-[9px] font-semibold tracking-[0.2em] uppercase text-white/25 mt-0.5">Admin Panel</div>
          </div>
        </NuxtLink>
      </div>

      <!-- Nav -->
      <nav class="flex-1 px-3 pt-4 space-y-0.5 overflow-y-auto">
        <NuxtLink
          to="/admin"
          class="flex items-center gap-3 py-2.5 rounded-xl text-[12px] font-semibold transition-all"
          :class="$route.path === '/admin'
            ? 'pl-[14px] text-white bg-[#EAB308]/[0.08] border-l-2 border-[#EAB308]'
            : 'px-4 text-white/40 hover:text-white/70 hover:bg-white/[0.03]'"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="7" height="9"></rect>
            <rect x="14" y="3" width="7" height="5"></rect>
            <rect x="14" y="12" width="7" height="9"></rect>
            <rect x="3" y="16" width="7" height="5"></rect>
          </svg>
          Dashboard
        </NuxtLink>

        <NuxtLink
          to="/admin/movies"
          class="flex items-center gap-3 py-2.5 rounded-xl text-[12px] font-semibold transition-all"
          :class="$route.path.startsWith('/admin/movies')
            ? 'pl-[14px] text-white bg-[#EAB308]/[0.08] border-l-2 border-[#EAB308]'
            : 'px-4 text-white/40 hover:text-white/70 hover:bg-white/[0.03]'"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"></rect>
            <line x1="7" y1="2" x2="7" y2="22"></line>
            <line x1="17" y1="2" x2="17" y2="22"></line>
            <line x1="2" y1="12" x2="22" y2="12"></line>
            <line x1="2" y1="7" x2="7" y2="7"></line>
            <line x1="2" y1="17" x2="7" y2="17"></line>
            <line x1="17" y1="17" x2="22" y2="17"></line>
            <line x1="17" y1="7" x2="22" y2="7"></line>
          </svg>
          Movies
        </NuxtLink>

        <NuxtLink
          to="/admin/schedules"
          class="flex items-center gap-3 py-2.5 rounded-xl text-[12px] font-semibold transition-all"
          :class="$route.path.startsWith('/admin/schedules')
            ? 'pl-[14px] text-white bg-[#EAB308]/[0.08] border-l-2 border-[#EAB308]'
            : 'px-4 text-white/40 hover:text-white/70 hover:bg-white/[0.03]'"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
            <line x1="16" y1="2" x2="16" y2="6"></line>
            <line x1="8" y1="2" x2="8" y2="6"></line>
            <line x1="3" y1="10" x2="21" y2="10"></line>
          </svg>
          Schedules
        </NuxtLink>

        <NuxtLink
          to="/admin/pricing"
          class="flex items-center gap-3 py-2.5 rounded-xl text-[12px] font-semibold transition-all"
          :class="$route.path.startsWith('/admin/pricing')
            ? 'pl-[14px] text-white bg-[#EAB308]/[0.08] border-l-2 border-[#EAB308]'
            : 'px-4 text-white/40 hover:text-white/70 hover:bg-white/[0.03]'"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
          </svg>
          Pricing
        </NuxtLink>

        <NuxtLink
          to="/admin/directors"
          class="flex items-center gap-3 py-2.5 rounded-xl text-[12px] font-semibold transition-all"
          :class="$route.path.startsWith('/admin/directors')
            ? 'pl-[14px] text-white bg-[#EAB308]/[0.08] border-l-2 border-[#EAB308]'
            : 'px-4 text-white/40 hover:text-white/70 hover:bg-white/[0.03]'"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
            <circle cx="12" cy="7" r="4"></circle>
          </svg>
          Directors
        </NuxtLink>

        <NuxtLink
          to="/admin/stars"
          class="flex items-center gap-3 py-2.5 rounded-xl text-[12px] font-semibold transition-all"
          :class="$route.path.startsWith('/admin/stars')
            ? 'pl-[14px] text-white bg-[#EAB308]/[0.08] border-l-2 border-[#EAB308]'
            : 'px-4 text-white/40 hover:text-white/70 hover:bg-white/[0.03]'"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
          </svg>
          Stars
        </NuxtLink>
      </nav>

      <!-- Bottom user section -->
      <div class="p-3 mt-auto border-t border-white/[0.05]">
        <div class="bg-white/[0.03] border border-white/[0.05] rounded-xl px-4 py-3 flex items-center gap-3 mb-2">
          <div class="w-7 h-7 bg-[#EAB308] rounded-lg flex items-center justify-center flex-shrink-0 text-black text-[11px] font-black">
            {{ userInitial }}
          </div>
          <div class="overflow-hidden min-w-0">
            <p class="text-[9px] font-semibold tracking-[0.18em] uppercase text-white/25 mb-0.5">Administrator</p>
            <p class="text-[11px] font-medium text-white/60 truncate">{{ user?.email || 'Admin' }}</p>
          </div>
        </div>

        <button @click="handleLogout" class="w-full flex items-center gap-2.5 px-4 py-2.5 rounded-xl text-[11px] font-semibold text-white/30 hover:text-white/60 hover:bg-white/[0.03] transition-all">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
            <polyline points="16 17 21 12 16 7"></polyline>
            <line x1="21" y1="12" x2="9" y2="12"></line>
          </svg>
          Logout
        </button>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="md:ml-[232px] min-h-screen bg-[#090909] w-full overflow-x-hidden flex flex-col">
      <!-- Topbar -->
      <div class="border-b border-white/[0.05] px-8 h-14 flex items-center justify-between flex-shrink-0">
        <span class="text-[11px] text-white/25 font-medium">
          Admin <span class="text-white/15 mx-1">/</span> <span class="text-white/40">{{ sectionName }}</span>
        </span>
      </div>

      <!-- Page Content -->
      <div class="p-6 md:p-8">
        <slot />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const isSidebarOpen = ref(false)
const { user, userInitial, isAdmin, logout, fetchUser } = useAuth()

onMounted(async () => {
  if (!user.value) {
    await fetchUser()
  }

  if (!user.value || !isAdmin.value) {
    navigateTo('/')
  }
})

const handleLogout = () => {
  logout()
}

// Close sidebar on route change
const route = useRoute()
watch(() => route.path, () => {
  isSidebarOpen.value = false
})

const sectionName = computed(() => {
  const path = route.path
  if (path.startsWith('/admin/movies')) return 'Movies'
  if (path.startsWith('/admin/schedules')) return 'Schedules'
  if (path.startsWith('/admin/pricing')) return 'Pricing'
  if (path.startsWith('/admin/directors')) return 'Directors'
  if (path.startsWith('/admin/stars')) return 'Stars'
  return 'Dashboard'
})
</script>
