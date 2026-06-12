<template>
  <div class="min-h-screen bg-bg-main flex items-center justify-center p-4 font-sans text-white">
    <div class="max-w-md w-full bg-bg-card p-8 rounded-2xl border border-gray-800 shadow-2xl">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold mb-2">Login</h1>
        <p class="text-text-soft text-sm">Sign in to continue your movie journey</p>
      </div>

      <div v-if="errorMessage" class="mb-6 p-3 bg-red-500/10 border border-red-500 text-red-500 text-sm rounded-lg text-center">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin">
        <BaseInput v-model="email" label="Email" type="email" placeholder="Enter your email address" />
        <BaseInput v-model="password" label="Password" type="password" placeholder="Enter your password" />
        
        <div class="flex justify-end mb-6">
          <a href="#" class="text-xs text-primary hover:underline">Forgot Password?</a>
        </div>

        <BaseButton :loading="isLoggingIn">Login</BaseButton>
      </form>

      <div class="mt-8 text-center border-t border-gray-800 pt-6">
        <p class="text-sm text-text-soft">
          Don't have an account? 
          <NuxtLink to="/auth/signup" class="text-primary font-bold hover:underline">Sign up</NuxtLink>
        </p>
      </div>
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
      
      if (isAdmin.value) {
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