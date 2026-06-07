import { Image, Info, Phone, PlusCircle, Send, Smile, Video } from "lucide-react";
import { conversations } from "../../shared/data/mockData";

export function ChatPage() {
  return (
    <section className="chat-layout">
      <aside className="conversation-panel">
        <div className="chat-heading">
          <h1>Messages</h1>
          <button className="ghost-icon" title="New message"><PlusCircle size={17} /></button>
        </div>
        <div className="chat-search">Search conversations...</div>
        {conversations.map((conversation) => (
          <button className={conversation.active ? "conversation active" : "conversation"} key={conversation.name}>
            <i>{conversation.name.slice(0, 1)}</i>
            <span><strong>{conversation.name}</strong><small>{conversation.pet}</small><em>{conversation.preview}</em></span>
          </button>
        ))}
      </aside>

      <article className="message-panel">
        <header className="message-header">
          <div className="avatar-name"><i>A</i><span><strong>Alex Rivera</strong><small>Mochi · Poodle · Online Now</small></span></div>
          <div className="message-actions">
            <Phone size={17} /><Video size={17} /><Info size={17} />
          </div>
        </header>
        <div className="message-thread">
          <span className="date-divider">Today</span>
          <div className="bubble incoming">Hi there! Checking in on how Mochi is doing today. Has he had his afternoon walk yet?</div>
          <small className="message-time left">10:45 AM</small>
          <div className="bubble outgoing">Hi Alex! Yes, Mochi just got back from a 30-minute walk in the park. He was very energetic today!</div>
          <small className="message-time right">10:48 AM</small>
          <div className="image-message">
            <Image size={40} />
            <p>Look at that smile! He also finished his lunch right after.</p>
          </div>
        </div>
        <footer className="composer">
          <PlusCircle size={18} />
          <Image size={18} />
          <input placeholder="Type a message for Alex..." />
          <Smile size={18} />
          <button className="send-button" title="Send"><Send size={18} /></button>
        </footer>
      </article>
    </section>
  );
}
