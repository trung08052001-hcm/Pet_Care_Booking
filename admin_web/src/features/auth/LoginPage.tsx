import { useState } from "react";
import { ArrowRight, Eye, Headphones, Lock, Mail, PawPrint, ShieldCheck } from "lucide-react";
import { loginAdmin, type AdminSession } from "../../shared/api/authApi";

type LoginPageProps = {
  onSignIn: (session: AdminSession) => void;
};

export function LoginPage({ onSignIn }: LoginPageProps) {
  const [identifier, setIdentifier] = useState("admin@pawcare.com");
  const [password, setPassword] = useState("pawcareadmin");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  return (
    <main className="login-page">
      <section className="login-hero" aria-label="Admin login">
        <div className="login-brand">
          <div className="login-logo">
            <PawPrint size={25} />
          </div>
          <h1>PawCare Admin</h1>
          <p>Management Console</p>
        </div>

        <form
          className="login-card"
          onSubmit={async (event) => {
            event.preventDefault();
            setIsSubmitting(true);
            setError(null);

            try {
              const session = await loginAdmin({
                identifier,
                password,
              });

              onSignIn(session);
            } catch (submitError) {
              setError(
                submitError instanceof Error
                  ? submitError.message
                  : "Unable to sign in to the admin portal."
              );
            } finally {
              setIsSubmitting(false);
            }
          }}
        >
          <label>
            Email Address
            <span className="login-input">
              <Mail size={17} />
              <input
                type="email"
                placeholder="admin@pawcare.com"
                value={identifier}
                onChange={(event) => setIdentifier(event.target.value)}
              />
            </span>
          </label>

          <label>
            <span className="password-label">
              Password
              <button type="button">Forgot password?</button>
            </span>
            <span className="login-input">
              <Lock size={17} />
              <input
                type="password"
                placeholder="password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
              />
              <Eye size={17} />
            </span>
          </label>

          <label className="remember-row">
            <input type="checkbox" />
            Remember me on this device
          </label>

          <button className="login-submit" type="submit" disabled={isSubmitting}>
            {isSubmitting ? "Signing In..." : "Sign In"}
            <ArrowRight size={18} />
          </button>

          {error ? <p className="login-error">{error}</p> : null}
          <p className="security-note">Authorized access only. Security protocols in effect.</p>
        </form>

        <div className="login-support">
          <article>
            <Headphones size={20} />
            <span><strong>IT Help Desk</strong><small>24/7 Priority Support</small></span>
          </article>
          <article>
            <ShieldCheck size={20} />
            <span><strong>Secure Login</strong><small>End-to-end Encryption</small></span>
          </article>
        </div>

        <footer className="login-footer">
          <span>© 2026 PawCare Management. The Trusted Neighbor In Pet Care.</span>
          <nav>
            <a href="#privacy">Privacy Policy</a>
            <a href="#terms">Terms of Service</a>
            <a href="#support">Contact Support</a>
          </nav>
        </footer>
      </section>
    </main>
  );
}
