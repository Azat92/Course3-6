//
//  CommentCel.m
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CommentCell.h"
#import "Comment+CoreDataProperties.h"

@implementation CommentCell

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    self.commentText.preferredMaxLayoutWidth = CGRectGetWidth(self.commentText.frame);
}

-(void)updateWithModel:(id)model
{
    if ([model isKindOfClass:[Comment class]]) {
        Comment *comment = (Comment*)model;
        _commentText.text = comment.text;
        
        NSString *userText = [NSString stringWithFormat:@"user id: %@",comment.userID];
        _userTitle.text = userText;
        
        NSString *dateString = [NSDateFormatter localizedStringFromDate:comment.date
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        _dateTitle.text = dateString;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
