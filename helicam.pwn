#include <a_samp>
#include <streamer>
#include <foreach>
#include <sscanf2>
#include <zcmd>

#define COLOR_WHITE 	(0xFFFFFFFF)
#define COLOR_TOMATO  (0xFF6347FF)

new pZortObject[MAX_PLAYERS];
new kardesim_helikopter[MAX_PLAYERS];
new PlayerText:HelikopterGosterge[MAX_PLAYERS][1];

enum playerData {
		pYerGozetle
	};

new PlayerData[MAX_PLAYERS][playerData];

public OnFilterScriptExit()
{
	return 1;
}

main()
{
}

YerGozetleBitir(playerid)
{
	 	 KillTimer(kardesim_helikopter[playerid]);
	 	 DestroyPlayerObject(playerid, pZortObject[playerid]);
}

CMD:helicam(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid))
     return	SendClientMessage(playerid, COLOR_TOMATO, "You must be in a vehicle.");

	if (GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
 	   return SendClientMessage(playerid, COLOR_TOMATO, "Get on the passenger seat of the vehicle and try again.");

	switch (PlayerData[playerid][pYerGozetle])
	{
		case 0:
		{
   		PlayerData[playerid][pYerGozetle] = 1;
		SendClientMessage(playerid, COLOR_TOMATO, "[ ! ] {FFFFFF}The helicopter camera was opened successfully.");
		for(new i=0; i < 1; i++) PlayerTextDrawShow(playerid, HelikopterGosterge[playerid][i]);

		new strs[52];
		format(strs, 52, "(( THIS PLAYER USING THE HELICOPTER CAMERA ))", playerid);
		SetPlayerChatBubble(playerid, strs, COLOR_TOMATO, 10.0, 1500);

		pZortObject[playerid] = CreatePlayerObject(playerid, 19482, 0.0, 0.0, 4.0, 0.0, 0.0, 0.0);
		AttachPlayerObjectToVehicle(playerid, pZortObject[playerid], vehicleid, 0.0, 0.0, -1.7, 0.0, 0.0, 0.0);
		kardesim_helikopter[playerid] = SetTimerEx("KardesimHelikopter", 10, true, "d", playerid);
		}
		case 1:
		{
			PlayerData[playerid][pYerGozetle] = 0;
			SendClientMessage(playerid, COLOR_TOMATO, "[ ! ] {FFFFFF}The helicopter camera was closed successfully.");
			TogglePlayerSpectating(playerid, false);
			YerGozetleBitir(playerid);
			for(new i=0; i < 1; i++) PlayerTextDrawHide(playerid, HelikopterGosterge[playerid][i]);
    		PutPlayerInVehicle(playerid, vehicleid, 2);
		}
	}
	return 1;
}

forward KardesimHelikopter(playerid);
public KardesimHelikopter(playerid)
{
    	AttachCameraToPlayerObject(playerid, pZortObject[playerid]);
}

public OnPlayerConnect(playerid)
{
	PlayerData[playerid][pYerGozetle] = 0;
	CreateTextdraw(playerid);
	return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
	PlayerData[playerid][pYerGozetle] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	PlayerData[playerid][pYerGozetle] = 0;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(PlayerData[playerid][pYerGozetle] == 1)
	{
        SendClientMessage(playerid, COLOR_TOMATO, "[ ! ] {FFFFFF}The helicopter camera was switched off because you were injured.");
  		PlayerData[playerid][pYerGozetle] = 0;
		TogglePlayerSpectating(playerid, false);
		YerGozetleBitir(playerid);
		for(new i=0; i < 1; i++) PlayerTextDrawHide(playerid, HelikopterGosterge[playerid][i]);
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(PlayerData[playerid][pYerGozetle] == 1)
	{
  	PlayerData[playerid][pYerGozetle] = 0;
	TogglePlayerSpectating(playerid, false);
	YerGozetleBitir(playerid);
	for(new i=0; i < 1; i++) PlayerTextDrawHide(playerid, HelikopterGosterge[playerid][i]);
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnRconCommand(cmd[])
{
	return 1;
}

stock CreateTextdraw(playerid)
{
	HelikopterGosterge[playerid][0] = CreatePlayerTextDraw(playerid, 15.625000, 26.666667, "mdl-2001:helikoptergozetleme");
	PlayerTextDrawLetterSize(playerid, HelikopterGosterge[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, HelikopterGosterge[playerid][0], 602.000000, 374.000000);
	PlayerTextDrawAlignment(playerid, HelikopterGosterge[playerid][0], 1);
	PlayerTextDrawColor(playerid, HelikopterGosterge[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, HelikopterGosterge[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, HelikopterGosterge[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, HelikopterGosterge[playerid][0], 255);
	PlayerTextDrawFont(playerid, HelikopterGosterge[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, HelikopterGosterge[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, HelikopterGosterge[playerid][0], 0);
	return 1;
}
