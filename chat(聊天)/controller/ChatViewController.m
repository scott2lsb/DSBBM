//
//  chatViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#define kTimeLimit 60*60*24*2


#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "ChatFootbarView.h"
#import "UIImage+Extension.h"
#import "friendInfoViewController.h"
#import "NSString+Extension.h"
#import "DetailWishViewController.h"
#import "NSString+Emote.h"
#import "PhotoViewController.h"
#import "SaveImage.h"
#import "sqlStatusTool.h"
#import "synFriends.h"
#import "chatData.h"
#import "RecordAudio.h"
#import "voiceLongBtn.h"
#import "voiceTime.h"
#import "bigImage.h"
#import "souceDownload.h"


@interface ChatViewController ()<chatTableViewDelegate, UITextViewDelegate, MJRefreshBaseViewDelegate,RecordAudioDelegate, voiceLongBtnDelegate>

@property (nonatomic, strong) NSDictionary *SmileDict;
@property (nonatomic, strong)  NSMutableArray *timeArray;
@end


@implementation ChatViewController
{
    UIView                  * _textViewBack;
    UITextView              *_textView;
    BmobChatUser            * _chatUser;
    NSMutableDictionary     *_infoDic;
    UITableView             *_chatTableView;
    NSMutableArray          *_chatArray;
    BOOL                    _isFished;
    NSUInteger              _page;
    NSUInteger              _totalCount;
    smileView               *_emojiView;//表情
    //表情按钮
    UIButton                * emojiButton;
    //添加按钮
    UIButton                * addButton;
    //发送按钮
    UIButton                * sendBut;
    UIButton                * voiceBtn;
    voiceLongBtn                * voicelongBtn;
    //输入框的线
    UIView                  * textViewXian;
    ChatFootbarView         *_footbarView;//照片，照相，地理位置
    UIImageView             *_readedView;
    UIView                  *_addFriendView;
    //发送过来的
    NSMutableDictionary     *_sendWishDict;
    //输入框的背景
    UIView                  * textViewBj;
    //记录输入法的y
    CGFloat                 textY;
    //记录输入框栏的高度
    CGFloat                 BJHeight;
    //输入时的高度
    CGFloat                 tempHeight;
    MJRefreshHeaderView     *headRefresh;
    CGFloat                 keyboardHeight;
    BOOL                    isVoice;
    //位置
    NSInteger               _location;
    RecordAudio             *recordAudio;
    NSData                  *curAudio;
    BOOL                    isRecording;
    int                     endtime;
    UIView                  *recodeCover;
    UIImageView             *middleImageView;
    UIImageView             *lajitongView;
    NSTimer                 *timer;
    UILabel                 *lable;
}

- (NSDictionary *)SmileDict
{
    if (_SmileDict == nil) {
        //1.获得plist的全路径
        NSString *path = [[NSBundle mainBundle]pathForResource:@"smile.plist" ofType:nil];
        //2.加载数据
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        _SmileDict = dict;
    }
    return _SmileDict;
}

- (NSMutableArray *)timeArray
{
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

- (instancetype)initWithUserDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _infoDic = [[NSMutableDictionary alloc] init];
        _sendWishDict = [NSMutableDictionary dictionary];
        if (dic) {
            [_infoDic setDictionary:dic];
        }
        _chatUser = [[BmobChatUser alloc] init];
        _chatUser.objectId = [[dic objectForKey:@"uid"] description];
        _chatUser.username = [[dic objectForKey:@"name"] description];
        _chatUser.avatar   = [[dic objectForKey:@"avatar"] description];
        _chatUser.nick     = [[dic objectForKey:@"nick"] description];
    }
    
    return self;
}

- (void)test
{
    
//    NSLog(@"contentSxize = %@, contentOffset = %@, contentInset = %@", NSStringFromCGSize(_chatTableView.contentSize) , NSStringFromCGPoint(_chatTableView.contentOffset),NSStringFromUIEdgeInsets(_chatTableView.contentInset) );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFriend = NO;
    isVoice = NO;
    tempHeight = 49;
    textY = Main_screen_height;
    BJHeight = 49;
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    [sqlStatusTool selectBlackList];
    [self createTable];
    [self createNaBar];
    [self createTextView];
    _page       = 0;
    _totalCount = 0;
    _isFished   = NO;
    
    //下拉刷新
    headRefresh = [[MJRefreshHeaderView alloc]init];
    headRefresh.delegate = self;
    headRefresh.scrollView = _chatTableView;
    //音频
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BmobDB currentDatabase] createDataBase];
    [self getUnreadMsg];
    
}

- (void)getUnreadMsg
{
    NSString *lastTime = [chatData readChatMessageTimeAndSaveTime];
    [chatData getMessageWhenReceivePush:lastTime successful:^(BOOL successful, NSDictionary *dict) {
        if (successful) {
            
            [self performSelector:@selector(searchMessages) withObject:nil afterDelay:0.3f];
        }
        
    }];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNext];
        [headRefresh endRefreshing];
    });
    
}

//类型mt是5， mc 为  愿望text ＋ "&" + 愿望url ＋ "&" + 愿望评论数 ＋ "&" + 愿望点赞数 ＋ “&” ＋ 愿望objectId + "&" + 时间
- (void)sendWhereFromWish
{
    NSString *str;
    NSDate *temp = _infoDic[@"createdAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:temp];
    
    
    str = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@", _infoDic[@"context"],_infoDic[@"image"],_infoDic[@"like"],_infoDic[@"comment"],_infoDic[@"objectId"],strDate];
    
    NSLog(@"str = %@",str);
    [self sendMessageWithContent:str type:5 timeStr:0];

}


-(void)createNaBar{
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    
    self.view.userInteractionEnabled = YES;
    
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = _chatUser.nick;
    tit.textAlignment = YES;
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.textColor = [UIColor whiteColor];
    [bar addSubview:tit];
    
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    but.tag = 10;
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:but];
    
    UIButton * but1 = [[UIButton alloc] initWithFrame:CGRectMake(Main_screen_width - 44, 0, 44,44)];
    but1.tag = 11;
    [but1 setImage:[UIImage imageNamed:@"mingpian"] forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(goUserDetail) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:but1];
}

