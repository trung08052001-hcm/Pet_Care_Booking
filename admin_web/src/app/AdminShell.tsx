import { Bell, LogOut, PawPrint, Plus, Search, Settings } from "lucide-react";
import type { ReactNode } from "react";
import { navigationItems, type AdminSection, type NavigationItem } from "./navigation";

type AdminShellProps = {
  activeSection: AdminSection;
  currentSection: NavigationItem;
  children: ReactNode;
  onNavigate: (section: AdminSection) => void;
};

export function AdminShell({ activeSection, currentSection, children, onNavigate }: AdminShellProps) {
  return (
    <div className="admin-app">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark">
            <PawPrint size={18} />
          </div>
          <div>
            <strong>Admin Panel</strong>
            <span>Management Console</span>
          </div>
        </div>

        <nav className="sidebar-nav" aria-label="Admin navigation">
          {navigationItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.id}
                className={item.id === activeSection ? "nav-item active" : "nav-item"}
                type="button"
                onClick={() => onNavigate(item.id)}
                title={item.label}
              >
                <Icon size={16} />
                <span>{item.label}</span>
              </button>
            );
          })}
        </nav>

        <div className="sidebar-footer">
          <button className="primary-action" type="button">
            <Plus size={16} />
            New Booking
          </button>
          <button className="logout-action" type="button">
            <LogOut size={15} />
            Logout
          </button>
        </div>
      </aside>

      <div className="workspace">
        <header className="topbar">
          <div className="search-field">
            <Search size={15} />
            <input aria-label="Search" placeholder={`Search ${currentSection.label.toLowerCase()}...`} />
          </div>
          <div className="topbar-actions">
            <button className="icon-button has-dot" type="button" title="Notifications">
              <Bell size={17} />
            </button>
            <button className="icon-button" type="button" title="Settings">
              <Settings size={17} />
            </button>
            <div className="admin-profile">
              <span>
                <strong>Alex Rivera</strong>
                <small>Senior Admin</small>
              </span>
              <img
                alt="Admin avatar"
                src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=96&q=80"
              />
            </div>
          </div>
        </header>
        <main className="page-shell">{children}</main>
      </div>
    </div>
  );
}
