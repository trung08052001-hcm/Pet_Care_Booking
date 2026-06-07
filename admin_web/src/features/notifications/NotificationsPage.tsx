import { Archive, BellRing, CheckCircle, Clock, ShieldCheck, Star, TriangleAlert } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { notifications } from "../../shared/data/mockData";

const iconMap = {
  booking: BellRing,
  message: Clock,
  system: ShieldCheck,
  warning: TriangleAlert,
  review: Star,
};

export function NotificationsPage() {
  return (
    <section className="notification-layout">
      <PageHeader title="Notifications" description="Keep track of every administrative update in real time." />
      <aside className="notification-side">
        <article className="summary-tile">
          <BellRing size={21} />
          <strong>Activity Summary</strong>
          <span>New Alerts <b>12</b></span>
          <span>Avg. Response <b>14m</b></span>
        </article>
        <article className="quick-actions">
          <strong>Quick Actions</strong>
          <button><CheckCircle size={15} /> Mark all as read</button>
          <button><Archive size={15} /> Archive history</button>
        </article>
      </aside>
      <div className="notification-feed">
        <div className="tab-row"><span className="pill selected">All</span><span className="pill">Unread</span><span className="pill">System</span><span className="pill">Bookings</span></div>
        {notifications.map((item) => {
          const Icon = iconMap[item.tone as keyof typeof iconMap];
          return (
            <article className={`notification-card ${item.tone}`} key={item.title}>
              <Icon size={22} />
              <div><h3>{item.title}</h3><p>{item.body}</p>{item.tone === "booking" ? <button className="small-primary">Accept Booking</button> : null}</div>
              <small>{item.time}</small>
            </article>
          );
        })}
      </div>
    </section>
  );
}
