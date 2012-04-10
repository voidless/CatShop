#import "KittenTableViewController.h"
#import "Cat.h"
#import "SortedCat.h"
#import "CurrentCat.h"
#import "KittenDescriptionController.h"
#import "KittenTableCellController.h"
#import "KittenCreateController.h"

@interface KittenTableViewController ()

@property (strong) NSIndexPath *selectedIndexPath;

@end


@implementation KittenTableViewController

@synthesize tableView = _tableView;

@synthesize delegate;

@synthesize selectedIndexPath;

#pragma mark Actions

- (IBAction)backButton
{
    [delegate kittenFlip];
}

- (IBAction)editButton
{
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
}

- (void)KittenCreated:(Cat*)newCat
{
//    NSLog(@"recieved cat: %@", newCat);
    
    NSUInteger pIdx = [Cat count] - 1;
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pIdx inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Cat count];
}

- (Cat*)kittenByIndexPath:(NSIndexPath*)idxp
{
    return [SortedCat catSortedAtIndex:idxp.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"KittenCell";
    KittenTableCellController *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSAssert(cell != nil, @"Cell with id %@ doesn't exist", cellId);
    
    Cat *k = [self kittenByIndexPath:indexPath];
    
    cell.nameLabel.text = k.name;
    
    if (k.price > 0)
    {
        cell.priceLabel.text = [[NSString alloc] initWithFormat:@"$%d", k.price];
    } else {
        cell.priceLabel.text = @"Не продается";
    }
    
    cell.photoImage.image = k.image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [SortedCat moveCatSortedFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cat *k = [self kittenByIndexPath:indexPath];
    
    [k delete];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];    
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Удалить";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"DescSegue" sender:self];
    
//    [delegate kittenSetCurrent:indexPath.row];
    Cat *k = [SortedCat catSortedAtIndex:indexPath.row];
    [[CurrentCat currentCat] setCurrentCatId:k.objectID];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KittenDescriptionController *kdc = segue.destinationViewController;
    if ([kdc isKindOfClass:[KittenDescriptionController class]]
        && [segue.identifier isEqualToString:@"DescSegue"])
    {
        kdc.kitten = [SortedCat catSortedAtIndex:selectedIndexPath.row];
    }
    
    KittenCreateController *kct = segue.destinationViewController;
    if ([kct isKindOfClass:[KittenCreateController class]]
        && [segue.identifier isEqualToString:@"AddKitten"])
    {
        kct.delegate = self;
    }
}

- (void)markRowAtIndex:(NSIndexPath*)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)selectKittenAtIndex:(NSInteger)index
{
    if (index >= [Cat count]) {
        return;
    }
    
    if (self.isViewLoaded && self.view.window)
    {
        [self markRowAtIndex:[NSIndexPath indexPathForRow:index inSection:0]];
    } else {
        selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];;
    }
}

#pragma mark Lifetime

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (selectedIndexPath)
    {
        [self markRowAtIndex:selectedIndexPath];
    }
}

@end
