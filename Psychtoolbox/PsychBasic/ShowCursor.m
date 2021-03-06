function oldType = ShowCursor(type, screenid, mouseid)
% oldType = ShowCursor([type][, screenidOrWindow=0][, mouseid])
%
% ShowCursor redisplays the mouse pointer after a previous call to HideCursor.
%
% If the optional 'type' is specified, it also allows to alter the shape of the
% cursor. Note that this function may not have any effect if the cursor location
% is not on top of an open onscreen window, as cursor visibility or shape may not
% be under Psychtoolbox control while the cursor interacts with other desktop
% items.
%
% 'screenidOrWindow' allows to specify the screen or onscreen window to which
% the function should apply. Although optional, it is strongly recommended to
% provide this parameter for cross-platform compatibility across operating systems.
%
% The optional 'mouseid' allows to select which mouse cursor shall be redisplayed
% or changed in visual appearance. This only makes sense if you have multiple
% visible mouse cursors, and it is a Linux/X11 only feature.
%
% The return value 'oldType' is always zero, as this query mechanism is not
% supported with PTB-3. Just returned for backwards-compatibility.
%
% Cursor shape can be selected. These types are defined by name:
%
% 'Arrow' = Standard mouse-pointer arrow.
% 'CrossHair' = A cross-hair cursor.
% 'Hand' = A hand symbol.
% 'SandClock' = Some sort of sand clock/hour-glass (not available on OSX).
% 'TextCursor' = A text selection/caret placement cursor (AKA I Beam).
%
% Apart from those names, you can pass integral numbers for 'type' to select
% further shapes. The mapping of numbers to shapes is operating system
% dependent, and therefore not portable across different platforms. On
% MS-Windows, you can select between number 0 to 13. On Linux/X11 you can
% select from a wide range of numbers from 0 up to (at least) 152, maybe
% more, depending on your setup. See the C header file "X11/cursorfont.h"
% for a mapping of numbers to shapes. Passing invalid numbers can create
% errors. On Linux with Wayland backend, you can pass custom additional
% namestrings as 'type'.
%
% LINUX: ____________________________________________________________________
%
% Linux allows for display and handling of multiple mouse cursors if your
% X-Server is of version 1.7 or later, or if you use the Wayland display
% backend on a modern Wayland server.
%
% OSX: ______________________________________________________________________
%
% If provided, an optional numeric 'type' argument changes the cursor shape to:
%
%   0: Arrow  = like 'Arrow'
%   4: I Beam = like 'TextCursor'
%   5: Cross  = like 'CrossHair'
%  10: Hand   = like 'Hand'
%
% Better use the names for cross platform portability!
%
% Windows: __________________________________________________________________
%
% If provided, an optional numeric 'type' argument changes the cursor shape to:
%
%   0: Arrow (IDC_ARROW)
%   1: Crosshair (IDC_CROSS)
%   2: Hand (IDC_HAND)
%   3: Four-pointed arrow pointing north, south, east, and west (IDC_SIZEALL)
%   4: Double-pointed arrow pointing north and south (IDC_SIZENS)
%   5: Double-pointed arrow pointing west and east (IDC_SIZEWE)
%   6: Hourglass (IDC_WAIT)
%   7: Slashed circle (IDC_NO)
%   8: I-beam (IDC_IBEAM)
%   9: Double-pointed arrow pointing northeast and southwest (IDC_SIZENESW)
%  10: Double-pointed arrow pointing northwest and southeast (IDC_SIZENWSE)
%  11: Standard arrow and small hourglass (IDC_APPSTARTING)
%  12: Arrow and question mark (IDC_HELP)
%  13: Vertical arrow (IDC_UPARROW)
% ___________________________________________________________________________

% 7/23/97  dgp Cosmetic editing.
% 8/15/97  dgp Explain hide/show counter.
% 3/15/99  xmz Added comments for PC version.
% 8/19/00  dgp Cosmetic.
% 4/14/03  awi ****** OS X-specific fork from the OS 9 version *******
%               Added call to Screen('ShowCursor'...) for OS X.
% 7/12/04  awi Divided into sections by platform.
% 11/16/04 awi Renamed Screen("ShowCursor") to Screen("ShowCursorHelper").
% 10/4/05  awi Note here that dgp made unnoted cosmetic changes between 11/16/04 and 10/4/05.
% 09/21/07 mk  Added code for selecting 'type' - the shape of a cursor - on supported systems.
% 08/14/14 dcn Fixed typo and simplified
% 01/13/15 mk  Update help text to match reality better, esp. OSX.
% 05/19/15 dcn Adding 'TextCursor' as now supported on all platforms.
% 03/30/20 dcn Added other standard Windows cursors.

% We default to setup of display screen zero, if no
% screenid provided. This argument is ignored on
% Windows and OS/X anyway. Only meaningful for
% Linux with X11. Linux with Wayland ignores screenid.

if nargin < 2 || isempty(screenid)
    screenid = 0;
end

if nargin < 3
    mouseid = [];
end

% Default to: No change in cursor shape...
if nargin < 1
    type = [];
else
    % Cursor shape change requested as well. Mapping of
    % types to shapes is highly OS dependent...
    if ischar(type)
        % Name string provided. We can map a few symbolic names to proper
        % id's for the different operating systems:
        if strcmpi(type, 'Arrow');
            % True for Windows and OS/X:
            type = 0;
            
            if IsLinux
                type = 2;
            end
        end
        
        if strcmpi(type, 'CrossHair');
            % True for Windows:
            type = 1;
            
            if IsOSX
                type = 5;
            end
            
            if IsLinux
                type = 34;
            end
        end

        if strcmpi(type, 'Hand');
            % True for Windows:
            type = 2;
            
            if IsOSX
                type = 10;
            end

            if IsLinux
                type = 58;
            end
        end

        if strcmpi(type, 'SandClock');
            % True for Windows:
            type = 6;
            
            if IsOSX
                type = 7;
            end

            if IsLinux
                type = 26;
            end
        end

        if strcmpi(type, 'TextCursor');
            % True for Windows:
            type = 8;
            
            if IsOSX
                type = 4;
            end

            if IsLinux
                type = 1;
            end
        end

        % Linux + Wayland allows passing name strings for cursors, on other
        % setups still having a unremapped string means failure:
        if ischar(type) && (~IsLinux || ~IsWayland)
            error('Unknown ''type'' shape specification passed to ShowCursor()!');
        end
    elseif ~isnumeric(type)
        error('type argument provided to ShowCursor() was not numeric or text');
    end
end

% Return a dummy oldtype, we don't have this info...
oldType = 0;

% Use Screen to emulate ShowCursor.mex
Screen('ShowCursorHelper', screenid, type, mouseid);
