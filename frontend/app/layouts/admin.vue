<template>
  <div class="min-h-screen bg-[#050505] text-white font-sans flex relative">

    <!-- Mobile Sidebar Toggle -->
    <button @click="isSidebarOpen = !isSidebarOpen" class="md:hidden fixed top-6 right-6 z-50 bg-[#EAB308] text-black p-3 rounded-full shadow-2xl">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="3" y1="12" x2="21" y2="12"></line>
        <line x1="3" y1="6" x2="21" y2="6"></line>
        <line x1="3" y1="18" x2="21" y2="18"></line>
      </svg>
    </button>

    <!-- Sidebar Overlay -->
    <div v-if="isSidebarOpen" @click="isSidebarOpen = false" class="md:hidden fixed inset-0 bg-black/80 z-40 backdrop-blur-sm"></div>

    <!-- Sidebar -->
    <aside 
      class="w-64 bg-[#0A0A0A] border-r border-white/5 flex flex-col fixed h-full z-50 transition-transform duration-300"
      :class="isSidebarOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'"
    >
      <div class="p-8">
        <NuxtLink to="/admin" class="text-xl font-luxury text-[#EAB308] tracking-tighter uppercase">
          ETHIO <span class="text-white">CINEMA HOUSE</span>
        </NuxtLink>
      </div>

      <nav class="flex-1 px-4 space-y-2 mt-4 overflow-y-auto">
        <NuxtLink to="/admin/movies" class="flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-white/5 transition text-sm font-bold" active-class="bg-[#EAB308] text-white shadow-lg shadow-[#EAB308]/20" :class="{ 'bg-[#EAB308] text-white shadow-lg shadow-[#EAB308]/20': $route.path.startsWith('/admin/movies') }">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"></rect><line x1="7" y1="2" x2="7" y2="22"></line><line x1="17" y1="2" x2="17" y2="22"></line><line x1="2" y1="12" x2="22" y2="12"></line><line x1="2" y1="7" x2="7" y2="7"></line><line x1="2" y1="17" x2="7" y2="17"></line><line x1="17" y1="17" x2="22" y2="17"></line><line x1="17" y1="7" x2="22" y2="7"></line></svg>
          Movies
        </NuxtLink>
        <NuxtLink to="/admin/schedules" class="flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-white/5 transition text-sm font-bold" active-class="bg-[#EAB308] text-white shadow-lg shadow-[#EAB308]/20">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
          Schedules
        </NuxtLink>
        <NuxtLink to="/admin/directors" class="flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-white/5 transition text-sm font-bold" active-class="bg-[#EAB308] text-white shadow-lg shadow-[#EAB308]/20">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
          Directors
        </NuxtLink>
        <NuxtLink to="/admin/stars" class="flex items-center gap-4 px-4 py-3 rounded-xl hover:bg-white/5 transition text-sm font-bold" active-class="bg-[#EAB308] text-white shadow-lg shadow-[#EAB308]/20">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
          Stars
        </NuxtLink>
      </nav>

      <div class="p-4 mt-auto border-t border-white/5">
        <div class="flex items-center gap-3 px-4 py-3 rounded-xl bg-white/5 mb-4">
          <div class="w-8 h-8 rounded-full bg-[#EAB308] text-black font-black flex items-center justify-center shadow-[0_0_15px_rgba(234,179,8,0.2)]">
            {{ userInitial }}
          </div>
          <div class="overflow-hidden">
            <p class="text-[10px] text-gray-500 font-bold uppercase tracking-widest">Admin</p>
            <p class="text-xs font-bold truncate">{{ user?.email || 'Admin' }}</p>
          </div>
        </div>

        <button @click="handleLogout" class="w-full text-xs text-gray-500 hover:text-white font-bold tracking-widest uppercase py-3 rounded-xl hover:bg-white/5 transition text-left px-4 mb-2">
          ← Logout
        </button>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 md:ml-64 p-6 md:p-10 bg-[radial-gradient(circle_at_top_right,rgba(234,179,8,0.05),transparent_40%)] w-full overflow-x-hidden min-h-screen">
      <slot />
    </main>
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
</script>