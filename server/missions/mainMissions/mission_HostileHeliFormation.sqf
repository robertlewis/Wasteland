private ["_missionMarkerName","_missionType","_picture","_vehicleClass1","_vehicleCLass2","_vehicleClass3","_vehicleName","_hint","_waypoint","_waypoints","_grouphsq","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_createVehicle","_leader"];

#include "mainMissionDefines.sqf"

_missionMarkerName = "HostileHelis_Marker";
_missionType = "Hostile Helicopters";

diag_log format["WASTELAND SERVER - Main Mission Started: %1", _missionType];

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1", _missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1", _missionType];

_grouphsq = createGroup civilian;

_createVehicle = {
    private ["_type","_position","_direction","_grouphsq","_vehicle","_soldier"];
    
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _grouphsq = _this select 3;
    
    _vehicle = _type createVehicle _position;
    _vehicle setVariable["newVehicle",1,true];
    _vehicle addEventHandler ["IncomingMissile", "hint format['Incoming Missile Launched By: %1', name (_this select 2)]"];
    _vehicle setDir _direction;
    _grouphsq addVehicle _vehicle;
    
    _soldier = [_grouphsq, _position] call createRandomPilot; 
    _soldier moveInDriver _vehicle;

    if(_type == "O_Heli_Attack_02_F") then
    {
        _soldier2 = [_grouphsq, _position] call createRandomPilot;
        _soldier2 moveInGunner _vehicle;
    };
    if(_type == "O_Heli_Attack_02_black_F") then
    {
        _soldier2 = [_grouphsq, _position] call createRandomPilot;
        _soldier2 moveInGunner _vehicle;
    };
    if(_type == "B_Heli_Transport_01_F") then
    {
        _soldier2 = [_grouphsq, _position] call createRandomPilot;
        _soldier2 moveInGunner _vehicle;
        _soldier3 = [_grouphsq, _position] call createRandomPilot;
        _soldier3 assignAsGunner _vehicle;
        _soldier3 moveInCargo _vehicle;
    };
    if(_type == "B_Heli_Attack_01_F") then
    {
        _soldier1 = [_grouphsq, _position] call createRandomPilot;
        _soldier1 moveInCargo _vehicle;
    };
    
    _vehicle
};


_vehicles = [];
_vehicleClass1 = ["B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","O_Heli_Light_02_F","B_Heli_Attack_01_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"] call BIS_fnc_selectRandom;
_vehicleClass2 = ["B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","O_Heli_Light_02_F","B_Heli_Attack_01_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"] call BIS_fnc_selectRandom;
_vehicleClass3 = ["B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","O_Heli_Light_02_F","B_Heli_Attack_01_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"] call BIS_fnc_selectRandom;
_vehicles set [0, [_vehicleClass1, [2436.24,847.9,0.00133419], 91, _grouphsq] call _createVehicle];
_vehicles set [1, [_vehicleClass2, [2418.8,828.152,0.00138879], 285, _grouphsq] call _createVehicle];
_vehicles set [2, [_vehicleClass3, [2401.98,872.439,0.00141001], 285, _grouphsq] call _createVehicle];

_leader = driver (_vehicles select 0);
_grouphsq selectLeader _leader;
_leader setRank "LIEUTENANT";

_grouphsq setCombatMode "YELLOW";
_grouphsq setBehaviour "AWARE";
_grouphsq setFormation "STAG COLUMN";
_grouphsq setSpeedMode "LIMITED";

_waypoints = [
[3208.18,5892.56,0.00139952],
[4514.16,6803.21,8.18937],
[6601.05,5192.41,19.6563],
[2778.99,1745.92,0.00140381],
[1611.09,4970.55,0.00143862],
[1875.8,5944.03,0.00143862],
[2480.15,5602.22,0.00115967],
[5027.56,5903.91,0.00144958],
[4600.89,5293.84,0.00161743],
[4360.94,3788.16,0.0012207],
[3353.02,2908.18,0.00141907],
[3069.41,2144.08,0.00146484],
[1932.52,2701.13,4.23677],
[1987.06,3525.87,0.00142264],
[3535.24,4935.48,2.97694],
[6436.94,5431.56,0.00140905],
[4284.53,2628.48,3.2423],
[4514.16,6803.21,8.18937],
[6601.05,5192.41,19.6563],
[2778.99,1745.92,0.00140381],
[1611.09,4970.55,0.00143862],
[1875.8,5944.03,0.00143862],
[2480.15,5602.22,0.00115967],
[5027.56,5903.91,0.00144958],
[4600.89,5293.84,0.00161743],
[4360.94,3788.16,0.0012207],
[3353.02,2908.18,0.00141907],
[3069.41,2144.08,0.00146484],
[1932.52,2701.13,4.23677],
[1987.06,3525.87,0.00142264],
[3535.24,4935.48,2.97694],
[6436.94,5431.56,0.00140905],
[4284.53,2628.48,3.2423],
[644.232,6694.51,113.885]
];
{
    _waypoint = _grouphsq addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 45;
    _waypoint setWaypointCombatMode "WHITE"; // Defensiv behaviour
    _waypoint setWaypointBehaviour "AWARE"; 
    _waypoint setWaypointFormation "STAG COLUMN";
    _waypoint setWaypointSpeed "LIMITED";
} forEach _waypoints;

_marker = createMarker [_missionMarkerName, position leader _grouphsq];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Hostile Helis";

_picture = getText (configFile >> "CfgVehicles" >> _vehicleClass1 >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _vehicleClass1 >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>! AIR ALARM !</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>Hostile AirSquad</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>At least one hostile <t color='%4'>%3</t> has been spotted. Take them out!</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor];
messageSystem = _hint;
if (!isDedicated) then { call serverMessage };
publicVariable "messageSystem";

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1", _missionType];

_failed = false;
_startTime = floor(time);
_numWaypoints = count waypoints _grouphsq;
waitUntil
{
    private ["_unitsAlive"];
    
    sleep 10; 
    
    _marker setMarkerPos (position leader _grouphsq);
    
    if ((floor time) - _startTime >= mainMissionTimeout) then { _failed = true };
    if (currentWaypoint _grouphsq >= _numWaypoints) then { _failed = true }; // HostileHelis got successfully to the target location
    _unitsAlive = { alive _x } count units _grouphsq;
    
    _unitsAlive == 0 || _failed
};

if(_failed) then
{
    // Mission failed
	{deleteVehicle _x;}forEach _vehicles;
	{deleteVehicle _x;}forEach units _grouphsq; 
	deleteGroup _grouphsq; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>Hostile AirSquad</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The enemy got away, better luck next time!</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    messageSystem = _hint;
    if (!isDedicated) then { call serverMessage };
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
    // Mission complete
	{if(!alive _x) then {deleteVehicle _x;};}forEach _vehicles;
    _ammobox = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox;
    clearWeaponCargoGlobal _ammobox; 
    [_ammobox,"mission_USSpecial2"] call fn_refillbox;
    _ammobox2 = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox2;
    clearWeaponCargoGlobal _ammobox2; 
    [_ammobox2,"mission_USLaunchers2"] call fn_refillbox;
    _ammobox3 = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox3;
    clearWeaponCargoGlobal _ammobox3; 
    [_ammobox3,"mission_Side_USSpecial"] call fn_refillbox;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>Hostile AirSquad</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The Hostile AirSquad has been taken down!</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    messageSystem = _hint;
    if (!isDedicated) then { call serverMessage };
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

deleteMarker _marker;
