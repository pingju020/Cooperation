//
//  XTDefines.h
//

//#import "ChatViewController.h"
#ifndef SNDEFINES
#define SNDEFINES


extern NSString *const kClientId;
extern NSString *const kClientSecret;
extern NSString *const kUserLoggedNotificationName;
extern NSString *const kApiVersion;
extern NSString *const linkage_urlpath;
extern NSString *const im_server_url;
extern NSString *const im_server_login_url;
extern NSString *const im_server_grouplist_url;
extern NSString *const im_server_wc_url;

extern NSString *const community_server_url;
extern NSString *const community_server;
extern NSString *const community_oauth_api;
extern NSString *const community_client_secret;
extern NSString *const community_client_id;
extern NSString *const community_grant_type;

extern NSString *const education_server_url;

extern NSString *const store_http_url ;
extern NSString *const linkage_http_url ;
extern NSString *const linkage_vidoe_http_url;
extern NSString *const origin;
extern UIImage *const img;
extern NSString *const SecretKey;

extern NSString *const  im_url;
extern NSString *const  im_urlpath;
extern NSString *const  im_client_id;
extern NSString *const  im_client_secret;
extern NSString *const  im_ws;

extern NSString *const  sq_url_oauth;
extern NSString *const  sq_url_oauth_path;
extern NSString *const  sq_url;
extern NSString *const  sq_urlpath;
extern NSString *const  sq_client_id;
extern NSString *const  sq_client_secret;


extern NSString *const  SQ_GETLOGGEDINUSER;
extern NSString *const  SQ_TALK_ADD;
extern NSString *const  SQ_TALK_FORWARD;
extern NSString *const  SQ_TALK_LIST;
extern NSString *const  SQ_TALKCOMMENT_LIST;
extern NSString *const  SQ_TALKCOMMENT_ADD;
extern NSString *const  SQ_PROFILEIMAGE;
extern NSString *const  SQ_UPLOAD_PIC;
extern NSString *const  SQ_GETALBUMS;
extern NSString *const  SQ_GETALBUM_DETAIL;
extern NSString *const  SQ_ALBUM_ADDCOMMENT;
extern NSString *const  SQ_ALBUM_GETCOMMENTS;
extern NSString *const  SQ_FRIEND_DYNAMIC;
extern NSString *const  SQ_RES_GETRESLIST;
extern NSString *const  SQ_RES_GETRESDETAIL;
extern NSString *const  SQ_RES_NETDISK;
extern NSString *const  SQ_RES_NETDISKUPLOAD;

enum ShowVC
{
    ChangePWD = 0,
    Logout = 1,
    FamilySendSMS = 2,
    NetDisk = 3,
    InfoSet = 4,
    FamilyReceviceBox = 5,
    FamilySendBox = 6,
    ReporterStation = 7,
    Lesson_table = 8,
    StudyResorce = 9,
    FamilyFavBox = 10,
    AddDisscuss = 11,
    DisscussList = 12,
    ChangeSkin = 13,
    UploadProImage = 14,
    AddPhoto = 15,
    PhotoList = 16,
    VideoShow = 17,
    changeClass = 18,
    DownloadedFile = 19,
    AddrList = 20,
    Mood = 21,
    AddChat = 22,
    FamilarityNum = 23,
    //最大值, 防止越界, 在上面添加新的
    MaxVc,
};

enum MoodVC {
    AddTalk_sqNotification = 0,
    TalkList_sqNotification = 1,
    AddPhoto_sqNotification = 2,
    AlbumList_sqNotification = 3,
    
    //最大值, 防止越界, 在上面添加新的
    MaxMoodVc,
    };

#define TabMainShowViewNotification @"TabMainShowViewNotification"
//#define changeClass @"changeClass"
//#define ChangePWD @"ChangePWD"

//#define StudyResorce @"StudyResorce"

//#define Logout @"Logout"
//#define FamilySendSMS @"FamilySendSMS"
//#define FamilyReceviceBox @"FamilyReceviceBox"
//#define FamilySendBox @"FamilySendBox"
//#define Lesson_table @"Lesson_table"
//#define FamilyFavBox @"FamilyFavBox"
//#define InfoSet @"InfoSet"
//#define UploadProImage @"UploadProImage"
//#define ChangeSkin @"ChangeSkin"
//#define AddDisscuss @"AddDisscuss"
//#define AddChat @"AddChat"
//#define DisscussList @"DisscussList"
//#define AddPhoto @"AddPhoto"
//#define PhotoList @"PhotoList"
//#define NetDisk @"NetDisk"
//#define ReporterStation @"ReporterStation"

//#define VideoShow @"VideoShow"

//#define TalkList_sqNotification @"TalkList_sqNotification"
//#define AddTalk_sqNotification @"AddTalk_sqNotification"
//#define AddPhoto_sqNotification @"AddPhoto_sqNotification"
//#define AlbumList_sqNotification @"AlbumList_sqNotification"

#define MonthChangedNotification @"MonthChangedNotification"
#define ListDataChangedNotification @"ListDataChangedNotification"
#define SMSDetailNotification @"SMSDetailNotification"
#define SMSReplyNotification @"SMSReplyNotification"
#define SMSForwardNotification @"SMSForwardNotification"

#define TwitterDetailNotification @"TwitterDetailNotification"

#define ContactViewControllerNotification @"ContactViewControllerNotification"
#define SendContactNotification @"SendContactNotification"
#define CloseContactNotification @"CloseContactNotification"
#define ShowContactNotification @"ShowContactNotification"
#define UploadPicNotification @"UploadPicNotification"
#define ShowPhotoNotification @"ShowPhotoNotification"
#define ShowPhotoVCNotification @"ShowPhotoVCNotification"
#define DeletePicNotification @"DeletePicNotification"
#define TiwitterCommentListDataChangedNotification @"TiwitterCommentListDataChangedNotification"

#define ChangeAblumNotification @"ChangeAblumNotification"

#define ShowHomeNotificMsg @"ShowHomeNotificMsg"
#define ShowJobNotificMsg @"ShowJobNotificMsg"
#define ShowSafeNotificMsg @"ShowSafeNotificMsg"

#define IMSendMsg @"IMSendMsg"
#define IMRevMsg @"IMRevMsg"
#define IMReloadMsgList @"IMReloadMsgList"

#define CloseNotifition @"CloseNotifition"
#define ShowNotifition @"ShowNotifition"
#define EditFamilNumNotifition @"EditFamilNumNotifition"

#define NetDiskSideMenuChanged @"NetDiskSideMenuChanged"
//修改:发信息的联系人换成可以跨班多选
#define ContactSelectFinish @"ContactSelectFinish"

#define ORG @"I01"
//#define HEADURL  @"http://211.138.251.204:8080/classSpace/module/common/shequhead/avatar/" //广西
//#define HEADURL  @"http://180.96.19.150/avatar/province/SH/" //上海
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

//#define ACCOUNT_GETLOGGEDINUSER @"account.getLoggedInUser";
//#define SQ_GETLOGGEDINUSER @"/account.getLoggedInUser";

#define HideUploadingMsg @"hideUploadingMsg"

#endif

