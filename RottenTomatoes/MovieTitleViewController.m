//
//  MovieTitleViewController.m
//  RottenTomatoes
//
//  Created by Jianbao Tao on 9/12/14.
//  Copyright (c) 2014 ___JimTao___. All rights reserved.
//

#import "MovieTitleViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailsViewController.h"

@interface MovieTitleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) MovieDetailsViewController *detailsVC;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

@property (strong, nonatomic) UIView *networkErrorView;
@property (strong, nonatomic) UILabel *networkErrorLabel;

@end

@implementation MovieTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loadIndicator startAnimating];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 125;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier: @"MovieCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    NSURLRequest *request = [self createHttpRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSLog(@"Error in loading");
            [self handleConnectionError:connectionError];
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = dict[@"movies"];
            [self.tableView reloadData];
        }
        [self.loadIndicator stopAnimating];
    }];
    
}

- (void)refresh:(UIRefreshControl *)sender
{
    NSLog(@"Refreshing");
    
    NSURLRequest *request = [self createHttpRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSLog(@"Error in loading");
            [self handleConnectionError:connectionError];
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = dict[@"movies"];
            [self.tableView reloadData];
        }
        [sender endRefreshing];
    }];
}

- (void)handleConnectionError:(NSError *)error {
    NSError *underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey];
    self.networkErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.networkErrorView.backgroundColor = [UIColor blackColor];
    self.networkErrorView.alpha = .85;
    
    // configure the error label
    self.networkErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 60)];
    self.networkErrorLabel.text = [underlyingError localizedDescription];
    [self.networkErrorLabel setTextColor:[UIColor whiteColor]];
    [self.networkErrorLabel setNumberOfLines:0];
    [self.networkErrorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
    [self.networkErrorLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.networkErrorView addSubview:self.networkErrorLabel];
    [self.tableView addSubview:self.networkErrorView];
}


- (NSURLRequest *) createHttpRequest {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"index path: %d", indexPath.row );
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];

    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected row %ld", (long)indexPath.row);
    
    if (!self.detailsVC) {
        self.detailsVC = [[MovieDetailsViewController alloc] initWithNibName:@"MovieDetailsViewController" bundle:nil];
    }
    
    self.detailsVC.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:self.detailsVC animated:YES];    
}


@end
