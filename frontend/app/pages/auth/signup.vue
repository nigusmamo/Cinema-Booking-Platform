<template>
  <div class="min-h-screen bg-bg-main flex items-center justify-center p-4 font-sans text-white">
    <div class="max-w-md w-full bg-bg-card p-8 rounded-2xl border border-gray-800 shadow-2xl">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold mb-2">Create Account</h1>
        <p class="text-text-soft text-sm">Join us and enjoy the best</p> 
      </div>
      <div v-if="errorMessage" class="mb-6 p-3 bg-red-500/10 border border-red-500 text-red-500 text-sm rounded-lg text-center">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleSignup">
        <BaseInput
          v-model="fullName"
          label="Full Name"
          placeholder="Enter your full name"
        />
        <BaseInput
          v-model="email"
          label="Email"
          type="email"
          placeholder="Enter your email address"
        />
        <BaseInput
          v-model="password"
          label="Password"
          type="password"
          placeholder="Enter your password"
        />

        <BaseButton :loading="isRegistering" class="mt-4">Sign Up</BaseButton>
      </form>

      <div class="mt-8 text-center border-t border-gray-800 pt-6">
        <p class="text-sm text-text-soft">
          Already have an account? 
          <NuxtLink to="/auth/login" class="text-primary font-bold hover:underline">Login</NuxtLink>
        </p>
      </div>
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
      },
      context: {
        headers: {
          Authorization: '' 
        }
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