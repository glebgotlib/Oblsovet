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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"Новости";
			break;
			
		case 1:
			cell.textLabel.text = @"Комиссии";
			break;
			
		case 2:
			cell.textLabel.text = @"Сессии";
			break;
			
		case 3:
			cell.textLabel.text = @"Календарь";
			break;
            
        case 4:
            cell.textLabel.text = @"Президиум";
            break;
            
        case 5:
            cell.textLabel.text = @"Согласителный совет";
            break;
            
        case 6:
            cell.textLabel.text = @"Фракции";
            break;
            
        case 7:
            cell.textLabel.text = @"Депутатские группы";
            break;
            
        case 8:
            cell.textLabel.text = @"Сообщения";
            break;
            
        case 9:
            cell.textLabel.text = @"Депутаты";
            break;
            
        case 10:
            cell.textLabel.text = @"Справочник";
            break;
            
        case 11:
            cell.textLabel.text = @"Log In";
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
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ListOfCommissionsTableViewController"];
            SessionsTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"SessionsTableViewController"];
            [cont refresh:@"session"];
            cont.objectR111111 = @"session";
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
            PresidiumTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"PresidiumTableViewController"];
            [cont refresh:@"presidium"];
            cont.objectR = @"presidium";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
            break;
            
        case 5:
        {
            SovetTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"SovetTableViewController"];
            [cont refresh:@"sovet"];
            cont.objectR = @"sovet";
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
            
        case 9:
        {
            DeputatsListTableViewController*cont = [mainStoryboard instantiateViewControllerWithIdentifier: @"DeputatsListTableViewController"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:cont
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
        }
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
