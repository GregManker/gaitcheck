//
//  SoundPairTVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "SoundPairTVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserDefaultsHelper.h"

@interface SoundPairTVC ()

@end

@implementation SoundPairTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UITableViewCell *cell = [self cellForRowAtIndexPath:1];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    tableView deque
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    int selectedIndex = [UserDefaultsHelper selectedSoundIndex];
//    if (indexPath.row == selectedIndex) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
////    cell.textLabel.text = [[audioFileList objectAtIndex:indexPath.row] lastPathComponent];
//    return cell;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *tone1;
    NSURL *tone2;
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        tone1 = [NSURL URLWithString:@"System/Library/Audio/UISounds/short_double_low.caf"];
        tone2 = [NSURL URLWithString:@"System/Library/Audio/UISounds/short_double_high.caf"];
        [self playSound:tone1];
        [NSThread sleepForTimeInterval:0.75];
        [self playSound:tone2];
        
    }
    if (indexPath.row == 1) {
        tone1 = [NSURL URLWithString:@"System/Library/Audio/UISounds/dtmf-1.caf"];
        tone2 = [NSURL URLWithString:@"System/Library/Audio/UISounds/dtmf-3.caf"];
        [self playSound:tone1];
        [NSThread sleepForTimeInterval:0.75];
        [self playSound:tone2];
    }
    NSArray *tones = [[NSArray alloc] initWithObjects: [tone1 absoluteString], [tone2 absoluteString], nil];
    [UserDefaultsHelper setSoundPair:tones];
    [UserDefaultsHelper setSoundIndex:indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView reloadData];
}

- (void)playSound:(NSURL *)url
{
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)url,&soundID);
    AudioServicesPlaySystemSound(soundID);
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
