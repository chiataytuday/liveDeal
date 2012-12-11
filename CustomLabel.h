//
//  CustomLabel.h
//  bimby
//
//  Created by claudio barbera on 11/08/12.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    MSLabelVerticalAlignmentTop,
    MSLabelVerticalAlignmentMiddle,
    MSLabelVerticalAlignmentBottom
} MSLabelVerticalAlignment;

@interface CustomLabel : UILabel
{
    int _lineHeight;
}

@property (nonatomic, assign) int lineHeight;
@property (nonatomic, assign) MSLabelVerticalAlignment verticalAlignment;

@end