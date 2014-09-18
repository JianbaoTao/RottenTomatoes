//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Jianbao Tao on 9/14/14.
//  Copyright (c) 2014 ___JimTao___. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MovieDetailsViewController

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
}


- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"movie info: %@", self.movie);
    self.navigationItem.title = self.movie[@"title"];
    
    self.detailsLabel.text = [NSString stringWithFormat:@"%@\n%@",self.movie[@"year"],
                              self.movie[@"synopsis"]];
    
    self.textView.text = [NSString stringWithFormat:@"%@\n%@",self.movie[@"year"],
                          self.movie[@"synopsis"]];
    
    NSString *tmbUrl = [self.movie valueForKeyPath:@"posters.thumbnail"];
    [self.posterView setImageWithURL:[NSURL URLWithString:tmbUrl]];
}

- (void) viewDidAppear:(BOOL)animated {
    NSString *tmbUrl = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSString *oriUrl = [tmbUrl stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    [self.posterView setImageWithURL:[NSURL URLWithString:oriUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
