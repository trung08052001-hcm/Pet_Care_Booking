import { CalendarDays, Download, FileText, Users, Wallet } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";

export function ReportsPage() {
  return (
    <section className="page-stack">
      <PageHeader
        title="Business Intelligence"
        description="Analyze performance metrics and growth trends for Q3 2026."
        actions={
          <>
            <button className="secondary-inline"><CalendarDays size={15} /> Last 30 Days</button>
            <button className="secondary-inline"><FileText size={15} /> PDF</button>
            <button className="secondary-inline"><Download size={15} /> CSV</button>
          </>
        }
      />

      <div className="stats-grid three">
        <StatCard icon={Wallet} label="Monthly Revenue" value="$42,890.00" tone="orange" helper="+12.4%" />
        <StatCard icon={Users} label="New Customers" value="142" tone="blue" helper="+8.1%" />
        <StatCard icon={CalendarDays} label="Total Bookings" value="387" tone="green" helper="Goal: 400" />
      </div>

      <div className="reports-grid">
        <article className="panel revenue-panel">
          <div className="panel-title"><h2>Revenue Growth Trend</h2><span><i className="dot orange" /> Grooming <i className="dot blue" /> Boarding</span></div>
          <div className="bar-chart">
            {[42, 58, 82, 66, 100, 92].map((height, index) => (
              <div key={index}><span style={{ height: `${height}%` }} /><small>{["Jan", "Feb", "Mar", "Apr", "May", "Jun"][index]}</small></div>
            ))}
          </div>
        </article>
        <article className="panel donut-panel">
          <h2>Popular Services</h2>
          <div className="donut-chart services">1.2k<small>Total tasks</small></div>
          <ul className="legend-list">
            <li><i className="dot orange" /> Dog Walking <strong>45%</strong></li>
            <li><i className="dot blue" /> Grooming <strong>30%</strong></li>
            <li><i className="dot green" /> Healthcare <strong>25%</strong></li>
          </ul>
        </article>
      </div>

      <article className="panel">
        <div className="panel-title"><h2>Staff Performance Rankings</h2><button className="link-button">View Full Roster</button></div>
        <div className="data-table compact">
          <div className="table-row table-head"><span>Staff Member</span><span>Completed</span><span>Rating</span><span>Avg. Duration</span><span>Revenue Contrib.</span></div>
          {["David Chen", "Emily Watson", "Marcus Thorne"].map((name, index) => (
            <div className="table-row" key={name}>
              <span className="avatar-name"><i>{name[0]}</i>{name}</span>
              <span>{[154, 142, 128][index]} jobs</span>
              <span>★ {[4.9, 4.8, 5.0][index]}</span>
              <span>{[42, 38, 55][index]} mins</span>
              <strong>${["5,420", "4,890", "4,210"][index]}</strong>
            </div>
          ))}
        </div>
      </article>
    </section>
  );
}
