// Render the original SVG paths with WebKit for use in CoreGraphics GIF frames.
import AppKit
import WebKit

let base = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "assets/logos", isDirectory:true)
let output = base.appendingPathComponent("rendered",isDirectory:true)
try FileManager.default.createDirectory(at:output,withIntermediateDirectories:true)
let brands=["openai","claude","gemini","deepseek","huggingface","ollama"]
let app=NSApplication.shared
app.setActivationPolicy(.prohibited)
class Renderer:NSObject,WKNavigationDelegate {
    var web:WKWebView!
    var index=0
    func next() {
        if index == brands.count*2 { print("Rendered 12 theme-aware logo images.");exit(0) }
        let light=index>=brands.count
        let slug=brands[index%brands.count]
        var svg=try! String(contentsOf:base.appendingPathComponent(slug+".svg"),encoding:.utf8)
        svg=svg.replacingOccurrences(of:"1em",with:"128px").replacingOccurrences(of:"currentColor",with:light ? "#15252c":"#f5f0e8")
        let bg="transparent"
        web.loadHTMLString("<html><head><meta charset='utf-8'></head><body style='margin:0;background:\(bg);width:128px;height:128px'>\(svg)</body></html>",baseURL:nil)
    }
    func webView(_ webView:WKWebView,didFinish navigation:WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline:.now()+0.04) {
            webView.takeSnapshot(with:nil) { image,error in
                guard let tiff=image?.tiffRepresentation,let bitmap=NSBitmapImageRep(data:tiff),let png=bitmap.representation(using:.png,properties:[:]) else {print("Logo export failed");exit(1)}
                let name=brands[self.index%brands.count]+(self.index>=brands.count ? "-light":"-dark")+".png"
                try! png.write(to:output.appendingPathComponent(name))
                self.index+=1;self.next()
            }
        }
    }
}
let renderer=Renderer()
renderer.web=WKWebView(frame:NSRect(x:0,y:0,width:128,height:128))
renderer.web.navigationDelegate=renderer
renderer.web.setValue(false,forKey:"drawsBackground")
let window=NSWindow(contentRect:NSRect(x:0,y:0,width:128,height:128),styleMask:[],backing:.buffered,defer:false)
window.contentView=renderer.web
renderer.next()
DispatchQueue.main.asyncAfter(deadline:.now()+45) {print("Logo export timed out");exit(1)}
app.run()
