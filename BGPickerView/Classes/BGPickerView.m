//
//  BGPickerView.m
//  BGPickerView
//
//  Created by iOSzhb on 05/08/2014.
//  Copyright (c) 2014 iOSzhb. All rights reserved.
//

#import "BGPickerView.h"
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/1.f]
#define ScreenW  ([UIScreen mainScreen].bounds.size.width)
#define ScreenH ([UIScreen mainScreen].bounds.size.height)

/***************************
 *****                 *****
 *****  BGLayout       *****
 *****                 *****
 ****************************/
@interface BGLayout : UICollectionViewFlowLayout

@end

/***************************
 *****                 *****
 *****    Model        *****
 *****                 *****
 ****************************/
@interface BGModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign)  BOOL     hightLight;
@property (nonatomic, strong)  UIColor  *itemTextColor;
@property (nonatomic, strong)  UIFont   *itemFont;
@property (nonatomic, strong)  UIColor  *itemSelectedTextColor;
@property (nonatomic, strong)  UIFont   *itemSelectedFont;
@end

/***************************
 *****                 *****
 *****     subView     *****
 *****                 *****
 ****************************/
@interface BGCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) BGModel *model;
@end

/***************************
 *****                 *****
 *****  BGPickerView   *****
 *****                 *****
 ****************************/
@interface BGPickerView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *showView;


@property (nonatomic, strong) NSMutableArray *collectionViewArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end
@implementation BGPickerView
#pragma mark -- 1.初始化,配置数据源
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(213, 213, 213, 1.f);
        [self layoutIfNeeded];
    }
    return self;
}

- (void)setDataSource:(id<BGPickerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self configerMidView];
}

- (void)configerMidView
{
    //1.获取多少列
//    self.components = 1;
    NSInteger components = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        components = [self.dataSource numberOfComponentsInPickerView:self];
    }
    
    //2.创建components个collectionView
    for (NSInteger i=0; i<components; i++) {
        UICollectionView *collectionView = [self getCollectionView];
        collectionView.tag = 1000+i;
        [self.midView addSubview:collectionView];
        [self.collectionViewArray addObject:collectionView];
    }
    
    //3.配置collectionView的数据源
    [self configerCollectionViewDataSourceFase];
    
    [self.midView insertSubview:self.showView atIndex:0];
}

- (void)configerCollectionViewDataSourceFase
{
    NSInteger components = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        components = [self.dataSource numberOfComponentsInPickerView:self];
    }
    for (NSInteger i=0; i<components; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [self.dataSourceArray addObject:array];
        [self configerCollectionViewDataSourceTrue:i];
    }
}

