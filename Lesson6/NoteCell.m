//
//  NoteCell.m
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "NoteCell.h"
#import "Note.h"

@implementation NoteCell

-(void)updateWithModel:(id)model
{
    if ([model isKindOfClass:[Note class]]) {
        Note *note = (Note*)model;
        _title.text = note.name;
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
