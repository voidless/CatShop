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
    [delegate kittenTableReturnClicked:selectedIndexPath];
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
    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                      reuseIdentifier:cellId];
//    }
    
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
    
    [self performSegueWithIdentifier:@"modalDescSegue" sender:self];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nc = segue.destinationViewController;
    
    BOOL isNavCont = [nc isKindOfClass:[UINavigationController class]];
    
    if (isNavCont && [segue.identifier isEqualToString:@"modalDescSegue"])
    {
        KittenDescriptionController *kdc = [nc.viewControllers objectAtIndex:0];
        if ([kdc isKindOfClass:[KittenDescriptionController class]])
        {
            kdc.kitten = [kittens objectAtIndex:selectedIndexPath.row];
            
            UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Вернуться"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(dismissKittenPhotoController)];
            kdc.navigationItem.leftBarButtonItem = b;
        }
    }
}

- (void)dismissKittenPhotoController
{
    [self dismissModalViewControllerAnimated:YES];
    
    [self markRowAtIndex:self.tableView.indexPathForSelectedRow];
}

- (void)markRowAtIndex:(NSIndexPath*)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
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


@end
