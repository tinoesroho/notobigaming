#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION	 "1.01"

new Handle:sm_logo					 		 = INVALID_HANDLE;
new Handle:sm_logo_ver						 = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "NotObigaming Logo",
	author = "dataviruset + NotObigaming",
	description = "Display an overlay",
	version = PLUGIN_VERSION,
	url = "http://www.sourcemod.net/"
};


public OnPluginStart()
{
	
	// Create convars
	sm_logo = CreateConVar("sm_logo", "overlays/LOGOHERE", "What overlay to display if TEAM1 wins, relative to the materials-folder: path - path to overlay material without file extension (set downloading and precaching in addons/sourcemod/configs/overlay_downloads.ini)");
	sm_logo_ver = CreateConVar("sm_logo_ver", PLUGIN_VERSION, "Round end overlay plugin version (unchangeable)", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	HookConVarChange(sm_logo_ver, VersionChange);
}

public VersionChange(Handle:convar, const String:oldValue[], const String:newValue[])
{
	SetConVarString(convar, PLUGIN_VERSION);
}

public OnMapStart()
{

	decl String:file[256];
	BuildPath(Path_SM, file, 255, "configs/overlay_downloads.ini");
	new Handle:fileh = OpenFile(file, "r");
	if (fileh != INVALID_HANDLE)
	{
		decl String:buffer[256];
		decl String:buffer_full[PLATFORM_MAX_PATH];

		while(ReadFileLine(fileh, buffer, sizeof(buffer)))
		{
			TrimString(buffer);
			if ( (StrContains(buffer, "//") == -1) && (!StrEqual(buffer, "")) )
			{
				PrintToServer("Reading overlay_downloads line :: %s", buffer);
				Format(buffer_full, sizeof(buffer_full), "materials/%s", buffer);
				if (FileExists(buffer_full))
				{
					PrintToServer("Precaching %s", buffer);
					PrecacheDecal(buffer, true);
					AddFileToDownloadsTable(buffer_full);
					PrintToServer("Adding %s to downloads table", buffer_full);
				}
				else
				{
					PrintToServer("File does not exist! %s", buffer_full);
				}
			}
		}

	}

}

public OnClientPutInServer(client)
{
	decl String:overlaypath[PLATFORM_MAX_PATH];
	GetConVarString(sm_logo, overlaypath, sizeof(overlaypath));
    if(FindEntityByClassname(-1, "env_screenoverlay") != -1) // There already entity on map.
        return;

    new ent = CreateEntityByName("env_screenoverlay");
    if(ent != -1)
    {
        DispatchKeyValue(ent, "OverlayName1", overlaypath);
        DispatchKeyValue(ent, "OverlayTime1", "1.0");
        DispatchSpawn(ent);

        SetVariantString("OnUser1 !self,StartOverlays,,0,-1");
        AcceptEntityInput(ent, "AddOutput");
        AcceptEntityInput(ent, "FireUser1");
    } 
}