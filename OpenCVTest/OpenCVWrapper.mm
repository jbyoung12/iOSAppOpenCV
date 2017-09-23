//
//  OpenCVWrapper.m
//  OpenCVTest
//
//  Created by Joshua Young on 6/14/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//
#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
using namespace std;
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#include <stdio.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVUtils.h"


@implementation OpenCVWrapper

cv::Mat histOrig;
cv::Mat gsHistOrig;
double lastFour[] = {1.0, 1.0, 1.0, 1.0};
int counter = 0;

- (void) isThisWorking {
    cout << "HEY" << endl;
}


- (UIImage *)processImage:(UIImage *)image
{
    // Do some OpenCV stuff with the image
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    //cv::Mat curHist = makeHistogram(mat);
    cv::Mat curHist = makeRGBHist(mat);
    cv::Mat gsCurHist = makeGSHist(mat);

   // cv::Mat gray;
    //cv::cvtColor(mat, gray, CV_RGB2GRAY);
    
   // cv::Mat bin;
    //cv::threshold(gray, bin, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
    
    if (compHist(curHist, gsCurHist)){
        
        
        putText(mat, "Match", cv::Point(mat.cols/2-30, mat.rows/2-30), cv::FONT_HERSHEY_PLAIN, 1.0, CV_RGB(0,255,0), 2.0);
    }
    
    UIImage *binImg = MatToUIImage(mat);
    
    
  //  UIImage *binImg = MatToUIImage(histOrig);

    return binImg;

}

- (void) initialize: (UIImage *)image{
        cv::Mat mat;
        UIImageToMat(image, mat);
        //   histOrig = s   .makeHistogram(mat);
        //histOrig = makeHistogram(mat);
    histOrig = makeRGBHist(mat);
    gsHistOrig = makeGSHist(mat);
    }

 cv::Mat makeHistogram (cv::Mat& image){
       // int smallHistSize[] = {30};
        //float range[] = {0, 256};
       // int nChannels[] = {0};
        //cv::Mat hist;
    
        cv::Mat hsv;
        cv::cvtColor(image, hsv, CV_RGB2HSV);
    
        int hbins = 30, sbins = 32;
        int histSize[] = {hbins, sbins};
        // hue varies from 0 to 179, see cvtColor
        float hranges[] = { 0, 180 };
        // saturation varies from 0 (black-gray-white) to
        // 255 (pure spectrum color)
        float sranges[] = { 0, 256 };
        const float* ranges[] = { hranges, sranges };
        cv::Mat hist;
        // we compute the histogram from the 0-th and 1-st channels
        int channels[] = {0, 1};
    
      //  cv::calcHist(image, 0, nChannels, cv::Mat(), hist, 1, smallHistSize, range, true, false);
    
        //no mask
        cv::calcHist( &hsv, 1, channels, cv::Mat(), hist, 2, histSize, ranges, true, false );
        
        return hist;
}
bool compHist (cv::Mat& curHist, cv::Mat& gsCurHist ){

    double result = cv::compareHist( histOrig, curHist, CV_COMP_BHATTACHARYYA);
    //double result2 = cv::compareHist( histOrig, curHist, CV_COMP_CORREL);
   // double result3 = cv::compareHist( histOrig, curHist, CV_COMP_INTERSECT);
    double result4 = cv::compareHist( histOrig, curHist, CV_COMP_CHISQR);
    //double result5 = cv::compareHist( histOrig, curHist, CV_COMP_KL_DIV);

    double gsResult = cv::compareHist( gsHistOrig, gsCurHist, CV_COMP_BHATTACHARYYA);
    double gsResult2 = cv::compareHist( gsHistOrig, gsCurHist, CV_COMP_CHISQR);

    
    printf( "BHAT:%f\tGSBHAT:%f\n", result, gsResult);
    if (result<.725 && gsResult <.32 )
        return true;
    return false;
   // lastFour[counter] = result;
 //   counter++;
//    if (counter ==4)
//        counter = 0;
//   // if (result<.725 && gsResult <.32 )
//    for (int i = 0; i< 4; i++)
//    {
//        if (lastFour[i] > .725 || gsResult >.32)
//            return false;
//    }
//    printf("true");
//    return true;
   // return false;
}

