//
//  BGViewController.m
//  BGPickerView
//
//  Created by iOSzhb on 05/08/2014.
//  Copyright (c) 2014 iOSzhb. All rights reserved.
//

#import "BGViewController.h"
#import "BGPickerView.h"

@interface BGViewController ()<BGPickerViewDataSource,BGPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) BGPickerView *pickerView;
@end

@implementation BGViewController
#pragma mark -- lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pickerView];

//    self.textField.inputView = self.pickerView;
}



#pragma mark -- SystemDelegate


#pragma mark -- CustomViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(BGPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(BGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? 10 : 20;
    
}
- (NSString *)pickerView:(BGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"测试%zd - %zd",component, row];
    
}

- (void)pickerView:(BGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"customPikerViewDidSelectedComponent componet:%zd - row:%zd", component, row);
    
}

- (void)pickerViewCompleteSelectedRows:(NSArray *)rows
{
//    NSLog(@"customPikerViewCompleteSelectedRows rows:%@", rows);
    [self.textField resignFirstResponder];
    
}

- (void)pickerViewCancelSelect
{
    [self.textField resignFirstResponder];
}
#pragma mark -- NetworkDelegate
///**
// *  网络请求成功回调
// */
//- (void)manager:(HYDBaseRequestManager *)manager didSuccessWithResponse:(APIURLResponse *)response{
//    [self endMJRefreshAnimation];
//    [self.mjTableView reloadData];
//}
//
///**
// *  网络请求失败回调
// */
//- (void)manager:(HYDBaseRequestManager *)manager didFailedWithError:(NSError *)error{
//    GMLogError(@"%@ request failed, and error info is: %@",[manager class], error.userInfo);
//    [self endMJRefreshAnimation];
//}
#pragma mark -- event response

#pragma mark -- public methods

#pragma mark -- private methods
- (void)layoutPageSubviews
{
    
}

#pragma mark -- getter & setter
- (BGPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[BGPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 220);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
//        _pickerView.itemTextColor = [UIColor blackColor];
//        _pickerView.itemSelectedTextColor = [UIColor redColor];
    }
    return _pickerView;
}


#pragma mark -- other
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}



///** _meKeyBoardView懒加载 -- 实质getter方法 */
//- (BGPickerView *)meKeyBoardView
//{
//    if (_meKeyBoardView == nil) {
//        _meKeyBoardView = [[BGPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
//        _meKeyBoardView.dataSource = self;
//        _meKeyBoardView.delegate = self;
//    }
//    return _meKeyBoardView;
//}


@end
