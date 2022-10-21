/*******************************************************************************
* FILENAME :        modules/missions/sweetcall.pwn
*
* DESCRIPTION :
*       After first call sweet calls CJ.
*
* NOTES :
*       -
*/

#include <YSI\y_hooks>

static gplCurrentSound[MAX_PLAYERS] = {-1, ...};
static bool:gplIsPhoneRinging[MAX_PLAYERS];

static gCutsceneData[][][] =
{
    {29098, 1500, !"Manis, hei, Wassup?"},
    {29099, 2000, !"Pikir saya akan menjelaskan beberapa omong kosong."},
    {29100, 2500, !"Sejak Anda pergi, omong kosong telah berubah di sini."},
    {29101, 2150, !"Keluarga Grove Street tidak lagi."},
    {29102, 4200, !"Keluarga Seville Boulevard dan keluarga Temple Drive bertambah, dan dibagi dengan hutan."},
    {29103, 4200, !"Sekarang kami sangat sibuk membuat tersandung, balas dan vagos telah mengambil alih, jadi saksikan dirimu di luar sana."},
    {29104, 3100, !"Hanya karena mereka mengenakan sayuran hijau, tidak berarti mereka sekutu mereka.Salinan?"},
    {29105, 1500, !"Ya, aku mendengarmu."},
    {29106, 1500, !"Terimakasih atas peringatannya."},
    {29107, 1500, !"Tidak menyebutkannya."}
};

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_YES) && gplIsPhoneRinging[playerid])
    {
        gplCurrentSound[playerid] = 0;
        gplIsPhoneRinging[playerid] = false;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
        HidePlayerInfoMessage(playerid);
        defer ProcessPhoneCutscene(playerid);
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if(GetPlayerCurrentMission(playerid) == MISSION_SWEET_CALL && gplIsPhoneRinging[playerid] == false)
        defer RingPlayerPhone(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    gplCurrentSound[playerid] = -1;
    gplIsPhoneRinging[playerid] = false;
    return 1;
}

timer ProcessPhoneCutscene[1000](playerid)
{
    new i = gplCurrentSound[playerid];
    if(i < sizeof(gCutsceneData))
    {
        gplCurrentSound[playerid]++;
        PlayerPlaySound(playerid, gCutsceneData[i][0][0], 0.0, 0.0, 0.0);
        ShowPlayerSubtitle(playerid, gCutsceneData[i][2]);
        defer ProcessPhoneCutscene[gCutsceneData[i][1][0]](playerid);
    }
    else if(i == sizeof(gCutsceneData))
    {
        HidePlayerSubtitle(playerid);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
        SetPlayerCurrentMission(playerid, MISSION_HOME_INVASION);
        SetPlayerMapIcon(playerid, 0, 2459.3779, -1689.3700, 13.5377, 34, -1, MAPICON_GLOBAL_CHECKPOINT); // next mission
    }
}

timer RingPlayerPhone[3000](playerid)
{
    if(!IsPlayerConnected(playerid))
        return 1;
    else if(IsPlayerInAnyVehicle(playerid))
    {
        defer RingPlayerPhone(playerid);
        return 1;
    }
    else if(gplCurrentSound[playerid] == -1)
    {
        defer RingPlayerPhone(playerid);
        gplIsPhoneRinging[playerid] = true;
        PlayerPlaySound(playerid, 20600, 0.0, 0.0, 0.0);
        ShowPlayerInfoMessage(playerid, "Tekan Y untuk menjawab telepon.");
    }
    return 1;
}
