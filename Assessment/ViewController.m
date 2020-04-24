//
//  ViewController.m
//  Assessment
//
//  Created by Phua on 24/04/2020.
//  Copyright © 2020 123RF. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - IBAction
- (IBAction)buttonPressed:(id)sender {
    UIButton *button = (UIButton *) sender;

    GraphicOption tag = button.tag;

    switch (tag) {
        case GRAPHIC_OPTION_DRAW_2_X_2_SQUARE:
            [self drawSquares:2];
            break;
        case GRAPHIC_OPTION_DRAW_3_X_3_SQUARE:
            [self drawSquares:3];
            break;
        case GRAPHIC_OPTION_DRAW_APPLY_FILTER:
            [self applyFilter];
            break;
        default:
            break;
    }
}

#pragma mark - Methods (Draw)
- (void)drawSquares:(NSInteger)n {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger length = (CANVAS_HEIGHT - (MARGIN + LINE_WIDTH) * (n + 1)) / n;

        NSMutableArray *array = [NSMutableArray new];

        dispatch_group_t group = dispatch_group_create();

        dispatch_queue_t serial = dispatch_queue_create("com.123RF.Assessment", DISPATCH_QUEUE_SERIAL);

        for (int i = 0 ; i < n ; i++) {
            for (int j = 0 ; j < n ; j++) {
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    CAShapeLayer *square = [self generateSquare:length PositionX:MARGIN + (MARGIN + LINE_WIDTH + length) * i PositionY:MARGIN + (MARGIN + LINE_WIDTH + length) * j];

                    dispatch_async(serial, ^{
                        [array addObject:square];
                    });
                });
            }
        }

        dispatch_group_notify(group, serial, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.canvas.layer.sublayers = nil;

                for (CAShapeLayer *layer in array) {
                    [self.canvas.layer addSublayer:layer];
                }
            });
        });
    });
}

#pragma mark - Methods (Apply Filter)
- (void)applyFilter {
    //TODO: Apply Filter
}

#pragma mark - Methods (Helper)
- (CAShapeLayer *)generateSquare:(NSInteger)length PositionX:(NSInteger)positionX PositionY:(NSInteger)positionY {
    CAShapeLayer *square = [CAShapeLayer layer];

    square.lineWidth = LINE_WIDTH;
    square.fillColor = [self generateRandomColor];
    square.strokeColor = UIColor.blackColor.CGColor;
    square.path = [UIBezierPath bezierPathWithRect:CGRectMake(positionX, positionY, length, length)].CGPath;

    return square;
}

- (CGColorRef)generateRandomColor {
    CGFloat redValue = (CGFloat) arc4random() / UINT32_MAX;
    CGFloat greenValue = (CGFloat) arc4random() / UINT32_MAX;
    CGFloat blueValue = (CGFloat) arc4random() / UINT32_MAX;
    CGFloat alphaValue = (CGFloat) arc4random() / UINT32_MAX;

    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue].CGColor;
}



@end
