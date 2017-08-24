//
//  AgeVC.m
//  MyPickView
//
//  Created by Daibin on 2017/8/24.
//  Copyright © 2017年 com.yiyou. All rights reserved.
//

#import "AgeVC.h"
#import "AgeModel.h"

#define Navigation_Height 64
#define  IPHONE_WIDTH     [UIScreen mainScreen].bounds.size.width

@interface AgeVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *_yearArray;
    NSMutableArray *_mothArray;
    NSMutableArray *_dayArray ;
    UIView *_view;

}
@property (nonatomic,strong) UILabel *ageLabel;     //年龄
@property (nonatomic,strong) UILabel *constlLabel;   //星座
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic,strong) AgeModel *model;
@end

@implementation AgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"生日选择器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_yearArray removeAllObjects];
    [_mothArray removeAllObjects];
    [_dayArray removeAllObjects];
    [_pickerView removeFromSuperview];
}

- (void)setupView
{
//    YiWanAccount *_account = [YiWanAccount currentAccount];
//    NSDate *_date = [NSDate dateWithTimeIntervalSince1970:_account.birthday];
//    
//    NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
//    [formatter setLocale:[NSLocale    currentLocale]];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *_time = [formatter stringFromDate:_date];
//    NSArray *array  = [_time componentsSeparatedByString:@"-"];
    
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Navigation_Height+15, IPHONE_WIDTH, 70)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *AgLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,  10, 60, 20)];
    AgLabel.text = @"年龄";
    AgLabel.textColor = [UIColor blackColor];
    AgLabel.textAlignment = NSTextAlignmentCenter;
    AgLabel.font = [UIFont systemFontOfSize:15.0f];
    [bgView addSubview:AgLabel];
    
    _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,  10, IPHONE_WIDTH - 100, 20)];
    _ageLabel.font = [UIFont systemFontOfSize:15.0f];
    _ageLabel.textAlignment = NSTextAlignmentCenter;
    _ageLabel.textColor = [UIColor blackColor];
    [bgView addSubview:self.ageLabel];
    
    UILabel *costLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 60, 20)];
    costLabel.text = @"星座";
    costLabel.textColor = [UIColor blackColor];
    costLabel.textAlignment = NSTextAlignmentCenter;
    costLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [bgView addSubview:costLabel];
    
    _constlLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, IPHONE_WIDTH - 100, 20)];
    _constlLabel.textColor = [UIColor blackColor];
    _constlLabel.font = [UIFont systemFontOfSize:15.0f];
    _constlLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.constlLabel];
    
    UIView *sepView  = [[UIView alloc]initWithFrame:CGRectMake(10, 35, IPHONE_WIDTH-20, 1.0f)];
    sepView.backgroundColor = [UIColor grayColor];
    [bgView addSubview:sepView];
    
    
    [self.view addSubview:bgView];

}
- (void)initData
{
    NSArray *array = [self getsystemtime];
    self.model = [[AgeModel alloc]init];
    self.model.year = array[0];
    self.model.moth = array[1];
    self.model.day = array[2];
    _yearArray = [NSMutableArray array];
    NSString *yearSystem = array[0];    int yearCount = [yearSystem intValue];
    for (int i = 1970; i<yearCount+1; i++) {
        NSString *year = [NSString stringWithFormat:@"%d",i];
        [_yearArray addObject:year];
    }
    _mothArray = [NSMutableArray array];
    for (int i = 1; i<13; i++) {
        NSString *moth = [NSString stringWithFormat:@"%d",i];
        [_mothArray addObject:moth];
    }
    _dayArray = [NSMutableArray array];
    for (int i = 1; i<32; i++) {
        NSString *day = [NSString stringWithFormat:@"%d",i];
        [_dayArray addObject:day];
    }



}

