<template>
  <div class="min-h-screen bg-[#090909] flex items-center justify-center p-4 font-sans">
    <NuxtLink to="/"
      class="fixed top-4 left-4 z-10 w-8 h-8 flex items-center justify-center rounded-lg text-white/30 hover:text-white/70 hover:bg-white/[0.05] transition-all">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
    </NuxtLink>
    <div class="w-full max-w-sm">

      <!-- Logo mark -->
      <div class="text-center mb-10">
        <div class="inline-flex items-center gap-2 mb-6">
          <div class="w-6 h-6 bg-[#EAB308] rounded-md flex items-center justify-center flex-shrink-0">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="black">
              <rect x="3" y="3" width="18" height="13" rx="2" ry="2"/>
              <path d="M12 6.5L13.5 9H16l-2 2 .75 2.75L12 12.5l-2.75 1.25L10 11l-2-2h2.5L12 6.5z" fill="black"/>
            </svg>
          </div>
          <span class="text-[12px] font-semibold tracking-[0.15em] uppercase text-white/70">
            Ethio <span class="text-[#EAB308]">Cinema</span>
          </span>
        </div>
        <h1 class="text-white/85 text-2xl font-light mb-1.5">Welcome back</h1>
        <p class="text-white/30 text-[13px]">Sign in to continue your movie journey</p>
      </div>

      <!-- Error -->
      <div v-if="errorMessage" class="mb-5 px-4 py-3 bg-red-500/[0.06] border border-red-500/20 text-red-400 text-[12px] rounded-xl text-center">
        {{ errorMessage }}
      </div>

      <!-- Form -->
      <form @submit.prevent="handleLogin" class="space-y-1">
        <BaseInput v-model="email" label="Email" type="email" placeholder="Email Address" />
        <BaseInput v-model="password" label="Password" type="password" placeholder="Your password" />
        <div class="pt-3">
          <BaseButton :loading="isLoggingIn">Sign In</BaseButton>
        </div>
      </form>

      <!-- Footer link -->
      <p class="text-center text-[12px] text-white/25 mt-8">
        Don't have an account?
        <NuxtLink to="/auth/signup" class="text-white/55 hover:text-white transition-colors ml-1">Create one</NuxtLink>
      </p>

    </div>
  </div>
</template>

<script setup lang="ts">
import { LOGIN_MUTATION } from '~/graphql/auth'

const email = ref('')
const password = ref('')
const isLoggingIn = ref(false)
const errorMessage = ref('')
const { fetchUser, isAdmin, onLogin } = useAuth()

const handleLogin = async () => {
  if (!email.value || !password.value) {
    errorMessage.value = "Please fill in all fields."
    return
  }

  isLoggingIn.value = true
  errorMessage.value = ""

  try {
    const { $apollo } = useNuxtApp()
    const { onLogout, user } = useAuth()

    await onLogout()
    user.value = null

    const result = await $apollo.defaultClient.mutate({
      mutation: LOGIN_MUTATION,
      variables: {
        email: email.value,
        password: password.value
      }
    })

    if (result?.data?.login) {
      const { token, id } = result.data.login

      await onLogin(token)

      const userIdCookie = useCookie('user_id', { maxAge: 60 * 60 * 24 * 7, path: '/' })
      userIdCookie.value = id

      await fetchUser(token)

      const pendingRedirect = import.meta.client ? localStorage.getItem('cinema_redirect_after_login') : null
      if (pendingRedirect) {
        localStorage.removeItem('cinema_redirect_after_login')
        await navigateTo(pendingRedirect)
      } else if (isAdmin.value) {
        await navigateTo('/admin/movies')
      } else {
        await navigateTo('/')
      }
    }
  } catch (err: any) {
    console.error("Login Error:", err)
    errorMessage.value = err.message || "Invalid credentials."
  } finally {
    isLoggingIn.value = false
  }
}
</script>
