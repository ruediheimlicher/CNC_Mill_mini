//
//  rDrehknopf.swift
//  Robot_Interface
//
//  Created by Ruedi Heimlicher on 18.08.2019.
//  Copyright © 2019 Ruedi Heimlicher. All rights reserved.
//
import Cocoa
import Foundation

class rPlatteView: NSView
{
   var weg: NSBezierPath = NSBezierPath()
   var kreuz: NSBezierPath = NSBezierPath()
   var kreis: NSBezierPath = NSBezierPath()
   var achsen: NSBezierPath = NSBezierPath()
   var mittelpunkt:NSPoint = NSZeroPoint
   var winkel:CGFloat = 0
   var hyp:CGFloat = 0
   var hgfarbe:NSColor = NSColor()
   
   var rot:CGFloat=90
   var gruen:CGFloat=240
   var blau:CGFloat=50
   
   var markarray:[NSBezierPath] = [NSBezierPath]()
   var numarray:[NSBezierPath] = [NSBezierPath]()
   
   var punktarray:[NSPoint] = [NSPoint]()
   
   var redfaktor:CGFloat = 1
   var transformfaktor:CGFloat = 0 // px to mm
   var wegindex=0;
   var faktor:CGFloat = 0
   
   var fahrtweg:CGFloat = 0
   
   var stepperposition:Int = 0
   var oldstepperposition:Int = 0
   
 //  var wegarray:[[Int]] = [[Int]]()
   var wegfloatarray:[[Double]] = [[Double]]()
   
   var markfeldarray:[NSRect] = [NSRect]()
   var klickmarkindex:Int = 0 // klicked punkt
   var klickmarkIndexset:IndexSet = IndexSet()
   var linienfarbe:NSColor = NSColor()
   var kreislinienfarbe:NSColor = NSColor()
   var kreisfillfarbe:NSColor = NSColor()
   var kreisclearfarbe:NSColor = NSColor()
   
   var drawstatus = 0 // 0: setweg zeichnet den Weg  1: draw zeichnet den Weg nach setstepperposition
   var drawcount:Int = 0
   required init?(coder  aDecoder : NSCoder) 
   {
      super.init(coder: aDecoder)
      //Swift.print("PlatteView init")
      //   NSColor.blue.set() // choose color
      // let achsen = NSBezierPath() // container for line(s)
      let w:CGFloat = bounds.size.width
      let h:CGFloat = bounds.size.height
      let mittex:CGFloat = bounds.size.width / 2
      let mittey:CGFloat = bounds.size.height / 2
      mittelpunkt = NSMakePoint(mittex, mittey)
      hyp = bounds.size.height / 2
      //Swift.print("JoystickView init mittex: \(mittex) mittey: \(mittey) hyp: \(hyp)")
      achsen.move(to: NSMakePoint(0, mittey)) // start point
      achsen.line(to: NSMakePoint(w, mittey)) // destination
      achsen.move(to: NSMakePoint(mittex, 0)) // start point
      achsen.line(to: NSMakePoint(mittex, h)) // destination
      achsen.lineWidth = 1  // hair line
      //achsen.stroke()  // draw line(s) in color
      
      rot=36
      gruen=255
      blau=4
      
      linienfarbe = NSColor(red: CGFloat(rot/255), green: CGFloat(gruen/255), blue: CGFloat(blau/255), alpha: 1.0)
      //     linienfarbe = NSColor.green
      
      rot=27
      gruen=114
      blau=59
      kreislinienfarbe = NSColor(red: CGFloat(rot/255), green: CGFloat(gruen/255), blue: CGFloat(blau/255), alpha: 1.0)
      
      rot=70.0
      gruen=160
      blau=100
      kreisfillfarbe = NSColor(red: CGFloat(rot/255), green: CGFloat(gruen/255), blue: CGFloat(blau/255), alpha: 1.0)
      //kreisfillfarbe = NSColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: 1.0)
     
      //    Swift.print("rot: \(rot/255)\n")
      
      if let joystickident = self.identifier
      {
         //  Swift.print("JoystickView ident: \(joystickident) raw: \(joystickident.rawValue)")
         
      }
      else
      {
         //Swift.print("JoystickView no ident")
      }
      
   }
   
