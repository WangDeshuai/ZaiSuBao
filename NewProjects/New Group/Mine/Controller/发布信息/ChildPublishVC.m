//
//  ChildPublishVC.m
//  NewProjects
//
//  Created by feijiu_1 on 2017/12/12.
//  Copyright © 2017年 DSOperation. All rights reserved.
//

#import "ChildPublishVC.h"
#import "ChildPublishCell.h"
#import "ChildPublishList.h"
@interface ChildPublishVC ()
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ChildPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BG_COLOR;
    _dataArray=[NSMutableArray array];
    [self CreatTableView];
}
#pragma mark --控件创建---------
-(void)CreatTableView{
    self.baseTableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-44);
   
    self.baseTableView.rowHeight=160;
    self.baseTableView.tableFooterView=[UIView new];
    self.baseTableView.backgroundColor=BG_COLOR;
    [self.view addSubview:self.baseTableView];
    [self.baseTableView.mj_header beginRefreshing];
}
-(void)mjHeaderRefresh
{
    self.current=1;
    [self getPublicMessage:self.current];
}

-(void)mjFooterRefresh
{
   [self getPublicMessage:++self.current];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildPublishCell * cell =[ChildPublishCell cellWithTableView:tableView IndexPath:indexPath];
    //
    [self tableViewCell:cell IndexPath:indexPath];
    //实现cell高度缓存
   [self.baseTableView useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
   
    return cell;
}


-(void)tableViewCell:(ChildPublishCell*)cell IndexPath:(NSIndexPath*)indexPath{
    cell.editBtn.tag=indexPath.row;
    cell.undoBtn.tag=indexPath.row;
     [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [cell.undoBtn addTarget:self action:@selector(undoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.model=_dataArray[indexPath.row];
    if (_type==1) {
        //通过的
        cell.namelabel.hidden=YES;
    
    }else{
        //审核中 未通过的
        [cell.undoBtn setTitle:@"Delete" forState:0];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChildPublishList * model =_dataArray[indexPath.row];
    if ([model.isStatus isEqualToString:@"4497003100040003"]) {
        return 180;
    }else{
       return  150;
    }

}



#pragma mark ----网络请求类-------
-(void)getPublicMessage:(NSInteger)page{
    [[Engine sharedEngine] BJPostWithUrl:Main_URL withAPIName:UserApi_PublicMessage withParame:@{@"page":[NSString stringWithFormat:@"%lu",page],@"auditStatus":[NSString stringWithFormat:@"%d",_type]} callback:^(id item) {
        NSString * code =[NSString stringWithFormat:@"%@",[item objectForKey:@"resultCode"]];
        if ([code isEqualToString:@"1"]) {
           
            if (self.current==1) {
                _dataArray=[NSMutableArray array];
            }
                NSArray * listArr =[item objectForKey:@"list"];
                for (NSDictionary * dic in listArr) {
                    [_dataArray addObject:[ChildPublishList modelObjectWithDictionary:dic]];
                }
           
            
             [self.baseTableView reloadData];
        }else{
            --self.current;
            [LCProgressHUD showFailure:[item objectForKey:@"resultMessage"]];
        }
         [self.baseTableView.mj_header endRefreshing];
         [self.baseTableView.mj_footer endRefreshing];
    } failedBlock:^(id error) {
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
    }];
    
    
}



#pragma mark -----按钮点击事件----------
//编辑
-(void)editBtnClick:(UIButton*)btn{
//    NSLog(@"点击了编辑>>type=%d---btn.tag=%lu",_type,(long)btn.tag);
    if (_type==0) {
        //第一个界面的编辑
          NSLog(@"点击了第一个界面的编辑");
    }else{
        //第二个界面的编辑
          NSLog(@"点击了第二个界面的编辑");
    }
    
    
}
//撤销
-(void)undoBtnClick:(UIButton*)btn{
   
    if (_type==0) {
        //第一个界面的撤销
        //1.找到对应的cell
        ChildPublishCell * cell =[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
        //2.隐藏undo按钮
        cell.undoBtn.hidden=YES;
        //3.修改editbtn的背景颜色
        cell.editBtn.backgroundColor=Main_Color;
        [cell.editBtn setTitle:@"Resend" forState:0];
        cell.editBtn.tag=btn.tag;
        [cell.editBtn setTitleColor:[UIColor whiteColor] forState:0];
        //4.重写editBtn按钮点击事件
    }else{
        //第二个界面的删除
        NSLog(@"点击了第二个界面的删除");
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
