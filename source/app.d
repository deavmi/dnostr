import std.stdio;

import vibe.vibe;
import std.json;

import dlog : DefaultLogger, DLogger = Logger;

// TODO: Investigate if we need the belowe (I copied it from Birchwood)
__gshared DLogger logger;
__gshared static this()
{
    logger = new DefaultLogger();
}


void main()
{
	writeln("Edit source/app.d to start your project.");

	URL relayEndpoint = URL("http://[::1]:8082/");
	WebSocket d = connectWebSocket(relayEndpoint);

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


	d.send(json.toString());

	runApplication();
}

public string calculateID(JSONValue jsonIn)
{
	string id;

	JSONValue[] serializedJSON;
	serializedJSON ~= JSONValue(0);


	logger.log("Comptued ID of post is: "~id);


	return id;
}