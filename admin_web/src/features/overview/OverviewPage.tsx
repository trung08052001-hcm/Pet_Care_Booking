import { CalendarCheck, PawPrint, Star, Wallet } from "lucide-react";
import { bookings } from "../../shared/data/mockData";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";
import { StatusBadge } from "../../shared/components/StatusBadge";

export function OverviewPage() {
  return (
    <section className="page-stack">
      <PageHeader
        title="Dashboard Overview"
        description="Welcome back. Here's what's happening at PawSitive Care today."
      />

      <div className="stats-grid four">
        <StatCard icon={Wallet} label="Total Revenue" value="$25,000,000đ" tone="green" helper="+12%" />
        <StatCard icon={CalendarCheck} label="Active Bookings" value="48" tone="orange" helper="5 pending" />
        <StatCard icon={PawPrint} label="New Pets" value="12" tone="blue" helper="This week" />
        <StatCard icon={Star} label="Customer Satisfaction" value="4.9/5" tone="orange" helper="Excellent" />
      </div>

      <div className="overview-grid">
        <article className="panel chart-panel">
          <div className="panel-title">
            <div>
              <h2>Booking Trends</h2>
              <p>Weekly performance analysis</p>
            </div>
            <button className="chip-button" type="button">Last 7 Days</button>
          </div>
          <div className="line-chart">
            {[28, 44, 36, 58, 62, 51, 72].map((height, index) => (
              <span key={index} style={{ height: `${height}%` }} />
            ))}
          </div>
          <div className="chart-days">
            {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) => (
              <small key={day}>{day}</small>
            ))}
          </div>
        </article>

        <article className="panel donut-panel">
          <div className="panel-title">
            <h2>Service Distribution</h2>
          </div>
          <div className="donut-chart" aria-label="Service distribution">100%</div>
          <ul className="legend-list">
            <li><i className="dot orange" /> Grooming <strong>40%</strong></li>
            <li><i className="dot blue" /> Boarding <strong>25%</strong></li>
            <li><i className="dot green" /> Medical <strong>20%</strong></li>
            <li><i className="dot muted" /> Daycare <strong>15%</strong></li>
          </ul>
        </article>
      </div>

      <article className="panel">
        <div className="panel-title">
          <div>
            <h2>Recent Activity</h2>
            <p>Monitor live booking status updates</p>
          </div>
          <button className="link-button" type="button">View All Bookings</button>
        </div>
        <div className="data-table compact">
          <div className="table-row table-head">
            <span>Pet Name</span><span>Service</span><span>Date</span><span>Time</span><span>Status</span>
          </div>
          {bookings.slice(0, 3).map((booking) => (
            <div className="table-row" key={booking.pet}>
              <span className="name-cell"><img src={booking.image} alt="" />{booking.pet}</span>
              <span>{booking.service}</span>
              <span>{booking.date}</span>
              <span>{booking.time.split(" - ")[0]}</span>
              <StatusBadge
                status={booking.status}
                tone={booking.status === "Pending" ? "pending" : "confirmed"}
              />
            </div>
          ))}
        </div>
      </article>
    </section>
  );
}