- (void)configerCollectionViewDataSourceTrue:(NSInteger)component
{
    NSInteger rowCount = 0;
    if ([self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        rowCount = [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    //创建rowCount个model
    //2.创建对应cell对应的model
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSInteger j = 0; j < rowCount; j++) {
        BGModel *item = [[BGModel alloc] init];
        if ([self.dataSource respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
            item.title = [self.dataSource pickerView:self titleForRow:j forComponent:component];//给model属性赋值
        }
        [arrayM addObject:item];
    }
    //3.更换tableViewDataSourceArray中对应的值
    [self.dataSourceArray replaceObjectAtIndex:component withObject:arrayM];
}

#pragma mark -- 2.布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat allW = self.bounds.size.width;
    CGFloat allH = self.bounds.size.height;
    
    CGFloat topViewH = 44;
    CGFloat topMarginX = 15;//横向
    CGFloat leftBtnW = [self textWidth:self.leftBtn.currentTitle font:self.leftBtn.titleLabel.font];
    CGFloat rightBtnW = [self textWidth:self.rightBtn.currentTitle font:self.rightBtn.titleLabel.font];
    
    //1.topView
    self.topView.frame = CGRectMake(0, 0, allW, topViewH+1);
    self.leftBtn.frame = CGRectMake(topMarginX, 0, leftBtnW+5, topViewH);
    self.rightBtn.frame = CGRectMake(allW-topMarginX-rightBtnW-5, 0, rightBtnW+5, topViewH);
    self.lineView.frame = CGRectMake(0, topViewH, allW, 1);
    
    //2.minView
    self.midView.frame = CGRectMake(0, topViewH+1, allW, allH-topViewH-1);
    CGFloat showViewMarginY = 15.f;
    CGFloat collectionW = allW/self.collectionViewArray.count;
    CGFloat collectionH = CGRectGetHeight(self.midView.bounds)-showViewMarginY*2;
    NSUInteger count = self.collectionViewArray.count;
    for (NSInteger i=0; i<count; i++) {
        UICollectionView *collectionView = self.collectionViewArray[i];
        collectionView.frame = CGRectMake(i*collectionW, showViewMarginY, collectionW, collectionH);
        BGLayout *layout = (BGLayout *)collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(collectionW, collectionH/5.f);
        layout.sectionInset = UIEdgeInsetsMake(collectionH/5.f*2, 0, collectionH/5.f*2, 0);
        layout.minimumLineSpacing = 0.f;
    }
    
    //3.showView
    CGFloat showViewH = ceilf((CGRectGetHeight(self.midView.bounds)-2*showViewMarginY)/5);
//    CGFloat showViewY = (CGRectGetHeight(self.midView.bounds)-showViewH)*0.5+topViewH+1;
    CGFloat showViewY = (CGRectGetHeight(self.midView.bounds)-showViewH)*0.5;
    self.showView.frame = CGRectMake(0, showViewY, allW, showViewH);
    [self reloadAllComponents];
}


#pragma mark -- 3.dataSource / delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataSourceArray[collectionView.tag-1000];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BGCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BGCell" forIndexPath:indexPath];
    NSArray *dataSourceArrayInSection = self.dataSourceArray[collectionView.tag-1000];
    BGModel *model = dataSourceArrayInSection[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.topView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.topView.userInteractionEnabled = YES;
    NSInteger component = scrollView.tag-1000;
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:[self selectedCellIndex:self.collectionViewArray[component]] inComponent:component];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger row = [self selectedCellIndex:scrollView];
    [self hightLightCellWithRowIndex:row inComponent:scrollView.tag-1000];
}

- (NSInteger)selectedCellIndex:(UIScrollView *)scrollView
{
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    collectionView = self.collectionViewArray[collectionView.tag-1000];
    CGPoint pInView = [self.midView convertPoint:collectionView.center toView:collectionView];
    NSIndexPath *indexpath = [collectionView indexPathForItemAtPoint:pInView];
    return indexpath.row;
}

- (void)hightLightCellWithRowIndex:(NSInteger)cellIndex inComponent:(NSInteger)component
{
    NSArray *modelArray = self.dataSourceArray[component];
    NSUInteger count = modelArray.count;
    for (NSInteger i = 0; i < count; i++) {
        BGModel *model = (BGModel *)modelArray[i];
        model.itemTextColor = self.itemTextColor;
        model.itemSelectedTextColor = self.itemSelectedTextColor;
        model.hightLight = (i == cellIndex);
    }
    UICollectionView *collectionView = self.collectionViewArray[component];
    [collectionView reloadData];
}



#pragma mark -- 4.even
- (void)leftBtnClicked:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(pickerViewCancelSelect)]) {
        [self.delegate pickerViewCancelSelect];
    }
    btn.userInteractionEnabled = YES;
    [self reloadAllComponents];
}

- (void)rightBtnClicked:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    [self completeSelected];
    btn.userInteractionEnabled = YES;
    [self reloadAllComponents];
}

- (void)completeSelected
{
    if ([self.delegate respondsToSelector:@selector(pickerViewCompleteSelectedRows:)]) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (UICollectionView *sbView in self.collectionViewArray) {
            [arrayM addObject:@([self selectedCellIndex:sbView])];
        }
        [self.delegate pickerViewCompleteSelectedRows:arrayM];
    }
}
#pragma mark - events (For outside use)
- (void)reloadComponent:(NSInteger)component
{
    if (self.collectionViewArray.count >= component) {
        [self configerCollectionViewDataSourceTrue:component];
        UICollectionView *collectionView = self.collectionViewArray[component];
        [collectionView reloadData];
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        [self hightLightCellWithRowIndex:0 inComponent:component];

    }
}

- (void)reloadAllComponents
{
    for (NSInteger i = 0; i < self.collectionViewArray.count; i ++) {
        [self reloadComponent:i];
    }
}

#pragma mark -- 5.getter
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_topView];
    }
    return _topView;
}

- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"请选择" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_leftBtn setTitleColor:Color(27,108,250,1.f) forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchDown];
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.topView addSubview:_leftBtn];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_rightBtn setTitleColor:Color(27,108,250,1.f) forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchDown];
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.topView addSubview:_rightBtn];
    }
    return _rightBtn;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
        [self.topView addSubview:_lineView];
    }
    return _lineView;
}

- (UIView *)midView
{
    if (_midView == nil) {
        _midView = [[UIView alloc] init];
        _midView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_midView];
    }
    return _midView;
}

