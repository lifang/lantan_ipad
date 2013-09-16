//
//  PlateViewController.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-8-1.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PlateViewController.h"
#import "opencv2/opencv.hpp"
#import "OpenCVUtilities.h"
#import "PlateNumber.h"
#import "AppDelegate.h"

#define S(image,x,y) ((uchar*)(image->imageData + image->widthStep*(y)))[(x)]
#define  T 7
#define  T1 7
#define  N  3


static BOOL isContinue = YES;

@interface PlateViewController () {
    IplImage *pImgResize;
    IplImage *pImgCharOne;
    IplImage *pImgCharTwo;
    IplImage *pImgCharThree;
    IplImage *pImgCharFour;
    IplImage *pImgCharFive;
    IplImage *pImgCharSix;
    IplImage *pImgCharSeven;
    int col[20];
    int row_start;
    int row_end;
    int col_start;
    int col_end;
    int nCharWidth;
    int nCharHeight;
    int nSpace;
}

@end

@implementation PlateViewController
@synthesize delegate;
@synthesize imageView;
@synthesize pickerView,hud,strAlert,save;
@synthesize dataArray,plateArray,plateNumberArray,firstArray,plateString,imagee;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.save = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plate"]];
    self.imageView.image = self.imagee;
//    self.imageView.image = [UIImage imageNamed:@"1.jpg"];
//    self.imagee = self.imageView.image;
    
    tesseract = [[TesseractWrapper alloc] initEngineWithLanguage:@"chi_sim"];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"川",@"鄂",@"贵",@"甘",@"桂",@"赣",@"港",@"沪",@"黑",@"京",@"津",@"吉",@"晋",@"冀",@"鲁",@"辽",@"领",@"闽",@"蒙",@"宁",@"澳",@"青",@"琼",@"苏",@"陕",@"使",@"皖",@"湘",@"新",@"学",@"渝",@"云",@"粤",@"豫",@"浙",@"藏", nil];
    self.plateArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    self.plateNumberArray = [NSMutableArray arrayWithCapacity:7];
    [self.plateNumberArray addObject:array];
    for (int i=0; i<6; i++) {
        [self.plateNumberArray addObject:self.plateArray];
    }
    
    [self performSelector:@selector(shibie) withObject:nil afterDelay:1];
}

