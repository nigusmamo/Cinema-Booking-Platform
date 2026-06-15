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
        <h1 class="text-white/85 text-2xl font-light mb-1.5">Create your account</h1>
        <p class="text-white/30 text-[13px]">Join us and enjoy the best of cinema</p>
      </div>

      <!-- Error -->
      <div v-if="errorMessage" class="mb-5 px-4 py-3 bg-red-500/[0.06] border border-red-500/20 text-red-400 text-[12px] rounded-xl text-center">
        {{ errorMessage }}
      </div>

      <!-- Form -->
      <form @submit.prevent="handleSignup" class="space-y-1">
        <BaseInput v-model="fullName" label="Full Name" placeholder="Your full name" />
        <BaseInput v-model="email" label="Email" type="email" placeholder="Email Address" />
        <BaseInput v-model="password" label="Password" type="password" placeholder="Choose a strong password" />
        <div class="pt-3">
          <BaseButton :loading="isRegistering">Create Account</BaseButton>
        </div>
      </form>

      <!-- Footer link -->
      <p class="text-center text-[12px] text-white/25 mt-8">
        Already have an account?
        <NuxtLink to="/auth/login" class="text-white/55 hover:text-white transition-colors ml-1">Sign in</NuxtLink>
      </p>

    </div>
  </div>
</template>

<script setup lang="ts">
import { SIGNUP_MUTATION } from '~/graphql/auth'

const fullName = ref('')
const email = ref('')
const password = ref('')
const isRegistering = ref(false)
const errorMessage = ref('')

const handleSignup = async () => {
  if (!fullName.value || !email.value || !password.value) {
    errorMessage.value = "Please fill in all fields."
    return
  }

  isRegistering.value = true
  errorMessage.value = ""

  try {
    const { $apollo } = useNuxtApp()
    const result = await $apollo.defaultClient.mutate({
      mutation: SIGNUP_MUTATION,
      variables: {
        full_name: fullName.value,
        email: email.value,
        password: password.value
      }
    })

    if (result?.data?.signup) {
      await navigateTo('/auth/login')
    }
  } catch (err: any) {
    console.error("Signup Error:", err)
    errorMessage.value = err.message || "Failed to create account."
  } finally {
    isRegistering.value = false
  }
}
</script>
