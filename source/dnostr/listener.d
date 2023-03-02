module dnostr.listener;

import dnostr.messages;
import dnostr.logging;

/** 
 * NostrListener
 *
 * Defines a listener interface that a relay can use
 * to run events on
 */
public interface NostrListener
{
    // On event from a relay
    public void onEvent(NostrEvent);
}