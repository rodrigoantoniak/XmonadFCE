import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageHelpers (isDialog, isFullscreen, doCenterFloat, doFocus, doFullFloat, doRaise)
import XMonad.Util.SpawnOnce (spawnOnce)
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal      = "xfce4-terminal"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0022dd"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- take a screenshot
    , ((0,                  xK_Print ), spawn "xfce4-screenshooter")

    -- take a rectangle screenshot
    , ((shiftMask,          xK_Print ), spawn "xfce4-screenshooter -r")

    -- take a window screenshot
    , ((modm,               xK_Print ), spawn "xfce4-screenshooter -w")

    -- launch xfrun4
    , ((modm,              xK_Super_L), spawn "xfrun4")

    -- launch xfce4-popup-whiskermenu
    , ((0,                 xK_Super_L), spawn "xfce4-popup-whiskermenu")

    -- launch XFCE Screen Settings
    , ((shiftMask,         xK_Super_L), spawn "xfce4-display-settings --minimal")

    -- launch xfce4-appfinder
    , ((modm,               xK_p     ), spawn "xfce4-appfinder")

    -- launch catfish
    , ((modm .|. shiftMask, xK_p     ), spawn "catfish")

    -- launch VLC
    , ((modm,               xK_v     ), spawn "vlc")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Shift the windows until the focused one gets to the master area
    , ((modm,               xK_Tab   ), windows W.shiftMaster )

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown )

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Launch Thunar
    , ((modm              , xK_f     ), spawn "thunar")

    -- Launch the browser (in this case, LibreWolf)
    , ((modm              , xK_b     ), spawn "librewolf")

    -- Quit xfce4-session
    , ((modm .|. shiftMask, xK_q     ), spawn "xfce4-session-logout --logout")

    -- Manage xfce4-session
    , ((modm              , xK_q     ), spawn "xfce4-session-logout")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
    
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = manageDocks <+> composeAll
    [ resource  =? "galculator"              --> doCenterFloat
    , resource  =? "xfrun4"                  --> doCenterFloat
    , resource  =? "xfce4-appfinder"         --> doCenterFloat
    , resource  =? "catfish"                 --> doCenterFloat
    , className =? "Wrapper-2.0"             --> doCenterFloat
    , isDialog                               --> doCenterFloat
    , resource  =? "xfce4-popup-whiskermenu" --> doFloat
    , resource  =? "xfce4-panel"             --> doIgnore <+> doRaise
    , resource  =? "xfce4-notifyd"           --> doIgnore
    , resource  =? "xfdesktop"               --> doIgnore
    , resource  =? "xfce4-screensaver"       --> doIgnore
    , isFullscreen                           --> doFocus ]

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
        spawnOnce "compton &"
        spawnOnce "xfce4-panel --restart &"

------------------------------------------------------------------------

main = xmonad $ ewmhFullscreen . ewmh $ docks $ xfceConfig
    { terminal           = myTerminal
    , focusFollowsMouse  = myFocusFollowsMouse
    , clickJustFocuses   = myClickJustFocuses
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor

     -- key bindings
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
     
     -- hooks, layouts
    , layoutHook         = myLayout
    , manageHook         = myManageHook
    , startupHook        = myStartupHook
    }
