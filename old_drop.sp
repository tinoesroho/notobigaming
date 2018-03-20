#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "3.0.0"

new Handle:g_Cvar_DropOnDeath = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "FoF:BR Drop On Death",
	author = "notobigaming + bigbalaboom",
	description = "Drop weapons on death.",
	version = PLUGIN_VERSION,
	url = "www.sourcemod.net"
};

public OnPluginStart()
{
	g_Cvar_DropOnDeath = CreateConVar("sm_drop_on_death", "1", "Toggles plugin on and off.", FCVAR_PLUGIN);
	AutoExecConfig(true, "drop_on_death");

	HookConVarChange(g_Cvar_DropOnDeath, OnConVarChange);

	AddCommandListener(Command_Kill, "kill");
	AddCommandListener(Command_Kill, "explode");

	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("player_death", Event_player_death);
}

public OnConVarChange(Handle:cvar, const String:oldvalue[], const String:newvalue[])
{
	decl String:CvarName[64];
	GetConVarName(cvar, CvarName, sizeof(CvarName));
}

public Action:Event_player_death(Handle:event, const String:name[], bool:dontBroadcast) { 
 		new client = GetClientOfUserId(GetEventInt(event, "userid")); 
		DropItems(client);
}


public Action:Command_Kill(client, const String:command[], args)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		DropItems(client);
		ForcePlayerSuicide(client);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(GetClientHealth(client) <= 0)
	{
		DropItems(client);
	}
}

DropItems(client)
{
	if (GetConVarBool(g_Cvar_DropOnDeath))
	{
		new active_weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		decl String:active_weapon_name[64];
		GetClientWeapon(client, active_weapon_name, 64);
		// GetEdictClassname(active_weapon, active_weapon_name, sizeof(active_weapon_name));
		PrintToConsole(client,"You died. Dropped \"%s\"", active_weapon_name);
		SpawnWeapon(client, active_weapon_name, 1);
	}
}

SpawnWeapon(client, const String:weapon[], amount)
{
	if (!amount)
	{
		return;
	}

	new Float:vec[3];
	GetClientAbsOrigin(client, vec);

	new entity = CreateEntityByName("weapon_axe");
	vec[2] += 10;
	DispatchSpawn(entity);
	TeleportEntity(entity, vec, NULL_VECTOR, NULL_VECTOR);
}
