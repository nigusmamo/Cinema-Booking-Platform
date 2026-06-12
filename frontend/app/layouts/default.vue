<template>
  <div class="min-h-screen bg-[#0D0D0D] text-white font-sans">
    <nav class="border-b border-white/5 bg-black/80 backdrop-blur-md sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
        <NuxtLink :to="isAdmin ? '/admin/movies' : '/'" class="text-[#EAB308] text-xl font-black uppercase tracking-tighter">
          ETHIO <span class="text-white">CINEMA HOUSE</span>
        </NuxtLink>

        <div v-if="!isAdmin" class="hidden lg:flex items-center gap-10 text-[11px] font-black tracking-[0.2em] text-gray-400 uppercase">
          <NuxtLink to="/" class="hover:text-[#EAB308] transition">Home</NuxtLink>
          <NuxtLink to="/schedules" class="hover:text-[#EAB308] transition">Schedules</NuxtLink>
        </div>

        <div class="flex items-center gap-4">
          <template v-if="isAuthenticated">
             <div class="flex items-center gap-3">
               <span class="text-[10px] font-bold text-gray-500 uppercase tracking-widest hidden md:block">
                 {{ user?.full_name }}
               </span>
               <div @click="handleLogout" class="cursor-pointer w-10 h-10 bg-[#EAB308] rounded-full flex items-center justify-center text-black font-black shadow-[0_0_15px_rgba(234,179,8,0.3)] hover:scale-110 transition-all border-2 border-black">
                {{ userInitial }}
              </div>
             </div>
          </template>
          <NuxtLink v-else to="/auth/login" class="bg-[#EAB308] text-black px-6 py-2.5 rounded-xl font-black text-xs hover:scale-105 transition shadow-lg">
            LOGIN
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
const { user, userInitial, isAuthenticated,isAdmin, logout, fetchUser } = useAuth()

onMounted(() => {
  if (!user.value) {
    fetchUser()
  }
})

const handleLogout = () => {
  logout()
}
</script>