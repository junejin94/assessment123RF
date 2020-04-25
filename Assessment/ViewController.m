//
//  ViewController.m
//  Assessment
//
//  Created by Phua on 24/04/2020.
//  Copyright © 2020 123RF. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.context = [[MTIContext alloc] initWithDevice:MTLCreateSystemDefaultDevice() error:nil];

    self.button2x2.tintColor = UIColor.labelColor;
    self.button3x3.tintColor = UIColor.labelColor;
    self.buttonApplyFilter.tintColor = UIColor.labelColor;
    self.buttonClearCanvas.tintColor = UIColor.labelColor;
    self.buttonLoadImage.tintColor = UIColor.labelColor;

    self.button2x2.backgroundColor = UIColor.systemGray6Color;
    self.button3x3.backgroundColor = UIColor.systemGray6Color;
    self.buttonApplyFilter.backgroundColor = UIColor.systemGray6Color;
    self.buttonClearCanvas.backgroundColor = UIColor.systemGray6Color;
    self.buttonLoadImage.backgroundColor = UIColor.systemGray6Color;
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
        case GRAPHIC_OPTION_CLEAR_CANVAS:
            [self clearCanvas];
            break;
        case GRAPHIC_OPTION_LOAD_IMAGE:
            [self loadImage:[UIImage imageNamed:@"image.jpg"] Index:-1];
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
                    CALayer *square = [self generateSquare:length PositionX:MARGIN + (MARGIN + LINE_WIDTH + length) * i PositionY:MARGIN + (MARGIN + LINE_WIDTH + length) * j];

                    dispatch_async(serial, ^{
                        [array addObject:square];
                    });
                });
            }
        }

        dispatch_group_notify(group, serial, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.canvas.layer.contents = nil;
                self.canvas.layer.sublayers = nil;

                for (CALayer *layer in array) {
                    [self.canvas.layer addSublayer:layer];
                }
            });
        });
    });
}

#pragma mark - Methods (Load Image into CALayer)
- (void)loadImage:(UIImage *)image Index:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array = self.canvas.layer.sublayers;

        if (array.count) {
            for (CALayer *layer in array) {
                layer.contents = nil;
            }

            CALayer *layer = index >= 0 ? array[index] : array[arc4random() % array.count];

            layer.contents = (id) image.CGImage;
        } else {
            self.canvas.layer.contents = (id) image.CGImage;
        }
    });
}

- (void)clearCanvas {
    self.canvas.layer.contents = nil;
    self.canvas.layer.sublayers = nil;
}

#pragma mark - Methods (Apply Filter)
- (void)applyFilter {
    BOOL hasImageInCanvas = self.canvas.layer.contents;

    NSArray *array = self.canvas.layer.sublayers;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (array.count) {
            for (int i = 0 ; i < array.count ; i++) {
                CALayer *layer = array[i];

                if (layer.contents) {
                    [self loadImage:[self applyFilterToImage] Index:i];

                    break;
                }
            }
        } else if (hasImageInCanvas) {
            [self loadImage:[self applyFilterToImage] Index:0];
        }
    });
}

#pragma mark - Methods (Helper)
- (CALayer *)generateSquare:(NSInteger)length PositionX:(NSInteger)positionX PositionY:(NSInteger)positionY {
    CALayer *layer = [CALayer layer];

    layer.frame = CGRectMake(positionX, positionY, length, length);
    layer.borderWidth = LINE_WIDTH;
    layer.borderColor = UIColor.labelColor.CGColor;

    return layer;
}

- (UIImage *)applyFilterToImage {
    MTIImage *image = [[MTIImage alloc] initWithCGImage:[UIImage imageNamed:@"image.jpg"].CGImage options:nil];

    image = [image imageWithCachePolicy:MTIImageCachePolicyTransient];

    MTIVibranceFilter *vibranceFilter = [MTIVibranceFilter new];

    vibranceFilter.amount = VIBRANCE_FILTER_AMOUNT;
    vibranceFilter.inputImage = image;

    MTIImage *postVirbanceFilterImage = vibranceFilter.outputImage;

    MTICLAHEFilter *claheFilter = [MTICLAHEFilter new];

    claheFilter.inputImage = postVirbanceFilterImage;

    MTIImage *postClaheFilterImage = claheFilter.outputImage;

    CGImageRef ref = [self.context createCGImageFromImage:postClaheFilterImage error:nil];

    UIImage *postProcessedImage = [[UIImage alloc] initWithCGImage:ref];

    CFRelease(ref);

    return postProcessedImage;
}

@end
