#import "ViewController.h"
#import "../MGKMenuWithFilter.h"
#import <Quartz/Quartz.h>

@interface ViewController ()

@property (strong) IBOutlet NSButton *pushMeButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)showPopUpMenu:(id)sender
{
    NSURL *folder = [NSURL fileURLWithPath:@"/Library/Desktop Pictures"];

    NSArray *all_files = [NSFileManager.defaultManager contentsOfDirectoryAtURL:folder
                                                     includingPropertiesForKeys:nil
                                                                        options:0
                                                                          error:nil];
    
    NSString *jpg_predicate_string = @"self.absoluteString ENDSWITH '.jpg'";
    NSPredicate *jpg_predicate = [NSPredicate predicateWithFormat:jpg_predicate_string];
    NSArray *jpg_files = [all_files filteredArrayUsingPredicate:jpg_predicate];
    
    MGKMenuWithFilter *menu = [[MGKMenuWithFilter alloc] initWithTitle:@"Pictures"];
    
    for( NSURL *picture in jpg_files ) {
        NSMenuItem *item = [[NSMenuItem alloc] init];
        item.title = picture.lastPathComponent;
        item.action = @selector(showPicture:);
        item.target = self;
        
        NSSize size = NSMakeSize(32, 32);
        CGImageRef preview = QLThumbnailImageCreate(0, (__bridge CFURLRef)picture, size, 0);
        if( preview ) {
            item.image = [[NSImage alloc] initWithCGImage:preview size:size];
            CGImageRelease(preview);
        }

        item.representedObject = picture;
        [menu addItem:item];
    }
    
    [menu popUpMenuPositioningItem:nil
                         atLocation:NSMakePoint(0, self.pushMeButton.bounds.size.height)
                             inView:self.pushMeButton];
}

- (IBAction)showPicture:(id)sender
{
    [NSWorkspace.sharedWorkspace openURL:[sender representedObject]];
}

@end
