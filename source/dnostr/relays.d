module dnostr.relays;

import std.json;
import vibe.vibe : WebSocket, connectWebSocket, URL;
import vibe.vibe : HTTPClientSettings;

import gogga;
import core.thread : Thread, dur, Duration;
import std.conv : to;

// TODO: Investigate if we need the belowe (I copied it from Birchwood)
__gshared GoggaLogger logger;
__gshared static this()
{
    logger = new GoggaLogger();
}


public class NostrRelay : Thread
{
    private WebSocket ws;
    private string endpointURL;

    /* TIme to wait before marking a connect attempt as failed */
    private Duration connectTimeout = dur!("seconds")(2);

    /* Time in-between retries of connects */
    private Duration retryTime = dur!("seconds")(1);

    this(string url)
    {
        super(&run);
        this.endpointURL = url;
    }

    private bool attemptConnection()
    {
        logger.print("Connecting to relay at "~endpointURL~"...\n", DebugType.INFO);

        HTTPClientSettings clientSettings = new HTTPClientSettings();
        clientSettings.connectTimeout = connectTimeout;

        ws = connectWebSocket(URL(endpointURL), clientSettings);

        return ws.connected;
    }

    /** 
     * Loops until a connection is made
     */
    private void untilConnected()
    {
        while(!attemptConnection())
        {
            // TODO: Insert logic here

            logger.print("Unable to connect to endpoint, trying again in "~to!(string)(retryTime)~"\n", DebugType.ERROR);
            Thread.sleep(retryTime);
        }
    }


    /** 
     * Relay worker
     */
    public void run()
    {
        // TODO: This may be redundant now
        untilConnected();

        while(true)
        {
            /* Wait until the connection is closed or a message arrives */
            if(ws.waitForData())
            {
                string receivedText = ws.receiveText();
                handler(receivedText);
            }
            /* If we disconnected */
            else
            {
                untilConnected();
            }
            
            
        }
    }

    private void handler(string receivedText)
    {
       
        JSONValue receivedJSON;

        try
        {
            receivedJSON = parseJSON(receivedText);
        }
        catch(JSONException e)
        {
            logger.print("Error parsing JSON received from the relay\n", DebugType.ERROR);
        }
    }

    public void unsubscribe()
    {

    }

    public void subscribe()
    {

    }

    import dnostr.client : NostrEvent;
    public void event(NostrEvent event)
    {

    }
}