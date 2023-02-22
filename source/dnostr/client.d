module dnostr.client;

import dnostr.relays : NostrRelay;
import std.json;
import core.sync.mutex : Mutex;

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
            relay.start();
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


public abstract class NostrMessage
{
    public abstract JSONValue[] serialize();
    public abstract string encode();
}

// TODO: Move the generic stuff to the above
public class NostrEvent : NostrMessage
{
    private string publicKey;

    this(string publicKey)
    {
        this.publicKey = publicKey;
    }

    public final string generateID()
    {
        JSONValue jsonSerialized;


        return "generatedID (TODO)";
    }

    public override string encode()
    {
        // TODO: Add generateID call and switch out ID

        return "muh post (TODO)";
    }

    public override JSONValue[] serialize()
    {
        JSONValue[] items;

        /* Message types */
        items ~= JSONValue("EVENT");

        return items;
    }
}