-(void)goBack{
    [recordAudio stopPlay];
    [self.navigationController popViewControllerAnimated:YES];
    [self cleanData];
    [self cleanVoiceData];
}

- (void)cleanVoiceData{
    //1.删除转码的amr文件
    NSString *extensionAmr = @"amr";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [self cleanDataWithextension:extensionAmr path:documentsDirectory];
    //2.删除录音文件caf
    NSString *extensionCaf = @"caf";
    NSString *tmpDirecttory = NSTemporaryDirectory();
    [self cleanDataWithextension:extensionCaf path:tmpDirecttory];
    //3.删除图片
    NSString *extensionJpg = @"jpg";
    [self cleanDataWithextension:extensionJpg path:documentsDirectory];
    
}
/**
 *  删除sandbox中的文件
 *
 *  @param extension 后缀
 *  @param path      文件地址
 */
- (void)cleanDataWithextension:(NSString *)extension path:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];

        }
    }
}

- (void)cleanData
{
//    [headRefresh removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:_chatUser.objectId];
    NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:center];
    
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidRecieveUserMessage" object:nil];
    
    _chatArray                = nil;
    _chatUser                 = nil;
    _chatTableView.dataSource = nil;
    _chatTableView.delegate   = nil;
}

- (void)goUserDetail
{
    friendInfoViewController *info = [[friendInfoViewController alloc]init];
    info.furcation = 3;
    info.userId = _chatUser.objectId;
    info.userName = _chatUser.nick;
    [self.navigationController pushViewController:info animated:YES];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"消失");
    [super viewDidDisappear:animated];
    
}

-(void)createTable{
    
    _chatTableView = [[UITableView alloc]init];
    
    _chatTableView.frame = CGRectMake(0, 64, Main_screen_width, Main_screen_height - 64 - tempHeight);
    _chatTableView.showsVerticalScrollIndicator = NO;
    _chatTableView.dataSource     = self;
    _chatTableView.delegate       = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _chatTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    _chatTableView.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    _chatTableView.backgroundView = nil;
    _chatTableView.allowsSelection = NO;
    _chatTableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    //    _chatTableView.bounces = NO;
    //添加点击手势
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTouch:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    
    [_chatTableView addGestureRecognizer:singleTapGestureRecognizer];
    [self.view addSubview:_chatTableView];
    
    //键盘frame变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //接收消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:@"DidRecieveUserMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textchange) name:UITextViewTextDidEndEditingNotification object:nil];
    _chatArray  = [[NSMutableArray alloc] init];
    _page       = 0;
    _totalCount = 0;
    _isFished   = NO;
    [self performSelector:@selector(searchMessages) withObject:nil afterDelay:0.3f];
    
}

- (void)textchange
{
    NSLog(@"改变 ");
}

- (void)dealloc
{
    [headRefresh removeFromSuperview];

}

- (void)viewDidTouch
{
    [_textView resignFirstResponder];
    
//    NSLog(@"%@", NSStringFromCGRect(_textViewBack.frame));
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _textViewBack.frame;
        
        //229:是表情列表弹出后，加上四行textview的高度，后的y
        if (frame.origin.y >= 229) {
            frame.origin.y = Main_screen_height - BJHeight;
            _textViewBack.frame = frame;
        }
        
        frame = _emojiView.frame;
        frame.origin.y = Main_screen_height;
        _emojiView.frame = frame;
        
        frame = _footbarView.frame;
        frame.origin.y = Main_screen_height;
        _footbarView.frame = frame;
        
        //tableview
//        frame = _chatTableView.frame;
        frame = CGRectMake(0, 64 - (BJHeight - tempHeight), Main_screen_width, Main_screen_height - 64 - 50);
        _chatTableView.frame = frame;
    }];

}

- (void)viewTouch:(UITapGestureRecognizer *)tap
{
    [self viewDidTouch];
}


