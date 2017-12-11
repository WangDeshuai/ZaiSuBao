//
//  MineVC.m
//  NewProjects
//
//  Created by feijiu_1 on 2017/12/7.
//  Copyright © 2017年 DSOperation. All rights reserved.
//

#import "MineVC.h"
#import "MineCell.h"
#import "LoginVC.h"//登录页
#import "BasicInforMationVC.h"//基本信息
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong) UIImageView * imageview;
@property(nonatomic,strong)NSArray * imageArray;
@property(nonatomic,assign) CGRect  imageRect;
@end

@implementation MineVC
static const CGFloat headHeight =160;
static const CGFloat ratio =0.6;


- (void)viewWillAppear:(BOOL)animated{
    
// 设置导航栏背景透明(取值范围0~1)
   [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Personal center";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.backHomeBtn.hidden=YES;
    [self CreatBgImageView];
    [self CreatData];
    [self CreatTabelView];
}
#pragma mark ------创建控件-----------
//数据源
-(void)CreatData{
   NSArray * arr1=@[@"Published Infomation",@"View Records",@"My Privilege",@"Member Purchase",@"Purchase History"];
    NSArray * arr2=@[@"Basic Information",@"Change Password",@"Launch The Current Account"];
    NSArray * image1 =@[@"mine_0",@"mine_1",@"mine_2",@"mine_3",@"mine_4"];
    NSArray * image2=@[@"mine_5",@"mine_6",@"mine_7"];
    _dataArray=@[arr1,arr2];
    _imageArray=@[image1,image2];
}


//创建背景拉伸图
-(void)CreatBgImageView{
    _imageview =[UIImageView new];
    _imageview.image=[UIImage imageNamed:@"mine_bg"];
    _imageview.frame=CGRectMake(0, 0, ScreenWidth, ScreenWidth*ratio);
    _imageRect=_imageview.frame;
    [self.view addSubview:_imageview];
    //头像
    UIButton * headBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.backgroundColor=[UIColor yellowColor];
    [headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:0 placeholderImage:[UIImage imageNamed:@"mine_head"]];
    headBtn.sd_cornerRadius=@(40);
    [_imageview sd_addSubviews:@[headBtn]];
    headBtn.sd_layout
    .centerXEqualToView(_imageview)
    .topSpaceToView(_imageview, 10+64)
    .widthIs(80)
    .heightIs(80);
    //名字
    UILabel * namelabel =[UILabel new];
    namelabel.text=@"Alexandra";
    namelabel.textColor=[UIColor whiteColor];
    if (@available(iOS 8.2, *)) {
        namelabel.font=[UIFont systemFontOfSize:17 weight:.3];
    } else {
    }
    [_imageview sd_addSubviews:@[namelabel]];
    namelabel.sd_layout
    .topSpaceToView(headBtn, 10)
    .centerXEqualToView(headBtn)
    .heightIs(20);
    [namelabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth];
    
    //副标题(名字下面label)
    UILabel * namelabel2=[UILabel new];
    namelabel2.text=@"Memvership level 3";
    namelabel2.textColor=[[UIColor whiteColor]colorWithAlphaComponent:.5];
    if (@available(iOS 8.2, *)) {
        namelabel2.font=[UIFont systemFontOfSize:15 weight:.3];
    } else {
    }
    [_imageview sd_addSubviews:@[namelabel2]];
    namelabel2.sd_layout
    .topSpaceToView(namelabel, 5)
    .centerXEqualToView(headBtn)
    .heightIs(20);
    [namelabel2 setSingleLineAutoResizeWithMaxWidth:ScreenWidth];
    
    
}





//创建表头
-(UIView*)CraetTableViewHeader{
    UIView * headerView =[UIView new];
    headerView.backgroundColor=[UIColor clearColor];
    headerView.frame=CGRectMake(0, 0, ScreenWidth, headHeight);
    
    return headerView;
}

//创建tableView
-(void)CreatTabelView{
    UITableView * tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-53) style:UITableViewStylePlain];
    
    _tableView=tableView;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.tableFooterView=[UIView new];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.rowHeight=50;
    tableView.tableHeaderView=[self CraetTableViewHeader];
    [self.view addSubview:tableView];
}
#pragma mark -----表代理(tableViewDataSource--tableViewDelegate)
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell * cell =[MineCell cellWithTableView:tableView IndexPath:indexPath];
    cell.namelabel.text=_dataArray[indexPath.section][indexPath.row];
    [cell.leftImage setImage:[UIImage imageNamed:_imageArray[indexPath.section][indexPath.row]] forState:0];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[UIView new];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }  else{
        return 15;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
//        BasicInforMationVC * vc
    }
    
    
    LoginVC * vc =[LoginVC new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark ---ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<headHeight) {//向上滑offsetY+
        CGFloat aipat =offsetY/headHeight;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:aipat];
    }else{
         [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    }
    
    if (offsetY>0) {
        //往上移动
        _imageview.frame=({
            CGRect frame =_imageRect;
            frame.origin.y=_imageRect.origin.y-offsetY;
            frame;
        });
    }else
    {
        _imageview.frame=({
            CGRect frame=_imageRect;
            frame.size.height=_imageRect.size.height-offsetY;
            frame.size.width=frame.size.height/ratio;
            frame.origin.x=_imageRect.origin.x-(frame.size.width-_imageRect.size.width)/2;
            frame;
        });
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
