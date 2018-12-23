//
//  TutorialPageViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 23/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "TutorialPageViewController.h"
#import "ContentViewController.h"

#define PAGES_COUNT 4

@interface TutorialPageViewController ()

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation TutorialPageViewController {
  struct pageContentData {
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *contentText;
    __unsafe_unretained NSString *imageName;
  } contentData[PAGES_COUNT];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self createContentDataArray];
  
  self.dataSource = self;
  self.delegate = self;
  ContentViewController *startViewController = [self viewControllerAtIndex:0];
  [self setViewControllers:@[startViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
  
  _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50.0, self.view.bounds.size.width, 50.0)];
  _pageControl.numberOfPages = PAGES_COUNT;
  _pageControl.currentPage = 0;
  _pageControl.pageIndicatorTintColor = [UIColor grayColor];
  _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
  [self.view addSubview:_pageControl];
  
  _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
  _nextButton.frame = CGRectMake(self.view.bounds.size.width - 100.0, self.view.bounds.size.height - 50.0, 100.0, 50.0);
  [_nextButton addTarget:self action:@selector(nextButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
  [_nextButton setTintColor:[UIColor blueColor]];
  [self updateButtonWithIndex:0];
  [self.view addSubview:_nextButton];
}

- (void)createContentDataArray {
  NSArray *titles = [NSArray arrayWithObjects:@"ABOUT", @"AIRPLANE TICKETS", @"PRICE MAP", @"FAVORITES", nil];
  NSArray *contents = [NSArray arrayWithObjects:@"This app will help you to find airplane tickets", @"Find the cheapest ticket on a market", @"Check out Price Map to find where to go next", @"Save tickets that you've found to Favorites", nil];
  for (int i = 0; i < 4; ++i) {
    contentData[i].title = [titles objectAtIndex:i];
    contentData[i].contentText = [contents objectAtIndex:i];
    contentData[i].imageName = [NSString stringWithFormat:@"tutorialPage%d", i+1];
  }
}

- (ContentViewController *)viewControllerAtIndex:(int)index {
  if (index < 0 || index >= PAGES_COUNT) {
    return nil;
  }
  ContentViewController *contentViewController = [ContentViewController new];
  contentViewController.title = contentData[index].title;
  contentViewController.contentText = contentData[index].contentText;
  contentViewController.image =  [UIImage imageNamed: contentData[index].imageName];
  contentViewController.index = index;
  return contentViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
  if (completed) {
    int index = ((ContentViewController *)[pageViewController.viewControllers firstObject]).index;
    _pageControl.currentPage = index;
    [self updateButtonWithIndex:index];
  }
}

- (void)updateButtonWithIndex:(int)index {
  switch (index) {
    case 0:
    case 1:
    case 2:
      [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
      _nextButton.tag = 0;
      break;
    case 3:;
      [_nextButton setTitle:@"DONE" forState:UIControlStateNormal];
      _nextButton.tag = 1;
      break;
    default:
      break;
  }
}

- (void)nextButtonWasTapped:(UIButton *)sender
{
  int index = ((ContentViewController *)[self.viewControllers firstObject]).index;
  if (sender.tag) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialWasShown"];
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    __weak typeof(self) weakSelf = self;
    [self setViewControllers:@[[self viewControllerAtIndex:index + 1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
      weakSelf.pageControl.currentPage = index + 1;
      [weakSelf updateButtonWithIndex:index + 1];
    }];
  }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  int index = ((ContentViewController *)viewController).index;
  index--;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  int index = ((ContentViewController *)viewController).index;
  index++;
  return [self viewControllerAtIndex:index];
}

@end