-(void)shibie {
    AppDelegate *appdele = [AppDelegate shareInstance];
    self.hud = [[MBProgressHUD alloc] initWithView:appdele.window];
    [self.hud showWhileExecuting:@selector(handleWithImage) onTarget:self withObject:nil animated:YES];
    self.hud.labelText = @"正在努力定位车牌...";
    [appdele.window addSubview:hud];
}
-(void)segment{
    int i;
	for(i=0;i<7;i++)
	{
		switch(i){
			case 0:
			case 1:
				col[i*2]=i*nCharWidth+i*nSpace;
				col[i*2+1]=(i+1)*nCharWidth+i*nSpace;
				break;
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
				col[i*2]=i*nCharWidth+i*nSpace+22;
				col[i*2+1]=(i+1)*nCharWidth+i*nSpace+22;
				break;
		}
	}
    
    pImgCharOne=NULL;
	pImgCharOne=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	CvRect ROI_rect1;
	ROI_rect1.x=col[0];
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharOne);
	cvResetImageROI(pImgResize);
    UIImage *imageOne = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharOne];
    cvReleaseImage(&pImgCharOne);
    
	pImgCharTwo=NULL;
	pImgCharTwo=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	ROI_rect1.x=col[2]-2;
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharTwo);
	cvResetImageROI(pImgResize);
    UIImage *imageTwo = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharTwo];
    cvReleaseImage(&pImgCharTwo);

	pImgCharThree=NULL;
	pImgCharThree=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	ROI_rect1.x=col[4]-2;
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharThree);
	cvResetImageROI(pImgResize);
    UIImage *imageThree = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharThree];
    cvReleaseImage(&pImgCharThree);
    

	pImgCharFour=NULL;
	pImgCharFour=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	ROI_rect1.x=col[6]-2;
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharFour);
	cvResetImageROI(pImgResize);
    UIImage *imageFour = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharFour];
    cvReleaseImage(&pImgCharFour);
    

	pImgCharFive=NULL;
	pImgCharFive=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	ROI_rect1.x=col[8]-2;
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharFive);
	cvResetImageROI(pImgResize);
    UIImage *imageFive = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharFive];
    cvReleaseImage(&pImgCharFive);
    

	pImgCharSix=NULL;
	pImgCharSix=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	ROI_rect1.x=col[10]-2;
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharSix);
	cvResetImageROI(pImgResize);
    UIImage *imageSix = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharSix];
    cvReleaseImage(&pImgCharSix);
    

	pImgCharSeven=NULL;
	pImgCharSeven=cvCreateImage(cvSize(nCharWidth,nCharHeight),IPL_DEPTH_8U,1);
	ROI_rect1.x=col[12]-2;
	ROI_rect1.y=0;
	ROI_rect1.width=nCharWidth;
	ROI_rect1.height=nCharHeight;
	cvSetImageROI(pImgResize,ROI_rect1);
	cvCopy(pImgResize,pImgCharSeven);
	cvResetImageROI(pImgResize);
    UIImage *imageSeven = [OpenCVUtilities UIImageFromGRAYIplImage:pImgCharSeven];
    cvReleaseImage(&pImgCharSeven);
    cvReleaseImage(&pImgResize);

    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:imageOne];
    [self.dataArray addObject:imageTwo];
    [self.dataArray addObject:imageThree];
    [self.dataArray addObject:imageFour];
    [self.dataArray addObject:imageFive];
    [self.dataArray addObject:imageSix];
    [self.dataArray addObject:imageSeven];

    self.hud.labelText = @"正在识别中...";
    [self configureView];
}
- (void)bubbleSort:(NSMutableArray *)array {
    int i, y;
    BOOL bFinish = YES;
    for (i = 1; i<= [array count] && bFinish; i++) {
        bFinish = NO;
        for (y = (int)[array count]-1; y>=i; y--) {
            PlateNumber *num1 = [array objectAtIndex:y];
            PlateNumber *num2 = [array objectAtIndex:y-1];
            if ([num1.number intValue] < [num2.number intValue]) {
                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                bFinish = YES;
            }
        }
    }
}
//识别
- (void)configureView{
    self.save = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0);
    dispatch_async(queue, ^{
        self.firstArray = [[NSMutableArray alloc]init];
        for (int i=0;i<self.dataArray.count;i++) {
            UIImage *image = [self.dataArray objectAtIndex:i];
            NSString *result = [tesseract analyseImage:image];
            NSRange range = NSMakeRange(0, 1);
            NSString *str = nil;
            if (result.length >2) {
                str = [result substringWithRange:range];
            }
            if ([result isEqualToString:@""]) {
                str = @"1";
            }
            if (str && ([str isEqualToString:@"ó"]||[str isEqualToString:@"é"])) {
                str = @"6";
                
            }else if (str && [str isEqualToString:@"了"]){
                str = @"7";
                
            }else if (str && [str isEqualToString:@"口"]){
                str = @"Q";
                
            }else if (str && [str isEqualToString:@"丫"]){
                str = @"Y";
                
            }else if (str && [str isEqualToString:@"」"]){
                str = @"J";
                
            }else if (str && ([str isEqualToString:@"丨"] || [str isEqualToString:@"|"] || [str isEqualToString:@"I"])){
                str = @"1";
            }else if (str && [str isEqualToString:@"o"]){
                str = @"0";
                
            }
            [self.firstArray addObject:str];
        }
        tesseract = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.plateNumberArray = [[NSMutableArray alloc]init];
            NSArray *array = [[NSArray alloc]initWithObjects:@"川",@"鄂",@"贵",@"甘",@"桂",@"赣",@"港",@"沪",@"黑",@"京",@"津",@"吉",@"晋",@"冀",@"鲁",@"辽",@"领",@"闽",@"蒙",@"宁",@"澳",@"青",@"琼",@"苏",@"陕",@"使",@"皖",@"湘",@"新",@"学",@"渝",@"云",@"粤",@"豫",@"浙",@"藏", nil];
            for (int i=0; i<self.firstArray.count; i++) {
                NSString *string = [self.firstArray objectAtIndex:i];
                if (i==0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    if ([array containsObject:string]) {
                        [tempArray addObject:string];
                        for (int j=0; j<array.count; j++) {
                            NSString *str = [array objectAtIndex:j];
                            if (![str isEqualToString:string] && ![tempArray containsObject:str]) {
                                [tempArray addObject:str];
                            }
                        }
                        [self.plateNumberArray addObject:tempArray];
                    }else {
                        [self.plateNumberArray addObject:array];
                    }
                    
                }else {
                    NSMutableArray *wrongArray = [NSMutableArray arrayWithArray:[[LanTaiOrderManager sharedInstance] loadDataFromTableWithWrong:string]];
                    if (wrongArray.count >0) {
                        [self bubbleSort:wrongArray];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        if ([self.plateArray containsObject:string]) {
                            [tempArray addObject:string];
                            
                            for (int k = wrongArray.count-1; k>=0; k--) {
                                PlateNumber *num = [wrongArray objectAtIndex:k];
                                [tempArray addObject:num.right];
                            }
                            
                            for (int j=0; j<self.plateArray.count; j++) {
                                NSString *str = [self.plateArray objectAtIndex:j];
                                if (![str isEqualToString:string] && ![tempArray containsObject:str]) {
                                    [tempArray addObject:str];
                                }
                            }
                            [self.plateNumberArray addObject:tempArray];
                        }else {
                            [self.plateNumberArray addObject:self.plateArray];
                        }
                        
                    }else {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        if ([self.plateArray containsObject:string]) {
                            [tempArray addObject:string];
                            for (int j=0; j<self.plateArray.count; j++) {
                                NSString *str = [self.plateArray objectAtIndex:j];
                                if (![str isEqualToString:string] && ![tempArray containsObject:str]) {
                                    [tempArray addObject:str];
                                }
                            }
                            [self.plateNumberArray addObject:tempArray];
                        }else {
                            [self.plateNumberArray addObject:self.plateArray];
                        }
                    }
                }
            }
            
            for (int i=0; i<7; i++) {
                [self.pickerView selectRow:0 inComponent:i animated:YES];
            }
            [self.pickerView reloadAllComponents];
            AppDelegate *appdele = [AppDelegate shareInstance];
            [MBProgressHUD hideAllHUDsForView:appdele.window animated:YES];
        });
    });
}

