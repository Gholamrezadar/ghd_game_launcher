// GHDChart.qml
//
// A reusable time-series chart component supporting line and bar modes.
//
// Required data format (set via the `model` property):
//   [ { timestamp: <Date>, value: <number> }, ... ]
//
// Usage example:
//   GHDChart {
//       anchors.fill: parent
//       model:        myDataArray
//       plotMode:     GHDChart.PlotMode.Bar
//       title:        "Daily Playtime"
//       yUnit:        "Hours"
//       yMax:         10
//   }

import QtQuick 2.15

Item {
    id: root

    // ── Public API ────────────────────────────────────────────────────────────

    // Data: array of { timestamp: Date, value: number }
    property var model: []

    // Plot style
    enum PlotMode { Line, Bar }
    property int plotMode: GHDChart.PlotMode.Line

    // Labels
    property string title:      "Trend"
    property string yUnit:      ""
    property string xUnit:      "days ago"   // used in x-axis labels

    // Y axis — leave yMax as 0 to auto-scale
    property real yMin:         0
    property real yMax:         0            // 0 = auto
    property real yTickStep:    0            // 0 = auto (targets ~5 ticks)
    property int  yDecimals:    0

    // X axis — how many tick labels to show (evenly spaced)
    property int  xTickCount:   7

    // Margins
    property int marginLeft:    70
    property int marginRight:   30
    property int marginTop:     48
    property int marginBottom:  60

    // Colors
    property color bgColor:         "transparent"
    property color gridColor:       "#1F2937"
    property color axisColor:       "#6B7280"
    property color tickLabelColor:  "#9CA3AF"
    property color titleColor:      "#F9FAFB"
    property color seriesColor:     "#3B82F6"
    property color seriesHoverColor:"#60A5FA"
    property color tooltipBg:       "#1F2937"
    property color tooltipBorder:   "#374151"
    property color tooltipText:     "#F9FAFB"

    // Geometry
    property int  lineWidth:    3
    property int  dotRadius:    4
    property real barFillRatio: 0.6          // 0..1, fraction of slot used by bar
    property int  barMinWidth:  2

    // Fonts
    property string fontFamily: "Sans"
    property int    fontSize:   12
    property int    titleSize:  18

    // ── Internals ─────────────────────────────────────────────────────────────

    // Repaints whenever any visual property changes
    onModelChanged:           canvas.requestPaint()
    onPlotModeChanged:        canvas.requestPaint()
    onTitleChanged:           canvas.requestPaint()
    onYUnitChanged:           canvas.requestPaint()
    onXUnitChanged:           canvas.requestPaint()
    onYMinChanged:            canvas.requestPaint()
    onYMaxChanged:            canvas.requestPaint()
    onYTickStepChanged:       canvas.requestPaint()
    onYDecimalsChanged:       canvas.requestPaint()
    onXTickCountChanged:      canvas.requestPaint()
    onMarginLeftChanged:      canvas.requestPaint()
    onMarginRightChanged:     canvas.requestPaint()
    onMarginTopChanged:       canvas.requestPaint()
    onMarginBottomChanged:    canvas.requestPaint()
    onBgColorChanged:         canvas.requestPaint()
    onGridColorChanged:       canvas.requestPaint()
    onAxisColorChanged:       canvas.requestPaint()
    onTickLabelColorChanged:  canvas.requestPaint()
    onTitleColorChanged:      canvas.requestPaint()
    onSeriesColorChanged:     canvas.requestPaint()
    onSeriesHoverColorChanged:canvas.requestPaint()
    onLineWidthChanged:       canvas.requestPaint()
    onDotRadiusChanged:       canvas.requestPaint()
    onBarFillRatioChanged:    canvas.requestPaint()
    onBarMinWidthChanged:     canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent

        // Hit-test cache — populated every paint
        property var _hitCache: []   // line: {x,y,r,…}  bar: {x,y,w,h,cx,cy,…}

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            // ── Background ───────────────────────────────────────────────────
            ctx.fillStyle = root.bgColor
            ctx.fillRect(0, 0, width, height)

            if (!root.model || root.model.length === 0) return

            var pts = root.model.map(p => ({ x: p.timestamp, y: p.value }))

            // ── Resolve axis ranges ──────────────────────────────────────────
            var minX = Math.min.apply(null, pts.map(p => p.x.getTime()))
            var maxX = Math.max.apply(null, pts.map(p => p.x.getTime()))
            if (minX === maxX) { minX -= 86400000; maxX += 86400000 }

            var dataMin = Math.min.apply(null, pts.map(p => p.y))
            var dataMax = Math.max.apply(null, pts.map(p => p.y))

            var resolvedYMin = root.yMin
            var resolvedYMax = (root.yMax > 0) ? root.yMax : _niceMax(dataMax)
            if (resolvedYMax <= resolvedYMin) resolvedYMax = resolvedYMin + 1

            var resolvedStep = (root.yTickStep > 0)
                ? root.yTickStep
                : _niceStep(resolvedYMin, resolvedYMax, 5)

            var cW = width  - root.marginLeft - root.marginRight
            var cH = height - root.marginTop  - root.marginBottom

            // ── Mapping helpers ──────────────────────────────────────────────
            var slotMs = pts.length > 1 ? (maxX - minX) / (pts.length - 1) : 86400000
            var padMs  = slotMs * 0.5

            function mapX(t) {
                return root.marginLeft + (t - (minX - padMs)) / ((maxX + padMs) - (minX - padMs)) * cW
            }
            function mapY(v) {
                return height - root.marginBottom
                    - (v - resolvedYMin) / (resolvedYMax - resolvedYMin) * cH
            }

            var baseY = height - root.marginBottom

            // ── Y grid + labels ──────────────────────────────────────────────
            ctx.font = root.fontSize + "px " + root.fontFamily
            ctx.textAlign = "right"

            for (var yv = resolvedYMin; yv <= resolvedYMax + resolvedStep * 0.01; yv += resolvedStep) {
                var gy = mapY(yv)

                ctx.strokeStyle = root.gridColor
                ctx.lineWidth = 1
                ctx.beginPath()
                ctx.moveTo(root.marginLeft, gy)
                ctx.lineTo(width - root.marginRight, gy)
                ctx.stroke()

                ctx.fillStyle = root.tickLabelColor
                var label = yv.toFixed(root.yDecimals)
                if (root.yUnit) label += " " + root.yUnit
                ctx.fillText(label, root.marginLeft - 8, gy + 4)
            }

            // ── X axis ticks + labels ────────────────────────────────────────
            var spanMs  = maxX - minX
            var spanDay = spanMs / 86400000

            ctx.textAlign = "center"

            for (var ti = 0; ti <= root.xTickCount; ++ti) {
                var frac   = ti / root.xTickCount
                var tMs    = minX + frac * spanMs
                var tx     = mapX(tMs)
                var daysFromEnd = Math.round((maxX - tMs) / 86400000)

                ctx.strokeStyle = axisColor
                ctx.lineWidth   = 1
                ctx.beginPath()
                ctx.moveTo(tx, baseY)
                ctx.lineTo(tx, baseY + 5)
                ctx.stroke()

                ctx.fillStyle = root.tickLabelColor
                var xLabel
                if (daysFromEnd === 0)
                    xLabel = "Today"
                else if (spanDay <= 1)
                    xLabel = daysFromEnd + "h ago"    // hour-scale fallback label
                else
                    xLabel = daysFromEnd + " " + root.xUnit

                ctx.fillText(xLabel, tx, baseY + root.fontSize + 6)
            }

            // ── Axes ─────────────────────────────────────────────────────────
            ctx.strokeStyle = root.axisColor
            ctx.lineWidth   = 2
            ctx.beginPath()
            ctx.moveTo(root.marginLeft, root.marginTop)
            ctx.lineTo(root.marginLeft, baseY)
            ctx.lineTo(width - root.marginRight, baseY)
            ctx.stroke()

            // ── Series ───────────────────────────────────────────────────────
            canvas._hitCache = []

            if (root.plotMode === GHDChart.PlotMode.Bar) {
                var slotW = cW / pts.length
                var bW    = Math.max(root.barMinWidth, slotW * root.barFillRatio)

                for (let i = 0; i < pts.length; ++i) {
                    var bcx = mapX(pts[i].x.getTime())
                    var bx  = bcx - bW / 2
                    var by  = mapY(pts[i].y)
                    var bh  = baseY - by

                    _drawBar(ctx, bx, by, bW, bh, root.seriesColor)

                    canvas._hitCache.push({
                        kind: "bar",
                        x: bx, y: by, w: bW, h: bh,
                        cx: bcx, cy: by,
                        value: pts[i].y, date: pts[i].x
                    })
                }
            } else {
                // Line
                ctx.strokeStyle = root.seriesColor
                ctx.lineWidth   = root.lineWidth

                for (let i = 1; i < pts.length; ++i) {
                    ctx.beginPath()
                    ctx.moveTo(mapX(pts[i-1].x.getTime()), mapY(pts[i-1].y))
                    ctx.lineTo(mapX(pts[i  ].x.getTime()), mapY(pts[i  ].y))
                    ctx.stroke()
                }

                ctx.fillStyle = root.seriesColor
                for (let i = 0; i < pts.length; ++i) {
                    var lx = mapX(pts[i].x.getTime())
                    var ly = mapY(pts[i].y)

                    ctx.beginPath()
                    ctx.arc(lx, ly, root.dotRadius, 0, Math.PI * 2)
                    ctx.fill()

                    canvas._hitCache.push({
                        kind: "dot",
                        x: lx, y: ly, r: root.dotRadius + 4,
                        value: pts[i].y, date: pts[i].x
                    })
                }
            }

            // ── Title ────────────────────────────────────────────────────────
            ctx.fillStyle  = root.titleColor
            ctx.font       = "bold " + root.titleSize + "px " + root.fontFamily
            ctx.textAlign  = "left"
            ctx.fillText(root.title, root.marginLeft, root.marginTop - 10)
        }

        // ── Private helpers ──────────────────────────────────────────────────

        function _drawBar(ctx, x, y, w, h, color) {
            ctx.fillStyle = color
            ctx.beginPath()
            if (ctx.roundRect)
                ctx.roundRect(x, y, w, h, [3, 3, 0, 0])
            else
                ctx.rect(x, y, w, h)
            ctx.fill()
        }

        function _niceMax(v) {
            if (v <= 0) return 1
            var mag  = Math.pow(10, Math.floor(Math.log10(v)))
            var nice = [1, 2, 2.5, 5, 10]
            for (var i = 0; i < nice.length; ++i)
                if (nice[i] * mag >= v) return nice[i] * mag
            return 10 * mag
        }

        function _niceStep(lo, hi, targetTicks) {
            var raw  = (hi - lo) / targetTicks
            var mag  = Math.pow(10, Math.floor(Math.log10(raw)))
            var nice = [1, 2, 2.5, 5, 10]
            for (var i = 0; i < nice.length; ++i)
                if (nice[i] * mag >= raw) return nice[i] * mag
            return 10 * mag
        }

        // ── Mouse hover ──────────────────────────────────────────────────────
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onPositionChanged: function(mouse){
                tooltip.visible = false
                canvas.requestPaint()

                var hit = _findHit(mouse.x, mouse.y)
                if (!hit) return

                // Highlight hovered element
                var ctx = canvas.getContext("2d")
                if (hit.kind === "bar") {
                    canvas._drawBar(ctx, hit.x, hit.y, hit.w, hit.h,
                                    root.seriesHoverColor)
                } else {
                    ctx.fillStyle = root.seriesHoverColor
                    ctx.beginPath()
                    ctx.arc(hit.x, hit.y, root.dotRadius + 2, 0, Math.PI * 2)
                    ctx.fill()
                }

                tooltip.x    = _clampTooltipX(hit.cx ?? hit.x)
                tooltip.y    = (hit.cy ?? hit.y) - tooltip.height - 6
                tooltip.text = hit.date.toLocaleDateString()
                             + "  |  "
                             + hit.value.toFixed(2)
                             + (root.yUnit ? " " + root.yUnit : "")
                tooltip.visible = true
            }

            onExited: function() {
                tooltip.visible = false
                canvas.requestPaint()
            }

            function _findHit(mx, my) {
                var cache = canvas._hitCache
                for (var i = 0; i < cache.length; ++i) {
                    var p = cache[i]
                    if (p.kind === "bar") {
                        if (mx >= p.x && mx <= p.x + p.w &&
                            my >= p.y && my <= p.y + p.h)
                            return p
                    } else {
                        var dx = mx - p.x, dy = my - p.y
                        if (dx*dx + dy*dy <= p.r * p.r)
                            return p
                    }
                }
                return null
            }

            function _clampTooltipX(cx) {
                var tx = cx + 10
                var maxTx = canvas.width - tooltip.width - 4
                return Math.min(tx, maxTx)
            }
        }
    }

    // ── Tooltip overlay ───────────────────────────────────────────────────────
    Rectangle {
        id: tooltip
        visible: false
        z: 10
        color:  root.tooltipBg
        radius: 4
        border.color: root.tooltipBorder
        opacity: 0.95

        property string text: ""

        Text {
            id: ttText
            anchors { fill: parent; margins: 6 }
            color:          root.tooltipText
            font.pixelSize: root.fontSize
            font.family:    root.fontFamily
            text:           tooltip.text
        }

        width:  ttText.paintedWidth  + 12
        height: ttText.paintedHeight + 12
    }
}
