type StatusBadgeProps = {
  status: string;
  tone?: "confirmed" | "pending" | "cancelled" | "active" | "neutral";
};

export function StatusBadge({ status, tone = "neutral" }: StatusBadgeProps) {
  return <span className={`status-badge ${tone}`}>{status}</span>;
}
