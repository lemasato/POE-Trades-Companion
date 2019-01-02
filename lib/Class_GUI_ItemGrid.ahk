/*
#Include H:\UserLibrary\Documents\GitHub\POE-Trades-Companion\lib\Class_Gui.ahk
#Include H:\UserLibrary\Documents\GitHub\POE-Trades-Companion\lib\EasyFuncs.ahk
#SingleInstance, Force
#Persistent
PROGRAM := {}
PROGRAM.OS := {}
PROGRAM.OS.RESOLUTION_DPI := 1

GUI_ItemGrid.Create(12, 6, "Shop 1", -1920, 0 , 1080, 0, 0, "Map")
*/


class GUI_ItemGrid {
/*  Function usage example:
        GUI_ItemGrid.Show(5, 2, "Shop", 0, 0, 1080)
        ^ Will show the location of an item at X5 Y2, tab name "Shop", in borderless fullscreen, with a H res of 1080 
        Make sure to always retrieve the Client height and not the window height.

    With as reference resolution 1920x1080 (only the height matters though):

    Grid starts at 17x 162y
    tab_xRoot           17 / 1080 = 0.01666666666666666666666666666667
    tab_yRoot           162 / 1080 = 0.15

    A square is 54x54
    tab_squareWRoot     54 / 1080 = 0.05
    
    To know where the grid starts for a specific resolution, we do (tab_xRoot * resH)
    Example. On a resolution of 800x600:
        The grid will start at px 10: (tab_xRoot * 600) = ~10
        A single square will be 30px: (tab_squareWRoot * 600) = 30
        The grid will end at px 642: 10 + (30 * 12) = 10 + 360 = 370


    = = = = = = = = = = = = = = = = = = = = = = = = 
    For quad tabs:
    tab_xRoot and tab_yRoot are the same
    tab_squareWRoot and tab_squareHRoot are divided by 2 

    = = = = = = = = = = = = = = = = = = = = = = = = 
    For map tabs:
    Grid starts at 45x 488y
    map_xRoot           45 / 1080 = 0.0416666666666667
    map_yRoot           488 / 1080 = 0.4518518518518519

    A square is 49x49
    map_squareWRoot     49 / 1080 = 0.0444444444444444

    ( UNUSED INFOS
        First row starts at: 44x198 (1 > 9)
        Second row starts at: 83x266 (10 > 16 + U)
        Square is 45x45
        Space of 21w between each square
        
        Maps row starts at 84x331
        Second row starts at 84x402
        Map is 57x58
        Space of 16w between each map tier
    )
*/
    static tab_xRoot := 0.0157407407407407
	static tab_yRoot := 0.15

    static tab_squareWRoot := 0.0490740740740741
    static tab_squareHRoot := 0.0490740740740741
    static tab_casesCountX := 12
    static tab_casesCountY := 12

    static quad_squareWRoot := 0.0490740740740741/2
    static quad_squareHRoot := 0.0490740740740741/2
    static quad_casesCountX := 24
    static quad_casesCountY := 24

    static stashTabHeightRoot := 0.025 ; 0,02666666666666666666666666666667

    static map_xRoot := 0.0416666666666667
    static map_yRoot := 0.4518518518518519
    static map_squareWRoot := 0.0444444444444444
    static map_squareHRoot := 0.0444444444444444
    static map_casesCountX := 12
    static map_casesCountY := 6

    static gridThicc := 2
    static tabThicc := 1

