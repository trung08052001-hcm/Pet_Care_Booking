import { Upload } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";

export function SettingsPage() {
  return (
    <section className="page-stack">
      <PageHeader title="Settings" description="Control store information, permissions, notifications, and preferences." />
      <div className="settings-tabs"><span className="active">Store Information</span><span>Working Hours</span><span>Notifications</span><span>User Roles</span><span>System Preferences</span></div>

      <div className="settings-grid">
        <div className="settings-main">
          <article className="panel form-panel">
            <h2>General Business Details</h2>
            <div className="form-grid">
              <label>Business Name<input value="PawSitive Care Sanctuary" readOnly /></label>
              <label>Registration Number<input value="PC-9988-2026" readOnly /></label>
              <label className="wide">Business Address<textarea value="154 Tran Thi Trong, Tan Son Ward, Ho Chi Minh City" readOnly /></label>
              <label>Primary Phone<input value="+84 908 765 432" readOnly /></label>
              <label>Contact Email<input value="hello@pawsitivecare.com" readOnly /></label>
            </div>
          </article>

          <article className="panel branding-panel">
            <h2>Branding & Logo</h2>
            <div className="upload-box"><Upload size={28} /></div>
            <div><p>Upload your business logo. Recommended size is 512x512px in PNG or SVG format.</p><button className="primary-inline">Upload New</button><button className="secondary-inline">Remove</button></div>
          </article>
        </div>

        <aside className="settings-side">
          <article className="save-card"><h2>Save Changes</h2><p>You have 3 unsaved configuration changes in your settings.</p><button>Apply All Changes</button><button>Discard Draft</button></article>
          <article className="panel insights"><h3>Quick Insights</h3><span>Last Sync <b>2 mins ago</b></span><span>System Health <b className="ok">Optimal</b></span><span>Admin Users <b>4 active</b></span></article>
          <article className="panel help-card"><h3>Need Help?</h3><p>Check our administrative guide for setting up complex workflows.</p><button className="link-button">Read Documentation</button></article>
        </aside>
      </div>
    </section>
  );
}