- (void)handleWithImage {
    self.strAlert = @"";
    if (imagee == nil) {
        return;
    }
    //倾斜纠正
    IplImage *bgrImage = [OpenCVUtilities CreateBGRAIplImageFromUIImage:imagee];
    IplImage* src = cvCreateImage(cvSize(bgrImage->width,bgrImage->height),bgrImage->depth,bgrImage->nChannels);
    correctionPlatePositionForAngle(bgrImage, src);
    cvReleaseImage(&bgrImage);
    
    if (isContinue == NO) {
        self.strAlert = @"车牌倾斜纠正失败";
        return;
    }
    //根据蓝色灰度化
    IplImage *grayImage2=NULL;//////////////////////////////////////////////////////////////////////
    changeToGrayImageASColor(src, &grayImage2,1,1);

    //车牌定位
    CvRect rectt;
    IplImage *grayImage3=NULL;//////////////////////////////////////////////////////////////////////
    accuratePositionPlate(grayImage2, &grayImage3, rectt,1);
    cvReleaseImage(&grayImage2);
    cvReleaseImage(&grayImage3);
    
    if (rectt.width <=0 || rectt.height <= 0 || rectt.x > src->width || rectt.y > src->height || rectt.width > src->width || rectt.height > src->height) {
        self.strAlert = @"车牌定位失败";
        return;
    }
    
    //截取车牌
   	cvSetImageROI(src,rectt);
	IplImage*imagePlate=cvCreateImage(cvSize(rectt.width,rectt.height),src->depth,src->nChannels);
	cvCopy(src,imagePlate);
	cvResetImageROI(src);
    cvReleaseImage(&src);
    
    UIImage *imageSrc = [OpenCVUtilities UIImageFromBGRAIplImage:imagePlate];
    cvReleaseImage(&imagePlate);
    
    IplImage*temp_src = [OpenCVUtilities CreateBGRAIplImageFromUIImage:imageSrc];
    imageSrc = nil;
    
    IplImage* pImgCanny1=cvCreateImage(cvSize(temp_src->width,temp_src->height),IPL_DEPTH_8U,1);//分配内存
    cvCvtColor(temp_src,pImgCanny1,CV_BGRA2GRAY);//转化成灰度图像
    cvReleaseImage(&temp_src);
    
    IplImage* pImgCanny2=cvCreateImage(cvSize(pImgCanny1->width,pImgCanny1->height),IPL_DEPTH_8U,1);//分配内存
    cvSmooth(pImgCanny1,pImgCanny2,CV_GAUSSIAN,3,0,0);//平滑处理 CV_GAUSSIAN->高斯模糊
    IplImage* pImgCanny=cvCreateImage(cvSize(pImgCanny2->width,pImgCanny2->height),IPL_DEPTH_8U,1);//分配内存
    cvThreshold(pImgCanny2, pImgCanny, otsu(pImgCanny2), 255, CV_THRESH_BINARY);
    
    
    //自定义1*3的核进行X方向的膨胀
    IplConvKernel* kernal = cvCreateStructuringElementEx(3,1, 1, 0, CV_SHAPE_RECT);
    cvErode(pImgCanny, pImgCanny,kernal, 1);
    //自定义3*1的核进行Y方向的膨胀
    kernal = cvCreateStructuringElementEx(1, 3, 0, 1, CV_SHAPE_RECT);
    cvErode(pImgCanny, pImgCanny,kernal, 1);
    cvDilate(pImgCanny, pImgCanny,kernal, 1);
    //y方向投影
    int i,j;
	int k=0;
    int hhh = pImgCanny->height;
	int row[hhh];
	row_start=0;
	row_end=0;
	col_start=0;
	col_end=0;
	int count=0;
	bool flag = false;
    //行
    for(j=0;j<pImgCanny->height-1;j++) {
        count=0;
        //列
		for(i=0;i<pImgCanny->width-1;i++) {
            if(S(pImgCanny,i,j)!=S(pImgCanny,i+1,j))//访问像素点
                count++;
            if(count>T) {
                row[k]=j;
				k++;
				break;
            }
        }
    }
    
    for(i=0;i<k;i++)  {
        if((row[i]==row[i+1]-1)&&(row[i+1]==row[i+2]-1)){
			row_start=row[i];
			break;
		}
    }
    
    for(i=k-1;i>row_start;i--) {
        if((row[i]==row[i-1]+1)&&(row[i-1]==row[i-2]+1)){
			row_end=row[i];
			break;
		}
    }
    flag=false;
	for(i=5;i<pImgCanny->width;i++) {
        count=0;
		for(j=row_start;j<row_end;j++)
		{
			if(S(pImgCanny,i,j)==0)
				count++;
			if(count>T1)
			{
				col_start=i;
				flag=true;
				break;
			}
		}
		if(flag) break;
    }
    flag=false;
	for(i=pImgCanny->width;i>col_start;i--) {
        count=0;
		for(j=row_start;j<row_end;j++)
		{
			if(S(pImgCanny,i,j)==0)
				count++;
			if(count>T1)
			{
				col_end=i;
				flag=true;
				break;
			}
		}
		if(flag) break;
    }
    CvRect ROI_rect;
	col_start = col_start> 0?col_start:0;
    row_start = row_start>0?row_start:0;
	ROI_rect.x=col_start;
	ROI_rect.y=row_start-1 >0?row_start-1:row_start;
    int width = col_end-col_start;
    ROI_rect.width=width >= pImgCanny->width - col_start?pImgCanny->width - col_start:width;
    int height = row_end-row_start+2;
    ROI_rect.height=height >= pImgCanny->height - row_start?pImgCanny->height - row_start:height;
    
    if (ROI_rect.width <=0 || ROI_rect.height <= 0 || ROI_rect.x > pImgCanny->width || ROI_rect.y > pImgCanny->height || ROI_rect.width > pImgCanny->width || ROI_rect.height > pImgCanny->height) {
        self.strAlert = @"车牌精确定位失败";
        return;
    }
    
	cvSetImageROI(pImgCanny,ROI_rect);
	IplImage* pImg8uROI=cvCreateImage(cvSize(ROI_rect.width,ROI_rect.height),IPL_DEPTH_8U,1);
	cvCopy(pImgCanny,pImg8uROI);
	cvResetImageROI(pImgCanny);
    cvReleaseImage(&pImgCanny);
    
    int minX=0,maxX=0;
    cv::vector<double> pixls;//每列含有的白色像素点数
    countPixelsCountForEachCol(pImg8uROI, pixls);
    for (int i = 0; i < pixls.size(); i++) {
        int value = pixls[i];
        if (value != 0) {
            minX = i;
            break;
        }
    }
    for (int i = pixls.size()-1; i >= 0; i--) {
        int value = pixls[i];
        if (value != 0) {
            maxX = i;
            break;
        }
    }
    
    CvRect R_rect;
    R_rect.x = minX;
    R_rect.y = 0;
    R_rect.width = maxX-minX;
    R_rect.height = ROI_rect.height;
    
    if (R_rect.width <=0 || R_rect.height <= 0 || R_rect.x > pImg8uROI->width || R_rect.y > pImg8uROI->height || R_rect.width > pImg8uROI->width || R_rect.height > pImg8uROI->height) {
        self.strAlert = @"车牌分割失败";
        return;
    }
    
    cvSetImageROI(pImg8uROI,R_rect);
	IplImage* pImg8uROISmooth=cvCreateImage(cvSize(R_rect.width,R_rect.height),IPL_DEPTH_8U,1);
	cvCopy(pImg8uROI,pImg8uROISmooth);
	cvResetImageROI(pImg8uROI);
    cvReleaseImage(&pImg8uROI);
    
	int nWidth=409;
	int nHeight=90;
    
    IplImage* pImg7uROI = cvCreateImage(cvSize(nWidth,nHeight),IPL_DEPTH_8U,1);
    cvResize(pImg8uROISmooth,pImg7uROI,CV_INTER_LINEAR);//线性插值
    cvReleaseImage(&pImg8uROISmooth);
    
	pImgResize=NULL;
	pImgResize=cvCreateImage(cvSize(pImg7uROI->width,pImg7uROI->height),IPL_DEPTH_8U,1);
	cvThin(pImg7uROI, pImgResize, 1);
    cvReleaseImage(&pImg7uROI);
    
    nCharWidth=45;
	nSpace=12;
	nCharHeight=90;
    [self segment];
 
}
#pragma mark - picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 7;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 70;
}
- (NSInteger)pickerView:(UIPickerView *)pickerVieww numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *array = [self.plateNumberArray objectAtIndex:component];
    return array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerVieww titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *array = [self.plateNumberArray objectAtIndex:component];
    return [array objectAtIndex:row];
}

    
-(IBAction)surePressed:(id)sender {
    self.plateString = [NSMutableString string];
    for (int i=0; i<7; i++) {
        NSString *str = [[self.plateNumberArray objectAtIndex:i]objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        [self.plateString appendFormat:@"%@",str];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePlateView:)]) {
        [self.delegate closePlateView:self];
    }
}
#pragma mark - - -

