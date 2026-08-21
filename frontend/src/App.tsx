import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { MainLayout } from './layouts/MainLayout'
import { Home } from './pages/Home'
import { Search } from './pages/Search'
import { EventDetail } from './pages/EventDetail'
import { SeatSelection } from './pages/SeatSelection'
import { Payment } from './pages/Payment'
import { Confirmation } from './pages/Confirmation'
import { Login } from './pages/Login'
import { OtpVerify } from './pages/OtpVerify'
import { ForgotPassword } from './pages/ForgotPassword'
import { ResetPassword } from './pages/ResetPassword'
import { MyBookings } from './pages/MyBookings'
import { NotFound } from './pages/NotFound'
import { ComingSoonPage } from './components/ComingSoonPage'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<MainLayout />}>
          <Route index element={<Home />} />
          <Route path="search" element={<Search />} />
          <Route path="events/:eventId" element={<EventDetail />} />
          <Route path="events/:eventId/seats" element={<SeatSelection />} />
          <Route path="checkout/payment" element={<Payment />} />
          <Route path="bookings/:bookingId/confirmation" element={<Confirmation />} />
          <Route path="my-bookings" element={<MyBookings />} />
          <Route path="plays" element={<ComingSoonPage title="Plays & Theatre" phase="Coming Soon" />} />
          <Route path="live" element={<ComingSoonPage title="Live Events" phase="Coming Soon" />} />
        </Route>

        {/* Auth screens use their own split-screen layout, no header/nav */}
        <Route path="login" element={<Login />} />
        <Route path="verify-otp" element={<OtpVerify />} />
        <Route path="forgot-password" element={<ForgotPassword />} />
        <Route path="reset-password" element={<ResetPassword />} />

        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
