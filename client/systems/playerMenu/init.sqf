#include "defines.hpp"
#include "dialog\player_sys.sqf"; 

if(isnil {player getVariable __MONEY_VAR_NAME__}) then {player setVariable[__MONEY_VAR_NAME__,0,true];};
if(dialog) exitwith{};

disableSerialization;

private["_Dialog","_foodtext","_watertext","_moneytext","_mvalue","_rogue", "_moneyStr","_uptime","_groupButton","_mIndex","_uptimeText"];

_money = player getVariable __MONEY_VAR_NAME__;
_moneyStr = format["%1", _money];
pMenuActive = true;

_playerDialog = createDialog "playerSettings";

_Dialog = findDisplay playersys_DIALOG;
_Dialog displaySetEventHandler ["KeyDown", "_this call pMenuKeyPressed"];
_foodtext = _Dialog displayCtrl food_text;
_watertext = _Dialog displayCtrl water_text;
_moneytext = _Dialog displayCtrl money_text;
_mvalue = _Dialog displayCtrl money_value;
_rogue = _Dialog displayCtrl rogue_text;
_uptime = _Dialog displayCtrl uptime_text;
_groupButton = _Dialog displayCtrl groupButton;
_foodtext ctrlSettext format["%1 / 100", round(hungerLevel)];
_watertext ctrlSetText format["%1 / 100", round(thirstLevel)];
_moneytext ctrlSetText _moneyStr;

// First entry is all money if they have more than none!
if (_money > 0) then {
	_mIndex = _mvalue lbadd format["$%1", _moneyStr]; _mvalue lbSetData [0, _moneyStr];
};
_mIndex = _mvalue lbadd "$100"; _mvalue lbSetData [(lbSize _mvalue)-1, "100"];
_mIndex = _mvalue lbadd "$200"; _mvalue lbSetData [(lbSize _mvalue)-1, "200"];
_mIndex = _mvalue lbadd "$400"; _mvalue lbSetData [(lbSize _mvalue)-1, "400"];
_mIndex = _mvalue lbadd "$500"; _mvalue lbSetData [(lbSize _mvalue)-1, "500"];
_mIndex = _mvalue lbadd "$1000"; _mvalue lbSetData [(lbSize _mvalue)-1, "1000"];
_mIndex = _mvalue lbadd "$2000"; _mvalue lbSetData [(lbSize _mvalue)-1, "2000"];
_mIndex = _mvalue lbadd "$3000"; _mvalue lbSetData [(lbSize _mvalue)-1, "3000"];
_mIndex = _mvalue lbadd "$4000"; _mvalue lbSetData [(lbSize _mvalue)-1, "4000"];
_mIndex = _mvalue lbadd "$5000"; _mvalue lbSetData [(lbSize _mvalue)-1, "5000"];

// Select element 0 by default
lbSetCurSel [_mvalue, 0]; // Does this even fuckin work

//  enabled groups for bluefor/opfor for sthud usage (uncomment this to undo it) - JoSchaap
// if(str(playerSide) == "west" || str(playerSide) == "east") then
// {
// 	_groupButton ctrlShow false;    
// };

while {pMenuActive} do
{
    _uptimeText = [time/60/60] call BIS_fnc_timeToString;
    _uptime ctrlSetText format["Server Uptime: %1", _uptimeText];
	sleep 0.1;
};