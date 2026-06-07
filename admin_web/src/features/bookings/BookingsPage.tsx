import { CalendarDays, Clock, Headphones, MoreVertical } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";
import { StatusBadge } from "../../shared/components/StatusBadge";
import { bookings } from "../../shared/data/mockData";

export function BookingsPage() {
  return (
    <section className="page-stack">
      <PageHeader
        title="Booking Management"
        description="Oversee all upcoming and past pet care appointments."
      />

      <div className="booking-toolbar">
        <div className="filter-card"><small>Date Range</small><select><option>Next 7 Days</option></select></div>
        <div className="filter-card"><small>Status</small><div className="filter-pills"><b>All</b><span>Confirmed</span><span>Pending</span></div></div>
        <div className="filter-card"><small>Service Type</small><select><option>All Services</option></select></div>
        <div className="support-card"><Headphones size={20} /><span>Need Help?<br />Contact Support Team</span></div>
      </div>

      <div className="stats-grid two">
        <StatCard icon={CalendarDays} label="Today's Bookings" value="24" tone="orange" />
        <StatCard icon={Clock} label="Pending Confirm" value="12" tone="green" />
      </div>

      <article className="panel">
        <div className="data-table booking-table">
          <div className="table-row table-head">
            <span>Pet & Owner</span><span>Service Type</span><span>Date & Time</span><span>Status</span><span>Actions</span>
          </div>
          {bookings.map((booking) => (
            <div className="table-row" key={`${booking.pet}-${booking.service}`}>
              <span className="pet-owner">
                <img src={booking.image} alt={booking.pet} />
                <span><strong>{booking.pet}</strong><small>Owner: {booking.owner}</small></span>
              </span>
              <span><span className="service-pill">{booking.service}</span></span>
              <span><strong>{booking.date}</strong><small>{booking.time}</small></span>
              <StatusBadge
                status={booking.status}
                tone={booking.status === "Pending" ? "pending" : booking.status === "Cancelled" ? "cancelled" : "confirmed"}
              />
              <span className="row-actions">
                {booking.status === "Pending" ? <button className="small-primary">Confirm</button> : null}
                <button className="ghost-icon" title="More actions"><MoreVertical size={17} /></button>
              </span>
            </div>
          ))}
        </div>
        <div className="pagination"><span>Showing 1-10 of 48 bookings</span><b>1</b><span>2</span><span>3</span><span>...</span><span>5</span></div>
      </article>
    </section>
  );
}
