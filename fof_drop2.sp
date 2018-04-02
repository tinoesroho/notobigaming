#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

public OnPluginStart() {
    HookEvent("player_death", OnPlayerDeath, EventHookMode_Post);
    HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
}

public Action: Event_PlayerHurt(Handle: event, const String: name[], bool: dontBroadcast) {
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (GetClientHealth(client) <= 0) {

        new size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
        new ent;
        for (new a = 0; a < size; a++) // loop player weapons
        {
            if ((ent = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", a)) != -1) {
				new weapon = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", a);
				decl String:weapon_name[64];
				GetEdictClassname(weapon, weapon_name, sizeof(weapon_name));
				
				
				new spawnme = CreateEntityByName(weapon_name);
                new Float: vec[3];
                GetClientAbsOrigin(client, vec);
                vec[2] += 10;
                DispatchSpawn(spawnme);
                TeleportEntity(spawnme, vec, NULL_VECTOR, NULL_VECTOR);
            }
        }

    }
}

public Action: OnPlayerDeath(Handle: event, const String: name[], bool: dontBroadcast) {
    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    new size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
    new ent;
        for (new a = 0; a < size; a++) // loop player weapons
        {
            if ((ent = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", a)) != -1) {
				new weapon = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", a);
				decl String:weapon_name[64];
				GetEdictClassname(weapon, weapon_name, sizeof(weapon_name));
				
				
				new spawnme = CreateEntityByName(weapon_name);
                new Float: vec[3];
                GetClientAbsOrigin(client, vec);
                vec[2] += 10;
                DispatchSpawn(spawnme);
                TeleportEntity(spawnme, vec, NULL_VECTOR, NULL_VECTOR);
            }
        }
}
