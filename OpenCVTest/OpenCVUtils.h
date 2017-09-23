//
//  OpenCVUtils.h
//  OpenCVTest
//
//  Created by Joshua Young on 6/19/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//

#ifndef OpenCVUtils_h
#define OpenCVUtils_h

#import <opencv2/opencv.hpp>

cv::Mat makeHistogram (cv::Mat& image);

bool compHist (cv::Mat& m);

cv::Mat makeRGBHist (cv::Mat& image);

cv::Mat makeGSHist (cv::Mat& image);


#endif /* OpenCVUtils_h */