void countPixelsCountForEachCol(IplImage *srcImage,cv::vector<double>  & pixls){
    if (!srcImage) {
        return;
    }
    for (int col = 0; col < srcImage->width; col++) {
        pixls.push_back(0);
        for (int row = 0; row < srcImage->height; row++) {
            uchar * ptr = (uchar *)srcImage->imageData + srcImage->widthStep * row;
            int data = ptr[col];
            if (data > 0) {
                pixls[col]++;
            }
        }
    }
}
//图片细化处理
void cvThin( IplImage* src, IplImage* dst, int iterations)
{
    //此时的src是一个二值化的图片
    CvSize size = cvGetSize(src);
    cvCopy(src, dst);
    
    int n = 0,i = 0,j = 0;
    for(n=0; n<iterations; n++)//开始进行迭代
    {
        IplImage* t_image = cvCloneImage(dst);
        for(i=0; i<size.height;  i++)
        {
            for(j=0; j<size.width; j++)
            {
                if(CV_IMAGE_ELEM(t_image,uchar,i,j)==255)
                {
                    int ap=0;
                    int p2 = (i==0)?0:CV_IMAGE_ELEM(t_image,uchar, i-1, j);
                    int p3 = (i==0 || j==size.width-1)?0:CV_IMAGE_ELEM(t_image,uchar, i-1, j+1);
                    if (p2==0 && p3==255)
                    {
                        ap++;
                    }
                    
                    int p4 = (j==size.width-1)?0:CV_IMAGE_ELEM(t_image,uchar,i,j+1);
                    if(p3==0 && p4==255)
                    {
                        ap++;
                    }
                    
                    int p5 = (i==size.height-1 || j==size.width-1)?0:CV_IMAGE_ELEM(t_image,uchar,i+1,j+1);
                    if(p4==0 && p5==255)
                    {
                        ap++;
                    }
                    
                    int p6 = (i==size.height-1)?0:CV_IMAGE_ELEM(t_image,uchar,i+1,j);
                    if(p5==0 && p6==1)
                    {
                        ap++;
                    }
                    
                    int p7 = (i==size.height-1 || j==0)?0:CV_IMAGE_ELEM(t_image,uchar,i+1,j-1);
                    if(p6==0 && p7==255)
                    {
                        ap++;
                    }
                    
                    int p8 = (j==0)?0:CV_IMAGE_ELEM(t_image,uchar,i,j-1);
                    if(p7==0 && p8==255)
                    {
                        ap++;
                    }
                    
                    int p9 = (i==0 || j==0)?0:CV_IMAGE_ELEM(t_image,uchar,i-1,j-1);
                    if(p8==0 && p9==255)
                    {
                        ap++;
                    }
                    if(p9==0 && p2==255)
                    {
                        ap++;
                    }
                    
                    if((p2+p3+p4+p5+p6+p7+p8+p9)>255 && (p2+p3+p4+p5+p6+p7+p8+p9)<7*255)
                    {
                        if(ap==1)
                        {
                            if(!(p2 && p4 && p6))
                            {
                                if(!(p4 && p6 && p8))
                                {
                                    CV_IMAGE_ELEM(dst,uchar,i,j)=0;//设置目标图像中像素值为0的点
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        cvReleaseImage(&t_image);
        
        t_image = cvCloneImage(dst);
        for(i=0; i<size.height;  i++)
        {
            for(int j=0; j<size.width; j++)
            {
                if(CV_IMAGE_ELEM(t_image,uchar,i,j)==255)
                {
                    int ap=0;
                    int p2 = (i==0)?0:CV_IMAGE_ELEM(t_image,uchar, i-1, j);
                    int p3 = (i==0 || j==size.width-1)?0:CV_IMAGE_ELEM(t_image,uchar, i-1, j+1);
                    if (p2==0 && p3==255)
                    {
                        ap++;
                    }
                    int p4 = (j==size.width-1)?0:CV_IMAGE_ELEM(t_image,uchar,i,j+1);
                    if(p3==0 && p4==255)
                    {
                        ap++;
                    }
                    int p5 = (i==size.height-1 || j==size.width-1)?0:CV_IMAGE_ELEM(t_image,uchar,i+1,j+1);
                    if(p4==0 && p5==255)
                    {
                        ap++;
                    }
                    int p6 = (i==size.height-1)?0:CV_IMAGE_ELEM(t_image,uchar,i+1,j);
                    if(p5==0 && p6==255)
                    {
                        ap++;
                    }
                    int p7 = (i==size.height-1 || j==0)?0:CV_IMAGE_ELEM(t_image,uchar,i+1,j-1);
                    if(p6==0 && p7==255)
                    {
                        ap++;
                    }
                    int p8 = (j==0)?0:CV_IMAGE_ELEM(t_image,uchar,i,j-1);
                    if(p7==0 && p8==255)
                    {
                        ap++;
                    }
                    int p9 = (i==0 || j==0)?0:CV_IMAGE_ELEM(t_image,uchar,i-1,j-1);
                    if(p8==0 && p9==255)
                    {
                        ap++;
                    }
                    if(p9==0 && p2==255)
                    {
                        ap++;
                    }
                    if((p2+p3+p4+p5+p6+p7+p8+p9)>255 && (p2+p3+p4+p5+p6+p7+p8+p9)<7*255)
                    {
                        if(ap==1)
                        {
                            if(p2*p4*p8==0)
                            {
                                if(p2*p6*p8==0)
                                {
                                    CV_IMAGE_ELEM(dst, uchar,i,j)=0;
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        cvReleaseImage(&t_image);
    }
}
//根据车牌倾斜角校正车牌位置
void correctionPlatePositionForAngle(IplImage *srcImage,IplImage *destImage){
    IplImage *grayImage = nil;
    int thinTime = 0;
    IplImage *thinImage = cvCreateImage(cvSize(srcImage->width,srcImage->height),IPL_DEPTH_8U,1);
    changeToGrayImageASColor(srcImage, &grayImage,1);
    if (grayImage==NULL) {
        return;
    }
    cvThin(grayImage, thinImage, thinTime);
    
    // 3 . hough 找直线
    CvMemStorage * stroge = cvCreateMemStorage(0);
    CvSeq * lines = NULL;
    float *fline,fTheta;
    int angle;
    lines = cvHoughLines2(thinImage,stroge,CV_HOUGH_STANDARD,2,CV_PI/180,50,0,0);

    if (lines->total == 0) {
        isContinue = NO;
        return;
    }
    fline = (float*)cvGetSeqElem(lines,0);
    fTheta = fline[1]; // 过原点与直线垂直的直线与x轴夹角
    angle = (int)(fTheta *180/ CV_PI+0.5);
    if (angle >= 90 && angle <= 135)
    {
        angle = angle -90;
    }
    else if (angle >0 && angle <= 45)
    {
        
    }
    else if(angle >135 && angle < 180)
    {
        angle = 90 - angle;
    }else if (angle >45 &&angle <90)
    {
        angle = angle -90;
    }
    
    if (angle != 0) {
        float m[6];
        CvMat M = cvMat( 2, 3, CV_32F, m );
        CvPoint2D32f pt = cvPoint2D32f(thinImage->width/2.0, thinImage->height/2.0);
        cv2DRotationMatrix(pt, angle, 1.0, &M);
        cvWarpAffine(srcImage,destImage,&M,CV_INTER_AREA |CV_WARP_FILL_OUTLIERS,cvScalarAll(255));
    }else{
        cvCopy(srcImage, destImage);
    }
    
    cvReleaseMemStorage(&stroge);
    cvReleaseImage(&thinImage);
    cvReleaseImage(&grayImage);
}
//转换灰度图像，将指定颜色像素对应值255 其他颜色变为0
//intput:srcImage:rgb彩色图像,flag:0表示提取白色，1提取蓝色，2提取黄色，3提取黑色,color:0背景值255，1背景值0
//outPut:destImage:二值化图像
void changeToGrayImageASColor (IplImage *srcImage,IplImage **destImage,int flag = 1,int color = 0){
    IplImage* grayImage=cvCreateImage(cvSize(srcImage->width,srcImage->height),IPL_DEPTH_8U,1);
    int r,g,b;
    for( int y=0; y<srcImage->height; y++ ) {
        uchar* ptr = (uchar*) (srcImage->imageData + y * srcImage->widthStep);
        uchar * grayPtr = (uchar *)grayImage->imageData + grayImage->widthStep * y;
        for( int x=0; x<srcImage->width; x++ ) {
            b = ptr[4*x] ;
            g = ptr[4*x+1];
            r =  ptr[4*x+2];
            if (flag == 1) {//blue
                
            }
            
            switch (flag) {
                case 0://white
                    if (abs(r-b) < 35 && abs(g-b) < 35 && abs(r-g) < 35 &&(r > 175 || g > 175||b > 175)) {
                        grayPtr[x] = color?255:0;
                    }else{
                        grayPtr[x] = color?0:255;
                    }
                    ;
                    break;
                case 1://blue
                    if (2*b - r -g > 100) {
                        grayPtr[x] = color?0:255;
                    }else{
                        grayPtr[x] = color?255:0;
                    }
                    ;
                    break;
                case 2://yellow
                    ;
                    break;
                case 3://black
                    ;
                    break;
                default:
                    break;
            }
        }
    }
    
    if (destImage) {
        *destImage = grayImage;
    }
}
//精确定位车牌位置
//input:srcImage:二值化图像,plateBackgroundColor:0背景值255，1背景值0
//outPut:destImage:定位后车牌图像,plateRect:车牌相对与srcImage位置
void accuratePositionPlate (IplImage *srcImage,IplImage **destImage,CvRect & plateRect,int plateBackgroundColor = 0){
    if (!srcImage) {
        return;
    }
    int minSpace = 3;
    int charCount = 7;
    int spaceMinPixlsRow = 10,spaceMinPixlsCol = 2;
    int charMargin = 2;
    plateRect.x = 0;
    plateRect.y = 0;
    plateRect.width = 0;
    plateRect.height = 0;
    if (plateBackgroundColor) {//背景黑色
        //窃取纵坐标
        int isTopY = 0;
        for (int row = 0; row < srcImage->height; row++)  {
            uchar * ptr = (uchar *)srcImage->imageData + srcImage->widthStep * row;
            int currentColor = 255;
            int colorChangeCount = 0;
            int spaceCount = 0;
            for (int col = 0; col < srcImage->width; col++) {
                int data = ptr[col];
                if (currentColor != data) {
                    currentColor = data;
                    if (isTopY == 1) {
                        if (data == 0) {
                            colorChangeCount++;
                        }
                    }else{
                        if (col - spaceCount >= minSpace) {
                            spaceCount = col;
                            if (data == 255) {
                                colorChangeCount++;
                            }
                        }
                    }
                    
                }
            }
            
            if (isTopY == 1) {
                if (colorChangeCount < spaceMinPixlsCol && row - plateRect.y > srcImage->height/4.0) {//bottom
                    plateRect.height = row - plateRect.y+1;
                    cvLine(srcImage, cvPoint(0, row), cvPoint(srcImage->width, row), cvScalar(0),2);
                    break;
                }
            }else{
                if (colorChangeCount >=charCount && row > charMargin) {//top
                    isTopY = 1;
                    plateRect.y = row -2 > 0?row -2:0;
                    cvLine(srcImage, cvPoint(0, row), cvPoint(srcImage->width, row), cvScalar(0),2);
                    continue;
                }
            }
        }
        //查找车牌横坐标
        int isleft = 0,isright = 0;
        int left = 0,right = 0;
        for (int col = 0; col < srcImage->width; col++) {
            int colCountl = 0,colCountr = 0;
            for (int row = 0; row < srcImage->height; row++) {
                uchar * ptr = (uchar *)srcImage->imageData + srcImage->widthStep * row;
                if (isleft == 0) {
                    int left = ptr[col];
                    if (left == 0) {
                        colCountl++;
                    }
                }
                
                if (isright == 0) {
                    int right = ptr[srcImage->width - col-1];
                    if (right == 0) {
                        colCountr++;
                    }
                }
            }
            
            if (colCountl > spaceMinPixlsRow && col > charMargin && isleft == 0) {//left
                left = col;
                isleft = 1;
                cvLine(srcImage, cvPoint(col, 0), cvPoint(col,srcImage->height), cvScalar(0),4);
            }
            
            if (colCountr > spaceMinPixlsRow && col > charMargin && isright == 0) {//left
                right = srcImage->width-1- col;
                isright = 1;
                cvLine(srcImage, cvPoint(srcImage->width-1- col, 0), cvPoint(srcImage->width-1-col,srcImage->height), cvScalar(0),4);
            }
            
            if (isleft == 1 && isright == 1) {
                plateRect.x = left;
                plateRect.width = right - left+1 < srcImage->width?right - left+1:srcImage->width-1;
                break;
            }
        }
    }else{//背景白色
        for (int row = 0; row < srcImage->height; row++)  {
            uchar * ptr = (uchar *)srcImage->imageData + srcImage->widthStep * row;
            for (int col = 0; col < srcImage->width; col++) {
                int data = ptr[col];
                if (data > 0) {
                    
                }
            }
        }
    }
    
    if (destImage) {
        IplImage *tempImage = cvCreateImage(cvSize(plateRect.width, plateRect.height), srcImage->depth, srcImage->nChannels);
        cvSetImageROI(srcImage, plateRect);
        cvCopy(srcImage, tempImage);
        cvResetImageROI(srcImage);
        cvRectangle(tempImage, cvPoint(0, 0), cvPoint(plateRect.width-1, plateRect.height-1), cvScalar(0));
        *destImage = tempImage;
    }
    
}
int otsu(const IplImage *src_image) //大津法求阈值
{
    double sum = 0.0;
    double w0 = 0.0;
    double w1 = 0.0;
    double u0_temp = 0.0;
    double u1_temp = 0.0;
    double u0 = 0.0;
    double u1 = 0.0;
    double delta_temp = 0.0;
    double delta_max = 0.0;
    
    //src_image灰度级
    int pixel_count[256]={0};
    float pixel_pro[256]={0};
    int threshold = 0;
    uchar* data = (uchar*)src_image->imageData;
    //统计每个灰度级中像素的个数
    for(int i = 0; i < src_image->height; i++)
    {
        for(int j = 0;j < src_image->width;j++)
        {
            pixel_count[(int)data[i * src_image->width + j]]++;
            sum += (int)data[i * src_image->width + j];
        }
    }
    //计算每个灰度级的像素数目占整幅图像的比例
    for(int i = 0; i < 256; i++)
    {
        pixel_pro[i] = (float)pixel_count[i] / ( src_image->height * src_image->width );
    }
    //遍历灰度级[0,255],寻找合适的threshold
    for(int i = 0; i < 256; i++)
    {
        w0 = w1 = u0_temp = u1_temp = u0 = u1 = delta_temp = 0;
        for(int j = 0; j < 256; j++)
        {
            if(j <= i)   //背景部分
            {
                w0 += pixel_pro[j];
                u0_temp += j * pixel_pro[j];
            }
            else   //前景部分
            {
                w1 += pixel_pro[j];
                u1_temp += j * pixel_pro[j];
            }
        }
        u0 = u0_temp / w0;
        u1 = u1_temp / w1;
        delta_temp = (float)(w0 *w1* pow((u0 - u1), 2)) ;
        if(delta_temp > delta_max)
        {
            delta_max = delta_temp;
            threshold = i;
        }
    }
    return threshold;
}
int ImageStretchByHistogram(IplImage *src,IplImage *dst)
{
    assert(src->width==dst->width);
    float p[256],p1[256],num[256];
    
    memset(p,0,sizeof(p));
    memset(p1,0,sizeof(p1));
    memset(num,0,sizeof(num));
    
    int height=src->height;
    int width=src->width;
    long wMulh = height * width;
    
    for(int x=0;x<width;x++)
    {
        for(int y=0;y<height;y++)
        {
            uchar v=((uchar*)(src->imageData + src->widthStep*y))[x];
            num[v]++;
        }
    }
    
    for(int i=0;i<256;i++)
    {
        p[i]=num[i]/wMulh;
    }
    
    for(int i=0;i<256;i++)
    {
        for(int k=0;k<=i;k++)
            p1[i]+=p[k];
    }
    
    for(int x=0;x<width;x++)
    {
        for(int y=0;y<height;y++)
        {
            uchar v=((uchar*)(src->imageData + src->widthStep*y))[x];
            ((uchar*)(dst->imageData + dst->widthStep*y))[x]= p1[v]*255+0.5;
        }
    }
    
    return 0;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"///////////////////////////////////////");
}
@end
