import { Download, Eye, Star, UserPlus, Users } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";
import { customers } from "../../shared/data/mockData";

export function CustomersPage() {
  return (
    <section className="page-stack">
      <PageHeader
        title="Customer Database"
        description="Manage pet owner relationships and customer lifecycle."
        actions={
          <>
            <button className="secondary-inline"><Download size={15} /> Export CSV</button>
            <button className="primary-inline"><UserPlus size={15} /> Add Customer</button>
          </>
        }
      />

      <div className="stats-grid four">
        <StatCard icon={Users} label="Total Customers" value="1,248" tone="green" helper="+12%" />
        <StatCard icon={Users} label="Registered Pets" value="1,892" tone="green" helper="+8%" />
        <StatCard icon={Star} label="Avg. Monthly Spend" value="$245" tone="blue" helper="+4%" />
        <StatCard icon={Star} label="Customer Satisfaction" value="4.9" tone="orange" helper="★★★★★" />
      </div>

      <article className="panel">
        <div className="table-tools">
          <button className="chip-button">Filters</button>
          <span className="pill selected">All</span><span className="pill">VIP</span><span className="pill">New</span><span className="pill">Inactive</span>
          <small>Showing 1-10 of 1,248 customers</small>
        </div>
        <div className="data-table customer-table">
          <div className="table-row table-head">
            <span>Customer Name</span><span>Contact Info</span><span>Pets</span><span>Total Spend</span><span>Last Visit</span><span />
          </div>
          {customers.map((customer) => (
            <div className="table-row" key={customer.email}>
              <span className="avatar-name"><i>{customer.name.slice(0, 1)}</i><span><strong>{customer.name}</strong><small>{customer.tier}</small></span></span>
              <span><strong>{customer.email}</strong><small>(555) 123-4567</small></span>
              <span className="pet-tags">{customer.pets}</span>
              <span><strong>{customer.spend}</strong><small>Top 9% spender</small></span>
              <span>{customer.lastVisit}<small>8 days ago</small></span>
              <button className="ghost-icon" title="View"><Eye size={16} /></button>
            </div>
          ))}
        </div>
        <div className="pagination"><span>Previous</span><b>1</b><span>2</span><span>3</span><span>...</span><span>125</span><span>Next</span></div>
      </article>
    </section>
  );
}
