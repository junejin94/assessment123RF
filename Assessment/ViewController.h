//
//  ViewController.h
//  Assessment
//
//  Created by Phua on 24/04/2020.
//  Copyright © 2020 123RF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetalPetal/MetalPetal.h>

#pragma mark - Enum (Options)
typedef NS_ENUM(NSInteger, GraphicOption) {
    GRAPHIC_OPTION_DRAW_2_X_2_SQUARE,
    GRAPHIC_OPTION_DRAW_3_X_3_SQUARE,
    GRAPHIC_OPTION_DRAW_APPLY_FILTER,
    GRAPHIC_OPTION_CLEAR_CANVAS,
    GRAPHIC_OPTION_LOAD_IMAGE
};

#pragma mark - Constant
static NSInteger const CANVAS_HEIGHT          = 400;
static NSInteger const CANVAS_WIDTH           = 400;
static NSInteger const MARGIN                 =  20;
static NSInteger const LINE_WIDTH             =   4;
static NSInteger const VIBRANCE_FILTER_AMOUNT =   2;

#pragma mark - Interface (View Controller)
@interface ViewController : UIViewController

@property (strong, nonatomic) MTIContext *context;

@property (weak, nonatomic) IBOutlet UIView *canvas;
@property (weak, nonatomic) IBOutlet UIButton *button2x2;
@property (weak, nonatomic) IBOutlet UIButton *button3x3;
@property (weak, nonatomic) IBOutlet UIButton *buttonApplyFilter;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoadImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonClearCanvas;

@end
