//
//  CTVTeamViewerManager.h
//  Colours
//


#import <Foundation/Foundation.h>


typedef void (^CTVTeamViewerManagerSessionFailureBlock)(NSError *error);

@interface CTVTeamViewerManager : NSObject

@property (nonatomic, copy) CTVTeamViewerManagerSessionFailureBlock sessionFailureAction;
@property (nonatomic, copy) dispatch_block_t sessionEndAction;
@property (nonatomic, readonly) BOOL isSessionRunning;

+ (instancetype)sharedInstance;
- (void)startSession;
- (void)stopSession;

@end
