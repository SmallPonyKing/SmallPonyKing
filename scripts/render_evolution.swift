// Original soccer-marker animation for a GitHub profile. macOS system frameworks only.
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let outputDirectory = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "assets", isDirectory: true)
let mobile = CommandLine.arguments.contains("--mobile")
let width = mobile ? 600 : 1200
let height = mobile ? 1080 : 460
let frameCount = 96
let prefix = mobile ? "evolution-mobile" : "evolution"
let rgb = CGColorSpaceCreateDeviceRGB()
func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) -> CGColor {
    CGColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
}
let ink = color(12, 19, 23), gold = color(219, 194, 154), white = color(245, 240, 232)
let muted = color(155, 172, 177), green = color(106, 147, 130), border = color(40, 60, 57)
func point(_ x: CGFloat, _ top: CGFloat) -> CGPoint { CGPoint(x: x, y: CGFloat(height) - top) }
func box(_ x: CGFloat, _ top: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
    CGRect(x: x, y: CGFloat(height) - top - h, width: w, height: h)
}
func text(_ ctx: CGContext, _ string: String, _ x: CGFloat, _ baseline: CGFloat, _ size: CGFloat,
          _ fill: CGColor = muted, centered: Bool = false, bold: Bool = false, spacing: CGFloat = 0) {
    let font = CTFontCreateWithName((bold ? "HelveticaNeue-Bold" : "HelveticaNeue") as CFString, size, nil)
    let attrs: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key(kCTFontAttributeName as String): font,
        NSAttributedString.Key(kCTForegroundColorAttributeName as String): fill,
        NSAttributedString.Key(kCTKernAttributeName as String): spacing
    ]
    let line = CTLineCreateWithAttributedString(NSAttributedString(string: string, attributes: attrs))
    let length = CTLineGetTypographicBounds(line, nil, nil, nil)
    ctx.textPosition = point(centered ? x - length/2 : x, baseline)
    CTLineDraw(line, ctx)
}
func rounded(_ ctx: CGContext, _ rect: CGRect, _ radius: CGFloat, fill: CGColor, stroke: CGColor? = nil) {
    let path = CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
    ctx.addPath(path); ctx.setFillColor(fill); ctx.fillPath()
    if let stroke = stroke { ctx.addPath(path); ctx.setStrokeColor(stroke); ctx.setLineWidth(1); ctx.strokePath() }
}
func line(_ ctx: CGContext, _ a: CGPoint, _ b: CGPoint, _ fill: CGColor, _ thickness: CGFloat = 1) {
    ctx.setStrokeColor(fill); ctx.setLineWidth(thickness)
    ctx.move(to: a); ctx.addLine(to: b); ctx.strokePath()
}
func polar(_ radius: CGFloat, _ angle: CGFloat) -> CGPoint {
    CGPoint(x: radius*cos(angle), y: radius*sin(angle))
}
func polygon(_ ctx: CGContext, _ vertices: [CGPoint], fill: CGColor) {
    ctx.move(to: vertices[0]); vertices.dropFirst().forEach { ctx.addLine(to: $0) }; ctx.closePath()
    ctx.setFillColor(fill); ctx.fillPath()
}
func ball(_ ctx: CGContext, _ center: CGPoint, _ radius: CGFloat, _ angle: CGFloat) {
    ctx.saveGState()
    ctx.setFillColor(color(0,0,0,0.25))
    ctx.fillEllipse(in: CGRect(x: center.x-radius, y: center.y-radius-10, width: radius*2, height: radius*0.4))
    ctx.translateBy(x: center.x, y: center.y); ctx.rotate(by: angle)
    let circle = CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2)
    ctx.setFillColor(white); ctx.fillEllipse(in: circle)
    ctx.saveGState(); ctx.addEllipse(in: circle); ctx.clip()
    let angles = (0..<5).map { CGFloat($0)*CGFloat.pi*2/5 + CGFloat.pi/2 }
    polygon(ctx, angles.map { polar(radius*0.38, $0) }, fill: ink)
    for theta in angles {
        line(ctx, polar(radius*0.38, theta), polar(radius*0.68, theta), ink, radius*0.045)
        polygon(ctx, [polar(radius*0.68,theta), polar(radius*0.82,theta-0.28),
                      polar(radius*1.1,theta-0.4), polar(radius*1.1,theta+0.4), polar(radius*0.82,theta+0.28)], fill: ink)
    }
    ctx.restoreGState()
    ctx.setStrokeColor(gold); ctx.setLineWidth(1.4); ctx.strokeEllipse(in: circle)
    ctx.restoreGState()
}

