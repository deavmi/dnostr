module dnostr.app;

import std.stdio;

import vibe.d;
import std.json;

import  dnostr.logging;
/** 
 * FIXME: Fix the below so I need not import gogga too
 */
mixin LoggerSetup!();
import gogga;
import dnostr.messages;


void main()
{
	writeln("Edit source/app.d to start your project.");

	URL relayEndpoint = URL("http://[::1]:8082/");
	// WebSocket d = connectWebSocket(relayEndpoint);

	JSONValue json;

	json["id"] = "TODO";
	json["pubkey"] = " TODO";
	json["created_at"] = "TODO";
	json["kind"] = 1;

	/* Example tag */
	JSONValue[] tag1;
	tag1 ~= JSONValue("e");
	tag1 ~= JSONValue(1);
	tag1 ~= JSONValue("recommenedrelay url");

	/* A bunch of tags */
	JSONValue[] tags;
	tags  ~= tag1;
	
	// json["tags"] = 
	json["created_at"] = "TODO";
	
	/* Calculate the ID */
	string id = calculateID(json);
	json["id"] = id;


	// d.send(json.toString());



	import dnostr.relays;
	import dnostr.client;

	NostrRelay relay1 = new NostrRelay("http://[::1]:8082/");
	NostrRelay relay2 = new NostrRelay("http://[::1]:8082/");

	NostrRelay damusRelay = new NostrRelay("https://relay.damus.io/");
	

	NostrClient client = new NostrClient([relay1]);

	client.goOnline();

	NostrEvent nostrPost = new NostrEvent("TODO BRUH PUBKEY");
	client.event(nostrPost);

	// while(true)
	// {

	// }

	// runApplication();

	// writeln("hi");
}

public string calculateID(JSONValue jsonIn)
{
	string id;

	JSONValue[] serializedJSON;
	serializedJSON ~= JSONValue(0);


	logger.print("Comptued ID of post is: "~id~"\n", DebugType.INFO);


	return id;
}