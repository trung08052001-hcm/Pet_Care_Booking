export const bookings = [
  {
    pet: "Buddy",
    owner: "Michael Chen",
    service: "Full Grooming",
    date: "Oct 24, 2026",
    time: "10:30 AM - 12:00 PM",
    status: "Confirmed",
    image: "https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=160&q=80",
  },
  {
    pet: "Luna",
    owner: "Sarah Jenkins",
    service: "Vaccination",
    date: "Oct 24, 2026",
    time: "02:15 PM - 02:45 PM",
    status: "Pending",
    image: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=160&q=80",
  },
  {
    pet: "Cooper",
    owner: "David Wilson",
    service: "Day Boarding",
    date: "Oct 25, 2026",
    time: "08:00 AM - 06:00 PM",
    status: "Confirmed",
    image: "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=160&q=80",
  },
  {
    pet: "Bella",
    owner: "Emily Rodriguez",
    service: "Dog Walking",
    date: "Oct 25, 2026",
    time: "04:00 PM - 05:00 PM",
    status: "Cancelled",
    image: "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?auto=format&fit=crop&w=160&q=80",
  },
];

export const services = [
  {
    name: "Premium Grooming",
    category: "Full bath, trimming, ear cleaning, and coat styling.",
    meta: "90 min · $85 · All Care",
    active: true,
    image: "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=160&q=80",
  },
  {
    name: "Overnight Boarding",
    category: "Supervised overnight suites with climate control.",
    meta: "Per night · $120 · Accommodation",
    active: true,
    image: "https://images.unsplash.com/photo-1558788353-f76d92427f16?auto=format&fit=crop&w=160&q=80",
  },
  {
    name: "Wellness Exam",
    category: "Physical check, vaccination review, and health plan.",
    meta: "30 min · $60 · Medical",
    active: true,
    image: "https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?auto=format&fit=crop&w=160&q=80",
  },
  {
    name: "Agility Foundations",
    category: "Obstacle and handling skills for active dogs.",
    meta: "60 min · $55 · Training",
    active: false,
    image: "https://images.unsplash.com/photo-1544568100-847a948585b9?auto=format&fit=crop&w=160&q=80",
  },
];

export const customers = [
  { name: "Sarah Mitchell", tier: "VIP Status", email: "sarah.m@example.com", pets: "Luna +1", spend: "$2,480.00", lastVisit: "Oct 12, 2026" },
  { name: "James Wilson", tier: "Member since 2021", email: "j.wilson@home.net", pets: "B", spend: "$850.50", lastVisit: "Sep 28, 2026" },
  { name: "Emily Zhang", tier: "New Client", email: "emily.z@techhub.com", pets: "C P", spend: "$420.00", lastVisit: "Oct 14, 2026" },
  { name: "David Kim", tier: "Standard Member", email: "d.kim.vet@example.com", pets: "B", spend: "$1,120.00", lastVisit: "Oct 05, 2026" },
];

export const pets = [
  {
    name: "Buddy",
    type: "Dog",
    breed: "Golden Retriever",
    owner: "Michael Chen",
    age: "3 yrs",
    note: "Requires daily allergy medication.",
    image: "https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=420&q=80",
  },
  {
    name: "Luna",
    type: "Cat",
    breed: "Maine Coon Mix",
    owner: "Elena Gilbert",
    age: "1.5 yrs",
    note: "Up to date on all vaccinations.",
    image: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=420&q=80",
  },
  {
    name: "Coco",
    type: "Dog",
    breed: "Dachshund",
    owner: "Daniel Ortiz",
    age: "5 yrs",
    note: "Monitor back strain after activity.",
    image: "https://images.unsplash.com/photo-1612195583950-b8fd34c87093?auto=format&fit=crop&w=420&q=80",
  },
  {
    name: "Snowball",
    type: "Rabbit",
    breed: "Angora Rabbit",
    owner: "Liam Chen",
    age: "2 yrs",
    note: "Fresh hay must be available.",
    image: "https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=420&q=80",
  },
  {
    name: "Oliver",
    type: "Dog",
    breed: "Pembroke Corgi",
    owner: "Maria Stevens",
    age: "4 yrs",
    note: "Needs extra attention during social play.",
    image: "https://images.unsplash.com/photo-1612536057832-2ff7ead58194?auto=format&fit=crop&w=420&q=80",
  },
  {
    name: "Bella",
    type: "Dog",
    breed: "Greyhound",
    owner: "Suzanne Miller",
    age: "6 yrs",
    note: "Senior care protocol active.",
    image: "https://images.unsplash.com/photo-1591769225440-811ad7d6eab3?auto=format&fit=crop&w=420&q=80",
  },
];

export const notifications = [
  { title: "New Booking Request: Cooper", body: "Sarah Jenkins has requested a 3-night boarding slot for her Golden Retriever.", tone: "booking", time: "2 min ago" },
  { title: "Message from Elena M.", body: "Hi! Just checking if I need to bring Cooper's own bed for boarding.", tone: "message", time: "45 min ago" },
  { title: "System Backup Complete", body: "All pet records and customer data have been backed up successfully.", tone: "system", time: "3 hours ago" },
  { title: "Vaccination Expiring: Bella", body: "Rabies vaccination expires in 3 days. Booking restrictions will update soon.", tone: "warning", time: "5 hours ago" },
  { title: "New 5-Star Review", body: "Amazing care for my cat Luna. The daily updates put my mind at ease.", tone: "review", time: "Yesterday" },
];

export const conversations = [
  { name: "Alex Rivera", pet: "Mochi · Poodle", preview: "Thanks for the update! He looks so happy.", active: true },
  { name: "Elena Gilbert", pet: "Luna · Maine Coon", preview: "Does Luna need her medication before noon?", active: false },
  { name: "Marcus Chen", pet: "Cooper · Golden Retriever", preview: "Great, see you then!", active: false },
  { name: "Sarah Miller", pet: "Bella · Beagle", preview: "How was her walk today?", active: false },
];
