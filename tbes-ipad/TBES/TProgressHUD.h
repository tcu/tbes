/*

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
 
*/

/* ---------------------------------------------------------------------------
 ** Texas Christian University
 **
 ** TProgressHUD.h
 ** TBES
 **
 ** Created on 12/4/12
 ** Kenneth Leising 
 ** Catherine Urbano 
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol TProgressHUDDelegate;


typedef enum {
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
	TProgressHUDModeIndeterminate,
	/** Progress is shown using a round, pie-chart like, progress view. */
	TProgressHUDModeDeterminate,
	/** Progress is shown using a ring-shaped progress view. */
	TProgressHUDModeAnnularDeterminate,
	/** Shows a custom view */
	TProgressHUDModeCustomView,
	/** Shows only labels */
	TProgressHUDModeText
} TProgressHUDMode;

typedef enum {
	/** Opacity animation */
	TProgressHUDAnimationFade,
	/** Opacity + scale animation */
	TProgressHUDAnimationZoom
} TProgressHUDAnimation;


#ifndef T_STRONG
#if __has_feature(objc_arc)
#define T_STRONG strong
#else
#define T_STRONG retain
#endif
#endif

#ifndef T_WEAK
#if __has_feature(objc_arc_weak)
#define T_WEAK weak
#elif __has_feature(objc_arc)
#define T_WEAK unsafe_unretained
#else
#define T_WEAK assign
#endif
#endif


/** 
 * Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
 *
 * This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
 * The TProgressHUD window spans over the entire space given to it by the initWithFrame constructor and catches all
 * user input on this region, thereby preventing the user operations on components below the view. The HUD itself is
 * drawn centered as a rounded semi-transparent view which resizes depending on the user specified content.
 *
 * This view supports four modes of operation:
 * - TProgressHUDModeIndeterminate - shows a UIActivityIndicatorView
 * - TProgressHUDModeDeterminate - shows a custom round progress indicator
 * - TProgressHUDModeAnnularDeterminate - shows a custom annular progress indicator
 * - TProgressHUDModeCustomView - shows an arbitrary, user specified view (@see customView)
 *
 * All three modes can have optional labels assigned:
 * - If the labelText property is set and non-empty then a label containing the provided content is placed below the
 *   indicator view.
 * - If also the detailsLabelText property is set then another label is placed below the first label.
 */
@interface TProgressHUD : UIView

/**
 * Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
 * 
 * @param view The view that the HUD will be added to
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 * @return A reference to the created HUD.
 *
 * @see hideHUDForView:animated:
 * @see animationType
 */