-(void)searchMessages{
    
    NSString *targetId = _chatUser.objectId;
    NSArray *array = [[BmobDB currentDatabase] queryMessagesWithUid:targetId page:0];
    int num = [[BmobDB currentDatabase] queryChatTotalCountWithUid:targetId];
    NSLog(@"array.count = %d, 共%d", array.count, num);
    if (array && [array count] > 0) {
        [_chatArray setArray:array];
        [_chatTableView reloadData];
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    //总数
    _totalCount = [[BmobDB currentDatabase] queryChatTotalCountWithUid:targetId];
}



//收到信息
-(void)didReceiveNewMessage:(NSNotification *)noti{
    NSDictionary *userInfo = [noti object];
    
    if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@"readed"]) {
        
        for (BmobMsg *message in _chatArray) {
            if ([message.conversationId isEqualToString:[userInfo objectForKey:@"mId"]]) {
                message.isReaded = 1;
            }
        }
        
        NSLog(@"这是已读信息");
    }else if([[userInfo objectForKey:PUSH_KEY_MSGTYPE] integerValue] == 5 ){
        BmobMsg *msg             = [[BmobMsg alloc] init];
        msg.content              = [userInfo objectForKey:PUSH_KEY_CONTENT];
        msg.isReaded             = STATE_UNREAD;
        NSString *conversationId = [NSString stringWithFormat:@"%@&%@",msg.belongId,[BmobUser getCurrentUser].objectId];
        msg.conversationId       = conversationId;
        msg.msgTime              = [userInfo objectForKey:PUSH_KEY_MSGTIME];
        if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
            msg.msgType = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
        }
        
        msg.status = STATUS_RECEIVER_SUCCESS;
        
        [_chatArray addObject:msg];
        [_chatTableView reloadData];
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
    }else if ([[[userInfo objectForKey:PUSH_KEY_TARGETID] description] isEqualToString:_chatUser.objectId] && [[[userInfo objectForKey:PUSH_KEY_TOID] description] isEqualToString:[BmobUser getCurrentUser].objectId]) {
        
        BmobMsg *msg             = [[BmobMsg alloc] init];
        msg.belongAvatar         = [[_infoDic objectForKey:@"avatar"] description];
        msg.belongId             = [[userInfo objectForKey:PUSH_KEY_TARGETID] description];
        msg.belongNick           = [[userInfo objectForKey:PUSH_KEY_TARGETNICK] description];
        msg.belongUsername       = [[userInfo objectForKey:PUSH_KEY_TARGETUSERNAME] description];
        msg.content              = [userInfo objectForKey:PUSH_KEY_CONTENT];
        msg.isReaded             = STATE_UNREAD;
        NSString *conversationId = [NSString stringWithFormat:@"%@&%@",msg.belongId,[BmobUser getCurrentUser].objectId];
        msg.conversationId       = conversationId;
        msg.msgTime              = [userInfo objectForKey:PUSH_KEY_MSGTIME];
        if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
            msg.msgType = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
        }
        msg.status = STATUS_RECEIVER_SUCCESS;
       
        [_chatArray addObject:msg];
        [_chatTableView reloadData];
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}

/**
 发送信息前，判断一下。是否要发送，从哪发起聊天的。
 */
-(void)updateTableViewBySendMessageContent {
    
    if (self.where == 0 &&_chatArray.count == 0) {
        [self sendWhereFromWish];
        
    }else{
        
        NSArray *array = [[BmobDB currentDatabase] queryMessagesWithUid:_chatUser.objectId page:0];
        if (self.where == 0 ) {
            int count = array.count;
            for (int i = (count - 1); i  >= 0; i -- ) {
                BmobMsg *message = array[i];
                if (message.msgType == 5) {
                    NSDate *now = [NSDate date];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[message.msgTime integerValue]];
                    double deltaSeconds = fabs([date timeIntervalSinceDate:now]);
                    NSLog(@"type5 second = %f", deltaSeconds);
                    double deltaHours = deltaSeconds / 3600.0f;
                    if (deltaHours >= 5) {
                        [self sendWhereFromWish];
                    }
                    break;
                }
            }
            
        }
        
        
    }
    
   
}

//hahahahahhaahhahhahaahhaahh
//发送消息(文本/位置)
//类型mt是5， mc 为  愿望text ＋ "&" + 愿望url ＋ "&" + 愿望评论数 ＋ "&" + 愿望点赞数 ＋ “&” ＋ 愿望objectId
-(void)sendMessageWithContent:(NSString *)content type:(NSInteger)type timeStr:(CGFloat)timeStr{
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:[NSString stringWithFormat:@"%@frist",_chatUser.objectId]];
    BmobMsg * msg = [BmobMsg createAMessageWithType:type statue:STATUS_SEND_SUCCESS content:content targetId:_chatUser.objectId];
    msg.status = 0;
    msg.isReaded = 0;
    [_chatArray addObject:msg];
    
    [_chatTableView reloadData];
    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    msg.status = STATUS_SEND_SUCCESS;
    msg.chatId = _chatUser.objectId;
    
    if (type == MessageTypeText || type == 5) {
        [[BmobChatManager currentInstance] sendMessageWithUser:_chatUser
                                                       message:msg
                                                         block:^(BOOL isSuccessful, NSError *error) {
                                                             if(error)
                                                                 NSLog(@"%@", error);
                                                         }];
    }else if (type == MessageTypeImage){
        [[BmobChatManager currentInstance] sendImageMessageWithImagePath:content
                                                                    user:_chatUser
                                                                   block:^(BOOL isSuccessful, NSError *error) {
                                                                   }];
    }else if (type == MessageTypeVoice){
        [[BmobChatManager currentInstance] sendVoiceMessageWithVoicePath:content time:endRecordTime user:_chatUser block:^(BOOL isSuccessful, NSError *error) {}];
    }
    
    
}



-(void)loadNext{
    
    //总数
    _totalCount = [[BmobDB currentDatabase] queryChatTotalCountWithUid:_chatUser.objectId];
    
    if ([_chatArray count] > _totalCount) {
        return;
    }
    if (_isFished == YES) {
        return;
    }
    _isFished = YES;
    NSString *targetId = _chatUser.objectId;
    NSArray *array = [[BmobDB currentDatabase] queryMessagesWithUid:targetId page:_page + 1];
    if (array && [array count] > 0) {
        [_chatArray setArray:array];
        
        [_chatTableView reloadData];
        if ([_chatArray count] < _totalCount) {
            _isFished = NO;
            _page ++;
        }else{
            _isFished = YES;
        }
    }
    
}
/**
 时间比较
 */
