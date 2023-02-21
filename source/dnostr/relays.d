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
        logger.print("Connecting to relay at "~endpointURL~"...\n", DebugType.WARNING);

        HTTPClientSettings clientSettings = new HTTPClientSettings();
        clientSettings.connectTimeout = connectTimeout;
        
        try
        {
            ws = connectWebSocket(URL(endpointURL), clientSettings);
            logger.print("Connected to relay\n", DebugType.INFO);
            return true;
        }
        catch(Exception e)
        {
            // Catches the timeout
            return false;
        }

        // return ws.connected();
    }

    /** 
     * Loops until a connection is made
     *
     * NOTE: This is a tad broken, I dont think connectWebSocket is vibing, that
     * or my logic is broken
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
        logger.print("Hi\n", DebugType.INFO);

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
                logger.print("Relay connection state is closed\n", DebugType.ERROR);
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

    /** 
     * Called before any of the below methods, ensures
     * the connection to the relay is open, if not,
     * re-opens it
     */
    private void ensureOpen()
    {
        if(!ws.connected())
        {
            untilConnected();
        }
    }

    public void unsubscribe()
    {
        ensureOpen();

        // TODO: Implement me
    }

    public void subscribe()
    {
        ensureOpen();

        // TODO: Implement me
    }

    import dnostr.client : NostrEvent;
    public void event(NostrEvent event)
    {
        ensureOpen();

        // TODO: Implement me
    }
}