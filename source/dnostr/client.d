module dnostr.client;

import dnostr.relays : NostrRelay;
import std.json;

public class NostrClient
{
    private NostrRelay[] relays;
    private string myPublicKey = "MY public key (TODO)";

    this()
    {

    }

    public final void addRelay(NostrRelay relay)
    {
        // TODO: mutex-based lock and add to `relays`
    }

    public final void goOnline()
    {
        // Ensure all NostrRelays are online
    }

    public final void goOffline()
    {
        // Ensure all NostrRelays are offline
    }

    public void post(NostrPost post)
    {

        foreach(NostrRelay relay; relays)
        {
            relay.event(post);
        }
    }

    public NostrPost createPost()
    {
        // Set our public key in it
        NostrPost newPost = new NostrPost(myPublicKey);

        return newPost;
    }
}


public class NostrEvent
{

}

// TODO: Move the generic stuff to the above
public class NostrPost : NostrEvent
{
    protected string publicKey;

    protected this(string publicKey)
    {
        this.publicKey = publicKey;
    }

    public final string generateID()
    {
        JSONValue jsonSerialized;


        return "generatedID (TODO)";
    }

    public string encode()
    {
        // TODO: Add generateID call and switch out ID

        return "muh post (TODO)";
    }
}