let titles = ["Code & algorithms", "Connected software", "Cloud systems", "Applied AI", "Agent workflows"]
let descriptions = [
    ["Logic, data structures", "and reliable programs"],
    ["APIs, interfaces", "and shared services"],
    ["Distributed work", "and resilient systems"],
    ["Models, context", "and evaluated output"],
    ["Tools, state", "and human oversight"]
]
let destination = CGImageDestinationCreateWithURL(outputDirectory.appendingPathComponent(prefix+".gif") as CFURL, UTType.gif.identifier as CFString, frameCount, nil)!
CGImageDestinationSetProperties(destination, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary)
let gradient = CGGradient(colorsSpace: rgb, colors: [color(17,30,30),ink] as CFArray, locations: [0,1])!
for frame in 0..<frameCount {
    let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width*4, space: rgb, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(ink);ctx.fill(CGRect(x:0,y:0,width:width,height:height))
    ctx.saveGState()
    ctx.addPath(CGPath(roundedRect: box(1,1,CGFloat(width-2),CGFloat(height-2)), cornerWidth:22, cornerHeight:22, transform:nil));ctx.clip()
    ctx.drawLinearGradient(gradient,start:point(0,0),end:point(CGFloat(width),CGFloat(height)),options:[])
    if mobile {
        text(ctx,"SOFTWARE'S EVOLUTION",36,52,14,gold,spacing:2)
        text(ctx,"The next play.",36,105,38,white,bold:true)
        text(ctx,"An evolving field. My focus today.",36,143,20)
        rounded(ctx,box(28,180,544,788),18,fill:color(0,0,0,0),stroke:border)
        ctx.setStrokeColor(color(106,147,130,0.10));ctx.strokeEllipse(in:box(308,410,290,290))
        line(ctx,point(28,560),point(572,560),color(106,147,130,0.08))
    } else {
        text(ctx,"SOFTWARE'S EVOLUTION",36,42,12,gold,spacing:2)
        text(ctx,"New capabilities. The next play.",36,84,29,white,bold:true)
        text(ctx,"A WIDER VIEW → MY FOCUS",938,42,11,muted)
        rounded(ctx,box(28,112,1144,264),18,fill:color(0,0,0,0),stroke:border)
        ctx.setStrokeColor(color(106,147,130,0.12));ctx.strokeEllipse(in:box(528,162,144,144))
        line(ctx,point(600,112),point(600,376),color(106,147,130,0.12))
        rounded(ctx,box(28,189,34,90),0,fill:color(0,0,0,0),stroke:border)
        rounded(ctx,box(1138,189,34,90),0,fill:color(0,0,0,0),stroke:border)
    }
    let u = CGFloat(frame)/CGFloat(frameCount-1)
    let segment = min(3,Int(u*4))
    let local = u >= 1 ? CGFloat(1) : u*4-CGFloat(segment)
    let eased = local*local*(3-2*local)
    let progress = (CGFloat(segment)+eased)/4
    let nodes: [CGPoint] = (0..<5).map { mobile ? point(86,240+CGFloat($0)*160) : point(120+CGFloat($0)*240,234) }
    line(ctx,nodes[0],nodes[4],color(106,147,130,0.38),1.3)
    let active = mobile ? point(86,240+progress*640) : point(120+progress*960,234)
    line(ctx,nodes[0],active,color(219,194,154,0.7),2)
    for i in 0..<5 {
        let passed = progress >= CGFloat(i)/4
        let node = nodes[i]
        ctx.setFillColor(passed ? gold : green)
        ctx.fillEllipse(in:CGRect(x:node.x-4,y:node.y-4,width:8,height:8))
        if mobile {
            let top = 240+CGFloat(i)*160
            text(ctx,String(format:"%02d",i+1)+(i==4 ? " / MY FOCUS NOW" : " / CAPABILITY"),150,top-29,12,i==4 ? gold:muted,spacing:1.5)
            text(ctx,titles[i],150,top+6,27,i==4 ? gold:white,bold:true)
            text(ctx,descriptions[i][0],150,top+42,20)
            text(ctx,descriptions[i][1],150,top+70,20)
        } else {
            let x = 120+CGFloat(i)*240
            text(ctx,String(format:"%02d",i+1)+(i==4 ? " / MY FOCUS" : ""),x,147,11,i==4 ? gold:muted,centered:true,spacing:1.5)
            text(ctx,titles[i],x,177,18,i==4 ? gold:white,centered:true,bold:true)
            text(ctx,descriptions[i][0],x,308,15,muted,centered:true)
            text(ctx,descriptions[i][1],x,332,15,muted,centered:true)
        }
    }
    let bump = sin(local*CGFloat.pi)*(mobile ? CGFloat(22):CGFloat(31))
    let ballPosition = mobile ? CGPoint(x:active.x+bump,y:active.y) : CGPoint(x:active.x,y:active.y+bump)
    if frame == frameCount-1 {
        ctx.setStrokeColor(color(219,194,154,0.3));ctx.setLineWidth(1.5)
        ctx.strokeEllipse(in:CGRect(x:ballPosition.x-35,y:ballPosition.y-35,width:70,height:70))
    }
    ball(ctx,ballPosition,mobile ? 24:20,-progress*CGFloat.pi*6)
    if mobile {
        line(ctx,point(36,1000),point(564,1000),border)
        text(ctx,"SMALLPONYKING",36,1030,13,gold,spacing:2)
        text(ctx,"AI + AGENTS + SOFTWARE ENGINEERING",36,1058,14,white)
    } else {
        rounded(ctx,box(28,394,1144,44),10,fill:color(219,194,154,0.06),stroke:color(219,194,154,0.18))
        text(ctx,"MY POSITION TODAY",48,422,11,gold,spacing:1.4)
        text(ctx,"AI + agents, grounded in software engineering.",300,423,17,white)
        text(ctx,"SMALLPONYKING",988,422,12,gold,spacing:1)
    }
    ctx.restoreGState()
    rounded(ctx,box(1,1,CGFloat(width-2),CGFloat(height-2)),22,fill:color(0,0,0,0),stroke:border)
    let image=ctx.makeImage()!
    let delay = frame == frameCount-1 ? 1.8 : (frame == 0 ? 0.6 : 0.07)
    CGImageDestinationAddImage(destination,image,[kCGImagePropertyGIFDictionary:[kCGImagePropertyGIFDelayTime:delay]] as CFDictionary)
    if frame == frameCount-1 {
        let png=CGImageDestinationCreateWithURL(outputDirectory.appendingPathComponent(prefix+"-static.png") as CFURL,UTType.png.identifier as CFString,1,nil)!
        CGImageDestinationAddImage(png,image,nil)
        guard CGImageDestinationFinalize(png) else {fatalError("PNG export failed")}
    }
}
guard CGImageDestinationFinalize(destination) else {fatalError("GIF export failed")}
print("Generated \(prefix): \(frameCount) animated frames and a static alternative, \(width)x\(height).")
