import { Edit3, Plus, Trash2, Wallet, CheckCircle, BriefcaseBusiness } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";
import { StatusBadge } from "../../shared/components/StatusBadge";
import { services } from "../../shared/data/mockData";

export function ServicesPage() {
  return (
    <section className="page-stack">
      <PageHeader
        title="Service Inventory"
        description="Manage clinic offerings, pricing consistency, and service package performance."
        actions={<button className="primary-inline"><Plus size={15} /> Add New Service</button>}
      />

      <div className="services-summary">
        <StatCard icon={BriefcaseBusiness} label="Total Services" value="12" tone="blue" />
        <StatCard icon={CheckCircle} label="Active Now" value="10" tone="green" />
        <article className="top-service">
          <Wallet size={20} />
          <span>Top Performing Service</span>
          <strong>Premium Grooming</strong>
          <small>Generated +24% more revenue this month</small>
        </article>
      </div>

      <div className="service-list">
        {services.map((service) => (
          <article className={`service-card ${service.active ? "" : "muted-card"}`} key={service.name}>
            <img src={service.image} alt={service.name} />
            <div>
              <h3>{service.name} <StatusBadge status={service.active ? "Active" : "Inactive"} tone={service.active ? "active" : "neutral"} /></h3>
              <p>{service.category}</p>
              <small>{service.meta}</small>
            </div>
            <div className="card-actions">
              <button className="ghost-icon" title="Edit"><Edit3 size={16} /></button>
              <button className="ghost-icon danger" title="Delete"><Trash2 size={16} /></button>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
