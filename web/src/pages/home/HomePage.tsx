import { Link } from 'react-router-dom'

const services = [
  {
    code: 'GK',
    title: 'Professional Grooming',
    description:
      'Pamper your pet with gentle grooming, coat care and styling designed to keep them healthy and happy.',
    linkLabel: 'Learn more',
  },
  {
    code: 'PH',
    title: 'Luxury Pet Hotel',
    description:
      'Daily enrichment, climate-controlled suites and 24/7 attention, so your pet feels at home.',
    linkLabel: 'Check availability',
  },
  {
    code: 'VC',
    title: 'Veterinary Care',
    description:
      'Expert medical attention from trusted partners for wellness visits, advice and preventive treatment.',
    linkLabel: 'Book appointment',
  },
]

const highlights = [
  '24/7 staff monitoring and emergency-ready care.',
  'Daily updates via video, photos and notes.',
  'Pick-up and drop-off available in select zones.',
]

const trustCards = [
  {
    title: 'Safe & Clean',
    description:
      'Hospital-grade cleaning routines and dedicated wellness checks every day.',
    image:
      'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=900&q=80',
  },
  {
    title: 'Play Every Day',
    description:
      'Structured play sessions and outdoor time tailored to each pet personality.',
    image:
      'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=900&q=80',
  },
]

const testimonials = [
  {
    quote:
      'PawSitive Care felt like my second home for Max. The team sent updates every day and he came back calm and happy.',
    name: 'Sarah Johnson',
    meta: 'Pet mom of Max the corgi',
  },
  {
    quote:
      'The daycare routine worked wonders for Milo. He has more confidence, more play and a team that genuinely knows him.',
    name: 'Michael Chen',
    meta: 'Pet dad of Milo the shih tzu',
  },
  {
    quote:
      'I get peace of mind every time I travel. Their staff is warm, professional and incredibly attentive to Luna.',
    name: 'Amanda Rose',
    meta: 'Pet mom of Luna the cat',
  },
]

function SectionHeader({
  title,
  description,
  centered = false,
}: {
  title: string
  description: string
  centered?: boolean
}) {
  return (
    <div className={centered ? 'mx-auto max-w-2xl text-center' : 'max-w-xl'}>
      <h2 className="text-3xl font-semibold tracking-tight text-[var(--text-primary)] md:text-[2.2rem]">
        {title}
      </h2>
      <p className="mt-3 text-sm leading-7 text-[var(--text-secondary)] md:text-base">
        {description}
      </p>
    </div>
  )
}