- (UIView *)showView
{
    if (_showView == nil) {
        _showView = [[UIView alloc] init];
        _showView.backgroundColor = Color(27,108,250,0.5f);
        _showView.userInteractionEnabled = NO;
        [self.midView addSubview:_showView];
    }
    return _showView;
}

- (NSMutableArray *)collectionViewArray
{
    if (_collectionViewArray == nil) {
        _collectionViewArray = [NSMutableArray array];
    }
    return _collectionViewArray;
}

- (NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray == nil) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSIndexPath *)currentIndexPath
{
    if (_currentIndexPath == nil) {
        _currentIndexPath = [NSIndexPath indexPathWithIndex:0];
    }
    return _currentIndexPath;
}

#pragma mark - 6.other
- (CGFloat)textWidth:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}

- (UICollectionView *)getCollectionView
{
    BGLayout *layout = [self getBGLayout];
    UICollectionView *collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[BGCell class] forCellWithReuseIdentifier:@"BGCell"];
    return collectionView;
}

- (BGLayout *)getBGLayout
{
    BGLayout *layout = [[BGLayout alloc] init];
    return layout;
}

#pragma mark -- 7.setter
- (void)setCancelText:(NSString *)cancelText
{
    _cancelText = cancelText;
    [self.leftBtn setTitle:cancelText forState:UIControlStateNormal];
}

- (void)setCancelColor:(UIColor *)cancelColor
{
    _cancelColor = cancelColor;
    [self.leftBtn setTitleColor:cancelColor forState:UIControlStateNormal];
}

- (void)setCancelFont:(UIFont *)cancelFont
{
    _cancelFont = cancelFont;
    self.leftBtn.titleLabel.font = cancelFont;
    [self layoutIfNeeded];
}

- (void)setSureText:(NSString *)sureText
{
    _sureText = sureText;
    [self.rightBtn setTitle:sureText forState:UIControlStateNormal];
}

- (void)setSureTextColor:(UIColor *)sureTextColor
{
    _sureTextColor = sureTextColor;
    [self.rightBtn setTitleColor:sureTextColor forState:UIControlStateNormal];
}

- (void)setSureTextFont:(UIFont *)sureTextFont
{
    _sureTextFont = sureTextFont;
    self.rightBtn.titleLabel.font = sureTextFont;
    [self layoutIfNeeded];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    [self.showView setBackgroundColor:indicatorColor];
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    _itemTextColor = itemTextColor;
}

- (void)setItemSelectedTextColor:(UIColor *)itemSelectedTextColor
{
    _itemSelectedTextColor = itemSelectedTextColor;
}

@end



/***************************
 *****                 *****
 *****    BGModel      *****
 *****                 *****
 ****************************/
@implementation BGModel
@end




/***************************
 *****                 *****
 *****    BGCell       *****
 *****                 *****
 ****************************/
@implementation BGCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutIfNeeded];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

/** _titleLabel控件懒加载 -- 实质getter方法 */
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setModel:(BGModel *)model
{
    _model = model;
    _titleLabel.text = model.title;
    if (_model.hightLight) {
        self.titleLabel.textColor = model.itemSelectedTextColor ?: Color(150, 255, 31, 1.0);
    }else {
        self.titleLabel.textColor = model.itemTextColor ?: [UIColor blackColor];
    }
}


@end

/***************************
 *****                 *****
 *****  BGLayout       *****
 *****                 *****
 ****************************/
@implementation BGLayout
- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 0.0f;
}
//控制缩放
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 1.获取当前显示cell的布局
    NSArray *attrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        // 2.计算中心点距离
        CGFloat delta = fabs((attr.center.y - self.collectionView.contentOffset.y) - self.collectionView.bounds.size.height * 0.5);
        // 3.计算比例
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.height * 0.5) * 0.35;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attrs;
}

//定位中心点
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat collectionH = self.collectionView.bounds.size.height;
    // 最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    CGRect targetRect = CGRectMake(0, targetP.y, MAXFLOAT, collectionH);
    NSArray *attrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:targetRect] copyItems:YES];
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat delta = (attr.center.y - targetP.y) - self.collectionView.bounds.size.height * 0.5;
        if (fabs(delta) < fabs(minDelta)) {
            minDelta = delta;
        }
    }
    targetP.y += minDelta;
    if (targetP.y < 0) {
        targetP.y = 0;
    }
    return targetP;
}

// 在滚动的时候是否允许刷新布局 Invalidate:刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end