- (NSString *)timeAgoWithDate:(NSDate *)date lastDate:(NSDate *)lastDate
{
    //现在的时间
    NSDate *now = [NSDate date];
    //格式化
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"dd"];//天
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM"];//月
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yy"];//年
    
    //当前时间的年月日
    int ddNow = [[dateFormatter1 stringFromDate:now] integerValue];
    int mmNow = [[dateFormatter2 stringFromDate:now] integerValue];
    int yyNow = [[dateFormatter3 stringFromDate:now] integerValue];
    //当前信息的年月日
    int ddMsg = [[dateFormatter1 stringFromDate:date] integerValue];
    int mmMsg = [[dateFormatter2 stringFromDate:date] integerValue];
    int yyMsg = [[dateFormatter3 stringFromDate:date] integerValue];
    
    //当前信息时间
    double deltaSeconds = fabs([date timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    //上一条的信息时间
    double lastDeltaSeconds = fabs([lastDate timeIntervalSinceDate:now]);
    double lastDeltaMinutes = lastDeltaSeconds / 60.0f;
    //两条时间比较
    double timeCom = lastDeltaMinutes - deltaMinutes;
    
    NSString *timeStr ;
    NSString *temp;
    
    //如果这条时间与上一条的时间相差不到 10 分钟，就不显示
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    timeStr = [dateFormatter stringFromDate:date];
    
    if (yyMsg == yyNow){
        if (mmMsg == mmNow) {
            if (ddMsg == ddNow) {
                [dateFormatter setDateFormat:@"HH:mm"];
                temp = [dateFormatter stringFromDate:date];
                timeStr = [NSString stringWithFormat:@"今天 %@",temp];
            }else if ((ddNow - ddMsg) == 1)
            {
                [dateFormatter setDateFormat:@"HH:mm"];
                temp = [dateFormatter stringFromDate:date];
                timeStr = [NSString stringWithFormat:@"昨天 %@",temp];
            }
        }
    }
    
    if (lastDate) {
        if (timeCom < 10) {
            timeStr = nil;
        }
    }
    
    return timeStr;
    
}

//
- (void)textCellRegex:(NSString *)string
{
    NSError *error;
//    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSString *regulaStr = @"http+:[^\\s]*";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        NSLog(@"substringForMatch = %@",substringForMatch);
    }
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BmobMsg *message = (BmobMsg *)[_chatArray objectAtIndex:indexPath.row];
    
    //正常交流信息
    ChatTableViewCell * cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ce"];
    
    cell.delegete = self;
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ce" owner:self options:nil] lastObject];
    }
//    cell.dict = _infoDic;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[message.msgTime integerValue]];
    NSString *timeStr;
    if (indexPath.row == 0) {
        timeStr = [self timeAgoWithDate:date lastDate:nil];
    }else{
        BmobMsg *message2 = (BmobMsg *)[_chatArray objectAtIndex:(indexPath.row - 1)];
        //yyMMdd hhmmss
        
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[message2.msgTime integerValue]];
        timeStr = [self timeAgoWithDate:date lastDate:date2];
    }
    
    if (timeStr) {
        cell.timeLabel.text = timeStr;
    }
    
    [_timeArray addObject:timeStr];
    
    if (message.msgType == 5) {
        //解析
        NSArray *stringArray = [message.content componentsSeparatedByString:@"&"];
        [_sendWishDict setObject:[stringArray objectAtIndex:0] forKey:@"context"];
        [_sendWishDict setObject:[stringArray objectAtIndex:1] forKey:@"image"];
        [_sendWishDict setObject:[stringArray objectAtIndex:2] forKey:@"like"];
        [_sendWishDict setObject:[stringArray objectAtIndex:3] forKey:@"comment"];
        [_sendWishDict setObject:[stringArray objectAtIndex:4] forKey:@"objectId"];
        [_sendWishDict setObject:[stringArray objectAtIndex:5] forKey:@"createdAt"];
        
        cell.dict = _sendWishDict;
    }
    
    
    BOOL fromSelf =NO;
    NSArray *nameArray = [message.conversationId componentsSeparatedByString:@"&"];
    
    if ([[nameArray firstObject] isEqualToString:[BmobUser getCurrentUser].objectId]) {
        fromSelf = YES;
    }else{
        fromSelf = NO;
    }
    
    cell.type = message.msgType;
    cell.fromSelf = fromSelf;
    //自己发送的
    NSString *avatarStr;
    if (fromSelf ) {
        avatarStr = [[BmobUser getCurrentUser] objectForKey:@"avatar"];
        cell.dict = _sendWishDict;
        
        cell.bubbleView.image = [UIImage resizableImage:@"qipaoyou"];
        if (message.msgType == 5) {
            cell.textHead = @"你通过对方的愿望发起私聊";
            
        }
       
    }else{
        avatarStr = [[_infoDic objectForKey:@"avatar"] description];
        
        cell.dict = _sendWishDict;
        cell.bubbleView.image = [UIImage resizableImage:@"qipaozuo"];
        if (message.msgType == 5) {
            cell.textHead = @"对方通过你的愿望发起私聊";
        }
    }
    
    cell.iconUrl = avatarStr;

    if (message.msgType == 5) {
    }else if (message.msgType == 6) {
        
    }else if (message.msgType == MessageTypeText) {
        cell.contentImageView.image = nil;
        cell.contentLabel.text = [message.content smileTrans];
        [self textCellRegex:message.content];
    }else if(message.msgType == MessageTypeImage){
        cell.contentLabel.text = nil;
        cell.imageUrl = message.content;
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:message.content] placeholderImage:[UIImage imageWithContentsOfFile:message.content]];
    }else if (message.msgType == MessageTypeLocation){
        //        NSArray *stringArray = [message.content componentsSeparatedByString:@"&"];
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:message.content] placeholderImage:[UIImage imageNamed:@"location_default"]];
        cell.contentLabel.text = @"";
        
    }else if (message.msgType == MessageTypeVoice){
        NSLog(@"MessageTypeVoice = %@", message.content);
        cell.voiceUrl = message.content;
//        cell.voiceUrl = [souceDownload souceDownload:message.content];
    }
    return cell;
    
}

