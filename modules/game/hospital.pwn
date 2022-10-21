/*******************************************************************************
* FILENAME :        modules/game/hospital.pwn
*
* DESCRIPTION :
*       Sends players to hospital when they die.
*
* NOTES :
*       -
*/

#include <YSI\y_hooks>

//------------------------------------------------------------------------------

// Checks if the player died before spawning
static bool:gPlayerDied[MAX_PLAYERS];

// Player current hospital cutscene message
static gplCurrentMessage[MAX_PLAYERS];

//------------------------------------------------------------------------------

static gHospitalTutorial[][] =
{
    "Jika kesehatan Anda mencapai nol, Anda akan pingsan dan Anda akan dirawat di pusat medis setempat.",
    "Untuk membantu mengembalikan kesehatan Anda ke normal, Anda bisa makan makanan, menggunakan pick-up kesehatan atau Anda dapat melindungi diri Anda dengan mengenakan pelindung tubuh.",
    "Sebelum Anda habis, staf rumah sakit akan menyita senjata Anda dan menagih Anda untuk perawatan kesehatan yang Anda terima."
};

//------------------------------------------------------------------------------

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(GetPlayerCurrentMission(playerid) > MISSION_INTRO)
        gPlayerDied[playerid] = true;
    GameTextForPlayer(playerid, "Wasted", 5000, 2);
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    gPlayerDied[playerid] = false;
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerSpawn(playerid)
{
    if(gPlayerDied[playerid])
    {
        SetPlayerFacingAngle(playerid, 133.5321);
        SetPlayerPos(playerid, 2028.3698, -1420.2480, 16.9922);
        if(!GetPlayerFirstTime(playerid, FIRST_TIME_HOSPITAL))
        {
            gplCurrentMessage[playerid] = 0;
            SelectTextDraw(playerid, 0x00000000); // Hide player HUD
            HidePlayerClock(playerid);
            ShowPlayerCutsceneBars(playerid);
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 2025.1041, -1429.3228, 22.5467);
            SetPlayerCameraLookAt(playerid, 2025.3395, -1428.3467, 21.8717);
            ProcessHospitalCutscene(playerid);
        }
        else
            SetCameraBehindPlayer(playerid);
    }
    return 1;
}

//------------------------------------------------------------------------------

timer ProcessHospitalCutscene[6500](playerid)
{
    new i = gplCurrentMessage[playerid];
    if(i < sizeof(gHospitalTutorial))
    {
        ClearPlayerScreen(playerid);
        gplCurrentMessage[playerid]++;
        PlaySelectSound(playerid);
        ShowPlayerInfoMessage(playerid, gHospitalTutorial[i]);
        defer ProcessHospitalCutscene(playerid);
    }
    else if(i == sizeof(gHospitalTutorial))
    {
        ShowPlayerClock(playerid);
        CancelSelectTextDraw(playerid); // Show player HUD
        HidePlayerCutsceneBars(playerid);
        HidePlayerInfoMessage(playerid);
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable(playerid, true);
        SetPlayerFirstTime(playerid, FIRST_TIME_HOSPITAL, true);
    }
}
