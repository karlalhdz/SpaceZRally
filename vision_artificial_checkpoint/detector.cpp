#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <iostream>

using namespace cv;
using namespace std;

const int anchoVideo = 320;
const int altoVideo = 240;

int main(int, char**)
{
  VideoCapture cap(0);
  cap.set(CV_CAP_PROP_FRAME_WIDTH, anchoVideo);
  cap.set(CV_CAP_PROP_FRAME_HEIGHT, altoVideo);

  if(!cap.isOpened()) return -1;

  //Mat circ = imread("circulo1.png");
  Mat circ(altoVideo/2, anchoVideo/2, CV_8UC3);
  circle(circ, Point(anchoVideo/4, altoVideo/4), altoVideo/4,
         CV_RGB(255, 255, 0), -1);
  Mat frame;
  namedWindow("edges",1);

  Mat corr;
  Mat umbr;
  Point maxLoc;
  double maxVal;

  for(;;) {
    Mat m1;
    cap >> frame;
    //cvtColor(frame, umbr, CV_HLS2RGB);
//    inRange(frame, Scalar(165-30, 204-30, 213-30),
//                   Scalar(165+30, 204+30, 213+30), umbr);
//    umbr = 255 - umbr;
//    cvtColor(umbr, m1, CV_GRAY2RGB);
//    multiply(frame, m1/255, frame);

    matchTemplate(frame, circ, corr, CV_TM_CCORR);
    minMaxLoc(corr, NULL, &maxVal, NULL, &maxLoc);
    cout<<"maxVal = "<<maxVal<<"x="<<maxLoc.x<<", y="<<maxLoc.y<<endl;
    if (maxVal > 1e9) {
      line(frame, Point(maxLoc.x+anchoVideo/4, 0),
                  Point(maxLoc.x+anchoVideo/4, altoVideo-1),
                  CV_RGB(255, 0, 0));
      line(frame, Point(0, maxLoc.y+altoVideo/4),
                  Point(anchoVideo-1, maxLoc.y+altoVideo/4),
                  CV_RGB(255, 0, 0));
    }

    imshow("edges", frame);
    if(waitKey(30) >= 0) break;
  }
  return 0;
}
