//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "MomentsViewController.h"
#import "SlideshowController.h"
#import "MomentViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+MCLayout.h"

@interface MomentsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideshowControl>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) SlideshowController *slideshowController;
@property (nonatomic) CGSize momentSize;
@end

@implementation MomentsViewController

- (instancetype)initWithSlideshowController:(SlideshowController *)slideshowController
{
    if (self = [super init]) {
        _slideshowController = slideshowController;
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
    self.view = self.collectionView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.slideshowController setSlideshowControlDelegate:self];
    [self.slideshowController startSlideshow];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSInteger rowCount = 3;
    CGFloat momentHeight = floorf((self.view.mc_height - (rowCount - 1) * 6) / (CGFloat)rowCount);
    while (momentHeight > 160) {
        rowCount++;
        momentHeight = floorf((self.view.mc_height - (rowCount - 1) * 6) / (CGFloat)rowCount);
    }
    self.momentSize = CGSizeMake(momentHeight, momentHeight);
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
#pragma mark - UICollectionView delegate & dataSource
//------------------------------------------------------------------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.slideshowController.numberOfMoments;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MomentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moment" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[self.slideshowController momentMediaURLAtIndex:indexPath.item]];
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
    [self.slideshowController didSelectMomentAtIndex:indexPath.item];
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
#pragma mark - SlideshowControl
//------------------------------------------------------------------------------

- (void)didLoadMoments
{
    [self.collectionView reloadData];
}

- (void)displayingMomentAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    NSArray *selectedRows = [self.collectionView indexPathsForSelectedItems];
    for (NSIndexPath *i in selectedRows) {
        if (![i isEqual:indexPath]) {
            [self.collectionView deselectItemAtIndexPath:i animated:NO];
        }
    }
}
@end