   // https://stackoverflow.com/questions/21751105/mac-os-x-convert-between-nsview-coordinates-and-global-screen-coordinates
   
   override func draw(_ dirtyRect: NSRect) 
   {
      // https://stackoverflow.com/questions/36596545/how-to-draw-a-dash-line-border-for-nsview
      //self.layer?.backgroundColor = NSColor.white.cgColor
      super.draw(dirtyRect)
       // dash customization parameters
      let dashHeight: CGFloat = 1
      let dashColor: NSColor = .gray
      
      // setup the context
//      let currentContext = NSGraphicsContext.current!.cgContext
     // NSGraphicsContext.current!.CGContextClearRect(currentContext,self.bounds)
 //     currentContext.setLineWidth(dashHeight)
//    currentContext.setLineDash(phase: 0, lengths: [dashLength])
 //     currentContext.setStrokeColor(dashColor.cgColor)
      
      // draw the dashed path
  //    currentContext.addRect(bounds.insetBy(dx: dashHeight, dy: dashHeight))
 //     currentContext.strokePath()
      
      kreis.lineWidth = 1.5
      // neu
      
      //Swift.print("drawstatus: \(drawstatus) drawcount: \(drawcount) stepperposition: \(stepperposition) oldstepperposition: \(oldstepperposition) ")
      //Swift.print("draw  drawcount: \(drawcount) stepperposition: \(stepperposition)  dirtyRect: \(dirtyRect)")
      drawcount += 1
      
      if (drawstatus == 1)
      {
         //Swift.print("drawstatus 1")
         linienfarbe.set() // choose color
         weg.lineWidth = 1.5
         weg.stroke()  // draw line(s) in color
         
         var elcount:Int = 0
         var lastpunkt = NSMakePoint(0, 0)
         wegindex = 0
         //      let korr:CGFloat = 31.15
         let korr:CGFloat = 1
         markarray.removeAll()
         numarray.removeAll()
             for zeile in wegfloatarray
            {
               elcount += 1
               //  let x = CGFloat(zeile[0])
               //let lokalpunkt = NSMakePoint(CGFloat(zeile[1])/faktor/redfaktor * transformfaktor*korr,CGFloat(zeile[2])/faktor/redfaktor * transformfaktor*korr)
               
               let lokalpunkt = NSMakePoint(CGFloat(zeile[0]),CGFloat(zeile[1]))
               //Swift.print("lokalpunkt: \(lokalpunkt) stepperposition: \(stepperposition)" )
               //Swift.print("wegindex: \(wegindex) lokalpunkt: \(lokalpunkt) stepperposition: \(stepperposition)" )
               // Marke setzen
               var tempMarkRect:NSRect = NSMakeRect(lokalpunkt.x-3.1, lokalpunkt.y-3.1, 6.1, 6.1);
               
               if (wegindex == 0)
               {
                  tempMarkRect = NSMakeRect(lokalpunkt.x-5.1, lokalpunkt.y-5.1, 10.1, 10.1);
               }
               // tempMark=[NSBezierPath bezierPathWithOvalInRect:tempMarkRect]
               // Nummer setzen
               //          var tempNumRect:NSRect = NSMakeRect(lokalpunkt.x-12.1, lokalpunkt.y+4.1, 24.1, 8.1);
               var localkreis:NSBezierPath =  NSBezierPath()
               localkreis.appendOval(in: tempMarkRect)
               //              var fillcolor:NSColor = NSColor.blue
               //              fillcolor.setFill()
               markarray.append(localkreis)
               
               kreis.move(to: lokalpunkt)
               //    kreis.appendOval(in: tempMarkRect)
               
               linienfarbe.set() 
               
               //           var localnumfeld:NSBezierPath =  NSBezierPath()
               //           var numrect:NSRect  = NSMakeRect(tempNumPunkt.x-1, lokalpunkt.y+3, 12, 10);
               //            localnumfeld.appendRect(numrect)
               //numarray.append(localnumfeld)
               NSColor.white.set()
               //localnumfeld.fill()
               kreislinienfarbe.set() 
               localkreis.stroke()
               var tempNumPunkt:NSPoint = NSMakePoint(0, 0)
               if wegindex == wegfloatarray.count - 1
               {
                  tempNumPunkt = NSMakePoint(lokalpunkt.x - 12, lokalpunkt.y - 12)
               }
               else
               {
                  tempNumPunkt = NSMakePoint(lokalpunkt.x + 3, lokalpunkt.y + 3)
               }
               let atts = [NSAttributedStringKey.font:NSFont.init(name: "Helvetica", size: 10)]
               let numstring = String(wegindex)
               numstring.draw(
                  at: tempNumPunkt, 
                  withAttributes: atts as [NSAttributedStringKey : Any])
               
               if (wegindex <= stepperposition) || (klickmarkIndexset.contains(wegindex)) // Start, Marke fuellen
               {
                  //    var localkreis: NSBezierPath = NSBezierPath()
                  lastpunkt = lokalpunkt
                  weg.move(to: lokalpunkt)
                  /*
                   var localkreis:NSBezierPath =  NSBezierPath()
                   localkreis.appendOval(in: tempMarkRect)
                   //              var fillcolor:NSColor = NSColor.blue
                   //              fillcolor.setFill()
                   markarray.append(localkreis)
                   */
                  kreisfillfarbe.set() // choose color
                  if (wegindex > 0)
                  {
                     localkreis.fill()
                  }
                  kreislinienfarbe.set() // choose color
                  localkreis.lineWidth = 1.0
                  localkreis.stroke()
                  linienfarbe.set() 
                  //              kreis.append(localkreis)
                  /*
                   var tempNumPunkt:NSPoint = NSMakePoint(lokalpunkt.x + 3, lokalpunkt.y + 3)
                   let atts = [NSAttributedStringKey.font:NSFont.init(name: "Helvetica", size: 10)]
                   let numstring = String(wegindex)
                   numstring.draw(
                   at: tempNumPunkt, 
                   withAttributes: atts as [NSAttributedStringKey : Any])
                   */
               }
               else
               {
                  let dx = lokalpunkt.x - lastpunkt.x
                  let dy = lokalpunkt.y - lastpunkt.y
                  fahrtweg += hypotenuse(dx, dy)
                  lastpunkt = lokalpunkt
                  weg.line(to: lokalpunkt)
                  //       kreis.fill()
                  /*
                   var localkreis:NSBezierPath =  NSBezierPath()
                   localkreis.appendOval(in: tempMarkRect)
                   markarray.append(localkreis)
                   */
                  //              var fillcolor:NSColor = NSColor.blue
                  //              fillcolor.setFill()
                  NSColor.yellow.set() // choose color
                  localkreis.fill()
                  kreislinienfarbe.set() // choose color
                  localkreis.lineWidth = 1.0
                  localkreis.stroke()
                  NSColor.green.set() 
                  //              kreis.append(localkreis)
                  linienfarbe.set() 
                  /*
                   var tempNumPunkt:NSPoint = NSMakePoint(lokalpunkt.x + 3, lokalpunkt.y + 3)
                   let atts = [NSAttributedStringKey.font:NSFont.init(name: "Helvetica", size: 10)]
                   let numstring = String(wegindex)
                   numstring.draw(
                   at: tempNumPunkt, 
                   withAttributes: atts as [NSAttributedStringKey : Any])
                   */
                  
               }
               //localnumfeld.stroke()
               wegindex += 1
            }
         
         //print("draw fahrtweg: \(fahrtweg) element count: \(elcount)")
         
         //         drawstatus = 0
         
      }
      else
      {
         //Swift.print("drawstatus 0")
         linienfarbe.set() // choose color
         weg.lineWidth = 1.5
         weg.stroke()  // draw line(s) in color
         
         kreislinienfarbe.set() // choose color
         
         kreis.stroke()

         NSColor.green.set() 
         
      }
      
      // end neu
      NSColor.blue.set() // choose color
      achsen.stroke() 
      NSColor.red.set() // choose color
      kreuz.stroke()
      //   kreis.lineWidth = 1.5
      //    kreis.fill()
      //    kreis.stroke()
      //Swift.print( "draw markarray: \(markarray.count)" )
   }
   
