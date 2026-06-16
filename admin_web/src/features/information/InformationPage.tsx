import { useEffect, useMemo, useState } from "react";
import {
  Edit3,
  Eye,
  FileImage,
  Newspaper,
  Plus,
  RefreshCw,
  Save,
  Trash2,
} from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { StatCard } from "../../shared/components/StatCard";
import { StatusBadge } from "../../shared/components/StatusBadge";
import {
  informationApi,
  type InformationArticle,
  type InformationCategory,
  type InformationPayload,
} from "../../shared/api/informationApi";

const emptySection = {
  heading: "",
  body: "",
  image: "",
};

const emptyForm: InformationPayload = {
  slug: "",
  title: "",
  mainCategory: "Sức khỏe",
  category: "Sức khỏe",
  tag: "Sức khỏe",
  image: "",
  author: "PawSitive Care",
  publishedDate: "16 Thg 6, 2026",
  readTime: "5 phút đọc",
  shortDescription: "",
  content: {
    intro: "",
    sections: Array.from({ length: 5 }, () => ({ ...emptySection })),
    tip: "",
    conclusion: "",
  },
  sortOrder: 0,
  isActive: true,
};

const categories: InformationCategory[] = ["Sức khỏe", "Dinh dưỡng", "Huấn luyện"];

const fileToDataUrl = (file: File) =>
  new Promise<string>((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(String(reader.result || ""));
    reader.onerror = () => reject(new Error("Không đọc được file ảnh."));
    reader.readAsDataURL(file);
  });

const articleToForm = (article: InformationArticle): InformationPayload => ({
  sourceId: article.sourceId,
  slug: article.slug,
  title: article.title,
  mainCategory: article.mainCategory,
  category: article.category,
  tag: article.tag,
  image: article.image,
  author: article.author,
  publishedDate: article.publishedDate,
  readTime: article.readTime,
  shortDescription: article.shortDescription,
  content: {
    intro: article.content.intro,
    sections:
      article.content.sections.length > 0
        ? article.content.sections.map((section) => ({ ...section }))
        : Array.from({ length: 5 }, () => ({ ...emptySection })),
    tip: article.content.tip ?? "",
    conclusion: article.content.conclusion ?? "",
  },
  sortOrder: article.sortOrder,
  isActive: article.isActive,
});

