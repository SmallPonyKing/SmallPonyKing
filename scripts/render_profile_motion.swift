// Original continuous hero and six research-inspired AI-card animations.
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let outputDirectory = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "assets", isDirectory: true)
let mobile = CommandLine.arguments.contains("--mobile")
let light = CommandLine.arguments.contains("--light")
let hero = CommandLine.arguments.contains("--hero")
let width = mobile ? 600 : 1200
let height = hero ? (mobile ? 510 : 460) : (mobile ? 1110 : 620)
let frameCount = 72
let prefix = (hero ? "hero-motion" : "ai-landscape-motion") + (mobile ? "-mobile" : "") + (light ? "-light" : "")
let rgb = CGColorSpaceCreateDeviceRGB()
func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) -> CGColor {
    CGColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
}
func accent(_ alpha: CGFloat = 1) -> CGColor { light ? color(131,96,39,alpha) : color(219,194,154,alpha) }
func pitch(_ alpha: CGFloat = 1) -> CGColor { light ? color(68,117,98,alpha) : color(106,147,130,alpha) }
let ink = light ? color(249,251,249) : color(12,19,23)
let gold = accent(), white = light ? color(21,37,44) : color(245,240,232)
let muted = light ? color(77,97,104) : color(155,172,177)
let green = pitch(), border = light ? color(203,218,209) : color(40,60,57)
let ballInk = color(11,20,27), ballWhite = color(255,250,240)
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
    ctx.setFillColor(ballWhite); ctx.fillEllipse(in: circle)
    ctx.saveGState(); ctx.addEllipse(in: circle); ctx.clip()
    let angles = (0..<5).map { CGFloat($0)*CGFloat.pi*2/5 + CGFloat.pi/2 }
    polygon(ctx, angles.map { polar(radius*0.38, $0) }, fill: ballInk)
    for theta in angles {
        line(ctx, polar(radius*0.38, theta), polar(radius*0.68, theta), ballInk, radius*0.045)
        polygon(ctx, [polar(radius*0.68,theta), polar(radius*0.82,theta-0.28),
                      polar(radius*1.1,theta-0.4), polar(radius*1.1,theta+0.4), polar(radius*0.82,theta+0.28)], fill: ballInk)
    }
    ctx.restoreGState()
    ctx.setStrokeColor(gold); ctx.setLineWidth(1.4); ctx.strokeEllipse(in: circle)
    ctx.restoreGState()
}

let slugs=["openai","claude","gemini","deepseek","huggingface","ollama"]
let names=["OpenAI","Claude","Gemini","DeepSeek","Hugging Face","Ollama"]
let captions=["Tool orchestration.","Reasoning into code.","Text, image, audio.","Open-weight reasoning.","Models and datasets.","Local model runtime."]
let panel=light ? color(247,249,248):color(17,26,35)
let diagramBorder=light ? color(112,136,126):color(73,102,96)
let accents=[gold,color(217,119,87),color(100,141,231),color(91,116,246),color(238,180,34),pitch()]
var images:[CGImage]=[]
if !hero {
    images=slugs.map {
        let url=outputDirectory.appendingPathComponent("logos/rendered/"+$0+(light ? "-light":"-dark")+".png")
        guard let source=CGImageSourceCreateWithURL(url as CFURL,nil),let image=CGImageSourceCreateImageAtIndex(source,0,nil) else {fatalError("Run rasterize_logos.swift first: "+url.path)}
        return image
    }
}