   override func mouseDown(with theEvent: NSEvent) 
   {
      
      super.mouseDown(with: theEvent)
      //let ident  = self.identifier as! String
      let ident  = self.identifier
      let nc = NotificationCenter.default
      Swift.print("mouseDowne ident: \(ident)")
      var identstring = ""
      if let rawident:String = ident?.rawValue
      {
         identstring = rawident
      }
      else
      {
         identstring = "13"
         
      }
      
      let location = theEvent.locationInWindow
          Swift.print(location)
      //    NSPoint lokalpunkt = [self convertPoint: [anEvent locationInWindow] fromView: nil];
      let lokalpunkt = convert(theEvent.locationInWindow, from: nil)
      //    Swift.print(lokalpunkt)
      
      
      // setup the context
      // setup the context
      let dashHeight: CGFloat = 1
      let dashColor: NSColor = .green
      
 //     https://stackoverflow.com/questions/3051760/how-to-get-a-list-of-points-from-a-uibezierpath
      var klickindex = 0
      var infeld = 0 // klick in Feld
      var userinformation:[String : Any]
      
      for feld in markfeldarray
      {
       //  Swift.print("klickindex: \(klickindex) lokalpunkt: \(lokalpunkt) feld: \(feld) ")
         //    let klickrect = NSMakeRect(punkt.x-5, punkt.y-5, 10, 10)
         if mouse(lokalpunkt, in: feld)
         {
            Swift.print("\nmouseDown klick in \(klickindex)")
            userinformation = ["message":"mousedown", "klickpunkt": lokalpunkt, "index": klickindex] as [String : Any]
            nc.post(name:Notification.Name(rawValue:"klickpunkt"),
                    object: nil,
                    userInfo: userinformation)
            klickmarkindex = klickindex
            klickmarkIndexset.insert(klickindex)
            
            infeld = 1
            
            break
          }
          klickindex += 1
      }
      
      print("mouseDown klickmarkindex: \(klickmarkindex)")
      //    NSColor.blue.set() // choose color
      // https://stackoverflow.com/questions/47738822/simple-drawing-with-mouse-on-cocoa-swift
      //clearWeg()
      
   //   if kreuz.isEmpty
      if infeld == 1
      {
          let kreuzpunkt = punktarray[klickmarkindex];
         kreuz.move(to: kreuzpunkt)
         // kreuz zeichnen
         kreuz.line(to: NSMakePoint(kreuzpunkt.x+8, kreuzpunkt.y+8))
         kreuz.line(to: kreuzpunkt)
         kreuz.line(to: NSMakePoint(kreuzpunkt.x+8, kreuzpunkt.y-8))
         kreuz.line(to: kreuzpunkt)
         kreuz.line(to: NSMakePoint(kreuzpunkt.x-8, kreuzpunkt.y-8))
         kreuz.line(to: kreuzpunkt)
         kreuz.line(to: NSMakePoint(kreuzpunkt.x-8, kreuzpunkt.y+8))
         kreuz.line(to: kreuzpunkt)
         
         // zurueck zu kreuzpunkt
         weg.move(to: kreuzpunkt)
       
         
         userinformation = ["message":"mousedown", "punkt": lokalpunkt, "index": weg.elementCount, "first": 1, "ident" :identstring] as [String : Any]
         //userinformation["ident"] = self.identifier
      }
      
     else
      {
         weg.move(to: lokalpunkt)
         
         userinformation = ["message":"mousedown", "punkt": lokalpunkt, "index": weg.elementCount, "first": 0]
         //userinformation["ident"] = self.identifier
      }
     
      
  //    nc.post(name:Notification.Name(rawValue:"joystick"),
  //            object: nil,
  //            userInfo: userinformation)
      needsDisplay = true   
   }
   
