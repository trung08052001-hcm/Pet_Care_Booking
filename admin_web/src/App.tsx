import { useMemo, useState } from "react";
import { AdminShell } from "./app/AdminShell";
import { navigationItems, type AdminSection } from "./app/navigation";
import { LoginPage } from "./features/auth/LoginPage";
import { BookingsPage } from "./features/bookings/BookingsPage";
import { ChatPage } from "./features/chat/ChatPage";
import { CustomersPage } from "./features/customers/CustomersPage";
import { InformationPage } from "./features/information/InformationPage";
import { NotificationsPage } from "./features/notifications/NotificationsPage";
import { OverviewPage } from "./features/overview/OverviewPage";
import { PetsPage } from "./features/pets/PetsPage";
import { ReportsPage } from "./features/reports/ReportsPage";
import { ServicesPage } from "./features/services/ServicesPage";
import { SettingsPage } from "./features/settings/SettingsPage";
import type { AdminSession } from "./shared/api/authApi";

const pageMap: Record<AdminSection, JSX.Element> = {
  overview: <OverviewPage />,
  bookings: <BookingsPage />,
  services: <ServicesPage />,
  customers: <CustomersPage />,
  chat: <ChatPage />,
  information: <InformationPage />,
  pets: <PetsPage />,
  reports: <ReportsPage />,
  notifications: <NotificationsPage />,
  settings: <SettingsPage />,
};

export function App() {
  const [activeSection, setActiveSection] = useState<AdminSection>("overview");
  const [session, setSession] = useState<AdminSession | null>(() => {
    const savedSession = window.localStorage.getItem("admin_session");

    if (!savedSession) {
      return null;
    }

    try {
      return JSON.parse(savedSession) as AdminSession;
    } catch {
      window.localStorage.removeItem("admin_session");
      return null;
    }
  });

  const currentSection = useMemo(
    () => navigationItems.find((item) => item.id === activeSection) ?? navigationItems[0],
    [activeSection],
  );

  if (!session) {
    return (
      <LoginPage
        onSignIn={(nextSession) => {
          window.localStorage.setItem("admin_session", JSON.stringify(nextSession));
          setSession(nextSession);
        }}
      />
    );
  }

  return (
    <AdminShell
      activeSection={activeSection}
      currentSection={currentSection}
      onNavigate={setActiveSection}
    >
      {pageMap[activeSection]}
    </AdminShell>
  );
}
