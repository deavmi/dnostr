module dnostr.relays;

import std.json;
import vibe.vibe : WebSocket, connectWebSocket, WebSocketException;
import vibe.vibe : HTTPClientSettings, URL;

import gogga;
import core.thread : Thread, dur, Duration;
import std.conv : to;
import core.sync.mutex : Mutex;

// TODO: Investigate if we need the belowe (I copied it from Birchwood)
__gshared GoggaLogger logger;
__gshared static this()
{
    logger = new GoggaLogger();
}


public class NostrRelay : Thread
{
    private WebSocket ws;
    private Mutex connLock;
    private string endpointURL;

    /* TIme to wait before marking a connect attempt as failed */
    private Duration connectTimeout = dur!("seconds")(2);

    /* Time in-between retries of connects */
    private Duration retryTime = dur!("seconds")(5);

    this(string url)
    {
        super(&run);
        this.endpointURL = url;
        this.connLock = new Mutex();
    }

    /** 
     * Attempts a connection with a timeout, if it fails
     * then false is returned, else on success true is returned
     */
    private bool attemptConnection(int c)
    {
        /* Lock the method so only one can enter this at a time */
        connLock.lock();
        import std.conv : to;
        string b = to!(string)(c);
        import std.stdio;
        writeln("lock acquired: "~b);

        /**
        * Determine if we need connect
        * 1. Either first time connecting (`ws == null` is true)
        * 2. Or ws.connected is false
        */
        bool disconnected;

        /* If there is no socket present then we should try connecting */
        if(ws is null)
        {
            disconnected = true;
        }
        /* If not null */
        else
        {
            /* Then check if we are not connected */
            disconnected = !ws.connected();
        }

        /* Attempt one connection and save the status of that conneciton attempt */
        bool connectionAttempt;
        if(disconnected)
        {
            logger.print("Connecting to relay at "~endpointURL~"...\n", DebugType.WARNING);

            HTTPClientSettings clientSettings = new HTTPClientSettings();
            clientSettings.connectTimeout = connectTimeout;
            
            try
            {
                ws = connectWebSocket(URL(endpointURL), clientSettings);
                // ws.connected();
                
                logger.print("Connected to relay\n", DebugType.INFO);
                connectionAttempt = true;
            }
            catch(Exception e)
            {
                // Catches the timeout
                connectionAttempt = false;
            }
        }
        /* If not disconnected */
        else
        {
            /* Then return true as we are already connected */
            connectionAttempt = true;
        }

        writeln("lock released: "~b);

        /* Unlock the method so people can enter it now */
        connLock.unlock();

        

        return connectionAttempt;
    }

    /** 
     * Loops until a connection is made
     */
    private void ensureConnected(int b = __LINE__)
    {
        import std.stdio;
        writeln("Entered ensureCOnnected()");
        while(!attemptConnection(b))
        {
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
        ensureConnected();
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
                ensureConnected();
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


    public final void setListener()
    {

    }

    public void unsubscribe()
    {
        ensureConnected();

        // TODO: Implement me
    }

    public void subscribe()
    {
        ensureConnected();

        // TODO: Implement me
    }

    import dnostr.client : NostrMessage;
    public void event(NostrMessage event)
    {
        import std.stdio;
        writeln("Huy");
        ensureConnected();
        writeln("Huy [done]");
        

        // TODO: Implement me
        try
        {
            string eventJSON = event.encode();
            logger.dbg("EventJSON byte count: "~to!(string)(eventJSON.length)~"\n", DebugType.WARNING);

            ws.send(eventJSON);

        }
        catch(WebSocketException e)
        {
            // TODO: Handle exception here by throwing a custom exception `MessageNotSent`
            logger.print("Error whilst sending event '"~event.toString()~"' to relay\n", DebugType.ERROR);
        }
    }
}