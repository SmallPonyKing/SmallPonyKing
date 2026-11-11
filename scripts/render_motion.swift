// Original, self-contained workflow animation. Run with Swift on macOS.
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let width = 1200, height = 144, frames = 64
let output = URL(fileURLWithPath: CommandLine.arguments[1])
let destination = CGImageDestinationCreateWithURL(output as CFURL, UTType.gif.identifier as CFString, frames, nil)!
CGImageDestinationSetProperties(destination, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary)
let colors = CGColorSpaceCreateDeviceRGB()
func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    return CGColor(red: r/255, green: g/255, blue: b/255, alpha: a)
}
let bg = color(12,16,23), gold = color(219,194,154), muted = color(155,167,182)
func label(_ ctx: CGContext, _ string: String, x: CGFloat, y: CGFloat, size: CGFloat, ink: CGColor, centered: Bool = false) {
    let font = CTFontCreateWithName("HelveticaNeue-Medium" as CFString, size, nil)
    let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTFontAttributeName as String): font, NSAttributedString.Key(kCTForegroundColorAttributeName as String): ink]
    let line = CTLineCreateWithAttributedString(NSAttributedString(string: string, attributes: attrs))
    let measure = CTLineGetTypographicBounds(line, nil, nil, nil)
    ctx.textPosition = CGPoint(x: centered ? x - measure/2 : x, y: y)
    CTLineDraw(line, ctx)
}
let nodes: [(CGFloat,String)] = [(80,"OBSERVE"),(340,"REASON"),(600,"BUILD"),(860,"VALIDATE"),(1120,"ITERATE")]
for index in 0..<frames {
    let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width*4, space: colors, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(bg)
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
    ctx.setStrokeColor(color(43,52,66))
    ctx.addPath(CGPath(roundedRect: CGRect(x: 1, y: 1, width: 1198, height: 142), cornerWidth: 20, cornerHeight: 20, transform: nil))
    ctx.strokePath()
    label(ctx,"THE WORKFLOW",x:30,y:111,size:10,ink:gold)
    ctx.setStrokeColor(color(52,64,80));ctx.setLineWidth(1)
    ctx.move(to:CGPoint(x:80,y:68));ctx.addLine(to:CGPoint(x:1120,y:68));ctx.strokePath()
    let progress = CGFloat(index)/CGFloat(frames-1)
    let activeX = 80 + progress*1040
    ctx.setStrokeColor(color(219,194,154,0.65));ctx.setLineWidth(2)
    ctx.move(to:CGPoint(x:80,y:68));ctx.addLine(to:CGPoint(x:activeX,y:68));ctx.strokePath()
    for (x,title) in nodes {
        let distance = abs(activeX-x)
        let pulse = max(0,1-distance/180)
        ctx.setFillColor(color(219,194,154,0.08+pulse*0.08))
        ctx.fillEllipse(in:CGRect(x:x-16-pulse*6,y:52-pulse*6,width:32+pulse*12,height:32+pulse*12))
        ctx.setFillColor(x<=activeX ? gold : muted)
        ctx.fillEllipse(in:CGRect(x:x-5,y:63,width:10,height:10))
        label(ctx,title,x:x,y:29,size:13,ink:x<=activeX ? gold : muted,centered:true)
    }
    ctx.setFillColor(gold)
    ctx.fillEllipse(in:CGRect(x:activeX-4,y:64,width:8,height:8))
    let img=ctx.makeImage()!
    let delay = index == frames-1 ? 1.2 : 0.08
    CGImageDestinationAddImage(destination,img,[kCGImagePropertyGIFDictionary:[kCGImagePropertyGIFDelayTime:delay]] as CFDictionary)
}
guard CGImageDestinationFinalize(destination) else { fatalError("GIF export failed") }
print("Generated \(frames)-frame workflow GIF: \(output.path)")
