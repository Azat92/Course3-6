//
//  NoteCell.h
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <DTTableViewManager/DTTableViewManager.h>

@interface NoteCell : DTTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
