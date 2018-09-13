//
//  SelectProjectViewController.m
//  mb
//
//  Created by hz on 2018/8/8.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import "SelectProjectViewController.h"
#import "LeftEqualFlowLayout.h"
#import "SelectProjectTableViewCell.h"
#import "SelectProjectCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <MBTips/MBTips.h>
#import "ProjectListModel.h"
#import <PromiseKit/PromiseKit.h>
#import <PromiseKit/NSURLConnection+PromiseKit.h>

typedef enum{
    allProjectButtonDefault = 0,//默认状态
    allProjectButtonSectlect = 1,
} allProjectButtonType;

//extern NSString * const YZUpdateMenuTitleNote;

@interface SelectProjectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIView *sectionView;
@property (strong, nonatomic) UIButton *allProjectButton;
@property (assign, nonatomic) allProjectButtonType allProjectButtonType;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSIndexPath *selectAreaIndexPath;
@end

@implementation SelectProjectViewController
{
    SelectProjectBlock _selectProjectBlock;
}

- (void)setAllProjectButtonType:(allProjectButtonType)allProjectButtonType
{
    _allProjectButtonType = allProjectButtonType;
    if (allProjectButtonType == allProjectButtonDefault)
    {
        [self.allProjectButton setTitleColor:UIColorMake(102, 102, 102) forState:UIControlStateNormal];
        [self.allProjectButton setBackgroundColor:[UIColor whiteColor]];
        self.allProjectButton.layer.borderWidth = 0.5;
        self.allProjectButton.layer.borderColor = UIColorMake(213, 213, 213).CGColor;
    }
    if (allProjectButtonType == allProjectButtonSectlect)
    {
        [self.allProjectButton setTitleColor:UIColorMake(255, 255, 255) forState:UIControlStateNormal];
        [self.allProjectButton setBackgroundColor:UIColorMake(252, 122, 123)];
        self.allProjectButton.layer.borderWidth = 0.5;
        self.allProjectButton.layer.borderColor = UIColorMake(252, 122, 123).CGColor;
    }
}
-(UIView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[UIView alloc] init];
        
        _allProjectButton = [UIButton new];
        _allProjectButton.contentEdgeInsets = UIEdgeInsetsMake(8, 14, 8, 14);
        _allProjectButton.titleLabel.font = UIFontMake(13);
        [_allProjectButton addTarget:self action:@selector(allProjectAction) forControlEvents:UIControlEventTouchUpInside];
        [_allProjectButton setTitle:@"全部" forState:UIControlStateNormal];
        CGSize size = [_allProjectButton intrinsicContentSize];
        _allProjectButton.layer.cornerRadius = size.height/2;
        self.allProjectButtonType = allProjectButtonDefault;
        
        [_sectionView addSubview:_allProjectButton];
        [_allProjectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(15);
        }];
        
    }
    return _sectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectAreaIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

#if API_DEV == 1 //测试地址(外网能访问)
    NSString *baseURL = @"http://ygapidev.meb.com";
#else
    NSString *baseURL = @"https://ygapi.meb.com";
#endif
    
    NSString *apiPath = @"api/app/v1.0/Project/Select";
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", baseURL, apiPath];
    
    [NSURLConnection GET:URL].then(^(NSDictionary *dic){
        
        if ([dic[@"Success"] boolValue])
        {
            return [PMKPromise promiseWithValue:dic[@"Content"]];
        }
        else
        {
            NSString *message = dic[@"Message"] ? : @"";
            NSError *error = [NSError errorWithDomain:URL code:[dic[@"StatusCode"] integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
            return [PMKPromise promiseWithValue:error];
        }
    })
    .then(^(NSArray *array){
        NSError *error;
        NSArray *datas = [ProjectListModel arrayOfModelsFromDictionaries:array error:&error];
        return [PMKPromise promiseWithAdapter:^(PMKAdapter adapter) {
            adapter(datas, error);
        }];
    })
    .then(^(id data){

        self.dataArray = [self structureDataArray:data];
        [self.tableView reloadData];

        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    })
    .catch(^(NSError *error){
        [MBTips showTipWithText:error.localizedDescription inView:self.view];
    });
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectProjectTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SelectProjectTableViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectProjectCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SelectProjectCollectionViewCell class])];
    //cell左对齐
    LeftEqualFlowLayout *flowlayou = [[LeftEqualFlowLayout alloc] init];
    flowlayou.minimumLineSpacing = 20;
    flowlayou.minimumInteritemSpacing = 11;
    flowlayou.sectionInset = UIEdgeInsetsMake(72, 15, 20, 20);
    self.collectionView.collectionViewLayout = flowlayou;
    
    [self addAllProjecetViewAction];
}

