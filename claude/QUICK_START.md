# Quick Start Guide

## What Changed?

Your 700+ line `main.qml` has been refactored into:

1. **main.qml** (~120 lines) - Just the window and state management
2. **4 Components** - Reusable UI pieces
3. **Theme System** - All colors, fonts, and sizes in one place

## File Overview

```
├── main.qml                      ← Your main window (much smaller now!)
├── components/
│   ├── IconToolButton.qml       ← Reusable button (Add, Sort, View buttons)
│   ├── SearchBar.qml            ← The entire search bar
│   ├── GameCardDelegate.qml     ← Grid view card
│   └── GameListDelegate.qml     ← List view row
└── theme/
    ├── Theme.qml                ← All your colors, fonts, sizes
    └── qmldir                   ← Makes Theme a singleton
```

## Drop-In Replacement

**The refactored code is 100% compatible with your existing C++ code.**

It expects the same objects:
- `gameManager` (C++ object)
- `nameProxyModel` (C++ object)
- `gameManager.displayGames` (model)
- `gameManager.setAscending(bool)` (method)

**No C++ changes needed!**

## How to Use

### Step 1: Copy Files
Copy the entire `game-launcher-refactor` folder contents to your project.

### Step 2: Update Your .pro File
Add this line to your `.pro` file:
```qmake
QML_IMPORT_PATH += $$PWD/theme
```

### Step 3: Update Your qml.qrc
Use the provided `qml.qrc` or add these files to your existing one:
- main.qml
- components/*.qml
- theme/Theme.qml
- theme/qmldir

### Step 4: Make Sure Icons Are in Resources
Ensure these icon resources exist:
- `qrc:/icons/icon_add.svg`
- `qrc:/icons/icon_sort.svg`
- `qrc:/icons/icon_grid_view_outline.svg`
- `qrc:/icons/icon_list_view.svg`

### Step 5: Run!
No other changes needed. Your app will work exactly as before.

## Customizing

### Change Colors
Edit `theme/Theme.qml`:
```qml
readonly property color accentPrimary: "#YOUR_COLOR"
readonly property color backgroundColor: "#YOUR_COLOR"
```

### Change Sizes
Edit `theme/Theme.qml`:
```qml
readonly property int gridCellWidth: 250  // Bigger cards
readonly property int fontSizeLarge: 18   // Bigger text
```

### Change Animation Speed
Edit `theme/Theme.qml`:
```qml
readonly property int durationSlow: 300  // Slower animations
```

### Modify a Component
Each component is in its own file:
- Want to change grid cards? → Edit `components/GameCardDelegate.qml`
- Want to change search bar? → Edit `components/SearchBar.qml`

## Benefits

**Before:**
- 700 lines in one file
- Hard to find anything
- Colors/sizes duplicated everywhere
- Can't reuse components

**After:**
- Main file is 120 lines
- Each component in its own file
- All styling in one place
- Components are reusable

## Common Tasks

### Change the accent color from blue to red
```qml
// theme/Theme.qml
readonly property color accentPrimary: "#e74c3c"
readonly property color accentHover: "#c0392b"
readonly property color accentPressed: "#a93226"
```

### Make grid cards bigger
```qml
// theme/Theme.qml
readonly property int gridCellWidth: 250
readonly property int gridCellHeight: 350
```

### Change font everywhere
```qml
// theme/Theme.qml
readonly property int fontSizeNormal: 16      // was 14
readonly property int fontSizeLarge: 18       // was 16
readonly property int fontSizeXLarge: 20      // was 18
```

### Add a new component
1. Create `components/MyComponent.qml`
2. Import theme: `import "../theme"`
3. Use Theme values: `color: Theme.textPrimary`
4. Add to qml.qrc

## Troubleshooting

**"Theme is not defined"**
- Make sure `QML_IMPORT_PATH += $$PWD/theme` is in your .pro file
- Make sure `theme/qmldir` exists
- Clean and rebuild

**"Cannot find icon"**
- Check that icons are in your .qrc file under `/icons` prefix
- Check icon paths match: `qrc:/icons/icon_name.svg`

**"gameManager is not defined"**
- Make sure you're setting the C++ context in main.cpp
- The refactored code expects the same C++ setup as original

## What NOT to Change

**Don't modify these unless you know what you're doing:**
- `theme/qmldir` - Required for Theme singleton
- Component `required property` declarations - These define the API

## Need Help?

Check the full `README.md` for:
- Detailed component API reference
- Architecture explanation
- Integration guide
- Future enhancements

## Example: Making Cards Darker

**Original approach** (before refactoring):
- Search through 700 lines
- Find all `color: "#333"` instances
- Change each one manually
- Hope you didn't miss any

**New approach**:
1. Open `theme/Theme.qml`
2. Change `readonly property color cardBackground: "#333"` to `"#222"`
3. Done! All cards update automatically

This is the power of centralized theming! 🎨
