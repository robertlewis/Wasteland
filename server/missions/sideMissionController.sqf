//	@file Version: 1.1
//	@file Name: sideMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};

#include "sideMissions\sideMissionDefines.sqf";

private ["_SideMissions","_mission","_missionType","_notPlayedSideMissions","_nextMissionIndex","_missionRunning","_hint"];

diag_log format["WASTELAND SERVER - Started Side Mission State"];

_SideMissions = [[mission_WepCache,"mission_WepCache"],
				[mission_HostileHelicopter,"mission_HostileHelicopter"],
				[mission_MiniConvoy,"mission_MiniConvoy"],
				[mission_AirWreck,"mission_AirWreck"],
				[mission_SerialKiller,"mission_SerialKiller"],
				[mission_SunkenSupplys, "mission_SunkenSupplys"],
				[mission_SniperTeam, "mission_SniperTeam"]];
//USED FOR TESTING
//_SideMissions = [[mission_HostileHelicopter,"mission_HostileHelicopter"]];
				//[mission_SniperTeam, "mission_SniperTeam"]];//,
//[mission_Truck,"mission_Truck"][mission_SerialKiller,"mission_SerialKiller"]
//				[mission_ReconVeh,"mission_ReconVeh"]];[mission_MobMoney, "mission_MobMoney"]

_notPlayedSideMissions = +_SideMissions;

while {true} do
{
	_nextMissionIndex = floor random count _notPlayedSideMissions;
    _mission = _notPlayedSideMissions select _nextMissionIndex select 0;
    _missionType = _notPlayedSideMissions select _nextMissionIndex select 1;
    
    if (count _notPlayedSideMissions > 1) then {
        _notPlayedSideMissions set [_nextMissionIndex, -1];
        _notPlayedSideMissions = _notPlayedSideMissions - [-1];
    } else {
        _notPlayedSideMissions = +_SideMissions;
    };
    
	_missionRunning = [] spawn _mission;
    diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];
    if (sideMissionDelayTime < 60) then {
        _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 seconds</t>", sideMissionDelayTime, sideMissionColor, subTextColor];
    } else {
        _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 minutes</t>", sideMissionDelayTime / 60, sideMissionColor, subTextColor];
    };
	messageSystem = _hint;
	if (!isDedicated) then { call serverMessage };
	publicVariable "messageSystem";
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5;
};
