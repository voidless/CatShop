#import "KittenTableViewController.h"
#import "Cat+SortedCat.h"
#import "KittenDescriptionController.h"
#import "KittenTableCellController.h"
#import "KittenEditController.h"

@interface KittenTableViewController ()

@end


@implementation KittenTableViewController

@synthesize tableView = _tableView;

@synthesize delegate;

@synthesize context;
@synthesize currentCat;

#pragma mark Actions

- (IBAction)backButton
{
    [delegate kittenListControllerDidFinish:self];
}

- (IBAction)editButton
{
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
}

- (void)kittenFinishedEditing:(Cat *)newCat
{
    [newCat save];

    if (self.tableView.editing) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self currentIndex]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        NSInteger pIdx = [Cat countWithContext:context] - 1;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pIdx inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Cat countWithContext:context];
}

- (Cat *)kittenByIndexPath:(NSIndexPath *)idxp
{
    return [Cat catSortedAtIndex:(NSUInteger)idxp.row withContext:context];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"KittenCell";
    KittenTableCellController *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    NSAssert(cell != nil, @"Cell with id %@ doesn't exist", cellId);

    Cat *k = [self kittenByIndexPath:indexPath];

    cell.nameLabel.text = k.name;

    if (k.price > 0) {
        cell.priceLabel.text = [[NSString alloc] initWithFormat:@"$%d", k.price];
    } else {
        cell.priceLabel.text = @"Не продается";
    }

    cell.photoImage.image = k.image;

    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [Cat moveCatSortedFromIndex:(NSUInteger)sourceIndexPath.row toIndex:(NSUInteger)destinationIndexPath.row withContext:context];
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
    [self setCurrentIndex:indexPath];

    if (tableView.editing) {
        [self performSegueWithIdentifier:@"EditKitten" sender:self];
    } else {
        [self performSegueWithIdentifier:@"DescSegue" sender:self];
    }

}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KittenDescriptionController *kdc = segue.destinationViewController;
    if ([kdc isKindOfClass:[KittenDescriptionController class]]
            && [segue.identifier isEqualToString:@"DescSegue"]) {
        kdc.context = context;
        kdc.kitten = [Cat catWithId:currentCat.currentCatId andContext:context];
    }

    KittenEditController *kct = segue.destinationViewController;
    if ([kct isKindOfClass:[KittenEditController class]]
            && [segue.identifier isEqualToString:@"EditKitten"]) {
        kct.delegate = self;
        kct.context = context;

        if (self.tableView.editing) {
            kct.catToEdit = [self kittenByIndexPath:[self currentIndex]];
        } else {
            kct.catToEdit = [[Cat alloc] initWithEntity:[Cat entityFromContext:context] insertIntoManagedObjectContext:context];
        }
    }
}

#pragma mark Marking

- (void)markRowAtIndex:(NSIndexPath *)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSIndexPath *)currentIndex
{
    if (currentCat.currentCatId == nil) {
        return 0;
    }

    NSArray *cats = [Cat catsSortedWithContext:context];

    NSUInteger idx = [cats indexOfObjectPassingTest:^(id obj, NSUInteger index, BOOL *stop)
                                                    {
                                                        Cat *cat = (Cat *) obj;
                                                        *stop = ([cat.objectID isEqual:currentCat.currentCatId]);
                                                        return *stop;
                                                    }];

    if (idx != NSNotFound) {
        return [NSIndexPath indexPathForRow:idx inSection:0];
    }
    return 0;
}

- (void)setCurrentIndex:(NSIndexPath *)index
{
    currentCat.currentCatId = [[Cat catSortedAtIndex:(NSUInteger)index.row withContext:context] objectID];
}


#pragma mark Lifetime

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self markRowAtIndex:[self currentIndex]];
}

@end
