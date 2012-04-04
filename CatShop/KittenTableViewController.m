#import "KittenTableViewController.h"
#import "Kitten.h"
#import "KittenDescriptionController.h"

@interface KittenTableViewController ()

// TODO: remove this, use sorted
@property (strong) NSArray *kittens;

@property (strong) NSIndexPath *selectedIndexPath;

@end


@implementation KittenTableViewController

@synthesize tableView = _tableView;

@synthesize delegate;

@synthesize kittens;
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    return kittens.count;
}

- (Kitten*)kittenByIndexPath:(NSIndexPath*)idxp
{
    
    
    return [kittens objectAtIndex:idxp.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"KittenCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSAssert(cell != nil, @"Cell with id %@ doesn't exist", cellId);
    
    Kitten *k = [self kittenByIndexPath:indexPath];
    
    cell.textLabel.text = k.name;
    
    if (k.price > 0)
    {
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"$%d", k.price];
    } else {
        cell.detailTextLabel.text = @"Не продается";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"DescSegue" sender:self];
    
    [delegate kittenSetCurrent:indexPath.row];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KittenDescriptionController *kdc = segue.destinationViewController;
    if ([kdc isKindOfClass:[KittenDescriptionController class]]
        && [segue.identifier isEqualToString:@"DescSegue"])
    {
        kdc.kitten = [kittens objectAtIndex:selectedIndexPath.row];
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
    [self markRowAtIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark Lifetime

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    kittens = [Kitten kittens];
    NSLog(@"kittens recieved: %d", kittens.count);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