- (void)wishCellOnClick:(NSString *)objectId
{
    DetailWishViewController *detail = [[DetailWishViewController alloc]init];
    detail.objectId = objectId;
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat heightForCell = 0;
    BmobMsg  *dic       =(BmobMsg*) [_chatArray objectAtIndex:indexPath.row];
    
    NSString *timeStr;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dic.msgTime integerValue]];
    if (indexPath.row == 0) {
        timeStr = [self timeAgoWithDate:date lastDate:nil];
    }else{
        BmobMsg *message2 = (BmobMsg *)[_chatArray objectAtIndex:(indexPath.row - 1)];
        //yyMMdd hhmmss
        
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[message2.msgTime integerValue]];
        timeStr = [self timeAgoWithDate:date lastDate:date2];
    }
    CGFloat padding = 0;
    if (timeStr) {
        padding = 23 + 22;
    }else{
        padding = 23;
    }
    if (dic.msgType == 6) {
        heightForCell = 58;
    }else if (dic.msgType == 5) {
        heightForCell = 110 + padding;
    }else if (dic.msgType == MessageTypeText) {
        
        NSString *text = dic.content;
        NSString *tempStr =  [text sizeOfSmile1];
        CGSize contentSize  = [tempStr sizeWithFont:[self setFontSize:15] maxSize:CGSizeMake(135, MAXFLOAT)];
        
        heightForCell = contentSize.height + 34 + padding;
        
    }else if (dic.msgType == MessageTypeImage){
        heightForCell =  126 + padding;
    }else if (dic.msgType == MessageTypeLocation){
        heightForCell =  126 + padding;
    }else if (dic.msgType == 4){
        
        heightForCell = 52 + padding;
    }
    
    return heightForCell;
    //    return 145;
}

-(UIFont*)setFontSize:(CGFloat)size{
    
    return [UIFont systemFontOfSize:size];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_textView resignFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _location = textView.selectedRange.location;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_chatArray count];
}

-(void)keyboardFrameChange:(NSNotification *)note{
    // 设置窗口的颜色
    self.view.window.backgroundColor = _chatTableView.backgroundColor;

    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    textY = keyboardFrame.origin.y;

    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardY = [self.view convertRect:keyboardFrame fromView:nil].origin.y;
        CGRect inputViewFrame = _textViewBack.frame;
        CGRect tableviewFrame = _chatTableView.frame;
        CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
        CGFloat tableviewFrameY = keyboardFrame.size.height;
        keyboardHeight = tableviewFrameY;
        CGFloat messageViewFrameBottom = self.view.frame.size.height - tempHeight;
        if(inputViewFrameY > messageViewFrameBottom)
            inputViewFrameY = messageViewFrameBottom;
        
        _textViewBack.frame = CGRectMake(inputViewFrame.origin.x,
                                         inputViewFrameY,
                                         inputViewFrame.size.width,
                                         inputViewFrame.size.height);
        
        if ((_chatTableView.contentSize.height + 64) > inputViewFrameY) {
             _chatTableView.frame = CGRectMake(tableviewFrame.origin.x, 64 - tableviewFrameY , tableviewFrame.size.width, tableviewFrame.size.height);
        }
 
    }];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //退出键盘
    [self.view endEditing:YES];
    [self viewDidTouch];
}

-(void)createTextView{
    
    _textViewBack = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-49, 320, 49)];
    _textViewBack.userInteractionEnabled = YES;
    _textViewBack.backgroundColor = [UIColor whiteColor];
    
    _textView.scrollEnabled = NO;
//    _textView
    //设置
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake( 47, 9.5, 397 * 0.5, 30);
//    _textView.returnKeyType    = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.contentInset = UIEdgeInsetsMake(0, 2, 0, 0);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    //获得焦点
    _textView.delegate = self;
    _textView.bounces = NO;
    [_textViewBack addSubview:_textView];
    [self.view addSubview:_textViewBack];
    
    //发送
    sendBut = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 50, 50)];
    [sendBut setTitleColor:[UIcol hexStringToColor:@"#e6e6e6"] forState:UIControlStateNormal];
    [sendBut setImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
    [sendBut setImage:[UIImage imageNamed:@"fasongselect"] forState:UIControlStateHighlighted];
    [sendBut addTarget:self action:@selector(sendon) forControlEvents:UIControlEventTouchUpInside];
    sendBut.hidden = YES;
    [_textViewBack addSubview:sendBut];
    
    voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 10, 45, 30)];
    [voiceBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"yuyinselect"] forState:UIControlStateHighlighted];
    [voiceBtn addTarget:self action:@selector(voiceClick:) forControlEvents:UIControlEventTouchDown];
    [_textViewBack addSubview:voiceBtn];
    
    
    //表情
    emojiButton              = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiButton.tag          = 100;//229 + 45
    [emojiButton setFrame:CGRectMake(250, 29 * 0.5, 20, 20)];
    [emojiButton addTarget:self action:@selector(showBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [emojiButton setImage:[UIImage imageNamed:@"xuanzebiaoqing"] forState:UIControlStateNormal];
    [emojiButton setImage:[UIImage imageNamed:@"xuanzebiaoqingSelect"] forState:UIControlStateHighlighted];
    [_textViewBack addSubview:emojiButton];
    
    //输入框
    textViewXian = [[UIView alloc]initWithFrame:CGRectMake(45, 36, 229, 5)];
    textViewXian.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xian"]];
    [_textViewBack addSubview:textViewXian];
    
    //表情视图
    _emojiView                            = [[smileView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 174)];
    _emojiView.userInteractionEnabled     = YES;
    _emojiView.delegate                   = self;
    [self.view addSubview:_emojiView];
    
    
    //添加
    addButton                = [[UIButton alloc]init];
    addButton.tag                         = 101;
    addButton.frame = CGRectMake(2.5, 9 * 0.5, 40, 40);
    [addButton addTarget:self action:@selector(showBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"tianjiaselect"] forState:UIControlStateHighlighted];
    [_textViewBack addSubview:addButton];
    
    //选项
    _footbarView                          = [[ChatFootbarView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height, 320, 100)];
    _footbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footbarView];
    [_footbarView.libButton addTarget:self action:@selector(photoLib) forControlEvents:UIControlEventTouchUpInside];
    _footbarView.libLabel.text            = @"相册";
    [_footbarView.takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    _footbarView.takeLabel.text           = @"照相";
    
    
    UIImageView *inputBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 8, 170, 30)];
    inputBackgroundImageView.image        = [UIImage imageNamed:@"chat_input"];
    [_textViewBack addSubview:inputBackgroundImageView];
    //********************************************************************************
    
    //语音长按扭229 25 anzhushuohua
    voicelongBtn = [[voiceLongBtn alloc]initWithFrame:CGRectMake(45, (49 - 25) * 0.5, 229, 25)];
    [voicelongBtn setImage:[UIImage imageNamed:@"anzhushuohua"] forState:UIControlStateNormal];
    [voicelongBtn setImage:[UIImage imageNamed:@"anzhushuohuaselect"] forState:UIControlStateHighlighted];
    voicelongBtn.delegate = self;
    
    [_textViewBack addSubview:voicelongBtn];
    if (!isVoice) {
        voicelongBtn.hidden = YES;
    }else{
        voicelongBtn.hidden = NO;
    }

}

