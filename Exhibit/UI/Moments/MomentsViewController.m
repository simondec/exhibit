//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "MomentsViewController.h"
#import "SlideshowController.h"
#import "MomentViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+MCLayout.h"

@interface MomentsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideshowObserver>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) SlideshowController *slideshowController;
@property (nonatomic) CGSize momentSize;
@property (nonatomic) NSTimer *scrollTimer;
@property (nonatomic) UICollectionViewScrollPosition selectedMomentScrollPosition;
@property (nonatomic) BOOL didAppear;
@end

@implementation MomentsViewController

- (instancetype)initWithSlideshowController:(SlideshowController *)slideshowController
{
    if (self = [super init]) {
        _slideshowController = slideshowController;
        _selectedMomentScrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
        _momentSize = CGSizeMake(100, 100);
    }
    return self;
}

- (void)loadView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[MomentViewCell class] forCellWithReuseIdentifier:@"moment"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.exclusiveTouch = YES;
    self.view = self.collectionView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.slideshowController addSlideshowObserver:self];
    self.didAppear = YES;
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.slideshowController removeSlideshowObserver:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSInteger rowCount = 3;
    CGFloat momentHeight = floorf((self.view.mc_height - (rowCount - 1) * 6) / (CGFloat)rowCount);
    while (momentHeight > 200) {
        rowCount++;
        momentHeight = floorf((self.view.mc_height - (rowCount - 1) * 6) / (CGFloat)rowCount);
    }
    self.momentSize = CGSizeMake(momentHeight, momentHeight);
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)resetAutoScroll
{
    self.selectedMomentScrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
}

- (void)selectMomentAtIndex:(NSUInteger)index
{
    [self.slideshowController didSelectMomentAtChronologicalIndex:index];
}

- (void)resetAutoScrollingAfterDelay
{
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
    }

    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(resetAutoScroll) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

//------------------------------------------------------------------------------
#pragma mark - UICollectionView delegate & dataSource
//------------------------------------------------------------------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.didAppear ? self.slideshowController.numberOfMoments : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MomentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moment" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[self.slideshowController momentMediaURLAtChronologicalIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [collectionView indexPathsForSelectedItems];
    for (NSIndexPath *i in selectedRows) {
        if (![i isEqual:indexPath]) {
            [collectionView deselectItemAtIndexPath:i animated:NO];
        }
    }
    [self selectMomentAtIndex:indexPath.item];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
    }
    self.selectedMomentScrollPosition = UICollectionViewScrollPositionNone;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self resetAutoScrollingAfterDelay];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetAutoScrollingAfterDelay];
}

//------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegateFlowLayout
//------------------------------------------------------------------------------

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.momentSize;
}

//------------------------------------------------------------------------------
#pragma mark - SlideshowObserver
//------------------------------------------------------------------------------

- (void)didLoadMoments:(NSInteger)numberOfMoments
{
    [self.collectionView reloadData];
}

- (void)displayMoment:(Moment *)moment atChronologicalIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:self.selectedMomentScrollPosition];
    NSArray *selectedRows = [self.collectionView indexPathsForSelectedItems];
    for (NSIndexPath *i in selectedRows) {
        if (![i isEqual:indexPath]) {
            [self.collectionView deselectItemAtIndexPath:i animated:NO];
        }
    }
}
@end