// Local diagram coordinates are 320x110, with positive y downwards.
func concept(_ ctx:CGContext,_ index:Int,_ x:CGFloat,_ top:CGFloat,_ scale:CGFloat,_ t:CGFloat) {
    ctx.saveGState();ctx.translateBy(x:x,y:CGFloat(height)-top);ctx.scaleBy(x:scale,y:-scale)
    let a=accents[index]
    func p(_ x:CGFloat,_ y:CGFloat)->CGPoint {CGPoint(x:x,y:y)}
    func path(_ vertices:[CGPoint],_ c:CGColor,_ weight:CGFloat=1.5) {
        ctx.setStrokeColor(c);ctx.setLineWidth(weight);ctx.setLineCap(.round);ctx.move(to:vertices[0])
        vertices.dropFirst().forEach{ctx.addLine(to:$0)};ctx.strokePath()
    }
    func circle(_ x:CGFloat,_ y:CGFloat,_ r:CGFloat,_ c:CGColor) {
        ctx.setFillColor(c);ctx.fillEllipse(in:CGRect(x:x-r,y:y-r,width:r*2,height:r*2))
    }
    func rect(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ c:CGColor=diagramBorder) {
        let shape=CGPath(roundedRect:CGRect(x:x,y:y,width:w,height:h),cornerWidth:5,cornerHeight:5,transform:nil)
        ctx.addPath(shape);ctx.setStrokeColor(c);ctx.setLineWidth(1.5);ctx.strokePath()
    }
    func particle(_ vertices:[CGPoint],_ time:CGFloat,_ c:CGColor) {
        let u=(time-floor(time))*CGFloat(vertices.count-1),seg=min(vertices.count-2,Int(u)),f=u-CGFloat(seg)
        let v=p(vertices[seg].x+(vertices[seg+1].x-vertices[seg].x)*f,vertices[seg].y+(vertices[seg+1].y-vertices[seg].y)*f)
        circle(v.x,v.y,8,c.copy(alpha:0.12)!);circle(v.x,v.y,3.5,c)
    }
    switch index {
    case 0: // Selecting and routing between tools.
        let route=[p(42,28),p(160,72),p(278,28),p(160,72),p(42,28)]
        path([p(42,28),p(160,72),p(278,28)],diagramBorder)
        path([p(160,14),p(160,72)],diagramBorder)
        for (x,y) in [(CGFloat(42),CGFloat(28)),(160,14),(278,28)] {
            rect(x-17,y-11,34,22)
            path([p(x-7,y),p(x+7,y)],a)
        }
        ctx.setStrokeColor(a);ctx.setLineWidth(1.5);ctx.strokeEllipse(in:CGRect(x:140,y:52,width:40,height:40))
        circle(160,72,5,a);particle(route,t,a);particle([p(160,14),p(160,72)],t+0.4,a)
    case 1: // A code editor writes successive lines, then validates.
        rect(17,4,286,102)
        for i in 0..<3 {circle(31+CGFloat(i)*10,16,2.3,a.copy(alpha:0.65)!)}
        for i in 0..<4 {
            let reveal=max(0,min(1,t*5-CGFloat(i)))
            let y=34+CGFloat(i)*17
            path([p(34,y),p(34+reveal*(i==2 ? 123:191),y)],a.copy(alpha:0.3+reveal*0.55)!,3)
        }
        let cursor=34+min(1,t*5-3)*191
        if t>0.6 {path([p(max(34,cursor),78),p(max(34,cursor),91)],a,2)}
        if t>0.82 {path([p(263,72),p(271,80),p(285,62)],a,2.5)}
    case 2: // Text, image and waveform inputs converge.
        rect(15,8,48,27);path([p(25,17),p(52,17)],a);path([p(25,26),p(44,26)],a)
        rect(15,66,48,32);path([p(21,91),p(33,78),p(44,86),p(53,76)],color(220,125,131))
        for i in 0..<9 {
            let amp=5+abs(sin(t*CGFloat.pi*4+CGFloat(i)*0.8))*14
            path([p(104+CGFloat(i)*6,54-amp/2),p(104+CGFloat(i)*6,54+amp/2)],color(90,158,128),2)
        }
        let center=p(218,54)
        for input in [p(65,22),p(65,82),p(159,54)] {
            path([input,center],diagramBorder);particle([input,center],t+input.y/120,a)
        }
        path([center,p(274,54)],diagramBorder);particle([center,p(274,54)],t+0.3,a)
        let star=[p(283,34),p(289,48),p(304,54),p(289,60),p(283,76),p(277,60),p(263,54),p(277,48)]
        polygon(ctx,star,fill:a)
    case 3: // An illustrative multi-step reasoning path, not an architecture claim.
        let route=[p(24,54),p(105,22),p(202,81),p(291,54)]
        for edge in [[p(24,54),p(105,22)],[p(24,54),p(105,87)],[p(105,22),p(202,24)],[p(105,22),p(202,81)],[p(105,87),p(202,81)],[p(202,24),p(291,54)],[p(202,81),p(291,54)]] {path(edge,diagramBorder)}
        path(route,a.copy(alpha:0.6)!,2)
        for v in [p(24,54),p(105,22),p(105,87),p(202,24),p(202,81),p(291,54)] {circle(v.x,v.y,5,a.copy(alpha:0.5)!)}
        particle(route,t,a)
    case 4: // A community hub shares models and datasets.
        for y in [CGFloat(22),54,86] {rect(18,y-9,44,18)}
        for y in [CGFloat(20),54,88] {rect(253,y-10,47,20)}
        ctx.setStrokeColor(a);ctx.setLineWidth(1.5);ctx.strokeEllipse(in:CGRect(x:132,y:31,width:46,height:46))
        for i in 0..<3 {
            let left=p(62,22+CGFloat(i)*32),right=p(253,20+CGFloat(i)*34)
            path([left,p(155,54),right],diagramBorder)
            particle([left,p(155,54),right],t+CGFloat(i)/3,a)
        }
        circle(155,54,5,a)
    default: // A local model runs inside one machine.
        rect(45,4,230,86)
        path([p(35,97),p(285,97)],a,3)
        rect(178,25,67,46,a)
        for i in 0..<4 {
            let y=27+CGFloat(i)*15
            path([p(62,y),p(62+min(1,max(0,t*5-CGFloat(i)))*88,y)],a.copy(alpha:0.8)!,2.5)
        }
        particle([p(145,49),p(178,49)],t,a)
        for y in [CGFloat(36),49,62] {path([p(190,y),p(230,y)],a.copy(alpha:0.45)!)}
    }
    ctx.restoreGState()
}