- (void)btnTouchBegin
{
    [self startRecord];
    [voicelongBtn setImage:[UIImage imageNamed:@"anzhushuohuaselect"] forState:UIControlStateNormal];
}


- (void)btnTouchEnd:(float)fl
{
    if (fl > 10) {
        [self removeCovers];
        [timer invalidate];
        endRecordTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSURL *url = [recordAudio stopRecord];
        endtime = (int) endRecordTime;
        
        if (url != nil) {
            curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
            
        }
        [voicelongBtn setImage:[UIImage imageNamed:@"anzhushuohua"] forState:UIControlStateNormal];
       
    }else{
        [self stopRecord];
        [voicelongBtn setImage:[UIImage imageNamed:@"anzhushuohua"] forState:UIControlStateNormal];
    }
}

- (void)btnTouchMove:(float)fl
{
    if (fl > 10) {
        lable.text = @"松开取消发送";
        lable.textColor = [UIColor whiteColor];
        middleImageView.hidden = YES;
        lajitongView.hidden = NO;
        
    }else{
        middleImageView.hidden = NO;
        lajitongView.hidden = YES;
        lable.text = @"上滑取消发送";//126, 16.702}
        lable.textColor = [UIColor whiteColor];
    }
    
    [voicelongBtn setImage:[UIImage imageNamed:@"anzhushuohuaselect"] forState:UIControlStateNormal];

}
#pragma mark footbar
//相册
-(void)photoLib{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}
//拍照
-(void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing            = YES;
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}

-(void)presentImagePickerController:(UIImagePickerController *)picker{
    [self.navigationController presentViewController:picker animated:YES completion:^{
        //        [self hideBottomView];
    }];
}

-(void)showBottomView:(UIButton*)sender{
    [_textView resignFirstResponder];
    if (sender.tag == 100) {//表情
        _footbarView.hidden = YES;
        _emojiView.hidden = NO;
        _textViewBack.frame = CGRectMake(0,self.view.bounds.size.height - 174 - BJHeight, 320, BJHeight);
        _chatTableView.frame = CGRectMake(0, 64 - 174 - (BJHeight - 49), Main_screen_width, Main_screen_height - 64 - 49);
        _emojiView.frame = CGRectMake(0, self.view.bounds.size.height-174, 320, 174);
        
    }else if(sender.tag == 101){//图片
        _footbarView.hidden = NO;
        _emojiView.hidden = YES;
        _textViewBack.frame = CGRectMake(0,self.view.bounds.size.height - 100 - BJHeight, 320, BJHeight);
        _chatTableView.frame = CGRectMake(0, 64 - 100 - (BJHeight - 49), Main_screen_width, Main_screen_height - 64 - 49);
        _footbarView.frame = CGRectMake(0,self.view.bounds.size.height-100,320, 100);
        
    }
}

