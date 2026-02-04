# Game Launcher Refactoring

## Overview
This refactoring transforms a 700+ line monolithic QML file into a clean, maintainable component-based architecture with professional theming support.

## Project Structure

```
game-launcher-refactor/
├── main.qml                          # Main application window (120 lines)
├── components/                        # Reusable UI components
│   ├── IconToolButton.qml            # Reusable icon button with hover states
│   ├── SearchBar.qml                 # Search bar with integrated controls
│   ├── GameCardDelegate.qml          # Grid view game card
│   └── GameListDelegate.qml          # List view game row
└── theme/                            # Centralized theming
    ├── Theme.qml                     # Theme singleton with all styling
    └── qmldir                        # QML module definition
```

## Key Changes

### 1. Component Separation

**IconToolButton.qml**
- Extracted reusable icon button pattern used by Add, Sort, and View buttons
- Handles hover/press states internally
- Exposes `buttonClicked()` and `checkedChanged()` signals
- Props: `iconSource`, `isCheckable`, `isChecked`

**SearchBar.qml**
- Encapsulates entire search bar UI including TextField and all toolbar buttons
- Contains internal state for view mode and sort direction
- Exposes high-level signals: `searchTextChanged`, `addClicked`, `sortToggled`, `viewToggled`
- Keeps implementation details hidden

**GameCardDelegate.qml**
- Grid view card component with poster, overlay, and info sections
- Handles all hover/press animations internally
- Exposes `cardClicked(game)` signal
- Requires `modelData` property

**GameListDelegate.qml**
- List view row component with thumbnail, metadata, and launch button
- Separate hover states for card and button
- Exposes `launchClicked(game)` and `rowClicked(game)` signals
- Requires `modelData` property

### 2. State Management

All application state remains in `main.qml`:
- `isGridView`: Current view mode (grid/list)
- `filterText`: Current search filter
- `sortAscending`: Sort direction

All C++ interactions happen in `main.qml`:
- `gameManager.displayGames` - game model
- `nameProxyModel.filterText` - filter updates
- `gameManager.setAscending()` - sort updates

Components are pure UI - they receive props and emit signals.

### 3. Theming System

**Theme.qml** - Singleton pattern for centralized styling

**Color Palette:**
- Background colors: `backgroundColor`, `surfaceColor`, `surfaceDark`, etc.
- Text colors: `textPrimary`, `textSecondary`, `textTertiary`, etc.
- Accent colors: `accentPrimary`, `accentHover`, `accentPressed`
- Overlay colors: `overlayDark` with opacity properties

**Typography:**
- Font sizes: `fontSizeSmall` (11px) to `fontSizeDisplay` (64px)
- Semantic naming for easy updates

**Spacing & Layout:**
- Spacing: `spacingTiny` to `spacingLarge`
- Padding: `paddingSmall` to `paddingLarge`
- Border radius: `radiusSmall`, `radiusMedium`, `radiusLarge`

**Component Dimensions:**
- Grid: `gridCellWidth`, `gridCellHeight`
- List: `listItemHeight`, `listImageSize`, `listButtonWidth`
- Controls: `controlBarHeight`, `searchBarWidth`

**Animation:**
- Durations: `durationFast` (100ms), `durationNormal` (150ms), `durationSlow` (200ms)

### 4. Benefits

**Maintainability:**
- Main file reduced from 700+ to ~120 lines
- Each component has single responsibility
- Easy to locate and modify specific UI elements

**Theming:**
- Change colors/sizes in one place (`Theme.qml`)
- Add new themes by creating alternative Theme.qml files
- No magic numbers scattered through code

**Reusability:**
- IconToolButton used 3 times with different props
- Delegates can be used in different contexts
- SearchBar can be reused in other views

**Testability:**
- Components can be tested in isolation
- Clear prop/signal contracts
- No hidden dependencies

## Usage

### Changing Theme Colors

Edit `theme/Theme.qml`:

```qml
readonly property color accentPrimary: "#ff6b6b"  // Red accent
readonly property color backgroundColor: "#1a1a1a"  // Darker background
```

### Adding New Theme

1. Create `theme/DarkTheme.qml` with different values
2. Update import in components: `import "../theme" as DarkTheme`
3. Reference: `DarkTheme.Theme.accentPrimary`

### Using Components

```qml
// In any QML file
import "components"

GameCardDelegate {
    modelData: myGameObject
    onCardClicked: function(game) {
        console.log("Clicked:", game.name)
    }
}
```

## Integration Guide

### For Your Existing Project

1. **Copy files to your project:**
   ```
   your-project/
   ├── main.qml
   ├── components/
   └── theme/
   ```

2. **Update QML import paths** in your `.pro` or `CMakeLists.txt`:
   ```qmake
   QML_IMPORT_PATH += $$PWD/theme
   ```

3. **Keep your existing C++ code** - no changes needed:
   - `gameManager` object
   - `nameProxyModel` object
   - `displayGames` model
   - All C++ methods remain the same

4. **Resource file** - ensure icons are in resources:
   ```xml
   <qresource prefix="/icons">
       <file>icon_add.svg</file>
       <file>icon_sort.svg</file>
       <file>icon_grid_view_outline.svg</file>
       <file>icon_list_view.svg</file>
   </qresource>
   ```

5. **Replace your old main.qml** with the new one

## Component API Reference

### IconToolButton
**Props:**
- `iconSource: string` - Path to icon resource
- `isCheckable: bool` - Whether button is checkable
- `isChecked: bool` - Initial checked state

**Signals:**
- `buttonClicked()` - Emitted on click
- `checkedChanged(bool checked)` - Emitted when check state changes

### SearchBar
**Props:**
- `placeholderText: string` - TextField placeholder

**Signals:**
- `searchTextChanged(string text)` - Search text changed
- `addClicked()` - Add button clicked
- `sortToggled(bool ascending)` - Sort button toggled
- `viewToggled(bool isGridView)` - View button toggled

### GameCardDelegate
**Props:**
- `modelData: var` - Game object with properties: `name`, `posterUrl`, `playtimeMin`, `dateAdded`

**Signals:**
- `cardClicked(var game)` - Card clicked

### GameListDelegate
**Props:**
- `modelData: var` - Game object with properties: `name`, `posterUrl`, `playtimeMin`, `dateAdded`, `lastPlayed`

**Signals:**
- `launchClicked(var game)` - Launch button clicked
- `rowClicked(var game)` - Row clicked

## Future Enhancements

**Easy to add:**
- Settings panel to switch themes at runtime
- Multiple theme files (Light, Dark, High Contrast)
- Customizable grid cell sizes via Theme
- Accessibility features (font scaling)
- Animation toggle for performance

**Component additions:**
- GameDetailsView component
- FilterDropdown component
- ContextMenu component
- SettingsDialog component

## Migration Checklist

- [x] Extract IconToolButton component
- [x] Extract SearchBar component
- [x] Extract GameCardDelegate component
- [x] Extract GameListDelegate component
- [x] Create Theme singleton
- [x] Move all state to main.qml
- [x] Preserve C++ integration points
- [x] Reduce main.qml to ~120 lines
- [x] Document component APIs
- [x] Create integration guide

## Notes

- **No runtime changes** - Application behaves identically to original
- **Type safety** - Using `required property` for mandatory props
- **Performance** - No additional overhead, same rendering path
- **Qt version** - Compatible with Qt 5.15+ and Qt 6.x
- **Theme is a singleton** - Imported once, shared across all components
