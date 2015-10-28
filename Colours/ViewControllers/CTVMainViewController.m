//
//  CTVMainViewController.m
//  Colours
//


#import "CTVMainViewController.h"
#import "UIColor+Random.h"
#import "CTVColorViewController.h"
#import "CTVTeamViewerManager.h"
#import "UIAlertController+Extended.h"


static NSString * const kIsSessionRunningKeyPath = @"isSessionRunning";


@interface CTVMainViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

- (void)configureButtons;
- (void)configureTeamViewerManager;
- (void)colorButtonClicked:(UIButton *)sender;
- (void)helpButtonClicked;
- (void)adjustButtonsState;
- (void)closeButtonClicked;

@end


@implementation CTVMainViewController


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"COLORS";
    
    [self configureButtons];
    [self configureTeamViewerManager];
    
    [self adjustButtonsState];
    
    [[CTVTeamViewerManager sharedInstance]addObserver:self
                                           forKeyPath:kIsSessionRunningKeyPath
                                              options:NSKeyValueObservingOptionNew
                                              context:NULL];
}


- (void)dealloc {
    [[CTVTeamViewerManager sharedInstance]removeObserver:self forKeyPath:kIsSessionRunningKeyPath];
}


#pragma mark - Internal Logic


- (void)configureButtons {
    for (UIButton *button in _buttons) {
        button.backgroundColor = [UIColor random];
        
        button.layer.cornerRadius = 5.0;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [button addTarget:self
                   action:@selector(colorButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)configureTeamViewerManager {
    CTVTeamViewerManager *tvManager = [CTVTeamViewerManager sharedInstance];
    
    __weak __typeof(self) weakSelf = self;
    
    tvManager.sessionFailureAction = ^(NSError *error) {
        [UIAlertController showWithTitle:@"Session Error"
                                 message:error.localizedDescription
                          viewController:weakSelf];
    };
    
    tvManager.sessionEndAction = ^{
        [UIAlertController showWithTitle:@"Session Closed"
                                 message:nil
                          viewController:weakSelf];
    };
}


- (void)colorButtonClicked:(UIButton *)sender {
    CTVColorViewController *colorVC = [[CTVColorViewController alloc]init];
    colorVC.color = sender.backgroundColor;
    [self.navigationController pushViewController:colorVC animated:YES];
}


- (void)helpButtonClicked {
    [[CTVTeamViewerManager sharedInstance]startSession];
}


- (void)closeButtonClicked {
    [[CTVTeamViewerManager sharedInstance]stopSession];
}


- (void)adjustButtonsState {
    if ([CTVTeamViewerManager sharedInstance].isSessionRunning) {
        self.navigationItem.rightBarButtonItem = nil;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(closeButtonClicked)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Help"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(helpButtonClicked)];
        self.navigationItem.leftBarButtonItem = nil;
    }
}


#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:kIsSessionRunningKeyPath]) {
        [self adjustButtonsState];
    }
}

@end
