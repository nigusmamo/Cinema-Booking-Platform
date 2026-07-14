<template>
  <div class="min-h-screen bg-[#090909] text-white font-sans">
    <nav class="sticky top-0 z-50 bg-[#090909]/80 backdrop-blur-2xl border-b border-white/[0.04]">
      <div class="max-w-7xl mx-auto px-6 h-14 flex items-center justify-between">

        <NuxtLink :to="isAdmin ? '/admin/movies' : '/'" class="flex items-center gap-2.5 group">
          <div class="w-6 h-6 bg-[#EAB308] rounded-md flex items-center justify-center flex-shrink-0">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="black" xmlns="http://www.w3.org/2000/svg">
              <path d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z" opacity="0"/>
              <path d="M18 4H6C4.9 4 4 4.9 4 6v14l4-4h10c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 12H7.17L6 17.17V6h12v10z" opacity="0"/>
              <rect x="3" y="3" width="18" height="13" rx="2" ry="2"/>
              <circle cx="12" cy="9.5" r="3" fill="black" opacity="0.35"/>
              <path d="M12 6.5L13.5 9H16l-2 2 .75 2.75L12 12.5l-2.75 1.25L10 11l-2-2h2.5L12 6.5z" fill="black"/>
            </svg>
          </div>
          <span class="text-[12px] font-semibold tracking-[0.15em] uppercase text-white/80 group-hover:text-white transition-colors duration-200">
            Ethio <span class="text-[#EAB308]">Cinema</span>
          </span>
        </NuxtLink>

        <div v-if="!isAdmin" class="hidden lg:flex items-center gap-8">
          <NuxtLink to="/" class="text-[11px] font-medium tracking-[0.22em] uppercase text-white/30 hover:text-white/70 transition-colors duration-200">
            Home
          </NuxtLink>
          <NuxtLink to="/schedules" class="text-[11px] font-medium tracking-[0.22em] uppercase text-white/30 hover:text-white/70 transition-colors duration-200">
            Schedules
          </NuxtLink>
        </div>

        <div class="flex items-center gap-4">
          <template v-if="isAuthenticated">
            <span class="hidden md:block text-[11px] text-white/25 tracking-wider font-medium">
              {{ user?.full_name }}
            </span>
            <NuxtLink to="/profile"
              class="w-7 h-7 bg-[#EAB308] rounded-full flex items-center justify-center text-black text-[10px] font-bold hover:scale-110 hover:shadow-[0_0_12px_rgba(234,179,8,0.4)] transition-all duration-200">
              {{ userInitial }}
            </NuxtLink>
          </template>
          <NuxtLink v-else to="/auth/login"
            class="text-[10px] font-semibold tracking-[0.2em] uppercase text-white/45 hover:text-white/80 border border-white/[0.1] hover:border-white/[0.22] px-4 py-2 rounded-lg transition-all duration-200">
            Sign In
          </NuxtLink>
        </div>

      </div>
    </nav>
    <main>
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
const auth = useAuthStore()
const { user, userInitial, isAuthenticated, isAdmin } = storeToRefs(auth)
const { fetchUser } = auth

onMounted(() => {
  if (!user.value) {
    fetchUser()
  }
})
</script>
