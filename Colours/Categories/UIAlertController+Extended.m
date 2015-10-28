//
//  UIAlertController+Extended.m
//  Colours
//


#import "UIAlertController+Extended.h"


@implementation UIAlertController (Extended)


+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
       viewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:nil]];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
