module dnostr.messages;

import std.conv : to;
import std.string : cmp, toLower;
import dnostr.logging;

import std.json;

public abstract class NostrMessage
{
    public abstract JSONValue[] serialize();
    public abstract string encode();
}

public class Tag
{

}

// TODO: Move the generic stuff to the above
public class NostrEvent : NostrMessage
{
    private string publicKey;
    private string content;
    private Tag[] tags; // TODO: See what to do with this
    private int kind; // TODO: See what to do with this

    this(string publicKey, string content, Tag[] tags = null)
    {
        this.publicKey = publicKey;
        this.content = content;
        this.tags = tags;
    }

    private final void generateID(ref JSONValue inJSON)
    {
        JSONValue[] jsonSerialized;

        // TODO: Generate the ID
        // TODO: Update JSON
        // TODO: List thing

        // Add `0` as the ID (as per NIP-01)
        jsonSerialized ~= JSONValue(0);


        JSONValue[string] kvPair = inJSON.object();
        logger.dbg("kvPair: ", kvPair);

        /**
         * [
         *   0,
         *   <pubkey, as a (lowercase) hex string>,
         *   <created_at, as a number>,
         *   <kind, as a number>,
         *   <tags, as an array of arrays of non-null strings>,
         *   <content, as a string>
         *   ]
         */


        // As per NIP-01 put 0 here
        jsonSerialized ~= JSONValue(0);

        // Place public key
        jsonSerialized ~= inJSON["pubkey"];

        // Place creation time
        jsonSerialized ~= inJSON["created_at"];

        // Place kind
        jsonSerialized ~= inJSON["kind"];

        // Place the tags (if any)
        if("tags" in kvPair)
        {
            jsonSerialized ~= inJSON["tags"];
        }

        // Place the content
        jsonSerialized ~= inJSON["content"];

        JSONValue finalSerialized = JSONValue(jsonSerialized);

        logger.dbg("The JSON to BE serialized is:\n"~finalSerialized.toString());

        // Perform the sha on the string of the structure
        string finalSerializedString = finalSerialized.toString();
        import std.digest.sha : sha256Of;
        ubyte[] hashBytes = sha256Of!(string)(finalSerializedString);
        import std.digest : toHexString;
        string hashString = toHexString(hashBytes).toLower();
        logger.dbg("The generated hash for serialization is \""~hashString~"\"");

        // Now set the "id" field
        inJSON["id"] = hashString;
    }

    private JSONValue generateJSON()
    {
        // Generated JSON
        JSONValue generated;

        // Acquire the current UNIX time in seconds
        // and store this
        import std.datetime.systime : SysTime, Clock;
        SysTime creationTime = Clock.currTime();
        generated["created_at"] = creationTime.toUnixTime();

        // Set the public key
        generated["pubkey"] = publicKey;

        // Set the content
        generated["content"] = content;

        // Store the tags (if any)
        if(tags.length)
        {
            JSONValue[] tagList;


            // Store the list of tags into "tags"
            generated["tags"] = tagList;
        }

        // Create an "id" field
        generated["id"] = "";

        // Create the kind field
        generated["kind"] = kind;
        
        


        return generated;
    }

    public override string encode()
    {
        // TODO: Add generateID call and switch out ID
        // Generate the JSON
        JSONValue generatedJSON = generateJSON();

        // TODO: Generated the ID and set it for is
        generateID(generatedJSON);

        

        // TODO: Update the below string to be the thing above
        string finalStr = generatedJSON.toString();
        return finalStr;
    }

    public override JSONValue[] serialize()
    {
        JSONValue[] items;






        /* Message types */
        items ~= JSONValue("EVENT");

        return items;
    }
}