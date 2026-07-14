export const useBookingStore = defineStore('booking', () => {
  const selectedMovie = ref<any>(null)
  const selectedSeats = ref<string[]>([])
  const totalPrice = ref(0)
  const redirectAfterLogin = ref<string | null>(null)

  const saveBooking = (movieData: any, seats: string[], price: number) => {
    selectedMovie.value = movieData
    selectedSeats.value = seats
    totalPrice.value = price

    if (import.meta.client) {
      localStorage.setItem('cinema_booking_storage', JSON.stringify({ movie: movieData, seats, price }))
    }
  }

  const loadBooking = () => {
    if (import.meta.client) {
      const saved = localStorage.getItem('cinema_booking_storage')
      if (saved) {
        const parsed = JSON.parse(saved)
        selectedMovie.value = parsed.movie
        selectedSeats.value = parsed.seats
        totalPrice.value = parsed.price
        return true
      }
    }
    return false
  }

  const clearBooking = () => {
    selectedMovie.value = null
    selectedSeats.value = []
    totalPrice.value = 0
    if (import.meta.client) {
      localStorage.removeItem('cinema_booking_storage')
    }
  }

  return {
    selectedMovie,
    selectedSeats,
    totalPrice,
    redirectAfterLogin,
    saveBooking,
    loadBooking,
    clearBooking
  }
})
