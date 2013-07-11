//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:

if(!X_Server) exitWith {};

sideMissions = 1;
serverSpawning = 1;
buildingsloot = 1;

//Execute Server Side Scripts.
//vfats =[3.5] spawn compile preprocessFile ("server\functions\VFATS_SRV.sqf");
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompiledScripts = [] execVM "server\functions\serverCompile.sqf";
[] execVM "server\functions\broadcaster.sqf";
[] execVM "server\functions\relations.sqf";
[] execVM "server\functions\serverTimeSync.sqf";
waitUntil{scriptDone _serverCompiledScripts};

execVM "server\statSave\serverGather.sqf";

diag_log format["WASTELAND SERVER - Server Compile Finished"];

//Execute Server Spawning.
if (buildingsloot == 1) then {
	diag_log format["GOT WASTELAND - Placing loot in buildings"];
	_lootspawnz = [] execVM "server\spawning\lootCreation.sqf";
	sleep 0.1;
	diag_log format["GOT WASTELAND - Done placing loot in buildings"];
	};

if (serverSpawning == 1) then {
    diag_log format["WASTELAND SERVER - Initilizing Server Spawning"];
	_vehSpawn = [] ExecVM "server\functions\vehicleSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _vehSpawn};
    _objSpawn = [] ExecVM "server\functions\objectsSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn};
    _objSpawn2 = [] ExecVM "server\functions\objectsSpawning2.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn2};
    _boxSpawn = [] ExecVM "server\functions\boxSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _boxSpawn};
    _boatSpawn = [] ExecVM "server\functions\boatSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _boatSpawn};
    //_heliSpawn = [] ExecVM "server\functions\staticHeliSpawning.sqf";
    //waitUntil{sleep 0.1; scriptDone _heliSpawn};
	_buildrep = [] ExecVM "server\functions\rebuild.sqf";
	sleep 0.1;
	_initOwners = [] ExecVM "server\functions\initStoreOwners.sqf";
	sleep 0.1;
	_recurOwners = [] ExecVM "server\functions\recurInitStoreOwners.sqf";
	_cleanupLoop = [] ExecVM "server\functions\cleanupLoop.sqf";
	sleep 0.1;
};

//Execute Server Missions.
if (sideMissions == 1) then {
	diag_log format["WASTELAND SERVER - Initilizing Missions"];
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
	sleep 5;
	[] execVM "server\missions\moneyMissionController.sqf";
	sleep 5;
	[] execVM "server\missions\bountyMissionController.sqf";
};

if (isDedicated) then {
	_id = [] execFSM "server\WastelandServClean.fsm";
};