+ (TProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview and hides it. The counterpart to this method is showHUDAddedTo:animated:.
 *
 * @param view The view that is going to be searched for a HUD subview.
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @return YES if a HUD was found and removed, NO otherwise. 
 *
 * @see showHUDAddedTo:animated:
 * @see animationType
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds all the HUD subviews and hides them. 
 *
 * @param view The view that is going to be searched for HUD subviews.
 * @param animated If set to YES the HUDs will disappear using the current animationType. If set to NO the HUDs will not use
 * animations while disappearing.
 * @return the number of HUDs found and removed.
 *
 * @see hideAllHUDForView:animated:
 * @see animationType
 */
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview and returns it. 
 *
 * @param view The view that is going to be searched.
 * @return A reference to the last HUD subview discovered.
 */
+ (TProgressHUD *)HUDForView:(UIView *)view;

/**
 * Finds all HUD subviews and returns them.
 *
 * @param view The view that is going to be searched.
 * @return All found HUD views (array of TProgressHUD objects).
 */
+ (NSArray *)allHUDsForView:(UIView *)view;

/** 
 * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
 * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
 * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 *
 * @see animationType
 */
- (void)show:(BOOL)animated;

/** 
 * Hide the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 *
 * @see animationType
 */
- (void)hide:(BOOL)animated;

/** 
 * Hide the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @param delay Delay in secons until the HUD is hidden.
 *
 * @see animationType
 */
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/** 
 * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
 *
 * This method also takes care of autorelease pools so your method does not have to be concerned with setting up a
 * pool.
 *
 * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread.
 * @param target The object that the target method belongs to.
 * @param object An optional object to be passed to the method.
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will not use
 * animations while (dis)appearing.
 */
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

/** 
 * A convenience constructor that initializes the HUD with the window's bounds. Calls the designated constructor with
 * window.bounds as the parameter.
 *
 * @param window The window instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the window that the HUD will be added to).
 */
- (id)initWithWindow:(UIWindow *)window;

/**
 * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
 * view.bounds as the parameter
 * 
 * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the view that the HUD will be added to).
 */
- (id)initWithView:(UIView *)view;

/** 
 * TProgressHUD operation mode. The default is TProgressHUDModeIndeterminate.
 *
 * @see TProgressHUDMode
 */
@property (assign) TProgressHUDMode mode;

/**
 * The animation type that should be used when the HUD is shown and hidden. 
 *
 * @see TProgressHUDAnimation
 */
@property (assign) TProgressHUDAnimation animationType;

/**
 * The UIView (e.g., a UIImageView) to be shown when the HUD is in TProgressHUDModeCustomView.
 * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds). 
 */
@property (T_STRONG) UIView *customView;

/** 
 * The HUD delegate object. 
 *
 * @see TProgressHUDDelegate
 */
@property (T_WEAK) id<TProgressHUDDelegate> delegate;

/** 
 * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
 * set to @"", then no message is displayed.
 */
@property (copy) NSString *labelText;

/** 
 * An optional details message displayed below the labelText message. This message is displayed only if the labelText
 * property is also set and is different from an empty string (@""). The details text can span multiple lines. 
 */
@property (copy) NSString *detailsLabelText;

/** 
 * The opacity of the HUD window. Defaults to 0.9 (90% opacity). 
 */
@property (assign) float opacity;

/** 
 * The x-axis offset of the HUD relative to the centre of the superview. 
 */
@property (assign) float xOffset;

/** 
 * The y-ayis offset of the HUD relative to the centre of the superview. 
 */
@property (assign) float yOffset;

/**
 * The amounth of space between the HUD edge and the HUD elements (labels, indicators or custom views). 
 * Defaults to 20.0
 */
@property (assign) float margin;

/** 
 * Cover the HUD background view with a radial gradient. 
 */
@property (assign) BOOL dimBackground;

/*
 * Grace period is the time (in seconds) that the invoked method may be run without 
 * showing the HUD. If the task finishes before the grace time runs out, the HUD will
 * not be shown at all. 
 * This may be used to prevent HUD display for very short tasks.
 * Defaults to 0 (no grace time).
 * Grace time functionality is only supported when the task status is known!
 * @see taskInProgress
 */
@property (assign) float graceTime;

/**
 * The minimum time (in seconds) that the HUD is shown. 
 * This avoids the problem of the HUD being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 */
@property (assign) float minShowTime;

/**
 * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
 * If you don't set a graceTime (different than 0.0) this does nothing.
 * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
 * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
 * you need to set this property when your task starts and completes in order to have normal graceTime 
 * functionality.
 */
@property (assign) BOOL taskInProgress;

/**
 * Removes the HUD from its parent view when hidden. 
 * Defaults to NO. 
 */
@property (assign) BOOL removeFromSuperViewOnHide;

/** 
 * Font to be used for the main label. Set this property if the default is not adequate. 
 */
@property (T_STRONG) UIFont* labelFont;

/** 
 * Font to be used for the details label. Set this property if the default is not adequate. 
 */
@property (T_STRONG) UIFont* detailsLabelFont;

/** 
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0. 
 */
@property (assign) float progress;

/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
 */
@property (assign) CGSize minSize;

/**
 * Force the HUD dimensions to be equal if possible. 
 */
@property (assign, getter = isSquare) BOOL square;

@end


@protocol TProgressHUDDelegate <NSObject>

@optional

/** 
 * Called after the HUD was fully hidden from the screen. 
 */
- (void)hudWasHidden:(TProgressHUD *)hud;

@end


/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
@interface TRoundProgressView : UIView 

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end
