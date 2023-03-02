module dnostr.app;

import std.stdio;

import vibe.d;
import std.json;
import dnostr.logging;
import dnostr.messages;


void main()
{
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
	

	NostrClient client = new NostrClient([relay1, relay2]);

	client.goOnline();

	NostrEvent nostrPost = new NostrEvent("TODO BRUH PUBKEY", "This is my post's body!");
	client.event(nostrPost);

	

	runApplication();

	// writeln("hi");
}

public string calculateID(JSONValue jsonIn)
{
	string id;

	JSONValue[] serializedJSON;
	serializedJSON ~= JSONValue(0);


	logger.info("Computed ID of post is: ", id);


	return id;
}