<template>
  <div class="min-h-screen bg-[#0D0D0D] text-white font-sans">
    <nav class="border-b border-gray-800 bg-black/80 backdrop-blur-md sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
        <NuxtLink to="/" class="text-[#EAB308] text-xl font-black uppercase tracking-tighter">
          ETHIO <span class="text-white">CINEMA HOUSE</span>
        </NuxtLink>

        <div class="hidden lg:flex items-center gap-8 text-[13px] font-bold tracking-widest text-gray-400">
          <NuxtLink to="/" class="hover:text-[#EAB308] transition text-white">MOVIES</NuxtLink>
          <NuxtLink to="/schedules" class="hover:text-[#EAB308] transition">SCHEDULES</NuxtLink>
          <NuxtLink to="/cinemas" class="hover:text-[#EAB308] transition">CINEMAS</NuxtLink>
          <NuxtLink to="/offers" class="hover:text-[#EAB308] transition">OFFERS</NuxtLink>
          <NuxtLink v-if="userRole === 'admin'" to="/admin" class="text-[#EAB308] border border-[#EAB308]/30 px-3 py-1 rounded">ADMIN</NuxtLink>
        </div>

        <div class="flex items-center gap-6">
          <button class="text-gray-400 hover:text-white"><div class="i-heroicons-magnifying-glass-20-solid w-5 h-5"></div></button>
          <button class="text-gray-400 hover:text-white relative">
            <div class="i-heroicons-bell w-5 h-5"></div>
            <span class="absolute -top-1 -right-1 bg-red-600 w-2 h-2 rounded-full"></span>
          </button>
          
          <template v-if="isAuthenticated">
            <div @click="handleLogout" class="cursor-pointer w-10 h-10 bg-[#EAB308] rounded-full flex items-center justify-center text-black font-black ring-2 ring-offset-2 ring-offset-black ring-[#EAB308]/20">
              {{ userName.charAt(0) }}
            </div>
          </template>
          <NuxtLink :to="isAuthenticated ? '/schedules' : '/auth/login'" 
            class="bg-[#EAB308] text-black px-6 py-2.5 rounded-lg font-black text-sm hover:scale-105 transition shadow-[0_0_20px_rgba(234,179,8,0.2)]">
            {{ isAuthenticated ? 'MY TICKETS' : 'BOOK NOW' }}
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
const authCookie = useCookie('auth_token')
const isAuthenticated = computed(() => !!authCookie.value)
const userName = ref('User')
const userRole = ref('user')

const handleLogout = () => {
  authCookie.value = null
  navigateTo('/auth/login')
}
</script>