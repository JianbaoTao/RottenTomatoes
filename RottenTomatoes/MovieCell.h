//
//  MovieCell.h
//  RottenTomatoes
//
//  Created by Jianbao Tao on 9/14/14.
//  Copyright (c) 2014 ___JimTao___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end