   override func rightMouseDown(with theEvent: NSEvent) 
   {
      self.clearWeg()
      Swift.print("right mouse")
      let location = theEvent.locationInWindow
      Swift.print(location)
      needsDisplay = true
   }
   
   
   override func mouseDragged(with theEvent: NSEvent) 
   {
      Swift.print("mouseDragged")
      let location = theEvent.locationInWindow
      //Swift.print(location)
      var lokalpunkt = convert(theEvent.locationInWindow, from: nil)
      var userinformation:[String : Any]
      Swift.print(lokalpunkt)
      if (lokalpunkt.x >= self.bounds.size.width)
      {
         lokalpunkt.x = self.bounds.size.width
      }
      if (lokalpunkt.x <= 0)
      {
         lokalpunkt.x = 0
      }
      
      if (lokalpunkt.y > self.bounds.size.height)
      {
         lokalpunkt.y = self.bounds.size.height
      }
      if (lokalpunkt.y <= 0)
      {
         lokalpunkt.y = 0
      }     
      
 //     weg.line(to: lokalpunkt)
      
      
      
      needsDisplay = true
      userinformation = ["message":"mousedown", "punkt": lokalpunkt, "index": weg.elementCount, "first": -1] as [String : Any]
      userinformation["ident"] = self.identifier
      
      let nc = NotificationCenter.default
      nc.post(name:Notification.Name(rawValue:"pcb"),
              object: nil,
              userInfo: userinformation)
      
      
   }
   
