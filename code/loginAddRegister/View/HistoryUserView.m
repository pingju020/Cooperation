//
//  HistoryUserView.m
//  anhui
//
//  Created by Points on 15/6/5.
//  Copyright (c) 2015年 Education. All rights reserved.
//

#import "HistoryUserView.h"

@implementation HistoryUserView

- (id)initWithFrame:(CGFloat)maxY withArr:(NSArray *)arr isTeacher:(BOOL)isTeacher
{
    if(self = [super initWithFrame:MAIN_FRAME])
    {
        
        self.m_isTeacher = isTeacher;
        self.userInteractionEnabled = YES;
        
        if (arr && arr.count>0) {
            self.m_arrData = arr;
        }else{
           [self getArrHistoryUsers]; 
        }

        m_table = [[UITableView alloc]initWithFrame:CGRectMake(0, maxY, MAIN_WIDTH, self.m_arrData.count*40) style:UITableViewStylePlain];
        m_table.scrollEnabled = NO;
        [m_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        m_table.dataSource = self;
        m_table.delegate = self;
        [self addSubview:m_table];
        [self setBackgroundColor:[UIColor clearColor]];
        [m_table reloadData];
    }
    return self;
}

- (instancetype)initWithMaxY:(CGFloat)maxY
{
    return [self initWithFrame:maxY withArr:nil isTeacher:YES];
}

- (void)getArrHistoryUsers
{
    NSArray *arr = nil;//[sqliteADO queryAllUser];
    /*
    NSMutableArray *arrTet = [NSMutableArray array];
    for(NSDictionary *info in arr)
    {
        if(self.m_isTeacher)
        {
            if([info[@"userType"] integerValue] == 1)
            {
                [arrTet addObject:info];
            }
        }
        else
        {
            if([info[@"userType"] integerValue] == 3)
            {
                [arrTet addObject:info];
            }
        }
    }
    */
    //倒序输出 最新的放在前面
    arr = [[arr reverseObjectEnumerator] allObjects];
    
    self.m_arrData = arr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *contact = [self.m_arrData objectAtIndex:indexPath.row];
    static NSString * identify = @"ChatHis";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:VcBackgroudColor];

    UILabel *userLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, MAIN_WIDTH-120, 20)];
    [userLab setBackgroundColor:[UIColor clearColor]];
    [userLab setTextAlignment:NSTextAlignmentLeft];
    [userLab setText:contact[@"userName"]];
    [userLab setTextColor:UIColorFromRGB(0x828282)];
    [userLab setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:userLab];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setFrame:CGRectMake(MAIN_WIDTH-40, 5, 30, 30)];
     deleteBtn.tag = indexPath.row;
    [deleteBtn setImage:[UIImage imageNamed:@"login_delete@2x"] forState:UIControlStateNormal];
    [cell addSubview:deleteBtn];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *contact = [self.m_arrData objectAtIndex:indexPath.row];
    [self.m_delegate onSelectContactWith:contact[@"userName"] withPwd:contact[@"passWord"] withUrl:contact[@"headUrl"]];
    [self removeself];
}

- (void)deleteBtnClicked:(UIButton *)btn
{
    NSDictionary *contact = [self.m_arrData objectAtIndex:btn.tag];
    [self.m_delegate onDeleteContact:contact[@"userName"]];
    
    [self getArrHistoryUsers];
    m_table.height = _m_arrData.count*40;
    [m_table reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeself];
}


- (void)removeself
{
    [self.m_delegate onRemoveSelf];
    [self removeFromSuperview];

}

@end
