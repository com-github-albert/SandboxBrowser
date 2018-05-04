//
//  SandboxViewController.m
//  SandboxBrowser
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "SandboxViewController.h"

typedef enum : NSUInteger {
    SandboxFileDirectory,
    SandboxFileFile,
    SandboxFileBack,
    SandboxFileDismiss,
} SandboxFileType;

@interface SandboxFile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) SandboxFileType type;

@end

@implementation SandboxFile

@end

@interface SandboxViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation SandboxViewController {
    NSMutableArray<SandboxFile *> *_items;
    NSString *_cellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _items = [NSMutableArray array];
    _cellIdentifier = @"SandboxTableViewCell";
    
    self.headerView = [UIView new];
    [self.view addSubview:self.headerView];
    
    self.footerView = [UIView new];
    [self.view addSubview:self.footerView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.bounces = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self loadBrowser:NSHomeDirectory()];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat margin = 40;
    self.headerView.frame = CGRectMake(0, 0, width, margin);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), width, height - margin * 2);
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), width, margin);
}

- (void)loadBrowser:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [_items removeAllObjects];
    
    NSString *homePath = NSHomeDirectory();
    if ([path isEqualToString:homePath]) {
        
    } else {
        SandboxFile *file = [[SandboxFile alloc] init];
        file.path = path;
        file.name = @"🔙 ...";
        file.type = SandboxFileBack;
        [_items addObject:file];
    }
    
    NSArray *subPathNames = [fm contentsOfDirectoryAtPath:path error:nil];
    for (NSString *name in subPathNames) {
        
        if ([[name lastPathComponent] hasPrefix:@"."]) {
            continue;
        }
        
        BOOL isDirectory = false;
        NSString *fullPath = [path stringByAppendingPathComponent:name];
        [fm fileExistsAtPath:fullPath isDirectory:&isDirectory];
        
        SandboxFile *file = [[SandboxFile alloc] init];
        file.path = fullPath;
        if (isDirectory) {
            file.type = SandboxFileDirectory;
            file.name = [NSString stringWithFormat:@"%@ %@", @"📂", name];
        } else {
            file.type = SandboxFileFile;
            file.name = [NSString stringWithFormat:@"%@ %@", @"📄", name];
        }
        [_items addObject:file];
    }
    
    SandboxFile *file = [[SandboxFile alloc] init];
    file.path = path;
    file.name = @"✖️";
    file.type = SandboxFileDismiss;
    [_items addObject:file];
    
    [self.tableView reloadData];
}

- (void)shareBrowserFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    if (url) {
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        NSArray *excludedActivities = @[UIActivityTypePostToTwitter,
                                        UIActivityTypePostToFacebook,
                                        UIActivityTypePostToWeibo,
                                        UIActivityTypeMessage,
                                        UIActivityTypeMail,
                                        UIActivityTypePrint,
                                        UIActivityTypeCopyToPasteboard,
                                        UIActivityTypeAssignToContact,
                                        UIActivityTypeSaveToCameraRoll,
                                        UIActivityTypeAddToReadingList,
                                        UIActivityTypePostToFlickr,
                                        UIActivityTypePostToVimeo,
                                        UIActivityTypePostToTencentWeibo];
        activity.excludedActivityTypes = excludedActivities;
        
        if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
            activity.popoverPresentationController.sourceView = self.view;
            activity.popoverPresentationController.sourceRect = CGRectMake(28, 28, 28, 28);
        }
        
        [self presentViewController:activity animated:YES completion:nil];
    }
}

#pragma mark- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    SandboxFile *file = _items[indexPath.row];
    cell.textLabel.text = file.name;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    if (file.type == SandboxFileDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _items.count - 1) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SandboxFile *file = _items[indexPath.row];
    switch (file.type) {
        case SandboxFileDirectory:
            [self loadBrowser:file.path];
            break;
        case SandboxFileFile:
            [self shareBrowserFromPath:file.path];
            break;
        case SandboxFileBack:
            [self loadBrowser:[file.path stringByDeletingLastPathComponent]];
            break;
        case SandboxFileDismiss:
            [self.presentationModeDelegate presentationDelegateChangePresentationModeToMode:FloatingPresentationModeCondensed];
            break;
    }
}

@end