export function HomePage() {
  return (
    <div className="flex flex-1 flex-col gap-10 pb-8 lg:gap-14">
      <section className="grid items-center gap-10 rounded-[38px] bg-[var(--surface-elevated)] px-5 py-8 shadow-[var(--shadow-soft)] md:px-8 md:py-10 lg:grid-cols-[1.02fr_0.98fr] lg:px-10">
        <div className="max-w-xl">
          <span className="inline-flex rounded-full bg-[var(--accent-soft)] px-3 py-1 text-[11px] font-semibold tracking-[0.24em] text-[var(--accent-strong)] uppercase">
            Trusted by 1,200+ pet families
          </span>
          <h1 className="mt-5 text-4xl leading-tight font-semibold tracking-tight text-[var(--text-primary)] md:text-[3.35rem]">
            Your Pet&apos;s Happy Place Away From Home
          </h1>
          <p className="mt-4 max-w-lg text-sm leading-7 text-[var(--text-secondary)] md:text-base">
            Exceptional premium pet care that feels like family. From luxury
            boarding to expert veterinary support, we treat every pet with the
            love and attention they deserve.
          </p>

          <div className="mt-7 flex flex-wrap gap-3">
            <Link
              to="/register"
              className="rounded-2xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_14px_24px_rgba(245,140,62,0.28)] transition hover:translate-y-[-1px]"
            >
              Book a Visit
            </Link>
            <Link
              to="/#services"
              className="rounded-2xl border border-[var(--border-strong)] bg-white/70 px-5 py-3 text-sm font-semibold text-[var(--text-primary)] transition hover:bg-white"
            >
              Explore Services
            </Link>
          </div>
        </div>

        <div className="relative">
          <div className="relative overflow-hidden rounded-[34px] border border-white/70 bg-[linear-gradient(135deg,#b06f3d_0%,#f0d6bd_52%,#f7efe6_100%)] p-5 shadow-[0_22px_40px_rgba(184,124,76,0.24)]">
            <div className="grid min-h-[360px] place-items-center rounded-[28px] bg-[radial-gradient(circle_at_top,_rgba(255,255,255,0.95),_transparent_45%),linear-gradient(145deg,_rgba(126,79,40,0.28),_rgba(255,255,255,0.45)_55%,_rgba(196,137,88,0.35))]">
              <div className="relative flex items-end justify-center gap-4 md:gap-6">
                <div className="flex h-56 w-40 items-end justify-center rounded-[90px] rounded-b-[28px] bg-[linear-gradient(180deg,#d59a65_0%,#8f5c37_100%)] pb-8 shadow-[inset_0_8px_24px_rgba(255,255,255,0.2)]">
                  <div className="h-28 w-28 rounded-full border-[10px] border-[#f8e7d3] bg-[#8a5a34]" />
                </div>
                <div className="flex h-44 w-32 items-end justify-center rounded-[70px] rounded-b-[24px] bg-[linear-gradient(180deg,#f2f0ec_0%,#b9b1aa_100%)] pb-6 shadow-[inset_0_8px_22px_rgba(255,255,255,0.45)]">
                  <div className="h-20 w-20 rounded-full border-[8px] border-white bg-[#d8d3ce]" />
                </div>
              </div>
            </div>

            <div className="absolute bottom-5 left-5 rounded-2xl border border-white/70 bg-white/88 px-4 py-3 shadow-[0_12px_28px_rgba(53,37,22,0.12)] backdrop-blur">
              <div className="flex items-center gap-3">
                <span className="flex h-10 w-10 items-center justify-center rounded-full bg-[#daf0dc] text-sm font-bold text-[#3d8b48]">
                  C
                </span>
                <div>
                  <p className="text-sm font-semibold text-[var(--text-primary)]">
                    Certified Care
                  </p>
                  <p className="text-xs text-[var(--text-secondary)]">
                    Safe, monitored and pet-approved
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section
        id="services"
        className="rounded-[34px] bg-[var(--surface-elevated)] px-5 py-8 shadow-[var(--shadow-soft)] md:px-8 md:py-10"
      >
        <SectionHeader
          centered
          title="Our Signature Services"
          description="Tailored care designed for comfort, wellbeing and peace of mind. Explore our core services built for modern pet parents."
        />

        <div className="mt-8 grid gap-4 md:grid-cols-3">
          {services.map((service) => (
            <article
              key={service.title}
              className="rounded-[28px] border border-[var(--border-soft)] bg-[var(--card-soft)] p-6 transition hover:translate-y-[-2px] hover:shadow-[0_16px_30px_rgba(89,56,23,0.08)]"
            >
              <span className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[var(--accent-soft)] text-sm font-semibold text-[var(--accent-strong)]">
                {service.code}
              </span>
              <h3 className="mt-5 text-xl font-semibold text-[var(--text-primary)]">
                {service.title}
              </h3>
              <p className="mt-3 text-sm leading-7 text-[var(--text-secondary)]">
                {service.description}
              </p>
              <Link
                to="/register"
                className="mt-6 inline-flex text-sm font-semibold text-[var(--accent-strong)]"
              >
                {service.linkLabel} +
              </Link>
            </article>
          ))}
        </div>
      </section>

      <section
        id="about"
        className="grid gap-6 rounded-[34px] bg-[var(--surface-elevated)] px-5 py-8 shadow-[var(--shadow-soft)] md:px-8 md:py-10 lg:grid-cols-[0.92fr_1.08fr]"
      >
        <div>
          <SectionHeader
            title="Why Pet Parents Trust Us"
            description="We combine attentive care, clean facilities and dependable routines so you can feel good about every stay."
          />

          <ul className="mt-6 space-y-4">
            {highlights.map((item) => (
              <li
                key={item}
                className="flex gap-3 text-sm leading-7 text-[var(--text-secondary)]"
              >
                <span className="mt-1 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-[var(--accent-soft)] text-xs font-bold text-[var(--accent-strong)]">
                  +
                </span>
                <span>{item}</span>
              </li>
            ))}
          </ul>
        </div>

        <div className="grid gap-4 md:grid-cols-2">
          {trustCards.map((card) => (
            <article
              key={card.title}
              className="overflow-hidden rounded-[26px] border border-[var(--border-soft)] bg-[var(--card-soft)]"
            >
              <div
                className="h-48 bg-cover bg-center"
                style={{ backgroundImage: `url(${card.image})` }}
              />
              <div className="p-5">
                <h3 className="text-xl font-semibold text-[var(--text-primary)]">
                  {card.title}
                </h3>
                <p className="mt-2 text-sm leading-7 text-[var(--text-secondary)]">
                  {card.description}
                </p>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section
        id="reviews"
        className="rounded-[34px] bg-[var(--surface-elevated)] px-5 py-8 shadow-[var(--shadow-soft)] md:px-8 md:py-10"
      >
        <div className="flex flex-col gap-5 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 className="text-3xl font-semibold tracking-tight text-[var(--text-primary)] md:text-[2.15rem]">
              Happy Tails from Happy Parents
            </h2>
            <p className="mt-3 text-sm leading-7 text-[var(--text-secondary)]">
              4.9 average rating from families who trust us with their pets.
            </p>
          </div>

          <div className="flex items-center gap-2 self-start">
            <button
              type="button"
              className="flex h-10 w-10 items-center justify-center rounded-full border border-[var(--border-strong)] bg-white/70 text-[var(--text-primary)]"
            >
              1
            </button>
            <button
              type="button"
              className="flex h-10 w-10 items-center justify-center rounded-full bg-[var(--accent)] font-semibold text-[var(--accent-contrast)]"
            >
              2
            </button>
          </div>
        </div>

        <div className="mt-8 grid gap-4 lg:grid-cols-3">
          {testimonials.map((testimonial) => (
            <article
              key={testimonial.name}
              className="rounded-[26px] border border-[var(--border-soft)] bg-[var(--card-soft)] p-6"
            >
              <p className="text-sm leading-7 text-[var(--text-secondary)]">
                &ldquo;{testimonial.quote}&rdquo;
              </p>
              <div className="mt-6 border-t border-[var(--border-soft)] pt-4">
                <p className="font-semibold text-[var(--text-primary)]">
                  {testimonial.name}
                </p>
                <p className="mt-1 text-sm text-[var(--text-secondary)]">
                  {testimonial.meta}
                </p>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section
        id="contact"
        className="relative overflow-hidden rounded-[34px] bg-[linear-gradient(135deg,#8f4005_0%,#b3580f_45%,#9a4808_100%)] px-6 py-12 text-center shadow-[0_24px_40px_rgba(121,58,11,0.28)] md:px-10"
      >
        <div className="pointer-events-none absolute top-4 right-6 h-28 w-28 rounded-full bg-white/8 blur-2xl" />
        <div className="pointer-events-none absolute bottom-4 left-8 h-24 w-24 rounded-full bg-[#ffcf96]/15 blur-2xl" />
        <div className="relative mx-auto max-w-2xl">
          <h2 className="text-3xl font-semibold tracking-tight text-white md:text-[2.2rem]">
            Ready for a Happier Pet?
          </h2>
          <p className="mt-4 text-sm leading-7 text-[#fbe7d1] md:text-base">
            New clients get 10% off their first grooming session or overnight
            stay. Book your first visit today.
          </p>
          <Link
            to="/register"
            className="mt-7 rounded-full bg-white px-7 py-3 text-sm font-semibold text-[#8f4005] shadow-[0_16px_28px_rgba(82,34,3,0.25)]"
          >
            Book Your First Visit
          </Link>
          <p className="mt-4 text-xs tracking-[0.18em] text-[#ffd8b2] uppercase">
            No stress. No guilt. Just loving, premium pet care.
          </p>
        </div>
      </section>
    </div>
  )
}
