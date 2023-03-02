module dnostr.relays;

import std.json;
import vibe.vibe : WebSocket, connectWebSocket, WebSocketException;
import vibe.vibe : HTTPClientSettings, URL;
import dnostr.logging;

import core.thread : dur, Duration;
import core.thread.fiber : Fiber;
import std.conv : to;
import core.sync.mutex : Mutex;
import dnostr.messages;

public class NostrRelay : Fiber
{
    /** 
     * Connection-related parameters
     */
    private WebSocket ws;
    private string endpointURL;

    /* TIme to wait before marking a connect attempt as failed */
    private Duration connectTimeout = dur!("seconds")(2);

    /* Time in-between retries of connects */
    private Duration retryTime = dur!("seconds")(5);


    /* Queue of actions to process */
    
    /** 
     * Constructs a new relay at the given endpoint
     *
     * Params:
     *   url = tye endpoint of the relay
     */
    this(string url)
    {
        super(&worker);
        this.endpointURL = url;
    }

   

    /** 
     * Relay worker
     */
    public void worker()
    {
        /* Ensure we are online */
        ensureConnection();
    }

    private final void ensureConnection()
    {
        /* If no websocket is present */
        if(ws is null)
        {
            try
            {
                ws = connectWebSocket(URL(endpointURL));
            }
            catch(WebSocketException e)
            {
                logger.error("There was an error creating a web socket");
            }
        }

        /* Check we are connected */
        if(ws.connected())
        {
            // TODO: Add stuff here
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
            logger.error("Error parsing JSON received from the relay");
        }
    }


    public final void setListener()
    {

    }

    public void unsubscribe()
    {
        /* Ensure we are online */
        ensureConnection();

        // TODO: Implement me
    }

    public void subscribe()
    {
        /* Ensure we are online */
        ensureConnection();

        // TODO: Implement me
    }

    
    public void event(NostrEvent g)
    {
        /* Ensure we are online */
        ensureConnection();

        // TODO: Implement me
        ws.send(g.encode());
    }   
}