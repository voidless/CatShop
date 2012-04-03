#import "KittenTableViewController.h"
#import "Kitten.h"
#import "KittenDescriptionController.h"

@interface KittenTableViewController ()

@property (strong) NSArray *kittens;

@property (strong) NSIndexPath *selectedIndexPath;

@end


@implementation KittenTableViewController

@synthesize delegate;

@synthesize kittens;
@synthesize selectedIndexPath;

#pragma mark Actions

- (IBAction)backButton
{
    [delegate kittenFlipWithIndex:selectedIndexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kittens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"KittenCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    Kitten *k = [kittens objectAtIndex:indexPath.row];
    
    cell.textLabel.text = k.name;
    
    if (k.price > 0)
    {
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"$%d", k.price];
    } else {
        cell.detailTextLabel.text = @"Не продается";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"DescSegue" sender:self];
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


@end
