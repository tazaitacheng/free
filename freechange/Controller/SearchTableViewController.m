//
//  SearchViewController.m
//  Search
//
//  Created by lkjy on 16/5/16.
//  Copyright © 2016年 何健. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ZYPinYinSearch.h"
#import "ChineseString.h"

#define kColor  [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];

@interface SearchTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchResultsUpdating>

//模糊查询
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSArray *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/



@end



@implementation SearchTableViewController


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.backgroundColor = kColor;
    
    self.navigationItem.title = @"搜索框";
    [self.tableView setTableHeaderView:self.searchController.searchBar];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(10, 30, 23, 23);
//    [backBtn setImage:[UIImage imageNamed:@"btn_backItem"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goSearch)];
//    
//            self.navigationItem.leftBarButtonItem = leftItem;
//    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Init
- (void)initData
{
    _dataSource = @[@"成龙",@"梁山伯",@"Angel",@"长江1号",@"星爷",@"911",@"520ok",@"ren人",@"++family",@"中english9%+",@"武松",@"齐天大圣",@"曹操",@"林黛玉",@"Bob",@"夏勒特",@"神雕侠"];
    _searchDataSource = [NSMutableArray new];
    //获取索引的首字母
    _indexDataSource = [ChineseString IndexArray:_dataSource];
    //对原数据进行排序重新分组
    _allDataSource = [ChineseString LetterSortArray:_dataSource];
}

- (UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"搜索";
        //[_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return _indexDataSource.count;
    }else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        return [_allDataSource[section] count];
    }else
    {
        return _searchDataSource.count;
    }
}
//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.searchController.active)
    {
        return _indexDataSource[section];
    }else
    {
        return nil;
    }
}
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return _indexDataSource;
    }else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (!self.searchController.active)
    {
        cell.textLabel.text = _allDataSource[indexPath.section][indexPath.row];
    }else
    {
        cell.textLabel.text = _searchDataSource[indexPath.row];
    }
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [_searchDataSource removeAllObjects];
    NSArray *ary = [NSArray new];
    ary = [ZYPinYinSearch searchWithOriginalArray:_dataSource andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
    if (searchController.searchBar.text.length == 0) {
        [_searchDataSource addObjectsFromArray:_dataSource];
    }else {
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.tableView reloadData];
}



@end












