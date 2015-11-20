//
//  ListingView.m
//  TagViewTest
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import "ListingView.h"

@interface ListingView()

@end

@implementation ListingView

- (void)drawRect:(CGRect)rect {
    
    (self.flipped) ? [self setUpSpecial] : [self setUpRegular];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:gr];
    
}

- (void) setUpRegular {
    int height = self.frame.size.height;
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setFrame:CGRectMake(height/8, height/8, 3*height/4, 3*height/4)];
    
    if([self.type isEqualToString:@"people"]) {
        [icon setImage:[UIImage imageNamed:@"people.png"]];
        [icon setBackgroundColor:[UIColor colorWithRed:255/255.0 green:204/255.0 blue:17/255.0 alpha:1.0]];
    } else if([self.type isEqualToString:@"place"]){
        [icon setImage:[UIImage imageNamed:@"places.png"]];
        [icon setBackgroundColor:[UIColor colorWithRed:23/255.0 green:130/255.0 blue:44/255.0 alpha:1.0]];
    } else {
        [icon setImage:[UIImage imageNamed:@"events.png"]];
        [icon setBackgroundColor:[UIColor colorWithRed:23/255.0 green:141/255.0 blue:220/255.0 alpha:1.0]];
    }
    [self addSubview:icon];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height+5, 0, height*5, height/2)];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(height+5, height/2, height*5, height/2)];
    propertyLabel.text = [NSString stringWithFormat:@"%@: %.2f m", self.property, [self.value floatValue]];
    propertyLabel.textColor = [UIColor whiteColor];
    [self addSubview:propertyLabel];
    
    /*UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(height*3.5+5, height/2, height*2.5, height/2)];
    valueLabel.text = [NSString stringWithFormat:@"%.2fm", ;
    valueLabel.textColor = [UIColor whiteColor];
    [self addSubview:valueLabel];*/
    
    [self setNeedsLayout];
}

- (void) setUpSpecial {
    int height = self.frame.size.height;
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(height*0.25, 0, height, height)];
    [infoButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:infoButton];
    
    UIButton *directionsButton = [[UIButton alloc] initWithFrame:CGRectMake(height*1.75, 0, height, height)];
    [directionsButton setImage:[UIImage imageNamed:@"directions.png"] forState:UIControlStateNormal];
    [directionsButton addTarget:self action:@selector(directionsButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:directionsButton];
    
    UIButton *checkinButton = [[UIButton alloc] initWithFrame:CGRectMake(height*3.25, 0, height, height)];
    [checkinButton setImage:[UIImage imageNamed:@"checkin.png"] forState:UIControlStateNormal];
    [checkinButton addTarget:self action:@selector(checkinButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkinButton];
    
    UIButton *reviewsButton = [[UIButton alloc] initWithFrame:CGRectMake(height*4.75, 0, height, height)];
    [reviewsButton setImage:[UIImage imageNamed:@"review.png"] forState:UIControlStateNormal];
    [reviewsButton addTarget:self action:@selector(reviewsButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reviewsButton];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    self.flipped = !self.flipped;
    [self drawRect:self.frame];
}

-(void) infoButtonTouched {
    [self.viewCon infoButtonPressedWithObject: self];
}

-(void) directionsButtonTouched {
    [self.viewCon directionsButtonPressedWithObject: self];
}

-(void) checkinButtonTouched {
    [self.viewCon checkinButtonPressedWithObject: self];
}

-(void) reviewsButtonTouched {
    [self.viewCon reviewsButtonPressedWithObject: self];
}



@end
