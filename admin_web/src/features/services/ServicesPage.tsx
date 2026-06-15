import { useEffect, useMemo, useState } from "react";
import { CheckCircle, Edit3, Plus, Trash2, Wallet, BriefcaseBusiness } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";
import { StatusBadge } from "../../shared/components/StatusBadge";
import { serviceApi, type PetCareService, type ServicePayload } from "../../shared/api/serviceApi";

const emptyForm: ServicePayload = {
  title: "",
  description: "",
  detail: "",
  priceText: "",
  image: "",
  category: "all",
  badge: "POPULAR",
  isActive: true,
  isFeatured: false,
  sortOrder: 0,
};

const categoryLabel = (category: PetCareService["category"]) => {
  if (category === "dog") {
    return "Chó";
  }
  if (category === "cat") {
    return "Mèo";
  }
  return "Tất cả";
};

export function ServicesPage() {
  const [items, setItems] = useState<PetCareService[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState("");
  const [editingService, setEditingService] = useState<PetCareService | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [form, setForm] = useState<ServicePayload>(emptyForm);
  const [isSaving, setIsSaving] = useState(false);

  const activeCount = useMemo(() => items.filter((item) => item.isActive).length, [items]);
  const topService = items[0]?.title ?? "Chưa có dịch vụ";

  const loadServices = async () => {
    setIsLoading(true);
    setError("");
    try {
      setItems(await serviceApi.list());
    } catch (nextError) {
      setError(nextError instanceof Error ? nextError.message : "Không tải được dịch vụ.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadServices();
  }, []);

  const openCreateForm = () => {
    setEditingService(null);
    setForm(emptyForm);
    setIsFormOpen(true);
  };

  const openEditForm = (service: PetCareService) => {
    setEditingService(service);
    setForm({
      title: service.title,
      description: service.description,
      detail: service.detail,
      priceText: service.priceText,
      image: service.image,
      category: service.category,
      badge: service.badge,
      isActive: service.isActive,
      isFeatured: service.isFeatured ?? false,
      sortOrder: service.sortOrder,
    });
    setIsFormOpen(true);
  };

  const submitForm = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setIsSaving(true);
    setError("");
    try {
      if (editingService) {
        const updated = await serviceApi.update(editingService.id, form);
        setItems((current) =>
          current.map((item) => (item.id === updated.id ? updated : item)),
        );
      } else {
        const created = await serviceApi.create(form);
        setItems((current) => [...current, created].sort((a, b) => a.sortOrder - b.sortOrder));
      }
      setIsFormOpen(false);
      setEditingService(null);
      setForm(emptyForm);
    } catch (nextError) {
      setError(nextError instanceof Error ? nextError.message : "Không lưu được dịch vụ.");
    } finally {
      setIsSaving(false);
    }
  };

  const deleteService = async (service: PetCareService) => {
    if (!window.confirm(`Xóa dịch vụ "${service.title}"?`)) {
      return;
    }

    setError("");
    try {
      await serviceApi.remove(service.id);
      setItems((current) => current.filter((item) => item.id !== service.id));
    } catch (nextError) {
      setError(nextError instanceof Error ? nextError.message : "Không xóa được dịch vụ.");
    }
  };

  return (
    <section className="page-stack">
      <PageHeader
        title="Service Inventory"
        description="Quản lý dịch vụ chăm sóc, giá tiền, hình ảnh và nhóm chó/mèo."
        actions={
          <button className="primary-inline" onClick={openCreateForm}>
            <Plus size={15} /> Add New Service
          </button>
        }
      />

      <div className="services-summary">
        <StatCard icon={BriefcaseBusiness} label="Total Services" value={String(items.length)} tone="blue" />
        <StatCard icon={CheckCircle} label="Active Now" value={String(activeCount)} tone="green" />
        <article className="top-service">
          <Wallet size={20} />
          <span>Top Service</span>
          <strong>{topService}</strong>
          <small>Dữ liệu được quản lý từ MongoDB</small>
        </article>
      </div>

      {error ? <p className="admin-error">{error}</p> : null}

      {isFormOpen ? (
        <form className="service-form panel" onSubmit={submitForm}>
          <div className="panel-title">
            <div>
              <h2>{editingService ? "Cập nhật dịch vụ" : "Thêm dịch vụ"}</h2>
              <p>Thông tin này sẽ hiển thị ở màn Services của Flutter app.</p>
            </div>
            <button type="button" className="secondary-inline" onClick={() => setIsFormOpen(false)}>
              Hủy
            </button>
          </div>
          <div className="form-grid">
            <label>
              Tên dịch vụ
              <input value={form.title} onChange={(event) => setForm({ ...form, title: event.target.value })} required />
            </label>
            <label>
              Giá
              <input value={form.priceText} onChange={(event) => setForm({ ...form, priceText: event.target.value })} required />
            </label>
            <label>
              Nhóm
              <select value={form.category} onChange={(event) => setForm({ ...form, category: event.target.value as PetCareService["category"] })}>
                <option value="all">Tất cả</option>
                <option value="dog">Chó</option>
                <option value="cat">Mèo</option>
              </select>
            </label>
            <label className="service-toggle">
              <input type="checkbox" checked={form.isFeatured ?? false} onChange={(event) => setForm({ ...form, isFeatured: event.target.checked })} />
              Hiện ở Home
            </label>
            <label>
              Badge
              <input value={form.badge} onChange={(event) => setForm({ ...form, badge: event.target.value.toUpperCase() })} required />
            </label>
            <label>
              Thứ tự
              <input type="number" min={0} value={form.sortOrder} onChange={(event) => setForm({ ...form, sortOrder: Number(event.target.value) })} />
            </label>
            <label className="service-toggle">
              <input type="checkbox" checked={form.isActive} onChange={(event) => setForm({ ...form, isActive: event.target.checked })} />
              Đang bật dịch vụ
            </label>
            <label className="wide">
              Ảnh
              <input value={form.image} onChange={(event) => setForm({ ...form, image: event.target.value })} required />
            </label>
            <label className="wide">
              Mô tả ngắn
              <textarea value={form.description} onChange={(event) => setForm({ ...form, description: event.target.value })} required />
            </label>
            <label className="wide">
              Chi tiết
              <textarea value={form.detail} onChange={(event) => setForm({ ...form, detail: event.target.value })} required />
            </label>
          </div>
          <button className="primary-inline" type="submit" disabled={isSaving}>
            {isSaving ? "Đang lưu..." : "Lưu dịch vụ"}
          </button>
        </form>
      ) : null}

      <div className="service-list">
        {isLoading ? <p className="empty-state">Đang tải dịch vụ...</p> : null}
        {!isLoading && items.length === 0 ? <p className="empty-state">Chưa có dịch vụ nào.</p> : null}
        {items.map((service) => (
          <article className={`service-card ${service.isActive ? "" : "muted-card"}`} key={service.id}>
            <img src={service.image} alt={service.title} />
            <div>
              <h3>
                {service.title}{" "}
                <StatusBadge status={service.isActive ? "Active" : "Inactive"} tone={service.isActive ? "active" : "neutral"} />
              </h3>
              <p>{categoryLabel(service.category)} · {service.badge} · {service.priceText}</p>
              <small>{service.description}</small>
            </div>
            <div className="card-actions">
              <button className="ghost-icon" title="Edit" onClick={() => openEditForm(service)}><Edit3 size={16} /></button>
              <button className="ghost-icon danger" title="Delete" onClick={() => deleteService(service)}><Trash2 size={16} /></button>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