   func hypotenuse(_ a: CGFloat, _ b: CGFloat) -> CGFloat 
   {
      return (a * a + b * b).squareRoot()
   }
   
   func resetStepperposition()
   {
      stepperposition = 0
      oldstepperposition = 0
      needsDisplay = true
   }
   func setStepperposition(pos:Int)
   {
      stepperposition = pos
      drawstatus =  1
      /*
      if pos == 1
      {
         print("\t ******   PlatteView setStepperposition pos: \(pos) wegfloatarray: \(wegfloatarray) \nwegfloatarray: \(wegfloatarray)")
      }
       */
      //print("\t ******   PlatteView setStepperposition pos: \(pos) markfeldarray.count: \(markfeldarray.count) oldstepperposition: \(oldstepperposition)")
       if ((markfeldarray.count > stepperposition) && (stepperposition > oldstepperposition))// 
      {
         oldstepperposition = stepperposition
         //print("\t ******   PlatteView setStepperposition pos: \(pos) markfeldarray.count: \(markfeldarray.count) \nmarkrect: \(markfeldarray[stepperposition])")
         //print("\t ******   PlatteView setStepperposition zeichnen pos: \(pos) ")
         //print("\t ******   PlatteView setStepperposition pos: \(pos) feld: \(markfeldarray[stepperposition]) needs display")
         self.setNeedsDisplay(markfeldarray[stepperposition])
      //needsDisplay = true
         self.displayIfNeeded()
      }
       else if markfeldarray.count > 0
       {
         
         self.setNeedsDisplay(markfeldarray.last! )
         self.displayIfNeeded()
         //print("\t ******   PlatteView setStepperposition nicht zeichnen pos: \(pos) ")
         
       }
   }
   
 
   func setfloatWeg(newWeg:[[Double]], scalefaktor:Int , transform:Double)-> Int
   {
      //print("\t ******   PlatteView setfloatWeg newWeg: \(newWeg)")
      let flip = 1 // Darstellung im Graph spiegeln
      var maxy:Double = 0
      if flip == 1
      {
         
         for line in newWeg
         {
            if (line[2] > maxy)
            {
               maxy = line[2] 
            }
         }
         print("maxy: \(maxy)")
         maxy += 10 // Abstand vom unteren Rand in Graph
      }
      weg.removeAllPoints()
      kreuz.removeAllPoints()
      kreis.removeAllPoints()
      markfeldarray.removeAll()
      punktarray.removeAll()
      wegfloatarray.removeAll()
      for mark in markarray
      {
         mark.removeAllPoints()
      }
      markarray.removeAll()
      drawstatus = 1
      fahrtweg = 0
      //redfaktor = 200.0
      redfaktor = 1
      klickmarkindex = 0
      klickmarkIndexset.removeAll()
      
      transformfaktor = CGFloat(transform) // px to mm
      var wegindex=0;
      faktor = CGFloat(scalefaktor)
      let floatfaktor = Double(scalefaktor)
      var  tempMark:NSBezierPath
      var lastpunkt = NSMakePoint(0, 0)
      var elcount = 0
      
      //print("transformfaktor: \(transformfaktor) faktor: \(faktor)")
      for pos in 0..<newWeg.count
      {
         /*
         let nummerH = UInt16(newWeg[pos][39])
         let nummerL =  UInt16(newWeg[pos][40])
         
         var anzeigezeile:Int = Int(((nummerH << 8) | (nummerL )))
         if(newWeg[pos][41] == 0xFF) // keine Drillzeile
         {
            wegfloatarray.append([newWeg[pos][1] * Double(faktor * transformfaktor),newWeg[pos][2] * Double(faktor * transformfaktor)])
         }
         */
         var wegy = newWeg[pos][2]
         if flip == 1
         {
            wegy = maxy - newWeg[pos][2]
         }
 
         //wegfloatarray.append([newWeg[pos][1] * Double(faktor * transformfaktor),newWeg[pos][2] * Double(faktor * transformfaktor)])
         wegfloatarray.append([newWeg[pos][1] * Double(faktor * transformfaktor),wegy * Double(faktor * transformfaktor)])

         
      }
      
      
      for zeile in wegfloatarray
      {
         
   //      wegarray.append([wegindex,Int(zeile[1] * 1000000),Int(zeile[2] * 1000000) ])
         elcount += 1
         //  let x = CGFloat(zeile[0])
         let lokalpunkt = NSMakePoint(CGFloat(zeile[0]),CGFloat(zeile[1]))
         punktarray.append(lokalpunkt)
         //Swift.print("lokalpunkt: \(lokalpunkt) stepperposition: \(stepperposition)" )
         if wegindex == 0
         {
            lastpunkt = lokalpunkt
            weg.move(to: lokalpunkt)
            
         }
         else
         {
            let dx = lokalpunkt.x - lastpunkt.x
            let dy = lokalpunkt.y - lastpunkt.y
            fahrtweg += hypotenuse(dx, dy)
            lastpunkt = lokalpunkt
            weg.line(to: lokalpunkt)
         }
         //CNC_Stepper:
         /*
          NSRect tempMarkARect=NSMakeRect(lokalpunkt.x-4.1, lokalpunkt.y-4.1, 8.1, 8.1);
          tempMarkA=[NSBezierPath bezierPathWithOvalInRect:tempMarkARect];
          [[NSColor grayColor]set];
          [tempMarkA stroke];
          */
         var tempMarkRect:NSRect = NSMakeRect(lokalpunkt.x-4.1, lokalpunkt.y-4.1, 8.1, 8.1);
        
         // tempMark=[NSBezierPath bezierPathWithOvalInRect:tempMarkRect]
  //       kreis.move(to: lokalpunkt)
         
         kreis.appendOval(in: tempMarkRect)
         tempMarkRect = tempMarkRect.insetBy(dx: -4, dy: -4)
         markfeldarray.append(tempMarkRect)
         
         /*
          
           
          var tempNumPunkt:NSPoint = NSMakePoint(lokalpunkt.x + 3, lokalpunkt.y + 3)
          let atts = [NSAttributedStringKey.font:NSFont.init(name: "Helvetica", size: 10)]
          let numstring = String(wegindex)
          //       print(numstring)
          numstring.draw(
          at: tempNumPunkt, 
          withAttributes: atts as [NSAttributedStringKey : Any])
          */
         wegindex += 1
      }
      
     
      
      //print("setfloatWeg markfeldarray count: \(markfeldarray.count) \n \(markfeldarray) ")
      needsDisplay = true
      return Int(fahrtweg)
   }
   
