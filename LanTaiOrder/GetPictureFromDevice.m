#import "GetPictureFromDevice.h"
#import "NSDate+Additions.h"

@implementation GetPictureFromDevice

@synthesize fileType = fileType_;
@synthesize fileName = fileName_;
@synthesize fileData = fileData_;
@synthesize delegate = delegate_;
@synthesize fileUrl = fileUrl_;
@synthesize parentController;
@synthesize picCell;


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
		ipc.allowsEditing = YES;
        if ([self.parentController respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self.parentController presentModalViewController:ipc animated:YES];
        }
//        [(UIViewController *)self.parentController presentModalViewController:ipc animated:YES];
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
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
		NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        self.fileUrl = url;
        
        NSString *str = [NSDate dateToStringByFormat:[NSDate date] format:@"yyyyMMddHHmmss"];
        fullName = [NSString stringWithFormat:@"%@takephoto.jpg",str];
        uploadData = UIImageJPEGRepresentation(image, 0.7);
		
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
    NSLog(@"image full name is:%@",fullName);
    
	self.fileName = fullName;
	self.fileData = uploadData;
    [delegate_ didGetFileWithFile:self];
    if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        [picker dismissModalViewControllerAnimated:YES];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        [picker dismissModalViewControllerAnimated:YES];
    }
}
@end
