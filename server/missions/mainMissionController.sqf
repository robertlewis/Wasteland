//	@file Version: 1.1
//	@file Name: mainMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};

#include "mainMissions\mainMissionDefines.sqf";

private ["_MainMissions","_mission","_missionType","_notPlayedMainMissions","_nextMissionIndex","_missionRunning","_hint"];

diag_log format["WASTELAND SERVER - Started Main Mission State"];

_MainMissions = [
                 [mission_ArmedHeli,"mission_ArmedHeli"],
				 [mission_LightArmVeh,"mission_LightArmVeh"],
				 [mission_SeaConvoy, "mission_SeaConvoy"],
				 [mission_CivHeli,"mission_CivHeli"],
				 [mission_Convoy,"mission_Convoy"],
                 [mission_APC, "mission_APC"]
                ];
//_MainMissions = [[mission_ArmedHeli,"mission_ArmedHeli"]];//,
//				   [mission_APC,"mission_APC"]];[mission_MoneyShipment, "mission_MoneyShipment"]
//[mission_Outpost,"mission_Outpost"][mission_Insurgence, "mission_Insurgence"]
//				 [mission_HostileHeliFormation,"mission_HostileHeliFormation"],
_notPlayedMainMissions = +_MainMissions;

while {true} do
{
    //Select Mission
    _nextMissionIndex = floor random count _notPlayedMainMissions;
    _mission = _notPlayedMainMissions select _nextMissionIndex select 0;
    _missionType = _notPlayedMainMissions select _nextMissionIndex select 1;
    
    if (count _notPlayedMainMissions > 1) then {
        _notPlayedMainMissions set [_nextMissionIndex, -1];
        _notPlayedMainMissions = _notPlayedMainMissions - [-1];
    } else {
        _notPlayedMainMissions = +_MainMissions;
    };
    
	_missionRunning = [] spawn _mission;
    diag_log format["WASTELAND SERVER - Execute New Main Mission: %1",_missionType];
    if (mainMissionDelayTime < 60) then {
        _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 seconds</t>", mainMissionDelayTime, mainMissionColor, subTextColor];
    } else {
        _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 minutes</t>", mainMissionDelayTime / 60, mainMissionColor, subTextColor];
    };
	messageSystem = _hint;
if (!isDedicated) then { call serverMessage };
	publicVariable "messageSystem";
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5; 
};
