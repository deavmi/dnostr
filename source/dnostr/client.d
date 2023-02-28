module dnostr.client;

import  dnostr.logging;
/** 
 * FIXME: Fix the below so I need not import gogga too
 */
mixin LoggerSetup!();
import gogga;

import dnostr.relays : NostrRelay;
import core.sync.mutex : Mutex;
import dnostr.messages;

public class NostrClient
{
    private NostrRelay[] relays;
    private Mutex relaysLock;
    private string myPublicKey = "MY public key (TODO)";

    this(NostrRelay[] relays)
    {
        relaysLock = new Mutex();
        this.relays = relays;
    }

    public final void addRelay(NostrRelay relay)
    {
        // TODO: mutex-based lock and add to `relays`
    }

    public final void goOnline()
    {
        // Ensure all NostrRelays are online

        /* Lock the relay list */
        relaysLock.lock();

        /* Start each relay */
        foreach(NostrRelay relay; relays)
        {
            relay.call();
        }

        /* Unlock the relay list */
        relaysLock.unlock();
    }

    public final void goOffline()
    {
        // Ensure all NostrRelays are offline
    }

    public void event(NostrEvent post)
    {
        /* Lock the relay list */
        relaysLock.lock();

        /* Announce the event to each relay */
        foreach(NostrRelay relay; relays)
        {
            // TODO: Checking is relay even tpost worked, oif not, queue to disk or something for a later post (if enabled)
            import std.stdio;
            relay.event(post);
        }

        /* Unlock the relay list */
        relaysLock.unlock();
    }

   
}