#import "ViewController.h"
#import "Tile.h"

static int const kNumTiles = 5;
static int const kWidth    = 60;
static int const kHeight   = 60;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s: image %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGSize(_imageView.image.size));
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        tile.frame = CGRectMake(
                                (i + .5) * kWidth,
                                self.view.bounds.size.height - kHeight,
                                kWidth,
                                kHeight);
        
        [self.view addSubview:tile];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    float minScale = MIN(
                         _scrollView.frame.size.width / _imageView.image.size.width,
                         _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    float zoomScale = _scrollView.frame.size.width / _imageView.image.size.width;
    
    float maxScale = MAX(
                         2 * _scrollView.frame.size.width / _imageView.image.size.width,
                         2 * _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = maxScale;
    _scrollView.zoomScale = zoomScale;

    _scrollView.contentSize = _imageView.frame.size;
    
    NSLog(@"%s: _scrollView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.frame.origin),
          NSStringFromCGSize(_scrollView.frame.size));
    
    NSLog(@"%s: _imageView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_imageView.frame.origin),
          NSStringFromCGSize(_imageView.frame.size));
    
    NSLog(@"%s: minScale=%f zoomScale=%f maxScale=%f width=%f height=%f",
          __PRETTY_FUNCTION__,
          minScale,
          zoomScale,
          maxScale,
          (_scrollView.frame.size.width / _imageView.image.size.width),
          (_scrollView.frame.size.height / _imageView.image.size.height));
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (IBAction)scrollViewDoubleTapped:(UITapGestureRecognizer*)sender
{
    CGPoint pointInView = [sender locationInView:_imageView];
    
    float zoomScale = _scrollView.frame.size.width / _imageView.image.size.width;
    if (_scrollView.zoomScale <= zoomScale) {
        zoomScale *= 2;
    }
    
    CGSize size = _scrollView.bounds.size;

    CGFloat w = size.width / zoomScale;
    CGFloat h = size.height / zoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rect = CGRectMake(x, y, w, h);
    [_scrollView zoomToRect:rect animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
