import { gql } from '#imports'
import { GET_ME } from '~/graphql/movies'

export const useAuth = () => {
  const user = useState<any>('auth_user', () => null)
  const authCookie = useCookie('auth_token')
  const { resolveClient } = useApolloClient()
  const { onLogin, onLogout } = useApollo()

  const fetchUser = async (explicitToken?: string) => {
    const token = explicitToken || authCookie.value
    if (!token) {
      user.value = null
      return
    }

    try {
      const client = resolveClient()

      // 1. Fetch Basic Profile
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

        let isAdminFlag = false

        try {
          const { data: adminCheck } = await client.query({
            query: gql`query AdminCheck { movies_aggregate { aggregate { count } } }`,
            fetchPolicy: 'network-only',
            context: {
              headers: {
                Authorization: `Bearer ${token}`
              }
            }
          })
          if (adminCheck?.movies_aggregate) {
            isAdminFlag = true
          }
        } catch (e) { }

        userData.is_admin = isAdminFlag
        user.value = userData
      } else {
        user.value = null
      }
    } catch (err) {
      console.error("Auth fetch error:", err)
      user.value = null
    }
  }

  const setUser = (userData: any) => {
    user.value = userData
  }

  const logout = async () => {
    // 1. Clear Apollo Cache and Cookie
    await onLogout()

    // 2. Clear Vue State
    user.value = null
    const userIdCookie = useCookie('user_id')
    userIdCookie.value = null

    const { clearBooking } = useBookingStore()
    clearBooking()

    // 4. Redirect
    await navigateTo('/auth/login')
  }

  const userInitial = computed(() => {
    if (user.value?.full_name) {
      return user.value.full_name.charAt(0).toUpperCase()
    }
    return '?'
  })

  return {
    user,
    fetchUser,
    setUser,
    logout,
    onLogin,
    onLogout,
    userInitial,
    isAuthenticated: computed(() => !!user.value),
    isAdmin: computed(() => !!user.value?.is_admin)
  }
}
