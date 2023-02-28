module dnostr.messages;

import std.json;

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