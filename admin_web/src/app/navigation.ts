import {
  Bell,
  CalendarDays,
  HeartPulse,
  LayoutDashboard,
  MessageCircle,
  Newspaper,
  PawPrint,
  Scissors,
  Settings,
  Users,
} from "lucide-react";

export type AdminSection =
  | "overview"
  | "bookings"
  | "services"
  | "customers"
  | "chat"
  | "information"
  | "pets"
  | "reports"
  | "notifications"
  | "settings";

export const navigationItems = [
  { id: "overview", label: "Overview", icon: LayoutDashboard },
  { id: "bookings", label: "Bookings", icon: CalendarDays },
  { id: "services", label: "Services", icon: Scissors },
  { id: "customers", label: "Customers", icon: Users },
  { id: "chat", label: "Chat", icon: MessageCircle },
  { id: "information", label: "New Information", icon: Newspaper },
  { id: "pets", label: "Pets", icon: PawPrint },
  { id: "reports", label: "Reports", icon: HeartPulse },
  { id: "notifications", label: "Notifications", icon: Bell },
  { id: "settings", label: "Settings", icon: Settings },
] as const satisfies ReadonlyArray<{
  id: AdminSection;
  label: string;
  icon: typeof LayoutDashboard;
}>;

export type NavigationItem = (typeof navigationItems)[number];