- (void)voiceClick:(UIButton *)btn
{
    if (isVoice) {
        isVoice = NO;
        [btn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yuyinselect"] forState:UIControlStateHighlighted];
        voicelongBtn.hidden = YES;
        emojiButton.hidden = NO;
        _textView.hidden = NO;
        textViewXian.hidden = NO;

        
    }else{
        isVoice = YES;
        [_textView resignFirstResponder];
        [btn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jianpanselect"] forState:UIControlStateHighlighted];
        _chatTableView.frame = CGRectMake(0, 64, Main_screen_width, Main_screen_height - 64 - 49);
        _textViewBack.frame = CGRectMake(0,self.view.bounds.size.height-49, 320, 49);
        voicelongBtn.hidden = NO;
        emojiButton.hidden = YES;
        _textView.hidden = YES;
        textViewXian.hidden = YES;
    }
    
}


#pragma mark 各种 delegate
- (void)deleteSmile
{
    CGFloat smileLen = 6;
    NSString *smileHead = @"\\u";
    NSString *str = [_textView.text emoteStringWithDict:self.SmileDict];
    
    NSLog(@"smileHead = %@, %@", smileHead,str);

    NSInteger length = str.length;
    NSLog(@"textView.text = %@,长度 %d", str, length);
    if (length) {
        NSString *temp = nil;
        if ( length >= smileLen) {
            
            temp = [str substringFromIndex:length - smileLen];
            NSRange range = [temp rangeOfString:smileHead];
            if (range.location == 0) {
                str = [str substringToIndex:
                       [str rangeOfString:smileHead
                                          options:NSBackwardsSearch].location];
            }else{
                str = [str substringToIndex:length - 1];
            }
            str = [str emoteStringToHanzi];
            _textView.text = str;
        }
    }
}

//表情包代理方法
- (void)didSelectSmileView:(smileView *)view emojiText:(NSString *)text
{
    [self _textViewChangeWhere:2];
    [self.view endEditing:YES];
    
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:_textView.text];
    [String1 insertString:text atIndex:_location];
    [_textView setText:String1];
    
    [_textView setTextColor:[UIColor blackColor]];
    
}


//图片点击代理
- (void)pictureOnClick:(NSString *)pictureUrl
{
    NSLog(@"t图片点击");
    bigImage *imageCover = [[bigImage alloc]initWithUrl:pictureUrl];
    [self.view addSubview:imageCover];
}

/**1.键盘 2.表情*/
- (void)_textViewChangeWhere:(int)where
{
    voiceBtn.hidden = YES;
    sendBut.hidden = NO;
//    NSLog(@"contentOffset = %@", NSStringFromCGPoint(_textView.contentOffset));
    //一行，17.895000
    //四行，71.580002
    CGRect frame =  _textView.frame;
    CGRect BJframe =  _textViewBack.frame;
    
    CGSize size = [_textView.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(190, MAXFLOAT)];

    if (size.height >= 54) {
        CGPoint offset;
        offset.y = size.height - 54;
        _textView.contentOffset = offset;
        size.height = 54;
    }else if (size.height <= 18) {
        size.height = 30;
    }
    
    
    
    if (size.height  != (_textView.frame.size.height)) {
        BJframe.size.height = 49 + (size.height - 30) + 10;
        
        if (where == 1) {//键盘
            BJframe.origin.y = (textY - 49) - (size.height - 30) - 10;
        }else if (where == 2){
            BJframe.origin.y = (Main_screen_height - 174 - 49) - (size.height - 30) - 10;
        }
        
        
        //textView
        frame.size.height = size.height + 10;
        
        //按钮
        CGFloat centerY = BJframe.size.height / 2;
        
        CGPoint center = sendBut.center;
        center.y = centerY;
        sendBut.center = center;
        
        center = voiceBtn.center;
        center.y = centerY;
        voiceBtn.center = center;
        
        center = addButton.center;
        center.y = centerY;
        addButton.center = center;
        
        center = emojiButton.center;
        center.y = centerY;
        emojiButton.center = center;
        
        CGRect temp = textViewXian.frame;
        temp.origin.y = BJframe.size.height - 13;
        textViewXian.frame = temp;
        
    }
    
    BJHeight = _textViewBack.frame.size.height;
    _textView.frame = frame;
    _textViewBack.frame = BJframe;
}


- (void)textViewDidChange:(UITextView *)textView
{
   
    [self _textViewChangeWhere:1];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _textViewBack.frame = CGRectMake(0,self.view.bounds.size.height - 50 , 320, 50);
    _emojiView.frame = CGRectMake(0, self.view.bounds.size.height, 320, 174);
    _footbarView.frame = CGRectMake(0, self.view.bounds.size.height, 320, 100);
    
}

-(void)sendon{
    
    
    if(![_textView.text isEqualToString:@""]){
        //笑脸转义
        
        NSLog(@"text.length = %d", _textView.text.length);
        
        if (_textView.text.length < 60) {
            
            sendBut.hidden = YES;
            voiceBtn.hidden = NO;
            
            NSString *str = [self messageTransform:_textView.text];
            [self updateTableViewBySendMessageContent];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendMessageWithContent:str  type:MessageTypeText timeStr:0];
            });
            
            [_chatTableView reloadData];
            _textView.text = @"";
            
            CGRect frame =  _textViewBack.frame;
            frame.origin.y = frame.origin.y + (frame.size.height - 49);
            frame.size.height = 49;
            BJHeight = 49;
            _textViewBack.frame = frame;
            
            frame = _textView.frame;
            frame.size.height = 30;
            _textView.frame = frame;
            
            frame = emojiButton.frame;
            frame.origin.y = 29 * 0.5;
            emojiButton.frame = frame;
            
            frame = addButton.frame;
            frame.origin.y = 9 * 0.5;
            addButton.frame = frame;
            
            frame = voiceBtn.frame;
            frame.origin.y = 10;
            voiceBtn.frame = frame;
            
            frame = sendBut.frame;
            frame.origin.y = 0;
            sendBut.frame = frame;
            
            frame = textViewXian.frame;
            frame.origin.y = 36;
            textViewXian.frame = frame;
        }else {
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:nil message:@"字数不要超过60字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
        }
    }
    
}

- (NSString *)messageTransform:(NSString *)text
{

    NSString *str = [text emoteStringWithDict:self.SmileDict];
    return str;
}

#pragma mark imagePickerController delegate 图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"editImage.size = %@", NSStringFromCGSize(editImage.size));
    
    CGSize cg ;
    if (editImage.size.width > 640 || editImage.size.height > 640) {
        cg.width = 640;
        cg.height = 640;
    }else{
        cg = editImage.size;
    }
    cg = editImage.size;

    
    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(cg.width, cg.height)];
    NSString *currentTimeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] ];
    NSString *imagePath         = [NSString stringWithFormat:@"%@/%@.jpg",[self filepath],currentTimeString];
    
    if ([self saveImage:cutImage filepath:imagePath]) {
        //发送图片
        [self updateTableViewBySendMessageContent];sleep(0.5);
        [self sendMessageWithContent:imagePath type:MessageTypeImage timeStr:0];
    }
}

-(NSString *)filepath{
    NSArray  *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirecotry =[paths objectAtIndex:0];
    return documentDirecotry;
}

