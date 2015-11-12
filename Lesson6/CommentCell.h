//
//  CommentCell.h
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <DTTableViewManager/DTTableViewManager.h>

@interface CommentCell : DTTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateTitle;
@end
