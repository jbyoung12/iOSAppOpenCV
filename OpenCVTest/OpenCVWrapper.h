//
//  OpenCVWrapper.h
//  OpenCVTest
//
//  Created by Joshua Young on 6/14/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject


- (void)isThisWorking;

- (UIImage *)processImage:(UIImage *)image;

- (void) initialize: (UIImage *) image;
@end

