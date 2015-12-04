//
//  NotesViewController.m
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "NotesViewController.h"
#import "CoreDataStorageManager.h"
#import "NoteCell.h"
#import "CommentCell.h"

@interface NotesViewController (){
    NSFetchedResultsController *mainController;
}

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] setDataSource:self];
    if (_isComments) {
        [self setupComments];
        if (_arrivedComment!=nil) {
            NSIndexPath *idxPath = [mainController indexPathForObject:_arrivedComment];
            NSLog(@"IDX S:%li,R:%li",(long)idxPath.section,(long)idxPath.row);
            [self.tableView selectRowAtIndexPath:idxPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self performSelector:@selector(deselectRowAtIdx:) withObject:idxPath afterDelay:4.5];
        }
    }
    else [self setupNotes];
    NSLog(@"ROWS:%li",(long)[[self tableView] numberOfRowsInSection:0]);
}

-(void)deselectRowAtIdx:(NSIndexPath*)idxPath{
    [self.tableView deselectRowAtIndexPath:idxPath animated:YES];
}

-(void)setupNotes{
    [[self navigationItem] setTitle:@"Notes"];
    mainController = [CoreDataStorageManager notesFetchControllerWithPredicate:nil];
    CoreDataStorageManager *coreDataMgr = [[CoreDataStorageManager alloc] initWithFetchResultsController:mainController];
    [self setStorage:coreDataMgr];
    [self registerCellClass:[NoteCell class] forModelClass:[Note class]];
    [[self tableView] reloadData];
}

-(void)setupComments{
    [[self navigationItem] setTitle:_selectedNote.name];
    NSPredicate *commentsPredicate = [NSPredicate predicateWithFormat:@"theNote==%@",_selectedNote];
    mainController = [CoreDataStorageManager commentsFetchControllerWithPredicate:commentsPredicate];
    CoreDataStorageManager *coreDataMgr = [[CoreDataStorageManager alloc] initWithFetchResultsController:mainController];
    NSLog(@"COMMENTS C:%lu",[[mainController fetchedObjects]count]);
    [self setStorage:coreDataMgr];
    [self registerCellClass:[CommentCell class] forModelClass:[Comment class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0;
    [[self tableView] reloadData];

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isComments) {
        NotesViewController *destination = (NotesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NotesViewID"];
        destination.isComments = YES;
        destination.selectedNote = [mainController objectAtIndexPath:indexPath];
        [[self navigationController] pushViewController:destination animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
