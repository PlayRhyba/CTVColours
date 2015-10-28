//
//  CTVTeamViewerManager.m
//  Colours
//


#import "CTVTeamViewerManager.h"
#import <ScreenSharingSDK/ScreenSharingSDK.h>


static NSString * const kSDK_TOKEN = @"706ba98c-7ba8-54e1-e264-63117dd32366";
static NSString * const kCONFIGURATION_ID = @"95rcajp";


@interface CTVTeamViewerManager () <TVSessionDelegate, TVSessionCreationDelegate>

@property (nonatomic, strong) TVSession *session;
@property (nonatomic, readwrite) BOOL isSessionRunning;

@end


@implementation CTVTeamViewerManager


#pragma mark - Public Methods


+ (instancetype)sharedInstance {
    static CTVTeamViewerManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CTVTeamViewerManager alloc]init];
    });
    
    return _sharedInstance;
}


- (void)startSession {
    if (_isSessionRunning == NO) {
        self.isSessionRunning = YES;
        [TVSessionFactory createTVSessionWithToken:kSDK_TOKEN delegate:self];
    }
}


- (void)stopSession {
    [_session stop];
}


#pragma mark - TVSessionCreationDelegate


- (void)sessionCreationSuccess:(TVSession *)session {
    self.session = session;
    
    TVSessionConfiguration *sessionConfiguration = [TVSessionConfiguration tvSessionConfigurationWithBlock:^(TVSessionConfigurationBuilder *builder){
        builder.configurationId = kCONFIGURATION_ID;
        builder.serviceCaseName = @"Colours App Service Case";
        builder.serviceCaseDescription = @"Test Description.";
    }];
    
    [_session setSessionDelegate:self];
    [_session startWithConfiguration:sessionConfiguration];
}


- (void)sessionCreationFailed:(NSError *)error {
    self.session = nil;
    self.isSessionRunning = NO;
    
    if (_sessionFailureAction) {
        _sessionFailureAction(error);
    }
}


#pragma mark - TVSessionDelegate


- (void)sessionDidEnd {
    self.session = nil;
    self.isSessionRunning = NO;
    
    if  (_sessionEndAction) {
        _sessionEndAction();
    }
}


- (void)sessionDidFailWithError:(NSError*)error {
    if (_sessionFailureAction) {
        _sessionFailureAction(error);
    }
}

@end