func drawHero(_ ctx:CGContext,_ t:CGFloat) {
    let center=mobile ? point(507,91):point(970,236)
    let radius:CGFloat=mobile ? 35:97
    let orbit:CGFloat=mobile ? 48:142
    for ring in [orbit,orbit*1.2] {
        ctx.setStrokeColor(accent(0.18));ctx.setLineWidth(1)
        ctx.strokeEllipse(in:CGRect(x:center.x-ring,y:center.y-ring,width:ring*2,height:ring*2))
    }
    for i in 0..<3 {
        let theta=t*CGFloat.pi*2+CGFloat(i)*CGFloat.pi*2/3
        let x=center.x+cos(theta)*orbit,y=center.y+sin(theta)*orbit
        ctx.setFillColor(accent(0.1));ctx.fillEllipse(in:CGRect(x:x-10,y:y-10,width:20,height:20))
        ctx.setFillColor(gold);ctx.fillEllipse(in:CGRect(x:x-3,y:y-3,width:6,height:6))
    }
    ball(ctx,CGPoint(x:center.x,y:center.y+sin(t*CGFloat.pi*2)*4),radius,t*CGFloat.pi*2/5)
    let x:CGFloat=mobile ? 34:54
    text(ctx,"SMALLPONYKING",x,mobile ? 57:60,14,gold,bold:true,spacing:3)
    text(ctx,"Read the field.",x,mobile ? 183:154,mobile ? 60:66,white,bold:true)
    text(ctx,"Build the play.",x,mobile ? 259:231,mobile ? 60:66,white,bold:true)
    text(ctx,"AI / AGENTS / SOFTWARE ENGINEERING",x,mobile ? 310:282,mobile ? 17:15,gold)
    if mobile {
        text(ctx,"Code. Systems. Intelligence.",x,369,22)
        text(ctx,"Always moving forward.",x,400,22)
    } else {text(ctx,"Code. Systems. Intelligence. Always moving forward.",x,329,19)}
    let ruleTop:CGFloat=mobile ? 443:383,ruleWidth:CGFloat=mobile ? 528:654
    line(ctx,point(x,ruleTop),point(x+ruleWidth,ruleTop),border)
    let sweep=x+t*ruleWidth
    line(ctx,point(sweep-20,ruleTop),point(sweep+20,ruleTop),accent(0.65),2)
    text(ctx,"ALWAYS LEARNING. ALWAYS MOVING FORWARD.",x,mobile ? 478:416,mobile ? 12:11,muted,spacing:mobile ? 0:1.8)
}

