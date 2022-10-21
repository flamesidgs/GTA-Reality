/*******************************************************************************
* FILENAME :        main.pwn
*
* DESCRIPTION :
*       Includes all modules, includes and constants.
*
* NOTES :
*       This file is not intended to handle player's processes.
*
* CONTRIBUTORS :
*		Larceny
*
* THANKS :
*       SA:MP Team past, present and future - SA:MP.
*       Y_Less - YSI.
*       BlueG - MySQL Plugin.
*		Toribio/Southclaw - Progress bar inc.
*		Incognito - Streamer plugin
*/

// Required to be at the top
#include <a_samp>

//------------------------------------------------------------------------------

// Script version
#define SCRIPT_VERSION_MAJOR							0
#define SCRIPT_VERSION_MINOR							5
#define SCRIPT_VERSION_PATCH							"a"
#define SCRIPT_VERSION_NAME								"GTA:Reality"

// Database
#define MySQL_HOST		"localhost"
#define MySQL_USER		"root"
#define MySQL_DB		"gtareality"
#define MySQL_PASS		"root"
new MySQL:gMySQL;

//------------------------------------------------------------------------------

// Libraries
#include <a_mysql>
#include <YSI\y_commands>
#include <YSI\y_timers>
#include <YSI\y_hooks>
#include <progress2>
#include <streamer>
#include <util>

//------------------------------------------------------------------------------

hook OnGameModeInit()
{
	print("\n\n============================================================\n");
	print("Initializing...\n");
    SetGameModeText(SCRIPT_VERSION_NAME " " #SCRIPT_VERSION_MAJOR "." #SCRIPT_VERSION_MINOR "." #SCRIPT_VERSION_PATCH);

    // MySQL connection
    mysql_log(ERROR | WARNING | DEBUG);
	gMySQL = mysql_connect(MySQL_HOST, MySQL_USER, MySQL_PASS, MySQL_DB);
	if(mysql_errno(gMySQL) != 0)
    {
        print("ERROR: Could not connect to database!");
        return -1; // Stop the initialization if can't connect to database.
    }
	else
        printf("[mysql] connected to database %s at %s successfully!", MySQL_DB, MySQL_HOST);

	// Gamemode settings
	ShowNameTags(1);
	UsePlayerPedAnims();
	DisableInteriorEnterExits(); // For server-sided entrances
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(false);
	return 1;
}

//------------------------------------------------------------------------------

// Modules

/* Defs */
#include "../modules/def/ftime.pwn"
#include "../modules/def/dialog.pwn"
#include "../modules/def/mapicons.pwn"
#include "../modules/def/missions.pwn"

/* Data */
#include "../modules/data/accounts.pwn"

/* Game */
#include "../modules/game/clock.pwn"
#include "../modules/game/hospital.pwn"

/* Player */
#include "../modules/player/animpreload.pwn"

/* Missions */
#include "../modules/missions/intro.pwn"
#include "../modules/missions/sweetcall.pwn"
#include "../modules/missions/homeinvasion.pwn"

/* Visual */
#include "../modules/visual/subtitles.pwn"
#include "../modules/visual/cutscene.pwn"
#include "../modules/visual/info.pwn"

//------------------------------------------------------------------------------

main()
{
	printf("\n\n%s %d.%d.%d initialiazed.\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	print("============================================================\n");
}
