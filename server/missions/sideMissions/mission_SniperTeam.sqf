#include "setup.sqf"
#include "sideMissionDefines.sqf";

if(!isServer) exitwith {};

private ["_result","_missionMarkerName","_missionType","_startTime","_randomPos","_vehicleClass","_sbox","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_positions"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "SniperTeam_Marker";
_missionType = "Sniper Team";
#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Get Mission Location
//_returnData = call createMissionLocation;
_rand = floor (random 15);
_randomPos =(getMarkerPos format ["sniper_%1", _rand]);

//_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

/*
_marker = createMarkerLocal ["WeaponCache_Marker", _randomPos];
"WeaponCache_Marker" setMarkerShapeLocal "ICON";
"WeaponCache_Marker" setMarkerTypeLocal "mil_dot";
"WeaponCache_Marker" setMarkerColorLocal "ColorRed";
"WeaponCache_Marker" setMarkerSizeLocal [1,1];
"WeaponCache_Marker" setMarkerTextLocal "Sunken Supplies";
*/

_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>A sniper team has been spotted near the marker. Approach with extreme caution!</t>", _missionType,  sideMissionColor, subTextColor];
messageSystem = _hint;
publicVariable "messageSystem";

CivGrpS = createGroup civilian;
[CivGrpS,_randomPos] spawn createSniperTeam;

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1",_missionType];
#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif
waitUntil
{
    sleep 10; 
	_playerPresent = false;
	#ifdef __A2NET__
	_currTime = floor(netTime);
	#else
    _currTime = floor(time);
	#endif
    if(_currTime - _startTime >= sideMissionTimeout) then {_result = 1;};
    _unitsAlive = ({alive _x} count units CivGrpS);
    (_result == 1) OR (_unitsAlive < 1)
};

if(_result == 1) then
{
	//Mission Failed.
	{deleteVehicle _x;}forEach units CivGrpS;
    deleteGroup CivGrpS;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>FAIL! The snipers lived!</t>", _missionType, failMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
	// check if the vehicle is broken, if so delete it and the units
	_randomPos = [0,0,0];
	{_randomPos = position _x; deleteVehicle _x;}forEach units CivGrpS;
    deleteGroup CivGrpS;
	_sbox = createVehicle ["Box_NATO_Support_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
    [_sbox,"mission_Main_A3snipers"] call fn_refillbox;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The snipers have been taken out.</t>", _missionType, successMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;