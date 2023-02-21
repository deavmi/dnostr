module dnostr.relays;

import std.json;
import vibe.vibe : WebSocket, connectWebSocket, URL;

import dlog : DefaultLogger, DLogger = Logger;
import core.thread : Thread, dur, Duration;
import std.conv : to;

// TODO: Investigate if we need the belowe (I copied it from Birchwood)
__gshared DLogger logger;
__gshared static this()
{
    // TODO: Add a custom logger transformt aht includes the name of the relay in it
    logger = new DefaultLogger();
}

public class NostrRelay : Thread
{
    private WebSocket ws;
    private string endpointURL;

    this(string url)
    {
        super(&run);
        this.endpointURL = url;
    }

    private bool attemptConnection()
    {
        ws = connectWebSocket(URL(endpointURL));

        return ws.connected;
    }

    /** 
     * Relay worker
     */
    public void run()
    {
        Duration retryTime = dur!("seconds")(1000);
        while(!attemptConnection())
        {
            // TODO: Insert logic here

            logger.log("Unable to connect to endpoint, trying again in "~to!(string)(retryTime));
            Thread.sleep(retryTime);
        }

        while(true)
        {
            string receivedText = ws.receiveText();
            JSONValue receivedJSON;

            try
            {
                receivedJSON = parseJSON(receivedText);
            }
            catch(JSONException e)
            {
                logger.log("Error parsing JSON received from the relay");
            }
            
        }
    }

    public void unsubscribe()
    {

    }

    public void subscribe()
    {

    }

    public void event()
    {

    }
}