export function InformationPage() {
  const [items, setItems] = useState<InformationArticle[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<InformationCategory | "all">("all");
  const [editingArticle, setEditingArticle] = useState<InformationArticle | null>(null);
  const [form, setForm] = useState<InformationPayload>(emptyForm);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState("");

  const filteredItems = useMemo(() => {
    if (selectedCategory === "all") {
      return items;
    }
    return items.filter((item) => item.mainCategory === selectedCategory);
  }, [items, selectedCategory]);

  const activeCount = useMemo(() => items.filter((item) => item.isActive).length, [items]);

  const loadArticles = async () => {
    setIsLoading(true);
    setError("");
    try {
      setItems(await informationApi.list(40));
    } catch (nextError) {
      setError(nextError instanceof Error ? nextError.message : "Không tải được thông tin.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadArticles();
  }, []);

  const openCreateForm = () => {
    setEditingArticle(null);
    setForm({
      ...emptyForm,
      content: {
        ...emptyForm.content,
        sections: Array.from({ length: 5 }, () => ({ ...emptySection })),
      },
    });
  };

  const openEditForm = (article: InformationArticle) => {
    setEditingArticle(article);
    setForm(articleToForm(article));
  };

  const setSectionValue = (
    index: number,
    key: "heading" | "body" | "image",
    value: string,
  ) => {
    setForm((current) => ({
      ...current,
      content: {
        ...current.content,
        sections: current.content.sections.map((section, sectionIndex) =>
          sectionIndex === index ? { ...section, [key]: value } : section,
        ),
      },
    }));
  };

  const uploadHeroImage = async (file?: File) => {
    if (!file) {
      return;
    }
    setForm((current) => ({ ...current, image: "" }));
    setForm((current) => ({ ...current, image: current.image }));
    const image = await fileToDataUrl(file);
    setForm((current) => ({ ...current, image }));
  };

  const uploadSectionImage = async (index: number, file?: File) => {
    if (!file) {
      return;
    }
    const image = await fileToDataUrl(file);
    setSectionValue(index, "image", image);
  };

  const submitForm = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setIsSaving(true);
    setError("");

    const payload: InformationPayload = {
      ...form,
      tag: form.tag || form.mainCategory,
      category: form.category || form.mainCategory,
      content: {
        ...form.content,
        sections: form.content.sections.filter(
          (section) => section.heading.trim() && section.body.trim() && section.image.trim(),
        ),
      },
    };

    try {
      if (editingArticle) {
        const updated = await informationApi.update(editingArticle.id, payload);
        setItems((current) =>
          current.map((item) => (item.id === updated.id ? updated : item)),
        );
        setEditingArticle(updated);
        setForm(articleToForm(updated));
      } else {
        const created = await informationApi.create(payload);
        setItems((current) => [...current, created].sort((a, b) => a.sortOrder - b.sortOrder));
        setEditingArticle(created);
        setForm(articleToForm(created));
      }
    } catch (nextError) {
      setError(nextError instanceof Error ? nextError.message : "Không lưu được thông tin.");
    } finally {
      setIsSaving(false);
    }
  };

  const deleteArticle = async (article: InformationArticle) => {
    if (!window.confirm(`Xóa bài "${article.title}"?`)) {
      return;
    }

    setError("");
    try {
      await informationApi.remove(article.id);
      setItems((current) => current.filter((item) => item.id !== article.id));
      if (editingArticle?.id === article.id) {
        openCreateForm();
      }
    } catch (nextError) {
      setError(nextError instanceof Error ? nextError.message : "Không xóa được thông tin.");
    }
  };

  return (
    <section className="page-stack">
      <PageHeader
        title="New Information"
        description="Quản lý bài viết blog, hình ảnh nền và nội dung chi tiết hiển thị trong Flutter app."
        actions={
          <div className="inline-actions">
            <button className="secondary-inline" onClick={loadArticles}>
              <RefreshCw size={15} /> Refresh
            </button>
            <button className="primary-inline" onClick={openCreateForm}>
              <Plus size={15} /> New Information
            </button>
          </div>
        }
      />

      <div className="services-summary">
        <StatCard icon={Newspaper} label="Total Posts" value={String(items.length)} tone="blue" />
        <StatCard icon={Eye} label="Active Posts" value={String(activeCount)} tone="green" />
        <article className="top-service">
          <FileImage size={20} />
          <span>Image Setup</span>
          <strong>Hero + 5 section images</strong>
          <small>Ảnh được lưu trực tiếp trong MongoDB theo từng bài.</small>
        </article>
      </div>

      {error ? <p className="admin-error">{error}</p> : null}

      <div className="information-layout">
        <aside className="panel information-list-panel">
          <div className="panel-title">
            <div>
              <h2>Danh sách bài viết</h2>
              <p>Chọn một bài để chỉnh sửa.</p>
            </div>
          </div>
          <div className="info-filter-row">
            <button
              className={selectedCategory === "all" ? "chip-button active" : "chip-button"}
              onClick={() => setSelectedCategory("all")}
            >
              Tất cả
            </button>
            {categories.map((category) => (
              <button
                className={selectedCategory === category ? "chip-button active" : "chip-button"}
                key={category}
                onClick={() => setSelectedCategory(category)}
              >
                {category}
              </button>
            ))}
          </div>

          {isLoading ? <p className="empty-state">Đang tải thông tin...</p> : null}
          {!isLoading && filteredItems.length === 0 ? (
            <p className="empty-state">Chưa có bài viết phù hợp.</p>
          ) : null}
          <div className="information-list">
            {filteredItems.map((article) => (
              <article
                className={`information-row ${
                  editingArticle?.id === article.id ? "active" : ""
                }`}
                key={article.id}
                onClick={() => openEditForm(article)}
              >
                <img src={article.image} alt={article.title} />
                <div>
                  <h3>{article.title}</h3>
                  <p>{article.mainCategory} · {article.readTime}</p>
                  <StatusBadge
                    status={article.isActive ? "Active" : "Inactive"}
                    tone={article.isActive ? "active" : "neutral"}
                  />
                </div>
                <button
                  className="ghost-icon danger"
                  title="Delete"
                  onClick={(event) => {
                    event.stopPropagation();
                    deleteArticle(article);
                  }}
                >
                  <Trash2 size={15} />
                </button>
              </article>
            ))}
          </div>
        </aside>

        <form className="panel information-editor" onSubmit={submitForm}>
          <div className="panel-title">
            <div>
              <h2>{editingArticle ? "Cập nhật bài viết" : "Tạo bài viết mới"}</h2>
              <p>Thông tin này sẽ được app gọi từ API blog-posts.</p>
            </div>
            <button className="primary-inline" type="submit" disabled={isSaving}>
              <Save size={15} /> {isSaving ? "Đang lưu..." : "Lưu thông tin"}
            </button>
          </div>

          <div className="information-hero-editor">
            <img src={form.image || "https://placehold.co/720x360?text=Hero+Image"} alt="Hero preview" />
            <label>
              Ảnh nền bài viết
              <input
                value={form.image}
                onChange={(event) => setForm({ ...form, image: event.target.value })}
                placeholder="URL hoặc data:image..."
                required
              />
              <input
                accept="image/*"
                type="file"
                onChange={(event) => uploadHeroImage(event.target.files?.[0])}
              />
            </label>
          </div>

          <div className="form-grid">
            <label>
              Tiêu đề
              <input
                value={form.title}
                onChange={(event) => setForm({ ...form, title: event.target.value })}
                required
              />
            </label>
            <label>
              Slug
              <input
                value={form.slug}
                onChange={(event) => setForm({ ...form, slug: event.target.value })}
                placeholder="Tự sinh nếu để trống"
              />
            </label>
            <label>
              Main category
              <select
                value={form.mainCategory}
                onChange={(event) => {
                  const mainCategory = event.target.value as InformationCategory;
                  setForm({
                    ...form,
                    mainCategory,
                    category: mainCategory,
                    tag: mainCategory,
                  });
                }}
              >
                {categories.map((category) => (
                  <option key={category} value={category}>{category}</option>
                ))}
              </select>
            </label>
            <label>
              Tác giả
              <input
                value={form.author}
                onChange={(event) => setForm({ ...form, author: event.target.value })}
                required
              />
            </label>
            <label>
              Ngày đăng
              <input
                value={form.publishedDate}
                onChange={(event) => setForm({ ...form, publishedDate: event.target.value })}
                required
              />
            </label>
            <label>
              Thời gian đọc
              <input
                value={form.readTime}
                onChange={(event) => setForm({ ...form, readTime: event.target.value })}
                required
              />
            </label>
            <label>
              Thứ tự
              <input
                min={0}
                type="number"
                value={form.sortOrder}
                onChange={(event) => setForm({ ...form, sortOrder: Number(event.target.value) })}
              />
            </label>
            <label className="service-toggle">
              <input
                checked={form.isActive}
                type="checkbox"
                onChange={(event) => setForm({ ...form, isActive: event.target.checked })}
              />
              Đang hiển thị
            </label>
            <label className="wide">
              Mô tả ngắn
              <textarea
                value={form.shortDescription}
                onChange={(event) => setForm({ ...form, shortDescription: event.target.value })}
                required
              />
            </label>
            <label className="wide">
              Mở bài
              <textarea
                value={form.content.intro}
                onChange={(event) =>
                  setForm({
                    ...form,
                    content: { ...form.content, intro: event.target.value },
                  })
                }
                required
              />
            </label>
          </div>

          <div className="information-section-stack">
            <div className="panel-title compact">
              <div>
                <h2>Nội dung chi tiết</h2>
                <p>Mỗi mục gồm tiêu đề, mô tả và một ảnh riêng.</p>
              </div>
            </div>
            {form.content.sections.map((section, index) => (
              <article className="information-section-editor" key={`${index}-${section.heading}`}>
                <img
                  src={section.image || "https://placehold.co/360x240?text=Section+Image"}
                  alt={`Section ${index + 1}`}
                />
                <div>
                  <label>
                    Tiêu đề mục {index + 1}
                    <input
                      value={section.heading}
                      onChange={(event) => setSectionValue(index, "heading", event.target.value)}
                      required={index === 0}
                    />
                  </label>
                  <label>
                    Nội dung
                    <textarea
                      value={section.body}
                      onChange={(event) => setSectionValue(index, "body", event.target.value)}
                      required={index === 0}
                    />
                  </label>
                  <label>
                    Ảnh mục
                    <input
                      value={section.image}
                      onChange={(event) => setSectionValue(index, "image", event.target.value)}
                      placeholder="URL hoặc data:image..."
                      required={index === 0}
                    />
                    <input
                      accept="image/*"
                      type="file"
                      onChange={(event) => uploadSectionImage(index, event.target.files?.[0])}
                    />
                  </label>
                </div>
              </article>
            ))}
          </div>

          <div className="form-grid">
            <label className="wide">
              Gợi ý
              <textarea
                value={form.content.tip ?? ""}
                onChange={(event) =>
                  setForm({
                    ...form,
                    content: { ...form.content, tip: event.target.value },
                  })
                }
              />
            </label>
            <label className="wide">
              Kết luận
              <textarea
                value={form.content.conclusion ?? ""}
                onChange={(event) =>
                  setForm({
                    ...form,
                    content: { ...form.content, conclusion: event.target.value },
                  })
                }
              />
            </label>
          </div>
        </form>
      </div>
    </section>
  );
}