-(void)initView {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 260, IPHONE_WIDTH, 40)];
    NSArray *array = @[@"年",@"月",@"日"];
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width)/3)*i, 0, IPHONE_WIDTH/3, 40)];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:22];
        label.textAlignment = NSTextAlignmentCenter ;
        [self createBorderView:label];
        [_view addSubview:label];
    }
    [self.view addSubview:_view];
    NSArray *array1 = [self getsystemtime];
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 300, IPHONE_WIDTH, 162)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    NSString  *yearRow = array1[0];
    int year = [yearRow intValue]-1970;
    
    NSString *mothStr = array1[1];
    int moth = [mothStr intValue];
    
    NSString *dayStr = array1[2];
    int day = [dayStr intValue];
    //  设置默认选中日期
    [self.pickerView selectRow:year inComponent:0 animated:YES];
    [self.pickerView selectRow:(moth-1) inComponent:1 animated:YES];
    [self.pickerView selectRow:(day-1) inComponent:2 animated:YES];
    
    [self.view addSubview:self.pickerView];
    
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(100, 400, 80, 35);
    btn.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(self.pickerView.frame)+40);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn setTitle:@"确定" forState:0];
    [btn setBackgroundImage:[UIImage imageNamed:@"but7_off.png"] forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    //刷新UIPickerView
    [self.pickerView reloadAllComponents];
}
//   选择日期回调
-(void)btnClick{
    //     self.calendarblock (self.model);
    
    
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:[self.model.moth integerValue]];
    [comp setDay:[self.model.day integerValue]];
    [comp setYear:[self.model.year integerValue]];
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *Date1 = [myCal dateFromComponents:comp];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:0];
    
    NSTimeInterval _timer = [ Date1 timeIntervalSinceDate:date2];
    
    NSDate *date3 = [[NSDate alloc]init];
    NSTimeInterval _timer3  =  [date3 timeIntervalSince1970];
    
    if (_timer3 < _timer) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择的时间不对" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:sureAction];
        
    }else
    {
       
      //选择正确的操作;
        
        
        
    }
    
}
#pragma mark pickerviewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  _yearArray.count;
    } else if(component==1){
        
        return  _mothArray.count;
    }
    return _dayArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return  self.view.frame.size.width/3;
    } else if(component==1){
        return  self.view.frame.size.width/3;
    }
    return  self.view.frame.size.width/3;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH/3, 30)];
    
    text.font = [UIFont systemFontOfSize:20];
    text.textAlignment = NSTextAlignmentCenter;
    if (component==0) {
        text.text = [_yearArray objectAtIndex:row];
    }
    if (component==1) {
        text.text = [_mothArray objectAtIndex:row];
    }
    if (component==2) {
        text.text = [_dayArray objectAtIndex:row];
    }
    [view addSubview:text];
    
    return view;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = @"";
    if (component==0) {
        str = [_yearArray objectAtIndex:row];
    }
    if (component==1) {
        str = [_mothArray objectAtIndex:row];
    }
    if (component==2) {
        str = [_dayArray objectAtIndex:row];
    }
    return str;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = @"";
    if (component==0) {
        str = [_yearArray objectAtIndex:row];
    }
    if (component==1) {
        str = [_mothArray objectAtIndex:row];
    }
    if (component==2) {
        str = [_dayArray objectAtIndex:row];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.model.year = [_yearArray objectAtIndex:row];
        
    }
    if (component==1) {
        self.model.moth = [_mothArray objectAtIndex:row];
        
    }
    if (component==2) {
        self.model.day = [_dayArray objectAtIndex:row];
    }
    
    
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:[self.model.moth integerValue]];
    [comp setDay:[self.model.day integerValue]];
    [comp setYear:[self.model.year integerValue]];
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *Date1 = [myCal dateFromComponents:comp];
    
    
    _ageLabel.text = [NSString stringWithFormat:@"%ld",[self ageWithDateOfBirth:Date1]];
    
    _constlLabel.text = [self constellationSelectWithMonth:[self.model.moth intValue] day:[self.model.day intValue]];
    
    
}

#pragma mark - 创建边框
-(void)createBorderView:(UILabel*)lab{
    
    lab.layer.borderWidth = 0.5;
    //    // 设置圆角
    lab.layer.cornerRadius = 4.5;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 214.0/255.0, 214.0/255.0, 214.0/255.0, 1 });
    lab.layer.borderColor = borderColorRef;
    lab.backgroundColor = [UIColor whiteColor];
    
}

// 获取系统时间
-(NSArray*)getsystemtime{
    
    NSDate *date = [NSDate date];
    NSTimeInterval  sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *na = [df stringFromDate:currentDate];
    return [na componentsSeparatedByString:@"-"];
    
}

//计算年龄
- (NSInteger)ageWithDateOfBirth:(NSDate *)date
{
    NSDateComponents *copmponents1 = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay|kCFCalendarUnitMonth|kCFCalendarUnitYear fromDate:date];


    NSInteger brithDateYear = [copmponents1 year];
    NSInteger brithDateMonth = [copmponents1 month];
    NSInteger brithDateDay = [copmponents1 day];
    

     NSDateComponents *copmponents2 = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay|kCFCalendarUnitMonth|kCFCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger currentDateYear = [copmponents2 year];
    NSInteger currentDateMonth = [copmponents2 month];
    NSInteger currentDateDay = [copmponents2 day];
    
    
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    
    if ((currentDateMonth > brithDateMonth)||(currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;

}

//计算星座
- (NSString *)constellationSelectWithMonth:(int)month   day:(int)day
{
    
    
    NSString *astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*3-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*3, 3)]];
    
    
    return result;
    
    
}



@end