   func setWeg(newWeg:[[Int]], scalefaktor:Int , transform:Double)-> Int
   {
      return 13
   }
   /*
   func setWeg(newWeg:[[Int]], scalefaktor:Int , transform:Double)-> Int
   {
      print("\t ******   PlatteView setWeg: wegarray count: \(wegarray.count)  newWeg: \(newWeg)")
      weg.removeAllPoints()
      kreuz.removeAllPoints()
      kreis.removeAllPoints()
      for mark in markarray
      {
         mark.removeAllPoints()
      }
      markarray.removeAll()
      drawstatus = 0
      fahrtweg = 0
      redfaktor = 200.0
      transformfaktor = CGFloat(transform) // px to mm
      var wegindex=0;
      faktor = CGFloat(scalefaktor)
      var  tempMark:NSBezierPath
      var lastpunkt = NSMakePoint(0, 0)
      var elcount = 0
      
      wegarray = newWeg
      print("\t setWeg: wegarray: \(wegarray)")
      for zeile in newWeg
      {
         elcount += 1
         //  let x = CGFloat(zeile[0])
         let lokalpunkt = NSMakePoint(CGFloat(zeile[1])/faktor/redfaktor * transformfaktor,CGFloat(zeile[2])/faktor/redfaktor * transformfaktor)
         //print(lokalpunkt)
         if wegindex == 0
         {
            lastpunkt = lokalpunkt
            weg.move(to: lokalpunkt)
            
         }
         else
         {
            let dx = lokalpunkt.x - lastpunkt.x
            let dy = lokalpunkt.y - lastpunkt.y
            fahrtweg += hypotenuse(dx, dy)
            lastpunkt = lokalpunkt
            weg.line(to: lokalpunkt)
         }
         //CNC_Stepper:
         /*
          NSRect tempMarkARect=NSMakeRect(lokalpunkt.x-4.1, lokalpunkt.y-4.1, 8.1, 8.1);
          tempMarkA=[NSBezierPath bezierPathWithOvalInRect:tempMarkARect];
          [[NSColor grayColor]set];
          [tempMarkA stroke];
          */
         var tempMarkRect:NSRect = NSMakeRect(lokalpunkt.x-4.1, lokalpunkt.y-4.1, 8.1, 8.1);
         // tempMark=[NSBezierPath bezierPathWithOvalInRect:tempMarkRect]
         kreis.move(to: lokalpunkt)
         kreis.appendOval(in: tempMarkRect)
         //      weg.move(to: lokalpunkt)
         /*
          var tempNumPunkt:NSPoint = NSMakePoint(lokalpunkt.x + 3, lokalpunkt.y + 3)
          let atts = [NSAttributedStringKey.font:NSFont.init(name: "Helvetica", size: 10)]
          let numstring = String(wegindex)
          //       print(numstring)
          numstring.draw(
          at: tempNumPunkt, 
          withAttributes: atts as [NSAttributedStringKey : Any])
          */
         wegindex += 1
      }
      print("setWeg fahrtweg: \(fahrtweg) element count: \(elcount)")
      
      needsDisplay = true
      return Int(fahrtweg)
   }
   */
   func clearNum()
   {
      Swift.print( "clearNum numarray: \(numarray.count)" )
      return
      for num in numarray
      {
         num.fill()
      }
      needsDisplay = true
   }
   func clearMark()
   {

      //Swift.print( "clearMark markfeldarray: \(markfeldarray)")
      kreuz.removeAllPoints()
      //NSColor.white.set() // 
      
      klickmarkIndexset.removeAll()
      setStepperposition(pos: 0)
      needsDisplay = true
   }

   
   func clearWeg()
   {
      Swift.print( "clearWeg" )
      //Swift.print( "clearNum markarray: \(markarray.count)" )
      let clearColor:NSColor
         = .clear
      self.layer?.backgroundColor = .clear
      
      weg.removeAllPoints()
      kreuz.removeAllPoints()
      kreis.removeAllPoints()
      markfeldarray.removeAll()
      wegfloatarray.removeAll()
      
      for mark in markarray
      {
         mark.removeAllPoints()
      }
 
      markarray.removeAll()
      for num in numarray
      {
         num.fill()
      }

      drawstatus = 1
      fahrtweg = 0
      //redfaktor = 200.0
      redfaktor = 1
      klickmarkindex = 0
      wegindex=0;
      stepperposition = 0;
      weg.removeAllPoints() // linie weg
      
//      kreuz.removeAllPoints()
 //     kreis.removeAllPoints()
      klickmarkIndexset.removeAll()
      
       //markarray.removeAll()
      needsDisplay = true
      
   }
   /*
    override func rotate(byDegrees angle: CGFloat) 
    {
    var transform = NSAffineTransform()
    transform.rotate(byDegrees: angle)
    weg.transform(using: transform as AffineTransform)
    }
    */
   override func keyDown(with theEvent: NSEvent)
   {
      Swift.print( "Key Pressed" )
   }
   
} // rPlatteView

