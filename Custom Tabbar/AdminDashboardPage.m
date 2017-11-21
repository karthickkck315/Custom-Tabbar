

#define SCROLLHEIGHT 58

#define VIEWHEIGHT 50

#define VIEWWIDTH 60

#define IMAGEHEIGHT 35

#define UNDERLINELABELHEIGHT 2.0

#define TEXTLABELHEIGHT 20

#define BUTTONCLICKHEIGHT 75

#define CELLHEIGTH 115

#define XPOSTION 5

#define LISTIMAGEHEIGHT 30

#define LABLEHEIGHT 25

#import "AdminDashboardPage.h"


@interface AdminDashboardPage ()
{
    int screensize;
    int selectedBtn;
    UIScrollView *scroll,*scroll2;
    NSArray *dataArray;
    NSMutableArray *menuListArray;
    NSMutableArray *menuImageArray;
}

@end

@implementation AdminDashboardPage

- (void)viewDidLoad {
    [super viewDidLoad];

    selectedBtn = 0;
    self.navigationController.navigationBarHidden = NO;
    menuListArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    
    menuImageArray = [[NSMutableArray alloc]initWithObjects:@"123",@"1.png",@"1.png",@"1.png",@"1.png",@"1.png",@"1.png",@"1.png", nil];
   
    screensize = self.view.frame.size.width;
    scroll = [[UIScrollView alloc]init];
    scroll.frame = CGRectMake(0, 64, screensize, 60);
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:scroll];
    
    scroll2 = [[UIScrollView alloc]init];
    scroll2.frame = CGRectMake(0, 250, screensize, 90);
    scroll2.translatesAutoresizingMaskIntoConstraints = NO;
    scroll2.showsHorizontalScrollIndicator = NO;
    scroll2.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:scroll2];
    
    [self setUpView];
    [self SetUpView2];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)SetUpView2{
    
    int x = 5;
    
    for (int i=0; i< menuListArray.count; i++) {
        
        UIView *bgview = [[UIView alloc]init];
        bgview.frame = CGRectMake(x, 5, VIEWWIDTH, VIEWHEIGHT+30);
        bgview.backgroundColor = [UIColor whiteColor];
        
        UIImageView *carimage = [[UIImageView alloc]init];
        carimage.frame = CGRectMake(0, 0, VIEWWIDTH, IMAGEHEIGHT);
        [carimage setImage:[UIImage imageNamed:[menuImageArray objectAtIndex:i]]];
        carimage.backgroundColor = [UIColor clearColor];
        carimage.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *underlinelbl = [[UILabel alloc]init];
        underlinelbl.frame = CGRectMake(0, carimage.frame.origin.y+carimage.frame.size.height+2, VIEWWIDTH, UNDERLINELABELHEIGHT);
        underlinelbl.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *textlbl = [[UILabel alloc]init];
        textlbl.frame = CGRectMake(0, underlinelbl.frame.origin.y+underlinelbl.frame.size.height, VIEWWIDTH, TEXTLABELHEIGHT);
        textlbl.text = [menuListArray objectAtIndex:i];
        textlbl.textColor = [UIColor blackColor];
        textlbl.textAlignment = NSTextAlignmentCenter;
        
        UILabel *numberlbl = [[UILabel alloc]init];
        numberlbl.frame = CGRectMake(0,textlbl.frame.origin.y+textlbl.frame.size.height ,VIEWWIDTH , TEXTLABELHEIGHT);
        numberlbl.text = [NSString stringWithFormat:@"%d",i];
        numberlbl.textAlignment = NSTextAlignmentCenter;
        
        UIButton *carname = [[UIButton alloc]init];
        carname.frame = CGRectMake(bgview.frame.origin.x, bgview.frame.origin.y, VIEWWIDTH, VIEWHEIGHT+30);
        carname.tag = i+1;
        [carname addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [carname setBackgroundColor:[UIColor clearColor]];
        
        if (i == 0) {
            carname.layer.borderWidth = 1.0f;
            carname.layer.borderColor = [UIColor darkGrayColor].CGColor;
        }
        
        [scroll2 addSubview:bgview];
        [bgview addSubview:carimage];
        [bgview addSubview:underlinelbl];
        [bgview addSubview:textlbl];
        [bgview addSubview:numberlbl];
        [scroll2 addSubview:carname];
        
        x += bgview.frame.size.width+5;
    }
    scroll2.contentSize = CGSizeMake( x+20, scroll2.frame.size.height);
    scroll2.backgroundColor = [UIColor redColor];
}
-(void)buttonclick:(id)sender{
    
    UIButton *selectedButton = (UIButton *)sender;
    selectedBtn = (int)selectedButton.tag-1;
    
    for (UIView *subView in scroll2.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            if (btn.tag == selectedButton.tag) {
                btn.layer.borderWidth = 1.0f;
                btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
            }else{
                btn.layer.borderWidth = 1.0f;
                btn.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
    }
    
}

-(void)setUpView{
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    int x = 5;
    
    for (int i=0; i< menuListArray.count; i++) {
        
        UIView *bgview = [[UIView alloc]init];
        bgview.frame = CGRectMake(x, 5, VIEWWIDTH, VIEWHEIGHT);
        bgview.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *textlbl = [[UILabel alloc]init];
        textlbl.frame = CGRectMake(0,VIEWHEIGHT/2-TEXTLABELHEIGHT/2-5, VIEWWIDTH, TEXTLABELHEIGHT);
        textlbl.font = [UIFont systemFontOfSize:10];
        textlbl.text = [menuListArray objectAtIndex:i];
        textlbl.textColor = [UIColor whiteColor];
        textlbl.textAlignment = NSTextAlignmentCenter;
        
        UILabel *numberlbl = [[UILabel alloc]init];
        numberlbl.frame = CGRectMake(0,textlbl.frame.origin.y+textlbl.frame.size.height ,VIEWWIDTH , TEXTLABELHEIGHT);
        numberlbl.text = [NSString stringWithFormat:@"%d",i];
        numberlbl.font = [UIFont systemFontOfSize:10];
        numberlbl.textColor = [UIColor whiteColor];
        numberlbl.textAlignment = NSTextAlignmentCenter;
        
        UIButton *carname = [[UIButton alloc]init];
        carname.frame = CGRectMake(bgview.frame.origin.x, bgview.frame.origin.y, VIEWWIDTH, VIEWHEIGHT);
        carname.tag = i+1;
        [carname addTarget:self action:@selector(buttonclick2:) forControlEvents:UIControlEventTouchUpInside];
        [carname setBackgroundColor:[UIColor clearColor]];
        
        UILabel *underlinelbl = [[UILabel alloc]init];
        underlinelbl.frame = CGRectMake(0, VIEWHEIGHT, VIEWWIDTH, UNDERLINELABELHEIGHT);
        
        if (i == 0) {
            underlinelbl.backgroundColor = [UIColor whiteColor];
        }
        
        [scroll addSubview:bgview];
        [bgview addSubview:underlinelbl];
        [bgview addSubview:textlbl];
        [bgview addSubview:numberlbl];
        [scroll addSubview:carname];
        
        x += bgview.frame.size.width+5;
    }
    scroll.contentSize = CGSizeMake( x+20, scroll.frame.size.height);
    scroll.backgroundColor = [UIColor blackColor];
}


-(void)buttonclick2:(id)sender{
    
    UIButton *selectedButton = (UIButton *)sender;
    selectedBtn = (int)selectedButton.tag-1;
    
    for (UIView *subView in scroll.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            
            UIView *lineView;
            UIView *lineView2;
            if (btn.tag == selectedButton.tag) {
                
                lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, UNDERLINELABELHEIGHT)];
                [btn addSubview:lineView];
                lineView.backgroundColor = [UIColor whiteColor];
                [lineView2 removeFromSuperview];
            }else{
                
                [lineView removeFromSuperview];
                lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, UNDERLINELABELHEIGHT)];
                [btn addSubview:lineView2];
                lineView2.backgroundColor = [UIColor blackColor];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
