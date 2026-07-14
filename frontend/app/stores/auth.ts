import { GET_ME } from '~/graphql/movies'

const decodeRoleFromToken = (token: string): string | null => {
  try {
    const payload = token.split('.')[1]
    if (!payload) return null
    const base64 = payload.replace(/-/g, '+').replace(/_/g, '/')
    const json = decodeURIComponent(
      atob(base64)
        .split('')
        .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    )
    const claims = JSON.parse(json)
    return claims?.['https://hasura.io/jwt/claims']?.['x-hasura-default-role'] ?? null
  } catch {
    return null
  }
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<any>(null)

  const isAuthenticated = computed(() => !!user.value)
  const isAdmin = computed(() => !!user.value?.is_admin)
  const userInitial = computed(() =>
    user.value?.full_name ? user.value.full_name.charAt(0).toUpperCase() : '?'
  )

  const fetchUser = async (explicitToken?: string) => {
    const authCookie = useCookie('auth_token')
    const token = explicitToken || authCookie.value
    if (!token) {
      user.value = null
      return
    }

    try {
      const { resolveClient } = useApolloClient()
      const client = resolveClient()

      const { data } = await client.query({
        query: GET_ME,
        fetchPolicy: 'network-only',
        context: {
          headers: {
            Authorization: `Bearer ${token}`
          }
        }
      })

      if (data?.users?.length > 0) {
        const userIdCookie = useCookie('user_id')
        const rawUserData = data.users.find((u: any) => u.id === userIdCookie.value) || data.users[0]
        const userData = { ...rawUserData }

        userData.is_admin = decodeRoleFromToken(token) === 'admin'
        user.value = userData
      } else {
        user.value = null
      }
    } catch (err) {
      console.error('Auth fetch error:', err)
      user.value = null
    }
  }

  const onLogin = async (token: string) => {
    const { onLogin: apolloLogin } = useApollo()
    await apolloLogin(token)
  }

  const onLogout = async () => {
    const { onLogout: apolloLogout } = useApollo()
    await apolloLogout()
  }

  const logout = async () => {
    await onLogout()

    user.value = null
    const userIdCookie = useCookie('user_id')
    userIdCookie.value = null

    useBookingStore().clearBooking()

    await navigateTo('/auth/login')
  }

  return {
    user,
    isAuthenticated,
    isAdmin,
    userInitial,
    fetchUser,
    onLogin,
    onLogout,
    logout
  }
})
