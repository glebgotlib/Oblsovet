//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "ListOfCommissionsTableViewController.h"
#import "SovetTableViewController.h"
#import "SessionsTableViewController.h"
#import "PresidiumTableViewController.h"
#import "DeputatsListTableViewController.h"
#import "CalendarTableViewController.h"
#import "FractionTableViewController.h"
#import "DepGrupsTableViewController.h"
#import "MessagesTableViewController.h"
#import "CommissionDetailsViewController.h"
@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
	self.tableView.backgroundView = imageView;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Komision = "Комиссії";
//    Session = "Сессії";
//    Calendar = "Календар";
//    Presidium = "Президіум";
//    Sovet = "Согласителный совет";
//    Mess = "Повідомлення";
//    Deputat = "Депутати";
//    DepGrups = "Депутатскі групи";
//    Spravkic = "Довідник";
//    Login = "Увійти";
//    Fraktion = "Фракція";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = NSLocalizedString(@"News", nil);
			break;
			
		case 1:
			cell.textLabel.text = NSLocalizedString(@"Komision", nil);
			break;
			
		case 2:
			cell.textLabel.text = NSLocalizedString(@"Session", nil);
			break;
			
		case 3:
			cell.textLabel.text = NSLocalizedString(@"Calendar", nil);
			break;
            
        case 4:
            cell.textLabel.text = NSLocalizedString(@"Presidium", nil);
            break;
            
        case 5:
            cell.textLabel.text = NSLocalizedString(@"Sovet", nil);
            break;
            
        case 6:
            cell.textLabel.text = NSLocalizedString(@"Fraktion", nil);
            break;
            
        case 7:
            cell.textLabel.text = NSLocalizedString(@"DepGrups", nil);
            break;
            
        case 8:
            cell.textLabel.text = NSLocalizedString(@"Mess", nil);
            break;
            
        case 9:
            cell.textLabel.text = NSLocalizedString(@"Deputat", nil);
            break;
            
        case 10:
            cell.textLabel.text = NSLocalizedString(@"Spravki", nil);
            break;
            
        case 11:
            cell.textLabel.text =NSLocalizedString(@"Login", nil);
            break;
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	
	UIViewController *vc ;
	
	switch (indexPath.row)
	{
		case 0:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainTableViewController"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
			break;
			
        case 1:
        {
            ListOfCommissionsTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"ListOfCommissionsTableViewController"];
            [cont refresh:@"comission"];
            cont.objectR = @"comission";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
			break;
            
        case 2:
        {
//             TmpViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"TmpViewController"];
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ListOfCommissionsTableViewController"];
            TmpViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"TmpViewController"];
//            [cont refresh:@"session"];
            cont.object = @"session";
            cont.selectedId = @"1";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 3:
        {
            //            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ListOfCommissionsTableViewController"];
            CalendarTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"CalendarTableViewController"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 4:
        {
//            PresidiumTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"PresidiumTableViewController"];
//            [cont refresh:@"presidium"];
//            cont.objectR = @"presidium";
            CommissionDetailsViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"CommissionDetailsViewController"];
            cont.object = @"presidium";
            cont.selectedId = @"1";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 5:
        {
//            SovetTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"SovetTableViewController"];
//            [cont refresh:@"sovet"];
//            cont.objectR = @"sovet";
            CommissionDetailsViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"CommissionDetailsViewController"];
            cont.object = @"sovet";
            cont.selectedId = @"1";

            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 6:
        {
            FractionTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"FractionTableViewController"];
            [cont refresh:@"fraction"];
            cont.objectR = @"fraction";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 7:
        {
            DepGrupsTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"DepGrupsTableViewController"];
            [cont refresh:@"depgroup"];
            cont.objectR = @"depgroup";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 8:
        {
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"]==nil) {
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LogInViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                         withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                                 andCompletion:nil];
            }
            else{
                MessagesTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"MessagesTableViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                         withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                                 andCompletion:nil];
            }
        }
            break;
            
        case 9:
        {
            DeputatsListTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"DeputatsListTableViewController"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 10:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SpravkiViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                         withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                                 andCompletion:nil];
            break;

		case 11:
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"]==nil) {
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LogInViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
     															 withSlideOutAnimation:self.slideOutAnimationEnabled
     																	 andCompletion:nil];
            }
			break;
			
	}
	
//	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
//															 withSlideOutAnimation:self.slideOutAnimationEnabled
//																	 andCompletion:nil];


}

@end