- (void)selectProjectAction:(SelectProjectBlock)projectBlock
{
    _selectProjectBlock = projectBlock;
}

#pragma tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectProjectTableViewCell class])];
    [cell loadData:self.dataArray[indexPath.row]];
    //选中状态
    if (self.selectAreaIndexPath.section == indexPath.row)
    {
        cell.styleView.hidden = NO;
        cell.titleLabel.textColor = UIColorMake(255,102,102);
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.styleView.hidden = YES;
        cell.titleLabel.textColor = UIColorMake(125,125,125);
        cell.titleLabel.backgroundColor = UIColorMake(245,245,245);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectAreaIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    //更新按钮文字
    [self updateAllprojectTitle];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self childProjectArrayWithIndex:self.selectAreaIndexPath].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SelectProjectCollectionViewCell class]) forIndexPath:indexPath];
    [cell loadData:[self childProjectArrayWithIndex:self.selectAreaIndexPath][indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListModel *model = [self childProjectArrayWithIndex:self.selectAreaIndexPath][indexPath.row];
    CGSize size = [self buttonSize:model.name];
    return CGSizeMake(size.width,36);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectAreaIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectAreaIndexPath.section];
    self.allProjectButtonType = allProjectButtonDefault;
    
    SelectProjectCollectionViewCell *mycell = (SelectProjectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    mycell.selected = !mycell.selected;
    
    ProjectListModel *model = [self childProjectArrayWithIndex:self.selectAreaIndexPath][indexPath.row];
    if (model.name.length) {
        // 更新菜单标题
//        [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":model.name}];
    }
    
    if (_selectProjectBlock)
    {
        _selectProjectBlock(model.name,model.id);
    }
}

- (NSArray *)childProjectArrayWithIndex:(NSIndexPath *)index
{
    if (self.dataArray.count > index.section)
    {
        //返回二级项目
        ProjectListModel *data = self.dataArray[index.section];
        return data.childs;
        
    }
    return nil;
}

#pragma mark - 添加全部按钮层
- (void)addAllProjecetViewAction
{
    [self.collectionView addSubview:self.sectionView];
    [self.sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_top).offset(0);
        make.left.mas_equalTo(self.collectionView.mas_left).offset(0);
        make.height.mas_offset(72);
        make.width.mas_offset(SCREEN_WIDTH * 0.68);
    }];
}


#pragma mark - 全部按钮的点击
- (void)allProjectAction
{
    self.allProjectButtonType = allProjectButtonSectlect;
    SelectProjectCollectionViewCell *mycell = (SelectProjectCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectAreaIndexPath.row inSection:0]];
    mycell.selected = NO;
    
    ProjectListModel *model = self.dataArray[self.selectAreaIndexPath.section];
    if (model.name.length) {
//        // 更新菜单标题
//        [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":model.name}];
    }

    if (_selectProjectBlock)
    {
        _selectProjectBlock(model.name,model.id);
    }
}

#pragma mark - 更新全部按钮的文字
- (void)updateAllprojectTitle
{
    self.allProjectButtonType = allProjectButtonDefault;
    
    ProjectListModel *model = self.dataArray[self.selectAreaIndexPath.section];

    if ([model.name isEqualToString:@"全部项目"])
    {
        [self.allProjectButton setTitle:@"全部项目" forState:UIControlStateNormal];
        return;
    }

    [self.allProjectButton setTitle:[NSString stringWithFormat:@"全部%@项目",model.name] forState:UIControlStateNormal];
    
}


/**
 处理数据添加全部项目选项

 @param array <#array description#>
 */
- (NSMutableArray *)structureDataArray:(NSArray *)array
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    ProjectListModel * allProjectModel = [[ProjectListModel alloc] init];
    allProjectModel.name = @"全部项目";
    allProjectModel.id = nil;
    
    [dataArray addObjectsFromArray:array];
    [dataArray insertObject:allProjectModel atIndex:0];
    
    return dataArray;
}


/**
 根据title返回button的size
 
 @param title 内容
 @return size
 */

- (CGSize )buttonSize:(NSString *)title
{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15);
    button.titleLabel.font = UIFontMake(13);
    return [button intrinsicContentSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
