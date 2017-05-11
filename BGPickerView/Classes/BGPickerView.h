//
//  BGPickerView.h
//  BGPickerView
//
//  Created by iOSzhb on 05/08/2014.
//  Copyright (c) 2014 iOSzhb. All rights reserved.
//


#import <UIKit/UIKit.h>
@class BGPickerView;
@protocol BGPickerViewDataSource;
@protocol BGPickerViewDelegate;



@interface BGPickerView : UIView

@property (nonatomic, weak) id<BGPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<BGPickerViewDelegate>   delegate;

//以下所有属性都有默认值.
@property (nonatomic, copy) NSString *cancelText; //提示文字 默认：“请选择”
@property (nonatomic, strong) UIFont *cancelFont; //提示文字字体
@property (nonatomic, strong) UIColor *cancelColor; //提示文字颜色

@property (nonatomic, copy) NSString *sureText;  //按钮文字 默认：“完成”
@property (nonatomic, strong) UIFont *sureTextFont; //按钮文字字体
@property (nonatomic, strong) UIColor *sureTextColor; //按钮文字颜色

@property (nonatomic, strong) UIColor *indicatorColor; //指示器颜色

//待用
@property (nonatomic, strong) UIColor *itemTextColor; //选项文字颜色
@property (nonatomic, strong) UIColor *itemSelectedTextColor; //选项选中文字颜色

- (void)reloadComponent:(NSInteger)component; // 刷新某一组
- (void)reloadAllComponents; // 刷新所有组


@end



/***************************
 *****                 *****
 *****    dataSource   *****
 *****                 *****
 ****************************/
@protocol BGPickerViewDataSource <NSObject>

@optional;
- (NSInteger)numberOfComponentsInPickerView:(BGPickerView *)pickerView;
- (NSInteger)pickerView:(BGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(BGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;





@end


/***************************
 *****                 *****
 *****    delegate     *****
 *****                 *****
 ****************************/
@protocol BGPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(BGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerViewCancelSelect; // 完成选择 (点击完成按钮)
- (void)pickerViewCompleteSelectedRows:(NSArray *)rows; // 完成选择 (点击完成按钮) 返回所有选中行的索引数组

@end