    Create(gridItemX, gridItemY, gridItemTab, winX, winY, winH, winBorderSide="", winBorderTop="", itemType="") {
        global PROGRAM
        global GuiItemGrid, GuiItemGrid_Controls, GuiItemGrid_Submit
        global GuiItemGridQuad, GuiItemGridQuad_Controls, GuiItemGridQuad_Submit
        global GuiItemGridTabName, GuiItemGridTabName_Controls, GuiItemGridTabName_Submit

        resDPI := Get_DpiFactor()
        winH := winH / resDPI ; os dpi fix
        winX := winX / resDPI ; os dpi fix
        winY := winY / resDPI ; os dpi fix

        ; Get default border size if unspecified
        ; SysGet, SM_CXSIZEFRAME, 32
        ; SysGet, SM_CYSIZEFRAME, 33
        ; SysGet, SM_CYCAPTION, 4
        ; winBorderTop := winBorderTop=""?SM_CYSIZEFRAME+SM_CYCAPTION : winBorderTop
        ; winBorderSide := winBorderSide=""?SM_CXSIZEFRAME : winBorderSide

        ; Set border size at 0 if unspecified (borderless)
        winBorderTop := winBorderTop?winBorderTop:0
        winBorderSide := winBorderSide?winBorderSide:0

        winBorderSide := winBorderSide / resDPI
        winBorderTop := winBorderTop / resDPI

        xStart := this.tab_xRoot * winH, yStart := this.tab_yRoot * winH ; Calc first case x/y start pos
        map_xStart := this.map_xRoot * winH, map_yStart := this.map_yRoot * winH 
        gridItemX--, gridItemY-- ; Minus one, so we can get correct case multiplier

        GUI_ItemGrid.Destroy()

        ; = = = = = = = = = = = = Regular tab = = = = = = = = = = = = 
        ; Only show normal tab grid if both X and Y are lower than the max case count
        if (gridItemX+1 <= this.tab_casesCountX) && (gridItemY+1 <= this.tab_casesCountY) {
            tab_caseW := this.tab_squareWRoot * winH, tab_caseH := this.tab_squareHRoot * winH ; Calc case w/h
            tab_stashX := xStart + (gridItemX * tab_caseW), tab_stashY := yStart + (gridItemY * tab_caseH) ; Calc point pos
            tab_stashXRelative := tab_stashX + winX, tab_stashYRelative := tab_stashY + winY ; Relative to win pos
            tab_stashXRelative += winBorderSide, tab_stashYRelative += winBorderTop ; Add win border
            tab_pointW := tab_caseW, tab_pointH := tab_caseH ; Make a square same size as stash square
            squareColor := "10c200"

            Gui.New("ItemGrid", "-Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu +HwndhGuiItemGrid", "ItemGrid")
            Gui.Color("ItemGrid", "EEAA99")
            WinSet, TransColor, EEAA99 254 ; 254 = need to be trans to allow clickthrough style
            Gui.Add("ItemGrid", "Progress", "x0 y0 w" tab_pointW " h" this.gridThicc " Background" squareColor) ; ^
            Gui.Add("ItemGrid", "Progress", "x" tab_pointW - this.gridThicc " y0 w" this.gridThicc " h" tab_pointH " Background" squareColor) ; > 
            Gui.Add("ItemGrid", "Progress", "x0 y" tab_pointH - this.gridThicc " w" tab_pointW " h" this.gridThicc " Background" squareColor) ; v 
            Gui.Add("ItemGrid", "Progress", "x0 y0 w" this.gridThicc " h" tab_pointH " Background" squareColor) ; <
            showNormalTabGrid := True 
        }
        ;= = = = = = = = = = = = Quad tab = = = = = = = = = = = = 
        quad_caseW := this.quad_squareWRoot * winH, quad_caseH := this.quad_squareHRoot * winH ; Calc case w/h
        quad_stashX := xStart + (gridItemX * quad_caseW), quad_stashY := yStart + (gridItemY * quad_caseH) ; Calc point pos
        quad_stashXRelative := quad_stashX + winX, quad_stashYRelative := quad_stashY + winY ; Relative to win pos
        quad_stashXRelative += winBorderSide, quad_stashYRelative += winBorderTop ; Add win border
        quad_pointW := quad_caseW, quad_pointH := quad_caseH ; Make a square same size as stash square
        squareColor := "10c200"

        Gui.New("ItemGridQuad", "-Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu +HwndhGuiItemGridQuad", "ItemGridQuad")
        Gui.Color("ItemGridQuad", "EEAA99")
        WinSet, TransColor, EEAA99 254
        Gui.Add("ItemGridQuad", "Progress", "x0 y0 w" quad_pointW " h" this.gridThicc " Background" squareColor) ; ^
        Gui.Add("ItemGridQuad", "Progress", "x" quad_pointW - this.gridThicc " y0 w" this.gridThicc " h" quad_pointH " Background" squareColor) ; > 
        Gui.Add("ItemGridQuad", "Progress", "x0 y" quad_pointH - this.gridThicc " w" quad_pointW " h" this.gridThicc " Background" squareColor) ; v 
        Gui.Add("ItemGridQuad", "Progress", "x0 y0 w" this.gridThicc " h" quad_pointH " Background" squareColor) ; <

        ; = = = = = = = = = = = = Stash tab name = = = = = = = = = = = = 
        guiFont := "Fontin Regular", guiFontSize := 12
        txtSize := Get_TextCtrlSize("Tab: " gridItemTab, guiFont, guiFontSize)
        tabName_guiW := txtSize.W+30, tabName_guiH := txtSize.H+10
        fontColor := "000000", backgroundColor := "B9B9B9", borderColor := "000000"

        stashTabHeight := this.stashTabHeightRoot*winH
        ; stashTabNameX := xStart, stashTabNameY := yStart + (this.tab_casesCountY * caseH) + 5 ; Position: Under all cases
        stashTabNameX := xStart, stashTabNameY := yStart - (this.stashTabHeightRoot*winH) - tabName_guiH - 5 ; Position: Above tabs
        stashTabNameX += winBorderSide, stashTabNameY += winBorderTop ; Add window border
        stashTabNameXRelative := stashTabNameX + winX, stashTabNameYRelative := stashTabNameY + winY ; Relative to win pos
       
        Gui.New("ItemGridTabName", "-Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu +HwndhGuiItemGridTabName", "ItemGridTabName")
        Gui.Font("ItemGridTabName", guiFont, guiFontSize)
        Gui.Color("ItemGridTabName", backgroundColor)
        Gui.Add("ItemGridTabName", "Progress", "x0 y0 w" tabName_guiW " h" this.tabThicc " Background" borderColor) ; ^
        Gui.Add("ItemGridTabName", "Progress", "x" tabName_guiW-this.tabThicc " y0 w" this.tabThicc " h" tabName_guiH " Background" borderColor) ; > 
        Gui.Add("ItemGridTabName", "Progress", "x0 y" tabName_guiH-this.tabThicc " w" tabName_guiW-this.tabThicc " h" this.tabThicc " Background" borderColor) ; v 
        Gui.Add("ItemGridTabName", "Progress", "x0 y0 w" this.tabThicc " h" tabName_guiH " Background" borderColor) ; <
        Gui.Add("ItemGridTabName", "Text", "x0 y0 cBlack Center BackgroundTrans w" tabName_guiW " h" tabName_guiH " 0x200 c" fontColor, "Tab: " gridItemTab)

        ; = = = = = = = = = = = = Map tab = = = = = = = = = = = = 
        if (itemType = "Map") && (gridItemX+1 <= this.map_casesCountX) && (gridItemY+1 <= this.map_casesCountY) {
            map_caseW := this.map_squareWRoot * winH, map_caseH := this.map_squareHRoot * winH ; Calc case w/h
            map_stashX := map_xStart + (gridItemX * map_caseW), map_stashY := map_yStart + (gridItemY * map_caseH) ; Calc point pos
            map_stashXRelative := map_stashX + winX, map_stashYRelative := map_stashY + winY ; Relative to win pos
            map_stashXRelative += winBorderSide, map_stashYRelative += winBorderTop ; Add win border
            map_pointW := map_caseW, map_pointH := map_caseH ; Make a square same size as stash square
            squareColor := "007ec2"

            Gui.New("ItemGridMap", "-Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu +HwndhGuiItemGridMap", "ItemGridMap")
            Gui.Color("ItemGridMap", "EEAA99")
            WinSet, TransColor, EEAA99 254
            Gui.Add("ItemGridMap", "Progress", "x0 y0 w" map_pointW " h" this.gridThicc " Background" squareColor) ; ^
            Gui.Add("ItemGridMap", "Progress", "x" map_pointW - this.gridThicc " y0 w" this.gridThicc " h" map_pointH " Background" squareColor) ; > 
            Gui.Add("ItemGridMap", "Progress", "x0 y" map_pointH - this.gridThicc " w" map_pointW " h" this.gridThicc " Background" squareColor) ; v 
            Gui.Add("ItemGridMap", "Progress", "x0 y0 w" this.gridThicc " h" map_pointH " Background" squareColor) ; <
            showMapTabGrid := True
        }

        ; = = = = = = = = = = = = Show = = = = = = = = = = = = 
        if (showNormalTabGrid) {
            Gui.Show("ItemGrid", "x" tab_stashXRelative*resDPI " y" tab_stashYRelative*resDPI " AutoSize NoActivate")
            Gui, ItemGrid:+LastFound
            WinSet, ExStyle, +0x20
        }
        Gui.Show("ItemGridQuad", "x" quad_stashXRelative*resDPI " y" quad_stashYRelative*resDPI " AutoSize NoActivate")
        Gui, ItemGridQuad:+LastFound
        WinSet, ExStyle, +0x20

        Gui.Show("ItemGridTabName", "x" stashTabNameXRelative*resDPI " y" stashTabNameYRelative*resDPI " w" tabName_guiW " h" tabName_guiH " NoActivate")
        Gui, ItemGridTabName:+LastFound
        WinSet, Transparent, 254
        WinSet, ExStyle, +0x20

        if (showMapTabGrid) {
            Gui.Show("ItemGridMap", "x" map_stashXRelative*resDPI " y" map_stashYRelative*resDPI " NoActivate")
            Gui, ItemGridMap:+LastFound
            WinSet, ExStyle, +0x20
        }
    }

