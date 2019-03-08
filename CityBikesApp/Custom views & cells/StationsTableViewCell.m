//
//  StationsTableViewCell.m
//  CityBikesApp
//
//  Created by Kristoffer Anger on 2019-03-06.
//  Copyright © 2019 kriang. All rights reserved.
//

#import "StationsTableViewCell.h"

@implementation StationsTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLayout];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)createLayout {
    
    _distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.distanceLabel.font = self.detailTextLabel.font;
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.distanceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect detailTextLabelRect = self.detailTextLabel.frame;
    self.distanceLabel.frame = CGRectMake(0, detailTextLabelRect.origin.y, self.contentView.frame.size.width, detailTextLabelRect.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];    // Configure the view for the selected state
}

@end
