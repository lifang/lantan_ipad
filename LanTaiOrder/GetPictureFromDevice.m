#import "GetPictureFromDevice.h"
#import "NSDate+Additions.h"

#import "OverlayView.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation GetPictureFromDevice

@synthesize fileType = fileType_;
@synthesize fileName = fileName_;
@synthesize fileData = fileData_;
@synthesize delegate = delegate_;
@synthesize fileUrl = fileUrl_;
@synthesize parentController;
@synthesize picCell;
@synthesize customView;

- (id)initWithParentViewController:(id)pc
{
    if(self = [super init])
    {
        self.parentController = pc;
    }
    return  self;
}

#pragma mark - GetPictureFromDevice methods

- (void)takePhotoWithCamera
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
		if(fileType_ == kPhotoType)
			ipc.mediaTypes = [NSArray arrayWithObject:@"public.image"];
		else if(fileType_ == kMovieType){
			ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
		}
        else
        {
            ipc.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
        }
        
		ipc.delegate = self;
        
        if ([DataService sharedService].isTakePic == YES) {
            UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
            self.customView = [[OverlayView alloc]initWithFrame:CGRectMake(300, 250, 400, 200)];
            self.customView.backgroundColor = [UIColor clearColor];
            [vv addSubview:self.customView];
            ipc.cameraOverlayView = vv;
        }
        
        if ([self.parentController respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self.parentController presentModalViewController:ipc animated:YES];
        }
	}
	else {
        [delegate_ didGetFileFailedWithMessage:@"Error accessing device camera"];
	}
}

- (void)getPhotoFromLibrary
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
		if(fileType_ == kPhotoType)
			ipc.mediaTypes = [NSArray arrayWithObject:@"public.image"];
		else if(fileType_ == kMovieType){
			ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
		}
        else
        {
            ipc.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
        }
        
		ipc.delegate = self;
		ipc.allowsEditing = YES;
        if ([self.parentController respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self.parentController presentModalViewController:ipc animated:YES];
        }else{
            [self.parentController presentViewController:ipc animated:YES completion:nil];
        }
	}
	else {
        [delegate_ didGetFileFailedWithMessage:@"Error accessing photo library"];
	}
}

#pragma mark UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *fullName = nil;
	NSData *uploadData = nil;
	
	if(fileType_ == kPhotoType){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        self.fileUrl = url;
        
        UIImage* subImage = nil;
        if ([DataService sharedService].isTakePic == YES) {
            double imageWidth = image.size.width;
            double imageHeight = image.size.height;
            
            float x = imageWidth / 1024;
            float y = imageHeight / 768;
            
            CGSize subImageSize = CGSizeMake(self.customView.frame.size.width*x, self.customView.frame.size.height*y) ;
            CGRect subImageRect = CGRectMake(self.customView.frame.origin.x *x, self.customView.frame.origin.y *y, self.customView.frame.size.width *x, self.customView.frame.size.height *y);
            CGImageRef imageRef = image.CGImage;
            CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
            UIGraphicsBeginImageContext(subImageSize);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, subImageRect, subImageRef);
            subImage = [UIImage imageWithCGImage:subImageRef];
            UIGraphicsEndImageContext();
        }else {
            subImage = image;
        }
        
        NSString *str = [NSDate dateToStringByFormat:[NSDate date] format:@"yyyyMMddHHmmss"];
        fullName = [NSString stringWithFormat:@"%@takephoto.jpg",str];
        uploadData = UIImageJPEGRepresentation(subImage, 0.7);
		UIImageWriteToSavedPhotosAlbum(subImage, nil, nil, nil);
        
	}
	else if(fileType_ == kMovieType){
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.fileUrl = videoURL;
		uploadData = [NSData dataWithContentsOfURL:videoURL];
		NSString *path = [NSString stringWithFormat:@"%@",videoURL];
		if(path != nil)
		{
			NSFileManager *fm = [[NSFileManager alloc] init];
			fullName = [fm displayNameAtPath:path];
			//fullname:trim.***.mov
			fullName = [fullName substringFromIndex:5];
		}
		else {
            NSString *str = [NSDate dateToStringByFormat:[NSDate date] format:@"yyyyMMddHHmmss"];
			fullName = [NSString stringWithFormat:@"%@takevideo.mov",str];
		}
	}
    
	self.fileName = fullName;
	self.fileData = uploadData;
    [delegate_ didGetFileWithFile:self];
    if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
