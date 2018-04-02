#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

new String:PlayerWeapon[MAXPLAYERS+1][64];
new Handle:PlayerWeaponDelay[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:h_Trie;

public OnPluginStart()
{
    HookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
    
    h_Trie = CreateTrie();
}

public OnMapStart()
{
    // Clear all entries of the Trie
    ClearTrie(h_Trie);
}

public OnClientPutInServer(client)
{
    SDKHook(client, SDKHook_WeaponSwitchPost, OnWeaponChange);
}

public OnWeaponChange(client, weapon)
{
    if(IsClientConnected(client) && !IsFakeClient(client))
    {
        decl String:sclient[32];
        IntToString(client, sclient, sizeof(sclient));
        SetTrieValue(h_Trie, sclient, weapon, true);
        if(PlayerWeaponDelay[client] == INVALID_HANDLE)
            PlayerWeaponDelay[client] = CreateTimer(0.1, t_Death, client);
    }
}

public Action:t_Death(Handle:timer, any:client)
{
    if(IsClientInGame(client) && IsPlayerAlive(client))
    {
        new weapon;
        decl String:sclient[32];
        IntToString(client, sclient, sizeof(sclient));
        if(GetTrieValue(h_Trie, sclient, weapon))
        {
            decl String:sWeapon[64];
            GetEdictClassname(weapon, sWeapon, sizeof(sWeapon));
            PlayerWeapon[client] = sWeapon;
            //PrintToChatAll("%N's POST weapon switch is: %s", client, PlayerWeapon[client]);
            PlayerWeaponDelay[client] = INVALID_HANDLE;
            return Plugin_Continue;
        }
        //PrintToChatAll("Cannot find %N's last weapon switch", client);
        PlayerWeaponDelay[client] = INVALID_HANDLE;
    }
    return Plugin_Continue;
}

public Action:OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
    new victim = GetClientOfUserId(GetEventInt(event, "userid"));
    
    if(PlayerWeaponDelay[victim] != INVALID_HANDLE)
    {
        KillTimer(PlayerWeaponDelay[victim]);
        PlayerWeaponDelay[victim] = INVALID_HANDLE;
    }
    //PrintToChatAll("WeaponT - %s", PlayerWeapon[victim]);
    new Float:vec[3];
	GetClientAbsOrigin(victim, vec);
	new entity = CreateEntityByName(PlayerWeapon[victim]);
	vec[2] += 10;
	DispatchSpawn(entity);
	TeleportEntity(entity, vec, NULL_VECTOR, NULL_VECTOR);
	if(StrEqual("weapon_hegrenade", PlayerWeapon[victim], false))
    {
        PrintToChatAll("Check work");
    }
	PlayerWeapon[victim] = "nil";
	return Plugin_Continue;
}  
