//
//  ViewController.h
//  Assessment
//
//  Created by Phua on 24/04/2020.
//  Copyright © 2020 123RF. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Enum (Options)
typedef NS_ENUM(NSInteger, GraphicOption) {
    GRAPHIC_OPTION_DRAW_2_X_2_SQUARE,
    GRAPHIC_OPTION_DRAW_3_X_3_SQUARE,
    GRAPHIC_OPTION_DRAW_APPLY_FILTER,
};

#pragma mark - Constant
static NSInteger const CANVAS_HEIGHT = 400;
static NSInteger const CANVAS_WIDTH  = 400;
static NSInteger const MARGIN        =  20;
static NSInteger const LINE_WIDTH    =   4;

#pragma mark - Interface (View Controller)
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *canvas;

@end

