//
//  UIAlertController+Extended.h
//  Colours
//


#import <UIKit/UIKit.h>


@interface UIAlertController (Extended)

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
       viewController:(UIViewController *)viewController;
@end