    Destroy() {
        Gui, ItemGrid:Destroy
        Gui, ItemGridQuad:Destroy
        Gui, ItemGridTabName:Destroy
        Gui, ItemGridMap:Destroy
    }

    Detect(_hw="Off") {
        global GuiItemGrid, GuiItemGridQuad, GuiItemGridTabName

        hw := A_DetectHiddenWindows
        DetectHiddenWindows, %_hw%

        if WinExist("ahk_id " GuiItemGrid.Handle)
        || WinExist("ahk_id " GuiItemGridQuad.Handle)
        || WinExist("ahk_id " GuiItemGridTabName.Handle) 
        || WinExist("ahk_id " GuiItemGridMap.Handle) 
            exists := True
        else
            exists := False

        DetectHiddenWindows, %hw%
        return exists
    }

    IsVisible() {
        isVisible := GUI_ItemGrid.Detect(_hw:="Off")
        return isVisible
    }

    Exists() {
        exists := GUI_ItemGrid.Detect(_hw:="On")
        return exists
    }

    Hide() {
        if !GUI_ItemGrid.Exists()
            return

        Gui, ItemGrid:Hide 
        Gui, ItemGridQuad:Hide 
        Gui, ItemGridTabName:Hide 
        Gui, ItemGridMap:Hide 
    }

    Show() {
        if !GUI_ItemGrid.Exists()
            return

        Gui, ItemGrid:Show, NoActivate 
        Gui, ItemGridQuad:Show, NoActivate 
        Gui, ItemGridTabName:Show, NoActivate 
        Gui, ItemGridMap:Show, NoActivate 
    }
}