cv::Mat makeGSHist (cv::Mat& img){
    cv::Mat hist, gs;
    cv::cvtColor(img, gs, CV_RGB2GRAY);
    
    int gbins = 32;
    int histSize[] = {gbins};
    float gsranges[] = { 0, 256 };
    const float* ranges[] = { gsranges };
    // we compute the histogram from the 0-th and 1-st channels
    int channels[] = {0};
    cv::calcHist(&gs, 1, channels, cv::Mat(), hist, 1, histSize, ranges, true, false );
    return hist;
}
//BHAT:0.669026	CHI:14847868.059609	GSBHAT:0.280059	GSCHI:7786403.106282
//BHAT:0.721816	CHI:60430889.492235	GSBHAT:0.301884	GSCHI:7786902.694531


//BHAT:0.782218	CHI:12653119.972750	GSBHAT:0.322015	GSCHI:7668118.447398
//BHAT:0.790639	CHI:25929462.872227	GSBHAT:0.326968	GSCHI:11490509.669581

//#CROP OUT IMAGE WITH FINGER AND IDENTIFY IT
cv::Mat makeRGBHist (cv::Mat& img){
    cv::Mat hist, rgb;
    cv::cvtColor(img, rgb, CV_RGB2BGR);

    int rbins = 30, gbins = 32, bbins = 34;
    int histSize[] = {rbins, gbins, bbins};
    float rgbranges[] = { 0, 256 };
    const float* ranges[] = { rgbranges, rgbranges, rgbranges };
    // we compute the histogram from the 0-th and 1-st channels
    int channels[] = {0, 1, 2};

    cv::calcHist(&rgb, 1, channels, cv::Mat(), hist, 3, histSize, ranges, true, false );

    //cv::calcHist(&rgb, 2, {0,1,2}, cv::Mat(), hist, 3, {30, 31, 32}, {{0, 256}, {0, 256}, {0, 256}}, true, false );
// BHAT:0.344428	CORREL:0.820801	INTER:167852.000000	CHISQ:7939928.449110	KLDIV:39394279.160806//left
//    
//BHAT:0.604026	CORREL:0.424049	INTER:162674.000000	CHISQ:7840898.439847	KLDIV:74742912.741674//right
//
//BHAT:0.570303	CORREL:0.543883	INTER:152769.000000	CHISQ:8041040.322043	KLDIV:66094917.743007//good
//
//BHAT:0.666213	CORREL:0.354714	INTER:158499.000000	CHISQ:7782068.387960	KLDIV:93359206.149828//up
//    
//BHAT:0.587681	CORREL:0.447912	INTER:131099.000000	CHISQ:18110291.803812	KLDIV:55193633.168104//down
//    
//BHAT:0.670872	CORREL:0.494873	INTER:161200.000000	CHISQ:7767359.668673	KLDIV:126057691.965093 //sauter
//BHAT:0.522382	CORREL:0.416015	INTER:142115.000000	CHISQ:8693378.504506	KLDIV:44361751.535183
//BHAT:0.613000	CORREL:0.344660	INTER:126698.000000	CHISQ:14213988.679705	KLDIV:58591101.427919

    
    //BHAT:0.483630	CORREL:0.391286	INTER:154223.000000	CHISQ:10694653.389106	KLDIV:39633620.822760
    //BHAT:0.629157	CORREL:0.480031	INTER:139321.000000	CHISQ:8736074.040096	KLDIV:85118270.626931
    //BHAT:0.622401	CORREL:0.359145	INTER:139536.000000	CHISQ:8050862.168169	KLDIV:88629339.233838

    return hist;
}

@end
