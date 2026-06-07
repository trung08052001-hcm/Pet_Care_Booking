import { Download, MoreVertical, Plus, RotateCcw } from "lucide-react";
import { PageHeader } from "../../shared/components/PageHeader";
import { pets } from "../../shared/data/mockData";

export function PetsPage() {
  return (
    <section className="page-stack">
      <PageHeader
        title="Pet Registry"
        description="Manage all registered furry friends and their history."
        actions={
          <>
            <button className="primary-inline"><Plus size={15} /> Register Pet</button>
            <button className="secondary-inline"><Download size={15} /> Export List</button>
          </>
        }
      />

      <div className="pet-filterbar">
        <div><span className="pill selected">All Pets</span><span className="pill">Dogs</span><span className="pill">Cats</span><span className="pill">Birds</span><span className="pill">Small Pets</span></div>
        <button className="chip-button">Sort by: Newest</button>
      </div>

      <div className="pet-grid">
        {pets.map((pet) => (
          <article className="pet-card" key={pet.name}>
            <div className="pet-image"><img src={pet.image} alt={pet.name} /><span>{pet.type}</span></div>
            <div className="pet-content">
              <button className="ghost-icon pet-menu" title="More"><MoreVertical size={15} /></button>
              <h3>{pet.name}</h3>
              <p>{pet.breed} · {pet.age}</p>
              <small>Owner: <strong>{pet.owner}</strong></small>
              <div className="medical-note">
                <strong>Medical Notes</strong>
                <span>{pet.note}</span>
              </div>
              <div className="pet-actions">
                <button>Profile</button>
                <button title="History"><RotateCcw size={15} /></button>
              </div>
            </div>
          </article>
        ))}
        <article className="add-pet-card">
          <Plus size={26} />
          <strong>Add New Pet</strong>
          <span>Register a new animal companion to the database.</span>
        </article>
      </div>
    </section>
  );
}
