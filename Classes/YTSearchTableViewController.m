//
//  YTSearchTableViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/2/15.
//
//

#import "YTSearchTableViewController.h"
//#import "UIImageView+AFNetworking.h"
#import "YTTableViewCell.h"
#import "baby_ketten-Swift.h"

@interface YTSearchTableViewController ()

@end

@implementation YTSearchTableViewController

NSString* const kYouTubeAPIKey = @"AIzaSyBQgTWNFmBcR-omkycjHQRGiTtL2DUEm60";

- (void)viewDidLoad {
    [super viewDidLoad];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:[self getYouTubeSearchURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
//        [self loadVideosFromJSON:JSON];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error fetching search results: %@", error);
//        self.title = @"Not Found!";
//    }];

    [NetworkManager GET:[self getYouTubeSearchURL] completionHandler:^(id JSON) {
        NSLog(@"%@", JSON);
        [self loadVideosFromJSON:JSON];
    }];
}

- (NSString *)getYouTubeSearchURL {
    NSString *urlFormat = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&maxResults=15&type=video&key=%@";

    NSString *escapedSearchString = [self.searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    NSString *youTubeSearchUrl = [NSString stringWithFormat:urlFormat, escapedSearchString, kYouTubeAPIKey];

    return youTubeSearchUrl;
}

- (void)loadVideosFromJSON:(id)JSON {
    NSMutableArray *videos = [@[] mutableCopy];

    for (NSDictionary *entry in JSON[@"items"]) {
        [videos addObject:entry];
    }

    if ([videos count] == 0) {
        self.navigationItem.title = @"Not Found!";
    } else {
        self.navigationItem.title = @"Results";
    }

    self.videos = videos;
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"YTTableViewCell";
    YTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:@"YTTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }

    NSDictionary *video = self.videos[indexPath.row];
    //NSLog(@"%@", video);
    if (video) {
        cell.titleLabel.text = video[@"snippet"][@"title"];
        cell.descriptionLabel.text = video[@"snippet"][@"description"];

        __weak YTTableViewCell *_cell = cell;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:video[@"snippet"][@"thumbnails"][@"default"][@"url"]]
                                                 cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval:60];

        [cell.myImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ketten_small_white"] success:^(NSURLRequest *request, NSURLResponse *response, UIImage *image) {
            _cell.myImageView.image = image;
        }];

//        [cell.myImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ketten_small_white"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            _cell.myImageView.image = image;
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            NSLog(@"failed to log image with error: %@", error);
//        }];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *video = [self.videos objectAtIndex:indexPath.row];
    NSString *videoId = video[@"id"][@"videoId"];

    if (videoId) {
        NSString *urlString = [NSString stringWithFormat:@"http://youtube.com/watch?v=%@", videoId];

        NSLog(@"%@", urlString);
        NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *url = [NSURL URLWithString:escapedUrlString];

        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
