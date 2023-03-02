module dnostr.client;

import dnostr.logging;

import dnostr.relays : NostrRelay;
import dnostr.messages;

public class NostrClient
{
    private NostrRelay[] relays;
    private string myPublicKey = "MY public key (TODO)";

    this(NostrRelay[] relays)
    {
        this.relays = relays;
    }

    public final void addRelay(NostrRelay relay)
    {
        // TODO: mutex-based lock and add to `relays`
    }

    /**
     * Go online with all relays
     */
    public final void goOnline()
    {
        /* Start each relay */
        foreach(NostrRelay relay; relays)
        {
            relay.call();
        }
    }

    public final void goOffline()
    {
        // Ensure all NostrRelays are offline
    }

    public void event(NostrEvent post)
    {
        /* Announce the event to each relay */
        foreach(NostrRelay relay; relays)
        {
            // TODO: Checking is relay even tpost worked, oif not, queue to disk or something for a later post (if enabled)
            relay.event(post);

            logger.dbg("Done?");
        }
    }

   
}