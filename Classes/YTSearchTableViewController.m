//
//  YTSearchTableViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/2/15.
//
//

#import "YTSearchTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "YTTableViewCell.h"

@interface YTSearchTableViewController ()

@end

@implementation YTSearchTableViewController

NSString* const kYouTubeAPIKey = @"AIzaSyBQgTWNFmBcR-omkycjHQRGiTtL2DUEm60";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"YouTube";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self getYouTubeSearchURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self loadVideosFromJSON:JSON];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error fetching search results: %@", error);
        self.title = @"Not Found!";
    }];
}

- (NSString *)getYouTubeSearchURL {
    NSString *urlFormat = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&maxResults=15&type=video&key=%@";

    NSString *youTubeSearchUrl = [[NSString stringWithFormat:urlFormat, self.searchString, kYouTubeAPIKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    return youTubeSearchUrl;
}

- (void)loadVideosFromJSON:(id)JSON {
    NSMutableArray *videos = [@[] mutableCopy];

    for (NSDictionary *entry in JSON[@"items"]) {
        [videos addObject:entry];
    }

//    if ([videos count] == 0) {
//        self.navigationItem.title = @"Not Found!";
//    } else {
//        self.navigationItem.title = @"Calendar";
//    }

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

        [cell.myImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ketten_small_white"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            _cell.myImageView.image = image;
            NSLog(@"setting image.");
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"failed to log image with error: %@", error);
        }];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
