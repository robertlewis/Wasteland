//	@file Version: 1.0
//	@file Name: playerSelect.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#include "defines.hpp"

#define playerMenuDialog 55500
#define playerMenuPlayerList 55505
#define playerMenuSpectateButton 55506
#define playerMenuWarnMessage 55509

disableSerialization;

private ["_dialog","_playerListBox","_spectateButton","_switch","_index","_modSelect","_playerData","_target","_check","_spectating","_camadm","_rnum","_warnText","_targetUID","_playerName"];
_uid = getPlayerUID player;
_camadm = nil;

if ((_uid in moderators) OR (_uid in serverAdministrators)) then {
	_dialog = findDisplay playerMenuDialog;
	_playerListBox = _dialog displayCtrl playerMenuPlayerList;
	_spectateButton = _dialog displayCtrl playerMenuSpectateButton;
	_warnMessage = _dialog displayCtrl playerMenuWarnMessage;
	
	_switch = _this select 0;
	_index = lbCurSel _playerListBox;
	_playerData = _playerListBox lbData _index;
	_check = 0;

	{
		if (str(_x) == _playerData) then {
			_target = _x;
			_check = 1;
		};
	}forEach playableUnits;
	
	if (_check == 0) then {player globalChat "Select a player first"; exit;};
	
	switch (_switch) do
	{
	    case 0: //Spectate
		{
			_spectating = ctrlText _spectateButton;
			if (_spectating == "Spectate") then {
				_spectateButton ctrlSetText "Spectating";
				player commandChat format ["Viewing %1.", name _target];
				
				if (!isNil "_camadm") then {
					camDestroy _camadm;
				};

				_camadm = "camera" camCreate ([(position vehicle _target select 0) - 5,(position vehicle _target select 1), (position vehicle _target select 2) + 10]);
				_camadm cameraEffect ["external", "TOP"];
				_camadm camSetTarget (vehicle _target);
				_camadm camCommit 1;
							
				_rnum = 0;
				while {ctrlText _spectateButton == "Spectating"} do {
					switch (_rnum) do 
					{
						if (daytime > 19 || daytime < 3) then {camUseNVG true;} else {camUseNVG false;};
						case 0: {detach _camadm; _camadm attachTo [(vehicle _target), [0,-10,4]]; _camadm setVectorUp [0, 1, 5];}; 
						case 1: {detach _camadm; _camadm attachTo [(vehicle _target), [0,10,4]]; _camadm setDir 180; _camadm setVectorUp [0, 1, -5];};
						case 2: {detach _camadm; _camadm attachTo [(vehicle _target), [0,1,50]]; _camadm setVectorUp [0, 50, 1];};
						case 3: {detach _camadm; _camadm attachTo [(vehicle _target), [-10,0,2]]; _camadm setDir 90; _camadm setVectorUp [0, 1, 5];};
						case 4: {detach _camadm; _camadm attachTo [(vehicle _target), [10,0,2]]; _camadm setDir -90; _camadm setVectorUp [0, 1, -5];};                                                                        
					};
					player commandchat "Viewing cam " + str(_rnum) + " on " + str(name vehicle _target);
					_rnum = _rnum + 1;
					if (_rnum > 4) then {_rnum = 0;};
					sleep 5;
				};
			} else {
				_spectateButton ctrlSetText "Spectate";
				player commandchat format ["No Longer Viewing.", name _target];
				player cameraEffect ["terminate","back"];
				camDestroy _camadm;
			};
		};
		case 1: //Warn
		{	
			// CONVERTED TO USE SHADOW'S NEW serverRelayHandler SYSTEM
	        _adminName = name player;
			_warnText = ctrlText _warnMessage;
			_destPlayerUID = getPlayerUID _target;

			if (_warnText != "") then {
				_msg = format["ADMIN MESSAGE FROM %1:  %2", _adminName, _warnText];
				diag_log format ["Msg system sending from %1 -> %2 (UID %3):  %4", _adminName, name _target, _destPlayerUID, _msg];

				//if(X_Server) then {call serverRelayHandler};
				serverRelaySystem = [MESSAGE_BROADCAST_MSG_TO_PLAYER, MESSAGE_BROADCAST_MSG_TYPE_TITLE, _destPlayerUID, _msg];
				publicVariable "serverRelaySystem";
			} else {
				player globalChat "Type in a message to send";
			};
		};
	    case 2: //Slay
	    {
	    	player globalChat "Not working currently";
			//[_target, format["if (name player == ""%1"") then {player setdamage 1; Endmission ""END1"";failMission ""END1"";forceEnd; deletevehicle player;};",name _target], false] spawn fn_vehicleInit;
			 //processInitCommands;
			 //clearVehicleInit _target;
	    };
	    case 3: //Unlock Team Switcher
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(_x select 0 == _targetUID) then
			    {
			    	pvar_teamSwitchList set [_forEachIndex, "REMOVETHISCRAP"];
					pvar_teamSwitchList = pvar_teamSwitchList - ["REMOVETHISCRAP"];
			        publicVariableServer "pvar_teamSwitchList";
	                
	                [_target, format["if (name player == ""%1"") then {client_firstSpawn = nil;};",name _target], false] spawn fn_vehicleInit;
			         //processInitCommands;
			        //clearVehicleInit _target;
	                
	                [player, format["if isServer then {publicVariable 'pvar_teamSwitchList';};"], false] spawn fn_vehicleInit;
			        //processInitCommands;
			        //clearVehicleInit player;
			    };
			}forEach pvar_teamSwitchList;			
	    };
		case 4: //Unlock Team Killer
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(_x select 0 == _targetUID) then
			    {
			    	pvar_teamKillList set [_forEachIndex, "REMOVETHISCRAP"];
					pvar_teamKillList = pvar_teamKillList - ["REMOVETHISCRAP"];
			        publicVariableServer "pvar_teamKillList"; 
	                
	                [player, format["if isServer then {publicVariable 'pvar_teamKillList';};"], false] spawn fn_vehicleInit;
			        //processInitCommands;
					//clearVehicleInit player;       
			    };
			}forEach pvar_teamKillList;       		
	    };
        case 5: //Remove All Money
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) then
			    {
  					_x setVariable[__MONEY_VAR_NAME__,0,true];
			    };
			}forEach playableUnits;       		
	    };
        case 6: //Remove All Weapons
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) then
			    {
  					removeAllWeapons _x;
			    };
			}forEach playableUnits;       		
	    };
        case 7: //Check Player Gear
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) then
			    {
  					createGearDialog [_x, "RscDisplayGear"];
			    };
			}forEach playableUnits;        		
	    };
		case 8: //Add database Entry
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) then
			    {
					_donation = getPlayerUID _x + "_donation";
					//[_donation + "donation", _donation, "DonationAmount", "NUMBER"] call sendToServer;
					//[_donation + "donation", _donation, "ComputedMoney", "NUMBER"] call sendToServer;
					//[_donation + "donation", _donation, "Date", "ARRAY"] call sendToServer;
					_money = parseNumber(ctrlText _warnMessage);
					_computed = (_money * 25);
					[_donation, _donation, "Name", name _x] call fn_SaveToServer;
					[_donation, _donation, "DonationAmount", _money] call fn_SaveToServer;
					[_donation, _donation, "ComputedMoney", _computed] call fn_SaveToServer;
					[_donation, _donation, "Date", date] call fn_SaveToServer;
					player globalChat format["%1 has been registered with $%2 in donations. This equates to $%3 on spawn.", name _x, ctrlText _warnMessage, _computed];
			    };
			}forEach playableUnits;        		
	    };
	};
} else {
  exit;  
};