-(BOOL)saveImage:(UIImage*)image filepath:(NSString *)path{
    NSData *data = UIImageJPEGRepresentation(image, 0.9f);
    return  [data writeToFile:path atomically:YES ];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [originImage drawInRect:CGRectMake(0, 0, size.height, size.width)]; //newImageRect指定了图片绘制区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)iconOnClick:(BOOL)fromSelf
{
    friendInfoViewController *info = [[friendInfoViewController alloc]init];
    if (fromSelf) {
        
        BmobUser *bUser1 = [BmobUser getCurrentObject];
        info.furcation = 1;
        info.userId = bUser1.objectId;
        info.userName = [bUser1 objectForKey:@"nick"];
    }else
    {
        info.furcation = 3;
        info.userId = _chatUser.objectId;
        info.userName = _chatUser.nick;
        
    }
    [self.navigationController pushViewController:info animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//***************************************************************
- (void)recodeCover
{
    recodeCover = [[UIView alloc]initWithFrame:CGRectMake((Main_screen_width - 137) * 0.5, (Main_screen_height- 137) * 0.3, 137, 137)];
    recodeCover.alpha = 0.7;
    recodeCover.backgroundColor = [UIColor blackColor];
    recodeCover.layer.cornerRadius = 5;
    recodeCover.layer.masksToBounds = YES;
    [self.view addSubview:recodeCover];
    
    CGRect frame = recodeCover.frame;
    
    middleImageView = [[UIImageView alloc]init];
    middleImageView.frame = CGRectMake((Main_screen_width - 84) * 0.5, frame.origin.y + 15, 84, 79);
    [self.view addSubview:middleImageView];
    middleImageView.alpha = 1.0;
    middleImageView.hidden = NO;
    
    lajitongView = [[UIImageView alloc]init];
//    lajitongView.frame = CGRectMake((Main_screen_width - 137) * 0.5, frame.origin.y + 15, 137, 137);
    lajitongView.frame = middleImageView.frame;
    [self.view addSubview:lajitongView];
    lajitongView.image = [UIImage imageNamed:@"lajitong"];
    lajitongView.hidden = YES;
    
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.origin.y + frame.size.height - 17- 15, 130, 17)];
    lable.centerX = recodeCover.centerX;
    lable.text = @"上滑取消发送";//126, 16.702}
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    CGSize contentSize = [lable.text sizeWithFont:[self setFontSize:16] maxSize:CGSizeMake(135, MAXFLOAT)];
        
    NSLog(@"d收拾收拾%@", NSStringFromCGSize(contentSize));
    [self.view addSubview:lable];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
}

- (void)timeChange
{
    float lowMeter = [recordAudio getVoiceMeters];
    if (lowMeter == 0) {
        [middleImageView setImage:[UIImage imageNamed:@"yuyin0"]];
        
    }else if (0<lowMeter<0.2) {
        [middleImageView setImage:[UIImage imageNamed:@"yuyin1"]];
        
    }else if (0.2<=lowMeter<0.4){
        [middleImageView setImage:[UIImage imageNamed:@"yuyin2"]];

    }else if (0.4<=lowMeter<0.6){
        [middleImageView setImage:[UIImage imageNamed:@"yuyin3"]];

    }else if (0.6<=lowMeter<0.8){
        [middleImageView setImage:[UIImage imageNamed:@"yuyin4"]];

    }else if (0.8<=lowMeter<1.0){
        [middleImageView setImage:[UIImage imageNamed:@"yuyin5"]];

    }
}

- (void)removeCovers
{
    [middleImageView removeFromSuperview];
    [lajitongView removeFromSuperview];
    [lable removeFromSuperview];
    [recodeCover removeFromSuperview];
    middleImageView = nil;
    lajitongView = nil;
    lable = nil;
    recodeCover = nil;
}

//***************************************************************
static double startRecordTime=0;
static double endRecordTime=0;

-(void)showMsg:(NSString *)msg {
    //    self.msgLabel.text = msg;
    UIAlertView *alet = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alet show];
}

-(void) startRecord {
    [self recodeCover];
    
    [recordAudio stopPlay];
    [recordAudio startRecord];
    startRecordTime = [NSDate timeIntervalSinceReferenceDate];
    
    curAudio=nil;
}


-(void)stopRecord {
    
    [self removeCovers];
    [timer invalidate];
    endRecordTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSURL *url = [recordAudio stopRecord];
    endRecordTime -= startRecordTime;
    if (endRecordTime<1.00f) {
        [self showMsg:@"录音时间过短,应大于1秒"];
        return;
    } else if (endRecordTime>60.00f){
        [self showMsg:@"录音时间过长,应小于60秒"];
        return;
    }
    NSLog(@"endRecordTime = %f", endRecordTime);
    endtime = (int) endRecordTime;

    if (url != nil) {
        curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
        
    }
    
    [self updateTableViewBySendMessageContent];
    sleep(0.5);
    
    NSString *timeSaved = [voiceTime readVoiceTime];
    NSString *pathDir = [NSString stringWithFormat:@"%@/Caches/%@", NSHomeDirectory(), @"voiceDir"];
    NSString *voicePath = [pathDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", timeSaved]];
    NSLog(@"voicePath = %@",voicePath);
    //发送音频
    [self sendMessageWithContent:voicePath type:MessageTypeVoice timeStr:endRecordTime];
    
}


- (void)playVoice:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data ;
    if ([urlStr hasPrefix:@"http"]) {
        data = [NSData dataWithContentsOfURL:url];
    }else{
        data = [NSData dataWithContentsOfFile:urlStr];
    }
    NSLog(@"urlStr = %@, data = %@", urlStr, data);

    [recordAudio play:data];

}

-(void)RecordStatus:(int)status {
    if (status==0){
        //播放中
    } else if(status==1){
        //完成
        NSLog(@"播放完成");
    }else if(status==2){
        //出错
        NSLog(@"播放出错");
    }
}



@end
