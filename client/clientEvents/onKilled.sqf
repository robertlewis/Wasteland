//	@file Version: 1.0
//	@file Name: onKilled.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#include "defines.hpp"

_player = (_this select 0) select 0;
_killer = (_this select 0) select 1;
if(isnil {_player getVariable __MONEY_VAR_NAME__}) then {_player setVariable[__MONEY_VAR_NAME__,0,true];};
//diag_log (unitBackpack _player);
//clearMagazineCargoGlobal (unitBackpack _player);
//removebackpack _player;
playerSetupComplete = false;
PlayerCDeath = [_player];
publicVariable "PlayerCDeath";

if (isServer) then {
	_id = PlayerCDeath spawn serverPlayerDied;
};

if(!local _player) exitwith {};

if((_player != _killer) && (vehicle _player != vehicle _killer) && (playerSide == side _killer)) then {
	pvar_PlayerTeamKiller = objNull;
	if(_killer isKindOf "CAManBase") then {
		pvar_PlayerTeamKiller = _killer;
	} else {
		_veh = (_killer);
		_trts = configFile >> "CfgVehicles" >> typeof _veh >> "turrets";
		_paths = [[-1]];
		if (count _trts > 0) then {
			for "_i" from 0 to (count _trts - 1) do {
				_trt = _trts select _i;
				_trts2 = _trt >> "turrets";
				_paths = _paths + [[_i]];
				for "_j" from 0 to (count _trts2 - 1) do {
					_trt2 = _trts2 select _j;
					_paths = _paths + [[_i, _j]];
				};
			};
		};
		_ignore = ["SmokeLauncher", "FlareLauncher", "CMFlareLauncher", "CarHorn", "BikeHorn", "TruckHorn", "TruckHorn2", "SportCarHorn", "MiniCarHorn", "Laserdesignator_mounted"];
		_suspects = [];
		{
			_weps = (_veh weaponsTurret _x) - _ignore;
			if(count _weps > 0) then {
				_unt = objNull;
				if(_x select 0 == -1) then {_unt = driver _veh;}
				else {_unt = _veh turretUnit _x;};
				if(!isNull _unt) then {
					_suspects = _suspects + [_unt];
				};
			};
		} forEach _paths;

		if(count _suspects == 1) then {
			pvar_PlayerTeamKiller = _suspects select 0;
		};
	};
};

if(!isNull(pvar_PlayerTeamKiller)) then {
	publicVar_teamkillMessage = pvar_PlayerTeamKiller;
	publicVariable "publicVar_teamkillMessage";
};

private["_a","_b","_c","_d","_e","_f","_m","_player","_killer", "_to_delete"];

_to_delete = [];
_to_delete_quick = [];

//get the donation money and subtract it from their total
_mTotal = 0;
_mTotal = _player getVariable __MONEY_VAR_NAME__;
_mTotal = _mTotal - computedMoney;
if(_mTotal <= 0) then {_mTotal = 0;};
if(_mTotal > 0) then {
	// 15% tax on death!
	_mTotal = _mTotal - (_mTotal * .15);
	_m = "Land_Sack_F" createVehicle (position _player);
	_m setVariable[__MONEYBAG_VAR_NAME__, _mTotal, true];
	_m setVariable ["owner", "world", true];
	_to_delete = _to_delete + [_m];
};

//if((_player getVariable "canfood") > 0) then {
//	for "_a" from 1 to (_player getVariable "canfood") do {	
//		_m = "Land_Basket_F" createVehicle (position _player);
//		_to_delete = _to_delete + [_m];
//	};
//};
//
//if((_player getVariable "water") > 0) then {
//	for "_b" from 1 to (_player getVariable "water") do {	
//		_m = "Land_Bucket_F" createVehicle (position _player);
//		_to_delete = _to_delete + [_m];
//	};
//};

true spawn {
	waitUntil {playerRespawnTime < 2};
//	titleText ["", "BLACK OUT", 1];
};
