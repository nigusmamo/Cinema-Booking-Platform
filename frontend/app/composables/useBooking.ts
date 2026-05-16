// app/composables/useBooking.ts
export const useBookingStore = () => {
  // <any> እና <string[]> በማለት ለ TypeScript የሳጥኑን አይነት እንነግረዋለን
  const selectedMovie = useState<any>('selected_movie', () => null)
  const selectedSeats = useState<string[]>('selected_seats', () => [])
  const totalPrice = useState<number>('total_price', () => 0)

  const saveBooking = (movieData: any, seats: string[], price: number) => {
    selectedMovie.value = movieData
    selectedSeats.value = seats
    totalPrice.value = price
    
    // በኑክስት 4 'import.meta.client' መጠቀም ይመከራል
    if (import.meta.client) {
      const cleanData = JSON.stringify({ movie: movieData, seats, price })
      localStorage.setItem('cinema_booking_storage', cleanData)
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

  return {
    selectedMovie,
    selectedSeats,
    totalPrice,
    saveBooking,
    loadBooking
  }
}