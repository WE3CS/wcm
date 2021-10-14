//Sourcemod Includes
#include <sourcemod>

//Pragma
#pragma semicolon 1
#pragma newdecls required

//Globals
bool g_bMessagesShown[MAXPLAYERS + 1];

ConVar g_cServerLink;
ConVar g_cWebsiteLink;

public Plugin myinfo = 
{
	name = "Conmessage", 
	author = "Markie", 
	description = "Connect Message.", 
	version = "1.0.0", 
	url = "https://nerp.cf/"
};

public void OnPluginStart()
{
	g_cServerLink = CreateConVar("sm_cmsg_serverlink", "WE3CS.COM", "Link to your servers page");
	g_cWebsiteLink = CreateConVar("sm_cmsg_websitelink", "WE3CS.COM", "Link to your website");

	HookEvent("player_spawn", Event_OnPlayerSpawn);
}

public void OnMapStart()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		g_bMessagesShown[i] = false;
	}
}

public void Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (client == 0 || IsFakeClient(client))
	{
		return;
	}
	
	CreateTimer(0.2, Timer_DelaySpawn, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_DelaySpawn(Handle timer, any data)
{
	int client = GetClientOfUserId(data);
	
	if (client == 0 || !IsPlayerAlive(client) || g_bMessagesShown[client])
	{
		return Plugin_Continue;
	}

	char sServerLink[128];
	char sWebsiteLink[128];

	g_cServerLink.GetString(sServerLink, sizeof(sServerLink));
	g_cWebsiteLink.GetString(sWebsiteLink, sizeof(sWebsiteLink));
	
	PrintToChat(client, " \x04[\x06我为C狂\x04] \x07~ \x01欢迎你, \x03%N \x10请遵守本服协议如下：", client);
	PrintToChat(client, " \x04[\x06我为C狂\x04] \x07~ 1.严禁任何谈论政治、妄议中央等违法行为；");
	PrintToChat(client, " \x04[\x06我为C狂\x04] \x07~ 2.严禁任何形式的地域黑、尬吹、脑瘫行为；");
	PrintToChat(client, " \x04[\x06我为C狂\x04] \x07~ 3.严禁任何形式的人身攻击、语言暴力行为；");
	PrintToChat(client, " \x04[\x06我为C狂\x04] \x07~ 4.严禁任何广告、交易、钓鱼、挂机等内容；");
	PrintToChat(client, " \x04[\x06我为C狂\x04] \x07~ 5.严禁任何陀螺、鼠标宏、外挂、辅助等各种司马行为。");
	g_bMessagesShown[client] = true;
	
	return Plugin_Continue;
}

public void OnClientDisconnect(int client)
{
	g_bMessagesShown[client] = false;
}