func drawLandscape(_ ctx:CGContext,_ t:CGFloat) {
    for i in 0..<6 {
        let x:CGFloat=mobile ? 12+CGFloat(i%2)*294:12+CGFloat(i%3)*396
        let top:CGFloat=mobile ? 12+CGFloat(i/2)*366:12+CGFloat(i/3)*300
        let w:CGFloat=mobile ? 282:384,h:CGFloat=mobile ? 342:286
        rounded(ctx,box(x,top,w,h),18,fill:panel,stroke:border)
        let phase=(t+CGFloat(i)*0.13).truncatingRemainder(dividingBy:1)
        let float=sin(phase*CGFloat.pi*2)*3
        let logoX=x+26,logoTop=top+27+float
        ctx.draw(images[i],in:box(logoX,logoTop,58,58))
        text(ctx,names[i],x+102,top+66,mobile ? 22:27,white,bold:true)
        text(ctx,captions[i],x+28,top+124,mobile ? 19:20)
        concept(ctx,i,x+(mobile ? 26:30),top+(mobile ? 185:158),mobile ? 0.72:1,phase)
        let lineWidth=w-56
        line(ctx,point(x+28,top+h-17),point(x+w-28,top+h-17),border)
        let sweep=x+28+phase*(lineWidth-30)
        line(ctx,point(sweep,top+h-17),point(sweep+30,top+h-17),accents[i].copy(alpha:0.7)!,2)
    }
}

let destination=CGImageDestinationCreateWithURL(outputDirectory.appendingPathComponent(prefix+".gif") as CFURL,UTType.gif.identifier as CFString,frameCount,nil)!
CGImageDestinationSetProperties(destination,[kCGImagePropertyGIFDictionary:[kCGImagePropertyGIFLoopCount:0]] as CFDictionary)
let gradient=CGGradient(colorsSpace:rgb,colors:[light ? color(251,253,251):color(19,30,39),ink] as CFArray,locations:[0,1])!
for frame in 0..<frameCount {
    let ctx=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,space:rgb,bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(light ? color(255,255,255):color(13,17,23));ctx.fill(CGRect(x:0,y:0,width:width,height:height))
    if hero {
        ctx.saveGState();ctx.addPath(CGPath(roundedRect:box(1,1,CGFloat(width-2),CGFloat(height-2)),cornerWidth:20,cornerHeight:20,transform:nil));ctx.clip()
        ctx.drawLinearGradient(gradient,start:point(0,0),end:point(CGFloat(width),CGFloat(height)),options:[])
        for x in stride(from:CGFloat(0),through:CGFloat(width),by:60) {line(ctx,point(x,0),point(x,CGFloat(height)),pitch(0.045))}
        for y in stride(from:CGFloat(0),through:CGFloat(height),by:60) {line(ctx,point(0,y),point(CGFloat(width),y),pitch(0.045))}
    }
    let t=CGFloat(frame)/CGFloat(frameCount)
    if hero {drawHero(ctx,t);ctx.restoreGState();rounded(ctx,box(1,1,CGFloat(width-2),CGFloat(height-2)),20,fill:color(0,0,0,0),stroke:border)}
    else {drawLandscape(ctx,t)}
    let image=ctx.makeImage()!
    CGImageDestinationAddImage(destination,image,[kCGImagePropertyGIFDictionary:[kCGImagePropertyGIFDelayTime:0.09]] as CFDictionary)
    if frame == frameCount/2 {
        let poster=CGImageDestinationCreateWithURL(outputDirectory.appendingPathComponent(prefix+"-static.png") as CFURL,UTType.png.identifier as CFString,1,nil)!
        CGImageDestinationAddImage(poster,image,nil);guard CGImageDestinationFinalize(poster) else {fatalError("Poster export failed")}
    }
}
guard CGImageDestinationFinalize(destination) else {fatalError("GIF export failed")}
print("Generated \(prefix): \(frameCount) animated frames, \(width)x\(height).")
