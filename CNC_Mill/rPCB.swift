//
//  rBasis.swift
//  Robot_Interface
//
//  Created by Ruedi Heimlicher on 06.08.2019.
//  Copyright © 2019 Ruedi Heimlicher. All rights reserved.
//

import Cocoa

let USBATTACHED:Int     =      5
let USBREMOVED:Int      =      6

class rPCB: rViewController 
{
   
   
   var PCB_Test = 0
   
   var urlarray = [[String]]()
   
   var urldicarray = [[String:String]]() // dic dateiname:url
   var svgdicarray = [String:String]() // dic dateiname:url
   
   struct svgdata
   {
      let svgname:String
      let svgurl:String
   }
   var svgdataArray:[svgdata] = []
   
   var svgpoparray:[(svgname:String,svgurl:String)] = []
      
   var circledicarray = [[String:Int]]()
   
   var circlefloatdicarray = [[String:Double]]()
   
   var circlearray = [[Int]]() // Koordinaten der Punkte
   
   var circlefloatarray = [[Double]]() // Koordinaten der Punkte als double 
   
   var circlefloatarray_raw = [[Double]]() // Koordinaten der Punkte aus input
   
   var polylinepunktarray = [[Double]]()
   
   var maxdiff:Double = 100 // maximale differenz fuer doppelte Punkte
   var maxfloatdiff:Double = 5 // maximale differenz fuer doppelte Float-Punkte
   
   var zoomfaktor:Double = 1.0
   
   //  var transformfaktor:Double = 0.3527777777779440
   var transformfaktor:Double = 1
   
   var Schnittdatenarray = [[UInt8]]()
   var Schnittdatenarray_n = [[UInt8]]()
   var nextdatenarray = [UInt8]()
   
   var ablaufstatus:UInt8 = 0
   let DRILL_OK = 1
   var dpi2mmfaktor:Double = 0
   var mmFormatter = NumberFormatter()


   var drillweg = 5
   
   var platinendicke = 2.8
   
   var drillspeed = 2400
   
   var speedA = 2400
   var speedB = 2400;
   var speedC = 2000;

 
   var anschlagstatus = 0;
   
   var cncstatus:UInt8 = 0 // cncstatus
   let RUN = 0
   let PAUSE = 1
   let GO_BACK = 2
   let GO_END  = 3
   
   
   var CNC_DatendicArray = [[String:String]]()
   
   var lastklickposition:position = position()
   
   var lasttabledataindex:Int = 0 // letzte  CNC-position in circlearray
   var tabledatastatus:UInt8 = 0
   var mouseistdown:Int = 0
   
   var selectetDataTableRow = 0
   
   var tasktime:CFAbsoluteTime = 0
   var usbtime:CFAbsoluteTime = 0
   var waittime:CFAbsoluteTime?
   var responsetime:CFAbsoluteTime = 0
   
   
   
   var taskzeit:Double = 0
   var usbzeit:Double = 0
   var responsezeit:Double = 0
   
   var nextdatazeit:Double = 0
   
   
   //   var pfeilschrittweite:Int = 0
   var tsp_nn = rTSP_NN()
   // var schnittPfad = rSchnittPfad()
   // var usbstatus: Int32 = 0
   
   //  var teensy = usb_teensy()
   
   var now = Date()
   var startzeit = Date()
   
   var taskpopitems = [String]()
   
   var zeitformatter = DateComponentsFormatter()
   
   @IBOutlet weak var propfaktorFeld: NSTextField!
   
   @IBOutlet weak var propfaktorStepper: NSStepper!

   
   @IBOutlet weak var readSVG_Knopf: NSButton!
   
   @IBOutlet weak var readSVG_Pop: NSPopUpButton!
   
   @IBOutlet weak var SVG_Pfad: NSTextField!
   @IBOutlet weak var SVG_Testfeld: NSTextField!
   
   @IBOutlet weak var PCB_Data_Knopf: NSButton!
   
   @IBOutlet weak var DataSendTaste: NSButton!
   @IBOutlet weak var ClearPCBTaste: NSButton!
   @IBOutlet weak var linear_checkbox: NSButton!
   @IBOutlet weak var horizontal_checkbox:NSButton!
   @IBOutlet weak var figurschliessen_checkbox:NSButton!
   
   @IBOutlet weak var zoomFeld: NSTextField!
   
   @IBOutlet weak var fahrtweg: NSTextField!
   @IBOutlet weak var speedFeld: NSTextField!
   
   @IBOutlet weak var timerintervallFeld: NSTextField!
   
   @IBOutlet weak var ablaufzeitFeld: NSTextField!
   
   @IBOutlet weak var stepsFeld: NSTextField!
   @IBOutlet weak var ramp_OK_Check: NSButton!
   
   @IBOutlet weak var NN_OK_Check: NSButton! // NearestNeighbour
   
   @IBOutlet weak var dxFeld: NSTextField!
   @IBOutlet weak var dyFeld: NSTextField!
   
   @IBOutlet weak var dx_Stepper: NSStepper!
   @IBOutlet weak var dy_Stepper: NSStepper!
   
   @IBOutlet weak var homexFeld: NSTextField!
   @IBOutlet weak var homeyFeld: NSTextField!

   @IBOutlet weak var homexFeld_mm: NSTextField!
   @IBOutlet weak var homeyFeld_mm: NSTextField!

   @IBOutlet weak var stepsZFeld: NSTextField!
   
   @IBOutlet  var dataTable: NSTableView!
   
   @IBOutlet weak var drillKnopf: NSButton!
   @IBOutlet weak var drillOKKnopf: NSButton!
   @IBOutlet weak var drillUPKnopf: NSButton!
   
   @IBOutlet weak var drillStepUPKnopf: NSButton!
   @IBOutlet weak var drillStepDOWNKnopf: NSButton!
   @IBOutlet weak var MotorKnopf: NSButton!
   
   @IBOutlet weak var moveDickeKnopf: NSButton!
   
   @IBOutlet weak var drillwegFeld: NSTextField!
   @IBOutlet weak var drillwegmmFeld: NSTextField!
   @IBOutlet weak var drillspeedSlider: NSSlider!
   @IBOutlet weak var drillspeedFeld: NSTextField!
   
   @IBOutlet weak var dickeFeld: NSTextField!
   
   @IBOutlet weak var drillNullpunktKnopf: NSButton!
   @IBOutlet weak var drillMoveAbsUPKnopf: NSButton!
   @IBOutlet weak var drillMoveAbsDOWNKnopf: NSButton!
   @IBOutlet weak var drillAbsolutwegFeld: NSTextField!
   
   //@IBOutlet weak var Zeilen_Stepper: NSStepper!
   
   @IBOutlet weak var PauseKnopf: NSButton!
   
   @IBOutlet weak var TaskPop: NSPopUpButton!
   
    
   override func viewDidAppear() 
   {
      let a = 1
      //print ("PCB viewDidAppear selectedDevice: \(selectedDevice)")
   }
   
   @objc func printSomething() {
           print("Hello")
       }
  
   // MARK: ***    ***   viewDidLoad
   override func viewDidLoad() 
   {
      super.viewDidLoad()
      
      
       
      
      
      NotificationCenter.default.addObserver(self, selector:#selector(beendenAktion(_:)),name:NSNotification.Name(rawValue: "beenden"),object:nil)

      NSEvent.addLocalMonitorForEvents(matching: .keyDown) 
      {
         if self.myKeyDown(with: $0) {
            return nil
         } else {
            return $0
         }
      }
      NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
          self.flagsChanged(with: $0)
          return $0
      }
      /*
      print("PCB viewDidLoad UserDefaults Key value")
      for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
          print("\(key) = \(value) \n")
      }
      */
      
      if UserDefaults.standard.object(forKey: "propfaktor") != nil 
      {
         print("PCB viewDidLoad UserDefaults Key exists");
         propfaktor = UserDefaults.standard.object(forKey: "propfaktor") as! Double
         print("PCB viewDidLoad UserDefaults propfaktor : \(propfaktor)");
      }
      else
      {
         propfaktor = 2845000.0
      }

  //    readSVG_Pop.removeAllItems()
      
      /*
      if   UserDefaults.standard.array(forKey: "pcbpoparray")  as? [[String]] == nil //
      {
      readSVG_Pop.addItem(withTitle: "Neu")         
      }
      else
      {
         readSVG_Pop.addItem(withTitle: "Neu")
         let pcbpoparray:[[String]] = (UserDefaults.standard.array(forKey: "pcbpoparray") ?? [["leer"]])  as [[String]] 
         for popzeile in pcbpoparray
         {
            readSVG_Pop.addItem(withTitle: popzeile[0])
            svgdicarray[popzeile[0]] = popzeile[1]
         }
      }
      */
  //    readSVG_Pop.addItem(withTitle: "Neu")
      //let q = kgv(m:200,n:1096)
      // 
      let hh = phex(200);
      print("phex: \(hh)")
      // Do view setup here.
      self.view.window?.acceptsMouseMovedEvents = true
      //let view = view[0] as! NSView
      self.view.wantsLayer = true
      
      hintergrundfarbe  = NSColor.init(red: 0.15, 
                                       green: 0.15, 
                                       blue: 0.85, 
                                       alpha: 0.25)
      
      self.view.layer?.backgroundColor = hintergrundfarbe.cgColor
      
      formatter.maximumFractionDigits = 1
      formatter.minimumFractionDigits = 2
      formatter.minimumIntegerDigits = 1
      
      //Ablaufzeit
      zeitformatter.allowedUnits = [ .minute, .second]
      zeitformatter.unitsStyle = .positional
      zeitformatter.zeroFormattingBehavior = [ .pad ]
      ablaufzeitFeld.stringValue = zeitformatter.string(from: TimeInterval(0))!
      
      
      //formatter.roundingMode = .down
      print("viewDidLoad propfaktor: \(propfaktor)")
         
      transformfaktor = INTEGERFAKTOR/10/propfaktor
      dpi2mmfaktor = propfaktor / INTEGERFAKTOR
      //mmFormatter.usesGroupingSeparator = false
      //mmFormatter.numberStyle = .currency
      // localize to your grouping and decimal separator
      //mmFormatter.locale = Locale.current
      mmFormatter.minimumFractionDigits = 2
      
      //print("transformfaktor: \(transformfaktor)")
      let sup = self.view.superview
      //print("DeviceTab superview: \(String(describing: sup)) ident: \(String(describing: sup?.identifier))")
      
      //USB_OK.backgroundColor = NSColor.greenColor()
      // Do any additional setup after loading the view.
      let newdataname = Notification.Name("newdata")
        NotificationCenter.default.addObserver(self, selector:#selector(newDataAktion(_:)),name:newdataname,object:nil)
      //     NotificationCenter.default.addObserver(self, selector:#selector(joystickAktion(_:)),name:NSNotification.Name(rawValue: "joystick"),object:nil)
      NotificationCenter.default.addObserver(self, selector:#selector(usbstatusAktion(_:)),name:NSNotification.Name(rawValue: "usb_status"),object:nil)
      //     NotificationCenter.default.addObserver(self, selector:#selector(usbattachAktion(_:)),name:NSNotification.Name(rawValue: "usb_attach"),object:nil)
      
      NotificationCenter.default.addObserver(self, selector:#selector(dataTableAktion(_:)),name:NSNotification.Name(rawValue: "datatable"),object:nil)

      NotificationCenter.default.addObserver(self, selector:#selector(klickpunktAktion(_:)),name:NSNotification.Name(rawValue: "klickpunkt"),object:nil)
      //mmFormatter.string(from: NSNumber(Double(drillweg) * dpi2mmfaktor))
      let drillwegmm = Double(drillweg) * dpi2mmfaktor
      let mmString = String(format: "%0.2f",drillwegmm)
 //     drillwegmmFeld.stringValue = mmString
      
      drillwegFeld.integerValue = drillweg
      
      drillspeedFeld.integerValue = speedC
      drillspeedSlider.maxValue = 3000
      drillspeedSlider.integerValue = speedC
      
      let stepUpKnopf = NSButton()
      //stepUpKnopf.frame = NSMakeRect(1060,320, 32, 32) 
      stepUpKnopf.frame = drillStepUPKnopf.frame
      stepUpKnopf.title = "UP"
      stepUpKnopf.setButtonType(NSButton.ButtonType.momentaryPushIn)
      stepUpKnopf.bezelStyle = NSButton.BezelStyle.shadowlessSquare
      stepUpKnopf.imageScaling = .scaleProportionallyUpOrDown
      stepUpKnopf.image = NSImage(named: NSImage.Name(rawValue: "pfeilup"))
    //  stepUpKnopf.sendActionOn(NSEvent.NSEventMaskLeftMouseDown)

      stepUpKnopf.tag = 100
      stepUpKnopf.target = self
      stepUpKnopf.action = #selector(self.drill_up) 
      self.view.addSubview(stepUpKnopf)

      let stepDownKnopf = NSButton()
      //stepDownKnopf.frame = NSMakeRect(1060,285, 32, 32) 
      stepDownKnopf.frame = drillStepDOWNKnopf.frame
      stepDownKnopf.title = "UP"
      stepDownKnopf.setButtonType(NSButton.ButtonType.momentaryPushIn)
      stepDownKnopf.bezelStyle = NSButton.BezelStyle.shadowlessSquare
      stepDownKnopf.imageScaling = .scaleProportionallyUpOrDown
      stepDownKnopf.image = NSImage(named: NSImage.Name(rawValue: "pfeilup2"))
      stepDownKnopf.tag = 101
      stepDownKnopf.target = self
      stepDownKnopf.action = #selector(self.drill_down) 
      self.view.addSubview(stepDownKnopf)
      
      
      // schnittPfad
      schnittPfad?.setStartposition(x: 0x800, y: 0x800, z: 0)
      
      dickeFeld.doubleValue = platinendicke
      
      
      propfaktorStepper.doubleValue = propfaktor
      propfaktorFeld.doubleValue = propfaktor
      // Pot 0
      /*
       Pot0_Slider.integerValue = Int(ACHSE0_START)
       Pot0_Feld.integerValue = Int(ACHSE0_START)
       let intpos0 = UInt16(Double(ACHSE0_START) * FAKTOR0)
       Pot0_Feld.integerValue = Int(UInt16(Double(ACHSE0_START) * FAKTOR0))
       Pot0_Stepper_L.integerValue = 0
       Pot0_Stepper_L_Feld.integerValue = 0
       Pot0_Stepper_H.integerValue = Int(Pot0_Slider.maxValue)
       Pot0_Stepper_H_Feld.integerValue = Int(Pot0_Slider.maxValue)
       
       // Pot 1
       Pot1_Slider.integerValue = Int(ACHSE1_START)
       //Pot1_Feld.integerValue = Int(ACHSE1_START)
       let intpos1 = UInt16(Double(ACHSE1_START) * FAKTOR1)
       Pot1_Feld.integerValue = Int(UInt16(Double(ACHSE1_START) * FAKTOR1))
       //Pot1_Feld.integerValue = Int(intpos1)
       Pot1_Stepper_L.integerValue = 0
       Pot1_Stepper_L_Feld.integerValue = 0 
       Pot1_Stepper_H.integerValue = Int(Pot1_Slider.maxValue)
       Pot1_Stepper_H_Feld.integerValue = Int(Pot1_Slider.maxValue)
       //print("intpos0: \(intpos0) intpos1: \(intpos1)")
       */
      /*
       // Pot 2
       Pot2_Slider.integerValue = Int(ACHSE2_START)
       Pot2_Feld.integerValue = Int(ACHSE2_START)
       Pot2_Stepper_L.integerValue = 0
       Pot2_Stepper_L_Feld.integerValue = 0 
       Pot2_Stepper_H.integerValue = Int(Pot2_Slider.maxValue)
       Pot2_Stepper_H_Feld.integerValue = Int(Pot2_Slider.maxValue)
       
       // Pot 3
       Pot3_Slider.integerValue = Int(ACHSE3_START)
       Pot3_Feld.integerValue = Int(ACHSE3_START)
       Pot3_Stepper_L.integerValue = 0
       Pot3_Stepper_L_Feld.integerValue = 0 
       Pot3_Stepper_H.integerValue = Int(Pot3_Slider.maxValue)
       Pot3_Stepper_H_Feld.integerValue = Int(Pot3_Slider.maxValue)
       */
      
      teensy.write_byteArray[SCHRITTEX_A] = UInt8(((ACHSE0_START) & 0xFF00) >> 8) // hb
      teensy.write_byteArray[SCHRITTEX_B] = UInt8(((ACHSE0_START) & 0x00FF) & 0xFF) // lb
      
      teensy.write_byteArray[DELAYX_A] = UInt8(((ACHSE1_START) & 0xFF00) >> 8) // hb
      teensy.write_byteArray[DELAYX_B] = UInt8(((ACHSE1_START) & 0x00FF) & 0xFF) // lb
      
      teensy.write_byteArray[0] = SET_0
      //     let wegarray = wegArrayMitWinkel(winkel: 1.0, distanz: 124)
      
      dataTable.doubleAction = #selector(handleDoubleClick)
      updatePfeilschrittweite(sw: pfeilschrittweite + 1)
      
      /*
       let tagarray = [1,2,3,4,11,22,33,44]
       for pfeiltag in tagarray
       {
       var taste = self.view.viewWithTag(pfeiltag) as? rPfeiltaste
       taste?.setSchrittweite(sw: pfeilschrittweite)
       }
       */
      var schritteweitearray:[String] = ["1","2","4","8","16"]
      schritteweitepop.removeAllItems()
      schritteweitepop.addItems(withTitles: schritteweitearray)
      schritteweitepop.selectItem(withTitle: schritteweitearray[1])
      
       
      teensy.write_byteArray[DRILL_BIT] = 0
      
      // Taskpop
      taskpopitems.append("PCB")
      taskpopitems.append("Poly")
      TaskPop.removeAllItems()
      for taskitem in taskpopitems
      {
         TaskPop.addItem(withTitle: taskitem)
      }
   }
   
   @objc override func beendenAktion(_ notification:Notification)
   {
      
      print("PCB beendenAktion propfaktor: \(propfaktor)")
      /*
       //https://learnappmaking.com/userdefaults-swift-setting-getting-data-how-to/
       
       print("beendenAktion Pot1_Stepper_L: \(Pot1_Stepper_L.integerValue) Pot2_Stepper_L: \(Pot2_Stepper_L.integerValue)")
       UserDefaults.standard.set(Pot1_Stepper_L.integerValue, forKey: "robot1min")
       UserDefaults.standard.set(Pot2_Stepper_L.integerValue, forKey: "robot2min")
       
       UserDefaults.standard.set(rotoffsetstepper.integerValue, forKey: "rotoffset")
       UserDefaults.standard.set(pot1offsetstepper.integerValue, forKey: "robot1offset")
       UserDefaults.standard.set(pot2offsetstepper.integerValue, forKey: "robot2offset")
       
       UserDefaults.standard.set(winkelfaktor1stepper.floatValue,forKey: "winkelfaktor1")
       UserDefaults.standard.set(winkelfaktor2stepper.floatValue,forKey: "winkelfaktor2")
       
       
       print("PCB beendenAktion")
       
       

      */
      
      print("\nPCB beendenAktion")
      /*
       // unbenutzt. Keine Berechtigung
      let keyarray = Array(svgdicarray.keys)
      var pcbpoparray = [[String]]()
      for pcbkey  in keyarray
      {
         guard let pcburl = svgdicarray[pcbkey] else { return }
         if pcburl.count > 0
         {
         print("key: \(pcbkey) urlstring: \(pcburl)")
            pcbpoparray.append([pcbkey, pcburl])
         }
         //UserDefaults.standard.set(dateiurlstring, forKey: pcbkey)
         
      }
      UserDefaults.standard.set(pcbpoparray, forKey:"pcbpoparray")
      */
      UserDefaults.standard.set(propfaktor, forKey: "propfaktor")
      
      let testpropfaktor = UserDefaults.standard.object(forKey: "propfaktor") as! Double
      print("VC  beenden testpropfaktor: \(testpropfaktor)")

    //  let testpcbpoparray = UserDefaults.standard.array(forKey: "pcbpoparray")  as? [[String]] 
      NSApplication.shared.terminate(self)
   }
   
   
   override func beenden()
   {
      print("PCB  beenden propfaktor: \(propfaktor)")
      
      UserDefaults.standard.set(propfaktor, forKey: "propfaktor")
      
      let testpropfaktor = UserDefaults.standard.object(forKey: "propfaktor") as! Double
      print("PCB  beenden testpropfaktor: \(testpropfaktor)")
      NSApplication.shared.terminate(self)
   }

   
   // https://stackoverflow.com/questions/49724924/nsevent-keycode-to-unicode-character-in-swift
   func myKeyDown(with event: NSEvent) -> Bool {
       // handle keyDown only if current window has focus, i.e. is keyWindow
       guard let locWindow = self.view.window,
          NSApplication.shared.keyWindow === locWindow else { return false }
      print("myKeyDown    keyCode: \(event.keyCode)\n") 
       switch Int( event.keyCode) {
 
       
       /*
 case kVK_Escape:
          // do what you want to do at "Escape"
          return true
 */
       default: 
          return false
       }
    }

   override  func keyDown(with event: NSEvent) 
   {
      //https://stackoverflow.com/questions/32446978/swift-capture-keydown-from-nsviewcontroller
      print("*****    ****    keyDown code: \(event.keyCode)")  
      switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) 
      {
      /*
       case [.command] where event.characters == "l",
            [.command, .shift] where event.characters == "l":
           print("command-l or command-shift-l")
 */
      case [.shift]:
          print("shift key is pressed")
      case [.control]:
          print("control key is pressed")
      case [.option] :
          print("option key is pressed keycode: \(event.keyCode)")
         switch event.keyCode 
         {
         case 123:
             print("option-left arrow")
         case 124:
             print("option-right arrow")
         case 125:
             print("option-down arrow")
         case 126:
             print("option-up arrow")
         default:
             break
         }

      case [.command]:
          print("Command key is pressed")
      case [.control, .shift]:
          print("control-shift keys are pressed")
      case [.option, .shift]:
          print("option-shift keys are pressed")
 
      case [.command, .shift]:
          print("command-shift keys are pressed")
      case [.control, .option]:
          print("control-option keys are pressed")
      case [.control, .command]:
          print("control-command keys are pressed")
      case [.option, .command]:
          print("option-command keys are pressed ")
 
      case [.shift, .control, .option]:
          print("shift-control-option keys are pressed")
      case [.shift, .control, .command]:
          print("shift-control-command keys are pressed")
      case [.control, .option, .command]:
          print("control-option-command keys are pressed")
      case [.shift, .command, .option]:
          print("shift-command-option keys are pressed")
      case [.shift, .control, .option, .command]:
          print("shift-control-option-command keys are pressed")

      
      default:
         
         print("default  char: \(event.characters)")
           break
       }
      print("char: \(event.characters)")
   
   }
/*
   override func flagsChanged(with event: NSEvent) 
   {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift]:
            print("shift key is pressed")
        case [.control]:
            print("control key is pressed")
        case [.option] :
            print("option key is pressed")
        case [.command]:
            print("Command key is pressed")
        case [.control, .shift]:
            print("control-shift keys are pressed")
        case [.option, .shift]:
            print("option-shift keys are pressed")
        case [.command, .shift]:
            print("command-shift keys are pressed")
        case [.control, .option]:
            print("control-option keys are pressed")
        case [.control, .command]:
            print("control-command keys are pressed")
        case [.option, .command]:
            print("option-command keys are pressed")
        case [.shift, .control, .option]:
            print("shift-control-option keys are pressed")
        case [.shift, .control, .command]:
            print("shift-control-command keys are pressed")
        case [.control, .option, .command]:
            print("control-option-command keys are pressed")
        case [.shift, .command, .option]:
            print("shift-command-option keys are pressed")
        case [.shift, .control, .option, .command]:
            print("shift-control-option-command keys are pressed")
        default:
            print("no modifier keys are pressed")
        }
    }
*/
   func updatePfeilschrittweite(sw:Int)
   {
      let tagarray = [1,2,3,4,11,22,33,44,22,24]
      for pfeiltag in tagarray
      {
         var taste = self.view.viewWithTag(pfeiltag) as? rPfeiltaste
         taste?.setSchrittweite(sw: sw)
      }
      
   }
   
   @objc func handleDoubleClick()
   {
      
      let clickedRow = dataTable.clickedRow
      print("tableView doubleClick clickedRow: \(clickedRow)")
      
   }
   
   func tableViewSelectionDidChange(_ notification: Notification) 
   {
      print("tableView  tableViewSelectionDidChange notification: \(notification)")
      let selectedRow = (notification.object as! NSTableView).selectedRow
      print("tableView  tableViewSelectionDidChange selectedRow: \(selectedRow)")
      
      
      datatabletask(zeile:selectedRow)
      
      let nc = NotificationCenter.default
      var notificationDic = [String:Any]()
      notificationDic["selrow"] = selectedRow
      notificationDic["task"] = 1 // selection change
      
 /*   
            nc.post(name:Notification.Name(rawValue:"datatable"),
                    object: nil,
                   userInfo: notificationDic)        
 */     
   }
   
   @objc func handleClickedRow()
   {
      
      let clickedRow = dataTable.clickedRow
      print("tableView  clickedRow: \(clickedRow)")
      selectetDataTableRow = clickedRow
      
   }
   
   /*  
    func openFile() -> URL? 
    { 
    let myFileDialog = NSOpenPanel() 
    myFileDialog.runModal() 
    return myFileDialog.url 
    }  
    */
   
   
   func sortDicArray_float(origDicArray:[[String:Double]], key0:String, key1: String, order:Bool) -> [[String:Double]]
   {
      //print("sortDicArray_float anz: \(origDicArray.count) order: \(order)")
      var returnDicArray:[[String:Double]] = [[String:Double]]()
      // https://useyourloaf.com/blog/sorting-an-array-of-dictionaries
      
      var linear = 0
      if linear_checkbox.state == .on
      {
         print("linear on")
         linear = 1
      }
      // Array nach cx sortieren
      var cxDicArray:[[String:Double]] = [[String:Double]]()
      var keyA = "" // keys je nach order
      var keyB = ""
      
      if order == false // zuerst nach senkrechte sortieren (cx)
      {
         keyA = key0
         keyB = key1
      }
      else // zuerst waagrecht sortieren (cy)
      {
         keyA = key1
         keyB = key0
      }
      
      
      
      //     if order == false // zuerst nach senkrechte sortieren
      //    {
      cxDicArray = origDicArray.sorted 
         {
            guard let s1 = $0[keyA], let s2 = $1[keyA] else 
            {
               return false
            }
            if order == false
            {
               return s1 < s2
            }
            else
            {
               return s1 > s2 // reverse
            }
      }
      //   }
      /*
       else // zuerst nach waagrechte sortieren
       {
       cxDicArray = origDicArray.sorted 
       {
       guard let s1 = $0[keyA], let s2 = $1[keyA] else 
       {
       return false
       }
       return s1 > s2 // reverse
       }
       
       }
       */
      //print(returnDicArray)  
      
      //print("cxDicArray anz: \(cxDicArray.count)") 
      
      //     for el in cxDicArray
      //      {
      //         print("\(el[keyA] ?? 0)\t \(el[keyB] ?? 0)")
      //     }
      
      
      var equalarray = [[[String:Double]]]()
      var equaldicarray = [[String:Double]]() // Zeilen mit gleichem cx sammeln
      var equaldic:[String:Double] = [keyA:0] // startwert
      var eqindex = 0 
      var oldcx:Double = 0
      for el in cxDicArray
      {
         oldcx = equaldic[keyA]! // Wert von cx: Dics mit gleichem Wert suchen und in equalarray sammeln
         let cx:Double = el[keyA]! // aktueller wert
         //print("****                   eqindex 0: \(eqindex) cx: \(cx)")
         if cx == oldcx // Punkt mit gleichem cx, in equaldicarray einsetzen
         {
            equaldicarray.append(el)
            //print("eqindex A: \(eqindex) cx: \(cx)")
         }
         else // neuer Wert. 
         {
            // bisherigen equaldicarray in eaqualarray einfügen
            if equaldicarray.count > 0 // Array mit Inhalt
            {
               // equaldicarray mit gleichem cx nach cy sortieren
               var equaldicarraysorted = [[String:Double]]()
               equaldicarraysorted = equaldicarray.sorted {
                  guard let s1 = $0[keyB], let s2 = $1[keyB] else 
                  {
                     return false
                  }
                  if linear == 1 && eqindex % 2 == 0
                  {
                     return s1 > s2
                  }
                  else
                  {
                     return s1 < s2
                  }
               }
               
               //print("eqindex B: \(eqindex) cx: \(cx)")
               equalarray.append(equaldicarraysorted)
               equaldicarray.removeAll() // aufräumen
            }
            
            // neues Element in leerem equaldicarray einsetzen
            //print("eqindex C: \(eqindex) cx: \(cx)")
            equaldicarray.append(el)
            
            equaldic = el // aktualisieren
         }
         eqindex += 1
         if eqindex == origDicArray.count // letztes, einzelnes Element noch einsetzen
         {
            //print("eqindex last: \(eqindex)  cx: \(cx)")
            equalarray.append(equaldicarray)
         }
      }
      
      
      /*    
       print("sortDicArray_float equalarray anz: \(equalarray.count)")  
       
       for statusel in equalarray
       {
       print("statusel: \(statusel)") 
       }
       */    
      //print("equalarray anz: \(equalarray.count)") 
      for el in equalarray
      {
         if el.count > 0
         {
            
            for e in el
            {
               //print("\(e[keyA] ?? 0)\t \(e[keyB] ?? 0)")
               returnDicArray.append(e)
            }
         }
      }
      //print("returnDicArray anz: \(returnDicArray.count)")  
      
      /*       for el in returnDicArray
       {
       print("\(el[keyA] ?? 0)\t \(el[keyB] ?? 0)")
       }
       */
      return returnDicArray
   }   
   
   func sortDicArray_opt(origDicArray:[[String:Int]], key0:String, key1: String, order:Bool) -> [[String:Int]]
   {
      //print("sortDicArray_opt anz: \(origDicArray.count) order: \(order)")
      var returnDicArray:[[String:Int]] = [[String:Int]]()
      // https://useyourloaf.com/blog/sorting-an-array-of-dictionaries
      
      var linear = 0
      if linear_checkbox.state == .on
      {
         print("linear on")
         linear = 1
      }
      // Array nach cx sortieren
      var cxDicArray:[[String:Int]] = [[String:Int]]()
      var keyA = "" // keys je nach order
      var keyB = ""
      
      if order == false // zuerst nach senkrechte sortieren (cx)
      {
         keyA = key0
         keyB = key1
      }
      else // zuerst waagrecht sortieren (cy)
      {
         keyA = key1
         keyB = key0
      }
      
      
      
      //     if order == false // zuerst nach senkrechte sortieren
      //    {
      cxDicArray = origDicArray.sorted 
         {
            guard let s1 = $0[keyA], let s2 = $1[keyA] else 
            {
               return false
            }
            if order == false
            {
               return s1 < s2
            }
            else
            {
               return s1 > s2 // reverse
            }
      }
      //   }
      /*
       else // zuerst nach waagrechte sortieren
       {
       cxDicArray = origDicArray.sorted 
       {
       guard let s1 = $0[keyA], let s2 = $1[keyA] else 
       {
       return false
       }
       return s1 > s2 // reverse
       }
       
       }
       */
      //print(returnDicArray)  
      
      //print("cxDicArray anz: \(cxDicArray.count)") 
      
      //     for el in cxDicArray
      //      {
      //         print("\(el[keyA] ?? 0)\t \(el[keyB] ?? 0)")
      //     }
      
      
      var equalarray = [[[String:Int]]]()
      var equaldicarray = [[String:Int]]() // Zeilen mit gleichem cx sammeln
      var equaldic = [keyA:0] // startwert
      var eqindex = 0 
      var oldcx = 0
      for el in cxDicArray
      {
         oldcx = equaldic[keyA]! // Wert von cx: Dics mit gleichem Wert suchen und in equalarray sammeln
         let cx = el[keyA]! // aktueller wert
         //print("****                   eqindex 0: \(eqindex) cx: \(cx)")
         if cx == oldcx // Punkt mit gleichem cx, in equaldicarray einsetzen
         {
            equaldicarray.append(el)
            //print("eqindex A: \(eqindex) cx: \(cx)")
         }
         else // neuer Wert. 
         {
            // bisherigen equaldicarray in eaqualarray einfügen
            if equaldicarray.count > 0 // Array mit Inhalt
            {
               // equaldicarray mit gleichem cx nach cy sortieren
               var equaldicarraysorted = [[String:Int]]()
               equaldicarraysorted = equaldicarray.sorted {
                  guard let s1 = $0[keyB], let s2 = $1[keyB] else 
                  {
                     return false
                  }
                  if linear == 1 && eqindex % 2 == 0
                  {
                     return s1 > s2
                  }
                  else
                  {
                     return s1 < s2
                  }
               }
               
               //print("eqindex B: \(eqindex) cx: \(cx)")
               equalarray.append(equaldicarraysorted)
               equaldicarray.removeAll() // aufräumen
            }
            
            // neues Element in leerem equaldicarray einsetzen
            //print("eqindex C: \(eqindex) cx: \(cx)")
            equaldicarray.append(el)
            
            equaldic = el // aktualisieren
         }
         eqindex += 1
         if eqindex == origDicArray.count // letztes, einzelnes Element noch einsetzen
         {
            //print("eqindex last: \(eqindex)  cx: \(cx)")
            equalarray.append(equaldicarray)
         }
      }
      
      
      
      //print("sortDicArray_opt equalarray anz: \(equalarray.count)")  
      
      for statusel in equalarray
      {
         //print("el: \(el)") 
      }
      
      //print("equalarray anz: \(equalarray.count)") 
      for el in equalarray
      {
         if el.count > 0
         {
            
            for e in el
            {
               //print("\(e[keyA] ?? 0)\t \(e[keyB] ?? 0)")
               returnDicArray.append(e)
            }
         }
      }
      print("returnDicArray anz: \(returnDicArray.count)")  
      
      /*       for el in returnDicArray
       {
       print("\(el[keyA] ?? 0)\t \(el[keyB] ?? 0)")
       }
       */
      return returnDicArray
   }
   
   func sortArrayofArrays(origArray:[[Double]], index:Int, order:Bool) -> [[Double]]
   {
      if order == true
      {
      let sortedarray:[[Double]] = origArray.sorted(by: {
                                                   ($0[index]) > ($1[index])})
         return sortedarray
      }
      else
      {
         let sortedarray:[[Double]] = origArray.sorted(by: {
                                                      ($0[index]) < ($1[index])})
            return sortedarray
         
      }
         
  //    let sortedarray:[[Double]] = origArray.sort { ($0.1 as? Double ?? 1.0) < ($1.1 as? Double ?? 1.0) }
   //return sortedarray
   }
   
   func sortDicArray(origDicArray:[[String:Int]], key0:String, key1: String, order:Bool) -> [[String:Int]]
   {
      print("sortDicArray")
      var returnDicArray:[[String:Int]] = [[String:Int]]()
      let keyarray = Array(origDicArray[0].keys)
      //      let key0 = keyarray[0]
      //     let key1 = keyarray[1]
      //  print("keyarray: \(key0) \(key1)")
      if order == false // 
      {
         returnDicArray = origDicArray.sorted {
            guard let s1 = $0[key0], let s2 = $1[key0] else {
               return false
            }
            
            if s1 == s2 {
               guard let g1 = $0[key1], let g2 = $1[key1] else {
                  return false
               }
               return g1 < g2
            }
            
            return s1 < s2
         }
         
      }
      else
      {
         returnDicArray = origDicArray.sorted {
            guard let s1 = $0[key1], let s2 = $1[key1] else {
               return false
            }
            
            if s1 == s2 {
               guard let g1 = $0[key0], let g2 = $1[key0] else {
                  return false
               }
               return g1 < g2
            }
            
            return s1 < s2
         }
         
      }
      
      return returnDicArray
   }
   
   func clearteensy()
   {
      Schnittdatenarray.removeAll(keepingCapacity: true)
      if Schnittdatenarray.count == 0 // Array im Teensy loeschen
      {
         teensy.write_byteArray[25] = 1 //erstes Element
         teensy.write_byteArray[24] = 0xF1 // Stopp
         if teensy.dev_present() > 0
         {
            let senderfolg = teensy.send_USB()
            print("clearTeensy clear senderfolg: \(senderfolg)")
         }
         
      }
      
   }
   
   
   
   
   func flipSVG(svgarray:[[Double]])->[[Double]]
   {
      // find maxY
      var fliparray = [[Double]]()
      var maxY:Double = 0


      for zeile in svgarray
      {
         if zeile[2] > maxY
         {
            maxY = zeile[2]
            
         }
      }
      
      //print("flipSVG maxY: \(maxY)")
      for zeile in svgarray
      {
         var tempzeile = zeile
         tempzeile[2] = maxY - zeile[2] + 10
         fliparray.append(tempzeile)
      }
      return fliparray
   }
   
   func punktarrayvonTXT(txtarray: [String])->[[Double]]
   {
      let minabstand = 1.8
      var k=0
      var punktarray = [[Double]]()
      var txtpunktarray = [[Double]]()
      var okstringarray = [String]()
      var okindexset = IndexSet()
      
      var nearindexset = IndexSet()
      
      // Abstand filtern
      var doppelindex = 0
      for k in 0..<txtarray.count
      {
         var checkzeile = txtarray[k].split(separator: "\r")[0] // \r entfernen
         let checkpunktarray = checkzeile.split(separator: "\t")
         if checkpunktarray.count == 3
         {            
            
            let checkindex = Double(checkpunktarray[0])
            
            let checkx = Double(checkpunktarray[1])
            let checky = Double(checkpunktarray[2])
            
            // array fuer NN: x,y,z
            let checkpunktzeilenarray:[Double] = [checkindex!,checkx!,checky!]
            txtpunktarray.append(checkpunktzeilenarray)
            
            let checkxint = round(checkx ?? 0)
            let checkyint = round(checky ?? 0)
            //print("index: \(checkindex) x: \(checkx) y: \(checky)")
            
            for kk in k..<txtarray.count
            {
               if kk == k
               {
                  
               }
               else
               {
                  //print("k: \(k)")
                  var tempzeile = txtarray[kk].split(separator: "\r")[0] // \r entfernen
                  
                  let checkpunktarray = tempzeile.split(separator: "\t")
                  
                  let tempcheckx = Double(checkpunktarray[1]) 
                  let tempchecky = Double(checkpunktarray[2])
                  
                  let abstand:Double = hypot(((tempcheckx ?? 0) - (checkx ?? 0)),((tempchecky ?? 0) - (checky ?? 0)))
                  //print("kk: \(kk) abstand: \(abstand)")
                  if abstand < minabstand
                  { 
                     nearindexset.insert(kk)
                     if k > doppelindex
                     {
                        
                        doppelindex = k
                        print("*** doppelindex: \(doppelindex)")
                        
                     }
                     print("\tkk: \(kk) abstand: \(abstand)")
                  }
                  else
                  {
                     
                     let okpunkt = k
                     var okarray:[Double] = [checkindex!,checkx!,checky!]
                     let okstring:String = String(Int(checkpunktarray[0]) ?? 0) + "\t" + String(checkpunktarray[0]) + "\t"  + String(checkpunktarray[1])
                     if okindexset.contains(k)
                         {
                        
                        }
                     else 
                         {
                        okindexset.insert(k)
                        punktarray.append(okarray)
                        okstringarray.append(okstring)
                     }
                     
                     
                  }
               }
            }
            
            
         }// if checkpunktarray.count
         
      }
      
      
      //print (okstringarray)
      print("txtpunktarray: \(txtpunktarray)")
      tsp_nn.setkoordinaten(koord: txtpunktarray)
      tsp_nn.firstrun()
      tsp_nn.nearestneighbour()
      let nn_array = tsp_nn.weg
      print("nn_array: \(nn_array)") // indices der nn-Punkte
      
      var mill_floatarray = [[Double]]() //
      
      for zeilenindex in stride(from: 0, to: txtpunktarray.count, by: 1)
      {
         //print("zeilenindex: \(zeilenindex) data: \(txtpunktarray[zeilenindex])")
             let millindex = nn_array[zeilenindex]
            var tempfloatarray:[Double] = txtpunktarray[millindex]
            //print("zeilenindex: \(zeilenindex) tempfloatarray: \(tempfloatarray)")
            // index neu einsetzen
            tempfloatarray[0] = Double(zeilenindex)
            mill_floatarray.append(tempfloatarray)
      }
      
      

      
      return txtpunktarray // array mit array von 3 Double-werten x,y,z
   } // punktarrayvonTXT
   
   func punktarrayvonSGV(sgvarray: [String])->[[Double]]
   {
      var i=0
      var circle = 0
      var circlenummer = 0
      circlearray = [[Int]]()
      var circleelementarray = [Int]()
      var circlefloatelementarray = [Double]()
      var circleelementdic = [String:Int]()
      var punktarray = [[Double]]()
      var circlefloatelementdic = [String:Double]()
      var circleorellipsefloatelementdic = [String:Double]() // direkt aufgebaut, mit transform
      
      var circleorellipsefloatelementarray = [Double]()
      
      // polyline
      var polycount = 0
      var polylinenummer = 0
      var polylineelementdic = [String:Int]()
      
      // polyline
      var transformdoublearray = [Double]()
      var transformok = 0 //1: transform ist vorhanden
      var poly = 0;
      
      // transform: https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform
      let labelarray:[String] = ["cx","cy","transform","points"] // points neu fuer polyline // relevante daten
      let lastlabel:String = String(labelarray.last ?? "") // label "transform"
      var zeilenindex:Double = 0
      var circlecount = 0
      var circlecountB = 0
      var circlecountC = 0
      for zeile in sgvarray
      {
         //print("i: \(i) zeile: \(zeile)")
         let trimmzeile = zeile.trimmingCharacters(in: .whitespaces)
         
         
         if (trimmzeile.contains("circle") || trimmzeile.contains("ellipse")) // relevante zeile mit circle oder ellipse, start data-Block
         {
            circlecount += 1
            //print("\n\t\tcircle oder ellipse\ti: \(i) trimmzeile: \(trimmzeile)")
            circle = 9
            circlenummer = i
            circleelementarray.removeAll()
            circlefloatelementarray.removeAll()
            transformdoublearray.removeAll() // koeff array leeren
            circleelementdic = [:]
            circlefloatelementdic = [:]
            circleorellipsefloatelementdic = [:]
            circleorellipsefloatelementarray.removeAll()
            transformok = 0 // wer weiss?
         }

         // circle detektiert. Anzahl ist max 7 
         // trenner: </g>
         if circle > 0 // circle oder ellipse detektiert
         {
            
            
            if circle < 9 // circle wird mit jeder zeile decrementiert, 9 wird uebersprungen
            {     
               
              // print("\nneue Zeile i: \(i)\t circle: \(circle)  \ttrimmzeile: \(trimmzeile)")
               let zeilenarray = trimmzeile.split(separator: "=") // aufteilen in label und data
              //print("\t\t neue Zeile i: \(i) \t zeilenarray: \(zeilenarray)")
               
               
               // neu mit labelarray
               
               if (zeilenarray.count > 1)  // = ist vorhanden, Daten
               {
                  
                  let firstelement:String = String(zeilenarray[0]) // label
                  //print("i: \(i) zeilenindex: \(zeilenindex) \t firstelement: \t*\(firstelement)*")
                  
                  let contains = labelarray.contains(where:{$0 == firstelement})
                  
                  if contains == true // zeile ist relevant
                  {
                     
                     var partB = zeilenarray[1].replacingOccurrences(of: "\"", with: "")
                     partB = partB.replacingOccurrences(of: "/>", with: "")
                     //print("i: \(i) \t firstelement: \t \(firstelement) \t partB neu: \t\(partB)")
                     if lastlabel == firstelement // transform lesen firstelement ist "transform"
                     {
                        transformok = 1
                        print("transform: partB raw: \(partB)")
                        partB = partB.replacingOccurrences(of: "matrix(", with: "")
                        partB = partB.replacingOccurrences(of: ")", with: "")
                        //print("transform: partB sauber: \(partB)")
                        let transformarray = partB.split(separator: ",")
                        
                        //print("transformarray: \(transformarray[0]) \t \(transformarray[1]) \t \(transformarray[2])\t\(transformarray[3])")
                        guard let koeff_a:Double = Double(transformarray[0]) else { return punktarray} 
                        guard let koeff_b:Double = Double(transformarray[1]) else { return punktarray}
                        guard let koeff_c:Double = Double(transformarray[2]) else { return punktarray}
                        guard let koeff_d:Double = Double(transformarray[3]) else { return punktarray}
                        guard let koeff_e:Double = Double(transformarray[4]) else { return punktarray} 
                        guard let koeff_f:Double = Double(transformarray[5]) else { return punktarray}
                        
                        // transform-matrix bereitstellen
                        transformdoublearray = [koeff_a,koeff_b,koeff_c,koeff_d,koeff_e,koeff_f]
                        //print("i: \(i) \t firstelement: \(firstelement) transformdoublearray: \(transformdoublearray)")
                        
                        
                     }
                     
                     else // Datazeile
                     {
                        let partfloat = (partB as NSString).doubleValue  
                        //print("i: \(i) append: \t firstelement: \(firstelement) partfloat: \(partfloat)")
                        
                        circleorellipsefloatelementdic[firstelement] = partfloat
                        circleorellipsefloatelementarray.append(partfloat)
                        
                     }
                     // Floatwerte
                  }
                  else if (firstelement == "r")
                  {
                     circle = 1
                     //print("circle ist 1 zeilenindex: \(zeilenindex) firstelement ist r circlecount: \(circlecount) circlecountB: \(circlecountB) circleorellipsefloatelementarray: \(circleorellipsefloatelementarray)\n")
                     
                  }
                  
                  
               } // if zeilenarray.count > 1
               else  
               {
                  // arrays aufbauen
                  let firstelement:String = String(zeilenarray[0]) // label
                  var element0 = String(zeilenarray[0])
                  element0 = element0.replacingOccurrences(of: "<", with: "") // "erste zeile detekteren
                  let contains = labelarray.contains(where:{$0 == firstelement})
                  if contains == true // zeile ist relevant
                  {
                     // erste zeile, ueberspringen, 
                     //print("erste zeile: firstelement: \(firstelement) element0\(element0)")
                     
                  }
                  else
                  {
                     circle = 1 // serie end, 
                     circlecountB += 1
                     /*
                     if (circlecount > circlecountB)
                     {
                        print("zeilenindex: \(zeilenindex) DIFF")
                     }
                     */
                     
                     //print("circle ist 1 zeilenindex: \(zeilenindex) circlecount: \(circlecount) circlecountB: \(circlecountB) circleorellipsefloatelementarray: \(circleorellipsefloatelementarray)\n")
                     
                     zeilenindex += 1
                     
                     
                  }
               }
               
               
               // end labelarray


            } // circle < 9
            //print("\n*** *** *** *** ende circle: circle: \(circle)")
            if circle == 1 // Zeilen des Blocks sind abgearbeitet
            {
               //print("\n*** *** *** *** circle ist 1   \ni: \(i) circleorellipsefloatelementarray: \(circleorellipsefloatelementarray)")
               if (transformok == 1)
               {
                  
                 // print("transform circleorellipsefloatelementarray: \(circleorellipsefloatelementarray)")
                 //print(" transformdoublearray: \(transformdoublearray)")
                  let a = transformdoublearray[0]
                  let b = transformdoublearray[1]
                  
                  let c = transformdoublearray[2]
                  let d = transformdoublearray[3]
                  
                  let e = transformdoublearray[4]
                  let f = transformdoublearray[5]
                  
                  let ax_raw = circleorellipsefloatelementarray[0] // x
                  let ay_raw = circleorellipsefloatelementarray[1] // y
                  
                  let ax_transform = a * ax_raw + c * ay_raw + e
                  let ay_transform = b * ax_raw + d * ay_raw + f
                  
                  print("ax_raw: \(ax_raw) ay_raw: \(ay_raw)")
                  print("ax_transform: \(ax_transform) ay_transform: \(ay_transform)")
                  circleorellipsefloatelementarray[0] = ax_transform
                  circleorellipsefloatelementarray[1] = ay_transform
                  
                  transformok = 0
               }
               
               if circleorellipsefloatelementarray.count > 0
               {
                  //print("i: \(i) circleorellipsefloatelementarray: \(circleorellipsefloatelementarray)")
                  circleorellipsefloatelementarray.append(0.0)
                  
                  
                  punktarray.append(circleorellipsefloatelementarray)
               }
               else
               {
                  print("i: \(i) circleorellipsefloatelementarray ist leer")
               }
               
               circle = 0
            }// if circle = 1
            
            circle -= 1
            
         }// circle > 0
         
         // polyli9ne
         /*
          <polyline
               style="fill:none;stroke-linecap:round;stroke-linejoin:round;stroke-width:0.560891568661"
               id="DCD2298C"
               points="53.1781020343,171.627320784 0.330445784331,97.8616957843 39.6390395343,13.0491957843 73.3851332843,0.33044578433"/>

          
          */
         // MARK: POLYLINE
         if (trimmzeile.contains("polyline") )
         {
            print("polyline da: \(trimmzeile)")
            poly = 5
            polylinenummer = i
            polycount += 1
            polylineelementdic.removeAll()
         
         }
         
         if poly > 0 // Polyline detektiert
         {
            if poly < 5
            {
               let zeilenarray = trimmzeile.split(separator: "=") // aufteilen in label und data

               if zeilenarray.count > 1 // == ist da
               {
                  let firstelement:String = String(zeilenarray[0]) // label
                  //print("i: \(i) zeilenindex: \(zeilenindex) \t firstelement: \t*\(firstelement)*")
                  let contains = labelarray.contains(where:{$0 == firstelement})
                  if contains == true // zeile ist relevant
                  {
                     // Daten hinter "=" separieren
                     var partB = zeilenarray[1].replacingOccurrences(of: "\"", with: "")
                     partB = partB.replacingOccurrences(of: "/>", with: "")
                     //print("polyline i: \(i) \t firstelement: \t \(firstelement) \t partB neu: \t\(partB)\n")
                     print("polyline i: \(i) \t partB neu: \t\(partB)\n")
                     let polypunktarray = partB.split(separator: " ");
                     print("polyline i: \(i) \t polypunktarray: \t\(punktarray)\n")
                     for zeile in polypunktarray
                     {
                        print("zeile: \(zeile)")
                        //punktarray.append(zeile)
                        let zeilenpunkt = zeile.split(separator: ",")
                        print("zeilenpunkt: \(zeilenpunkt)")
                        var zeilenpunktarray =  zeilenpunkt.compactMap { Double($0) }
                        zeilenpunktarray.append(0.0)
                        print("zeilenpunktarray: \(zeilenpunktarray)")
                        punktarray.append(zeilenpunktarray)
                     }
                  }
               }
            }// poly < 5
            poly = poly - 1 
         }
         
         
         
         i += 1
      } // for zeile
      
      print("circlecount: \(circlecount) circlecountB: \(circlecountB) circlecountC: \(circlecountC)")
      //print("punktarray: \n\(punktarray)")
      return punktarray
   }
   
   func eckelinksunten(floatarray:[[Double]]) ->Int
   {
      // ecke links unten bestimmen 
      var eckedistanzmin:Int = Int.max
      var eckedistanzminindex:Int = 0;
      var z = 0
      for el in floatarray
      {
         
         let eckedistanz:Int = Int(el[4])
         //print("\(z) eckedistanz: \(eckedistanz)")
         if eckedistanz < eckedistanzmin
         {
            eckedistanzmin = eckedistanz
            eckedistanzminindex = z
         }
         
         z += 1
      }
      print("eckedistanzminindex: \(eckedistanzminindex) eckedistanzmin: \(eckedistanzmin)")
      
      return eckedistanzminindex
   }
   
   @IBAction func report_propfaktorStepper(_ sender: NSStepper)
   {
      print("report_propfaktorSteppern propfaktor vor: \(propfaktor)  val: \(sender.integerValue)")
      propfaktor = Double(sender.integerValue)
      propfaktorFeld.doubleValue = propfaktor
      print("report_propfaktorStepper propfaktor nach: \(propfaktor)")
   }
   
   
   @IBAction func report_readSVG_Pop(_ sender: NSPopUpButton)
   {
      print("report_readSVG_Pop titel: \(sender.titleOfSelectedItem) index: \(sender.indexOfSelectedItem)")
      guard let titel = sender.titleOfSelectedItem else { return } 
      
      let titelindex = sender.indexOfSelectedItem

      guard let tempurl = svgdicarray[titel] else 
      {
        print("keine url")
         return 
      } 
      print("titel: \(titel) url: \(tempurl)")
      
      guard URL(fileURLWithPath: tempurl ) != nil else 
      { 
         print("keine datei")
         return 
         
      }
      
     // let url = urldicarray as NSDictionary[titel]
      //sender.selectItem(withTitle: titel)
   }
   // MARK: ***      ***  report_readSVG
   
   @IBAction func report_readSVG(_ sender: NSButton)
   {
      // transform: https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform
      let labelarray:[String] = ["id","cx","cy","transform"] // relevante daten
      let drillarray = DrillDaten(tiefe: drillweg)
      var dateiname:String = ""
      var dateisuffix = ""
      var urlstring:String = ""
      //var fileURL:URL 
      
      guard let fileURL = openFile() else { return  }
      
      urlstring = fileURL.absoluteString
      dateiname = urlstring.components(separatedBy: "/").last ?? "-"
      print("report_readSVG fileURL: \(fileURL)")
      
      dateiname = dateiname.components(separatedBy: ".").first ?? "-"
      let converteddateiname = dateiname.replacingOccurrences(of: "%20", with: " ")
      print(converteddateiname) // Output: "Hello World"
      SVG_Pfad.stringValue = converteddateiname
      //
      
      
      /*
       if readSVG_Pop.titleOfSelectedItem == "Neu"
       {
       //let SVG_URL = openFile()
       // https://stackoverflow.com/questions/10016475/create-nsscrollview-programmatically-in-an-nsview-cocoa
       guard let fileURL = openFile() else { return  }
       
       urlstring = fileURL.absoluteString
       dateiname = urlstring.components(separatedBy: "/").last ?? "-"
       print("report_readSVG fileURL: \(fileURL)")
       dateiname = dateiname.components(separatedBy: ".").first ?? "-"
       SVG_Pfad.stringValue = dateiname
       
       // https://www.dotnetperls.com/dictionary-swift
       svgdicarray[dateiname] = urlstring
       
       if readSVG_Pop.itemTitles.contains(dateiname)
       {
       print("dateiname schon da")
       }
       else 
       {
       readSVG_Pop.insertItem(withTitle: dateiname, at: 1)
       
       if readSVG_Pop.numberOfItems > 5
       {
       readSVG_Pop.removeItem(at: 5)
       }
       }
       }
       else
       {
       guard let dateiname = readSVG_Pop.titleOfSelectedItem else {return}
       guard let dateiurl = svgdicarray[dateiname] else {return}
       urlstring = dateiurl
       }
       */
      
      //    print(Array(svgdicarray.keys))
      //    print(Array(svgdicarray.values))
      
      var punktarray = [[Double]]()
      circledicarray.removeAll()
      circlefloatarray.removeAll()
      circlefloatdicarray.removeAll()
      Plattefeld.clearWeg()
      Plattefeld.needsDisplay = true
      homeX = 0
      homeY = 0
      floathomeX = 0
      floathomeY = 0
      ablaufzeitFeld.stringValue = zeitformatter.string(from: TimeInterval(0))!
      //reading
      do {
         
         guard let  fileURL = URL.init(string:urlstring) else {return }
         
         //guard 
         //let  fileURL = URL(fileURLWithPath: "/Users/ruediheimlicher/Desktop/CNC_SVG/ATest0.svg" )// else {return }
         
         print("readSVG URL: \(fileURL)")
         dateisuffix = urlstring.components(separatedBy: ".").last ?? "-"         
         print("report_readSVG propfaktor: \(propfaktor)")
         circlearray = [[Int]]()
         
         switch dateisuffix 
         {
         case "svg":
            
            
            // SVG
            let SVG_data = try String(contentsOf: fileURL , encoding: String.Encoding.utf8)
            //print("SVGdata: \(SVG_data)")
            //let anz = SVG_data.count
            //print("SVGdata count: \(anz)")
            
            
            let SVG_text = SVG_data.components(separatedBy: "\n")
            // print("SVG_text: \(SVG_text)")
            let SVG_array = Array(SVG_text)
            var i=0
            var circle = 0
            var circlenummer = 0
            
            punktarray = punktarrayvonSGV(sgvarray:SVG_array)
            if punktarray.count == 0
            {
               return
            }
            //print("punktarray: \(punktarray)")
            break
            
         case "txt":
            print("suffix: \(dateisuffix)")
            let TXT_data = try String(contentsOf: fileURL , encoding: String.Encoding.utf8)
            //print("TXT_data: \(TXT_data)")
            let anz = TXT_data.count
            //print("TXT_data count: \(anz)")
            
            
            let TXT_text = TXT_data.components(separatedBy: "\n")
            // print("TXT_data: \(TXT_data)")
            let TXT_array = Array(TXT_text)
            
            //var txtdata = punktarrayvonTXT(txtarray:TXT_array)
            punktarray = punktarrayvonTXT(txtarray:TXT_array)
            if punktarray.count == 0
            {
               return
            }
            break;
            
         default:
            break
         }
         
         let formater = NumberFormatter()
         formater.groupingSeparator = "."
         formater.maximumFractionDigits = 3
         formater.minimumFractionDigits = 3
         formater.numberStyle = .decimal
         
         //print("report_readSVG circlefloatarray; \(circlefloatarray)")
         //print("report_readSVG punktarray; \(punktarray)")
         circlefloatarray = punktarray
         
         /*
          print("report_readSVG circlearray.  count: \(circlearray.count)")
          var ii = 0
          for el in circlearray
          {
          print("\(ii)\t\(el[0])\t \(el[1])\t ")
          ii += 1
          }
          */
         /*
          print("report_readSVG circledicarray")
          var iii = 0
          for el in circledicarray
          {
          print("\(iii) \(el)")
          iii += 1
          }
          */
         /*
          print("report_readSVG circlefloatarray A count: \(circlefloatarray.count)")
          var iii = 0
          for el in circlefloatarray
          {
          print("\(iii)\t\(el[1])\t \(el[2])  ")
          iii += 1
          }
          */
         
         print("punktarray")
         print_array(floatarr: punktarray)
         
         teensy.clear_writearray()
         
         // https://useyourloaf.com/blog/sorting-an-array-of-dictionaries/
         var sortedarray = [[String:Int]]()  // mit circledicarray
         var sortedfloatarray = [[Double]]()
         var mill_floatarray = [[Double]]()
         
         // MARK: *** PopTask
         let poptaskindex = TaskPop.indexOfSelectedItem
         switch poptaskindex
         {
         case 0: // PCB
            switch horizontal_checkbox.state
            {
            case .off:
                sortedfloatarray = sortArrayofArrays(origArray:circlefloatarray, index:1, order:false)
            case .on:
               
               sortedfloatarray = sortArrayofArrays(origArray:circlefloatarray, index:2, order:false)
               
            default:
               break
            }
            
            print("PCB sortedfloatarray")
            print_array(floatarr: sortedfloatarray)
            

            //print("sortedfloatarray")
            //print_svgarray(floatarr: sortedfloatarray)
            
            /*       
             //
             switch horizontal_checkbox.state
             {
             case .off:
             //print("horizontal_checkbox: off")
             sortedfloatarray = circlefloatarray.sorted(by: {
             ($0[1]) < ($1[1])})
             case .on:
             //print("horizontal_checkbox: on")
             sortedfloatarray = circlefloatarray.sorted(by: {
             ($0[2]) < ($1[2])})
             default:
             break
             }
             */
            
            //
            
            
            /*       
             print("report_readSVG sortedarray")
             var iiii = 0
             iiii = 0
             for el in sortedarray
             {
             print("\(iiii) \(el)")
             iiii += 1
             }
             */        
            
            //print("PCB sortedarray")
            //print(sortedarray)
            circlearray.removeAll()
            var zeilendicindex:Int = 0
            for zeilendic in sortedarray //
            {
               let cx:Int = (zeilendic["cx"]!) 
               let cy:Int = (zeilendic["cy"]!) 
               let cz:Int = (zeilendic["cz"]!) 
               let zeilenarray = [zeilendicindex,cx,cy,cz]
               circlearray.append(zeilenarray)
               zeilendicindex += 1
            }
            
             print("report_readSVG circlearray vor.  count: \(circlearray.count)")
             //print_intarray(intarr: circlearray)
            
            // float
            
            circlefloatarray.removeAll()
            zeilendicindex = 0
            for zeilendic in sortedfloatarray // Floatzahlen neu
            {
               let cx:Double = (zeilendic[0]) 
               let cy:Double = (zeilendic[1]) 
               let cz:Double = (zeilendic[2])
               let eckedistanz:Double = hypot(cx,cy) //pow(cx,2) + pow(cy,2)
               let zeilenarray = [Double(zeilendicindex),cx,cy,cz,eckedistanz]
               
               // print("\(zeilendicindex) \(cx) \(cy)")
               
               //let zeilenarray:[Double] = [Double(zeilendicindex),cx,cy,cz]
               circlefloatarray.append(zeilenarray)
               zeilendicindex += 1
            }
            
            print("report_readSVG circlefloatarray")
            print_array(floatarr: circlefloatarray)

            
            /*
             print("report_readSVG circlefloatarray B vor.  count: \(circlefloatarray.count)")
             for el in circlefloatarray
             {
             print("\(el[0] )\t \(el[1] ) \(el[2]) \(el[3])")
             }
             */
            
            
            //  var 
            var doppelindex:Int = 0
            var doppelcount = 0
            
            // float
            doppelindex = 0
            doppelcount = 0
            for datazeile in circlefloatarray
            {
               if doppelindex < circlefloatarray.count
               {
                  let akt = circlefloatarray[doppelindex]
                  var next = [Double]()
                  var n = 1
                  while doppelindex + n < circlefloatarray.count // naechste Zeilen absuchen
                  {
                     next = circlefloatarray[doppelindex+n]
                     var diffX:Double = (Double((next[1] - akt[1]))) 
                     //print(" zeile: \(doppelindex) n: \(n)\t diffX: \(diffX)")
                     
                     if fabs(diffX) < maxfloatdiff
                     {
                        //print("diffX < maxdiff  zeile: \(doppelindex) n: \(n)\t diffX: \(diffX)")
                        var diffY:Double = (Double((next[2] - akt[2])))
                        
                        if fabs(diffY) < maxfloatdiff
                        {
                           doppelcount+=1
                           //print(" *** diff zu klein akt zeile: \(doppelindex) n: \(n)\t diffX: \(diffX) diffY: \(diffY) ")
                           circlefloatarray.remove(at: doppelindex + n)
                           n -= 1 // ein element weniger, next ist bei n-1
                        }
                        
                     }
                     n += 1
                  }
               } // if < count
               doppelindex += 1
            } // for datazeile
            print("report_readSVG  doppelcount 2: \(doppelcount )")
            
            print("ciclefloatarray B")
            print_array(floatarr: circlefloatarray)

            
            /*
             print("report_readSVG circlearray nach. count: \(circlearray.count)")
             for el in circlearray
             {
             
             print("\(el[0] )\t \(el[1] )\t \(el[2])")
             
             }
             */
            /*
             print("report_readSVG circlefloatarray nach doppel, vor flip. count: \(circlefloatarray.count)")
             for el in circlefloatarray
             {
             print("\(el[0] )\t \(el[1] )\t \(el[2]) \(el[3])")
             }
             z = 0
             */
            
            
            let microstepindex = schritteweitepop.indexOfSelectedItem
            let microstep = Double(schritteweitepop.itemTitle(at: microstepindex))
            //print("microstep: \(microstep)")
            // umnummerieren und microstep
            // ecke links unten bestimmen
            
            for z in 0..<circlefloatarray.count
            {
               circlefloatarray[z][0] = Double(z)
               let el1 = circlefloatarray[z][1] * (microstep ?? 1)
               circlefloatarray[z][1] = el1
               let el2 = circlefloatarray[z][2] * (microstep ?? 1) 
               circlefloatarray[z][2] = el2   
               let el3 = circlefloatarray[z][3] * (microstep ?? 1) 
               circlefloatarray[z][3] = el3         
               
            }    
            
            circlefloatarray = flipSVG(svgarray: circlefloatarray)  
            
            print("sortedfloatarray flip")
            print_array(floatarr: sortedfloatarray)
            
            
            // definitever circlefloatarray
            /*
             print("report_readSVG definitiver circlefloatarray. count: \(circlefloatarray.count)")         
             for el in circlefloatarray
             {
             print("\(el[0] )\t \(el[1] )\t \(el[2])  \(el[3])")
             }
             */
            /*
             let newsortedarray:[[Double]] = circlefloatarray.sorted(by: {
             ($0[2]) < ($1[2])})
             
             print("report_readSVG newsortedarray nach new sort. count: \(newsortedarray.count)")         
             for el in newsortedarray
             {
             print("\(el[0] )\t \(el[1] )\t \(el[2])")
             }
             */
            /*
             print("report_readSVG circlefloatarray vor eckelinksunten. count: \(circlefloatarray.count)")                   
             for el in circlefloatarray
             {
             print("\(el[0] )\t \(el[1] )\t \(el[2]) \t\(el[3])")
             }
             */
            
            // ecke links unten bestimmen 
            let eckelinksuntenindex_raw = eckelinksunten(floatarray: circlefloatarray)
            print("eckelinksuntenindex_raw: \(eckelinksuntenindex_raw)")
            
            
            // Element an (0)einsetzen
            let firstzeile_raw = circlefloatarray[eckelinksuntenindex_raw]
            circlefloatarray.remove(at:eckelinksuntenindex_raw)
            circlefloatarray.insert(firstzeile_raw, at:0)
            
            // neu Nummerieren
            for z in 0..<circlefloatarray.count
            {
               circlefloatarray[z][0] = Double(z)
            }
            
            print("report_readSVG circlefloatarray nach eckelinksunten. count: \(circlefloatarray.count)")         
            for el in circlefloatarray
            {
               print("\(el[0] )\t \(el[1] )\t \(el[2]) \t\(el[3])")
               
            }
            
            
            
            circlefloatarray_raw.removeAll()
            
            
            circlefloatarray_raw = circlefloatarray // Eingabe sichern, ohne schliessen, ohne NN
            
            
            /*
             print("report_readSVG circlefloatarray nach new sort. count: \(circlefloatarray.count)")         
             
             for el in circlefloatarray
             {
             print("\(el[0] )\t \(el[1] )\t \(el[2]) \(el[3])")
             
             }
             */
            /* 
             print("report_readSVG circlefloatarray_raw. count: \(circlefloatarray_raw.count)")         
             
             for el in circlefloatarray_raw
             {
             print("\(el[0] )\t \(el[1] )\t \(el[2]) \t\(el[3])")
             }
             */
            
            
            
            
            // nearest neighbour stuff
            //   tsp_nn.setkoordinaten(koord: circlefloatarray)
            //   tsp_nn.firstrun()
            //   tsp_nn.nearestneighbour()
            //   let nn_array = tsp_nn.weg
            //print("nn_array: \(nn_array)")   
            
            // Figur schliessen
            
            // Ordnen nach x,y oder nn
            
            
            mill_floatarray = mill_floatArray_Funktion(circarray: circlefloatarray) //
            
            
            // ecke links unten bestimmen 
            let eckelinksuntenindex = eckelinksunten(floatarray: mill_floatarray)
            print("eckelinksuntenindex: \(eckelinksuntenindex)")
            /*
             // Element an (0)einsetzen
             let firstzeile = mill_floatarray[eckelinksuntenindex]
             mill_floatarray.remove(at:eckelinksuntenindex)
             mill_floatarray.insert(firstzeile, at:0)
             
             for z in 0..<mill_floatarray.count
             {
             mill_floatarray[z][0] = Double(z)
             }
             */   
            
            // Figur schliessen
            if figurschliessen_checkbox.state == .on
            {
               mill_floatarray.append(mill_floatarray[0])
            }
            else
            {
               
               print("Figur nicht schliessen?")
               let alert = NSAlert()
               alert.messageText = "Figur schliessen?"
               alert.informativeText = "Option ist nicht aktiviert"
               alert.alertStyle = .warning
               alert.addButton(withTitle: "Figur schliessen")
               alert.addButton(withTitle: "Ignorieren")
               // alert.addButton(withTitle: "Cancel")
               let antwort =  alert.runModal() 
               if antwort == .alertFirstButtonReturn
               {
                  figurschliessen_checkbox.state = .on
                  mill_floatarray.append(mill_floatarray[0])
               }
               else if antwort == .alertSecondButtonReturn
               {
                  
               }
               
               
               
            }
            
            //     print(mill_floatarray)
            
            circlefloatarray = mill_floatarray
            
            /*
             for ii in nn_array
             {
             nn_floatarray.append(circlefloatarray[ii])
             }
             */
            /*
             print("nn_floatarray")
             for el in nn_floatarray
             {
             print("\(el)")
             //     iii += 1
             }
             */
            
            // print("mill_floatarray A")
            
            stepperschritteFeld.integerValue = mill_floatarray.count-1   
            transformfaktor = 0.2
            setPCB_Output(floatarray: mill_floatarray, scale: 5, transform: transformfaktor)
            /*
             print("mill_floatarray B")
             for el in mill_floatarray
             {
             print("\(el)")
             //     iii += 1
             }
             */
            
            /*         
             let zeile:IndexSet = [0]
             dataTable.reloadData()
             dataTable.selectRowIndexes(zeile, byExtendingSelection: false)
             
             */
            //         lasttabledataindex = 0 // Zeile 0 in circlearray
            
            
            print("mill_floatarray C")
            for el in mill_floatarray
            {
               print("\(el)")
               //     iii += 1
            }
            
            // MARK: poly
         case 1: // polyline
            mill_floatarray.removeAll()
            var zeilendicindex:Int = 0
            for zeile in punktarray
            {
               let cx:Double = (zeile[0]) 
               let cy:Double = (zeile[1]) 
               let cz:Double = (0) 
               let eckedistanz:Double = hypot(cx,cy)
               let zeilenarray = [Double(zeilendicindex),cx,cy,cz,eckedistanz]
               polylinepunktarray.append(zeilenarray)
               zeilendicindex += 1
            }
            print("polylinepunktarray A")
            
            for el in polylinepunktarray
            {
               print("\(el)")
            }
             
            // doppelte suchen
            var doppelindex:Int = 0
            var doppelcount = 0
            for datazeile in polylinepunktarray
            {
               if doppelindex < polylinepunktarray.count
               {
                  let akt = polylinepunktarray[doppelindex]
                  var next = [Double]()
                  var n = 1
                  while doppelindex + n < polylinepunktarray.count // naechste Zeilen absuchen
                  {
                     next = polylinepunktarray[doppelindex+n]
                     var diffX:Double = (Double((next[1] - akt[1]))) 
                     //print(" zeile: \(doppelindex) n: \(n)\t diffX: \(diffX)")
                     
                     if fabs(diffX) < maxfloatdiff
                     {
                        //print("diffX < maxdiff  zeile: \(doppelindex) n: \(n)\t diffX: \(diffX)")
                        var diffY:Double = (Double((next[2] - akt[2])))
                        
                        if fabs(diffY) < maxfloatdiff
                        {
                           doppelcount+=1
                           //print(" *** diff zu klein akt zeile: \(doppelindex) n: \(n)\t diffX: \(diffX) diffY: \(diffY) ")
                           polylinepunktarray.remove(at: doppelindex + n)
                           n -= 1 // ein element weniger, next ist bei n-1
                        }
                        
                     }
                     n += 1
                  }
               } // if < count
               doppelindex += 1
            } // for datazeile
            
            print("polylinepunktarray B")
            
            for el in polylinepunktarray
            {
               print("\(el)")
               //     iii += 1
            }
            
            mill_floatarray = polylinepunktarray
            
            break
         default:
            break
            
         }// switch poptaskindex
         
         // Schnittdaten erzeugen
         Schnittdatenarray.removeAll() // Array leeren
         if drillOKKnopf.state == .off
         {
            
            print("Drill einschalten?")
            let alert = NSAlert()
            alert.messageText = "Drill einschalten?"
            alert.informativeText = "Die Option ist nicht aktiviert"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Drill aktivieren")
            alert.addButton(withTitle: "Ignorieren")
            //alert.addButton(withTitle: "Cancel")
            let antwort =  alert.runModal() 
            if antwort == .alertFirstButtonReturn
            {
               drillOKKnopf.state = .on
            }
            else if antwort == .alertSecondButtonReturn
            {
               
            }
         }
         
         
         
         let PCBDaten = PCB_Daten(floatarray: mill_floatarray)
         
      //   print_int8array(intarr: PCBDaten)
         
         //print_tabarray(PCBDaten)
         
         //circlefloatarray = PCBDaten
         /*
          print("mill_floatarray C")
          for el in mill_floatarray
          {
          print("\(el)")
          //     iii += 1
          }
          
          print("report_readSVG PCBDaten")
          
          //var iii = 0
          for el in PCBDaten
          {
          print("\(el)")
          //     iii += 1
          }
          
          print("report_readSVG circlefloatarray")
          for el in circlefloatarray
          {
          print("\(el)")
          //     iii += 1
          }
          */
         
         
         
         /*
          print("vor: \(PCBDaten[0][0]) \(PCBDaten[PCBDaten.count - 1][0])")
          let identischvor = (PCBDaten[0][0] == (PCBDaten[PCBDaten.count - 1][0]))
          print("nach: \(PCBDaten[0][0]) \(PCBDaten[PCBDaten.count - 1][0])")
          let identischnach = (PCBDaten[0][0] == (PCBDaten[PCBDaten.count - 1][0]))
          */ 
         
         Schnittdatenarray.append(contentsOf:PCBDaten)
         
         
         //     report_PCB_Daten(DataSendTaste)
         //1128
         //stepperschritteFeld.integerValue = Schnittdatenarray.count
         //Zeilen_Stepper.maxValue = Double(Schnittdatenarray.count - 1)
         //Zeilen_Stepper.intValue = 1
         //       stepperpositionFeld.intValue = 1
         //         homexFeld.integerValue = homeX
         //        homeyFeld.integerValue = homeY
         
         let homexstring = formater.string(from: NSNumber(value: floathomeX))
         homexFeld.stringValue = homexstring ?? "_"
         //homexFeld.doubleValue = floathomeX
         let homeystring = formater.string(from: NSNumber(value: floathomeY))
         homeyFeld.stringValue = homeystring ?? "_"
         //homeyFeld.doubleValue = floathomeY
         //
         let homexstring_mm = formater.string(from: NSNumber(value: floathomeX * transformfaktor))
         //homexFeld_mm.stringValue = homexstring_mm ?? "_"
         //homexFeld.doubleValue = floathomeX
         let homeystring_mm = formater.string(from: NSNumber(value: floathomeY * transformfaktor))
         //homeyFeld_mm.stringValue = homeystring_mm ?? "_"
         //homeyFeld.doubleValue = floathomeY
         
      }
      catch 
      {
         print("readSVG  error: \(error)")
         
         /* error handling here */
         return
      }
      
      
      lasttabledataindex = 0
      MotorKnopf.state = NSControl.StateValue.off
      /*
       print("report_readSVG Schnittdatenarray")
       for el in Schnittdatenarray
       {
       print("\(el)")
       }
       */
   }
   
   func mill_floatArray_Funktion(circarray:[[Double]])->[[Double]]
   {
      
      tsp_nn.setkoordinaten(koord: circarray)
      tsp_nn.firstrun()
      tsp_nn.nearestneighbour()
      let nn_array = tsp_nn.weg
      //print("nn_array: \(nn_array)")
      
      //    var nn_floatarray = [[Double]]() // array fuer nn-punkte
      
      var mill_floatarray = [[Double]]() //
      
      for zeilenindex in stride(from: 0, to: circarray.count, by: 1)
      {
         //print("zeilenindex: \(zeilenindex) data: \(circlefloatarray[zeilenindex])")
         if  NN_OK_Check.state == NSControl.StateValue.on // nearest neighbour
         {
            let millindex = nn_array[zeilenindex]
            var tempfloatarray:[Double] = circarray[millindex]
            //print("zeilenindex: \(zeilenindex) tempfloatarray: \(tempfloatarray)")
            // index neu einsetzen
            tempfloatarray[0] = Double(zeilenindex)
            //mill_floatarray.append(circarray[millindex])  
            mill_floatarray.append(tempfloatarray)
         }
         else
         {
            mill_floatarray.append(circarray[zeilenindex])
         }
      }
      
      /*
       for ii in nn_array
       {
       nn_floatarray.append(circlefloatarray[ii])
       }
       
       
       print("nn_floatarray")
       for el in nn_floatarray
       {
       print("\(el)")
       //     iii += 1
       }
       */
      /*
       print("func mill_floatarray")
       for el in mill_floatarray
       {
       print("\(el)")
       //     iii += 1
       }
       */
      return mill_floatarray
      
   }
   
   func setPCB_Output(floatarray: [[Double]], scale: Int, transform: Double)
   {
      print("setPCB_Output Start transform: \(transform)")
      
         
       print("setPCB_Output floatarray: \(floatarray.count)")
       for el in floatarray
       {
       print("\(el[0] )\t \(el[1] )\t \(el[2])")
       }
       
      //     Plattefeld.setStepperposition(pos: 0)
      let l = Plattefeld.setfloatWeg(newWeg: floatarray, scalefaktor: scale, transform:  transform)
      
      fahrtweg.integerValue = 0
      //      let l = Plattefeld.setWeg(newWeg: circlearray, scalefaktor: scale, transform:  transform)
      //      fahrtweg.integerValue = l
      
      // https://stackoverflow.com/questions/44630702/formatting-numbers-in-swift-3
      let formater = NumberFormatter()
      formater.groupingSeparator = "."
      formater.maximumFractionDigits = 3
      formater.minimumFractionDigits = 3
      formater.numberStyle = .decimal
      CNC_DatendicArray.removeAll()
      
      //Dicarray fuer tableView
      for zeilendaten in floatarray
      {
         //         print("zeilendaten: \(zeilendaten)")
         let z = Double(zeilendaten[1])/INTEGERFAKTOR
         let cx = formater.string(from: NSNumber(value: Double(zeilendaten[1])))// /INTEGERFAKTOR))
         //print("cx: \(cx)")
         let cy = formater.string(from: NSNumber(value: Double(zeilendaten[2])))// /INTEGERFAKTOR))
         //print("cy: \(cy)")
         let cz = formater.string(from: NSNumber(value: Double(zeilendaten[3])))// /INTEGERFAKTOR))
         //print("cy: \(cy)")
         
         var zeilendic = [String:String]()
         zeilendic["ind"] = String(Int(zeilendaten[0]))
         zeilendic["X"] = cx
         zeilendic["Y"] = cy
         zeilendic["Z"] = cz
         //cx: Optional("3.985") cy: Optional("26.298")
         //      print("zeilendic: \(zeilendic)")
         CNC_DatendicArray.append(zeilendic)
         
         
          print("report_readSVG CNC_DatendicArray")
          for el in CNC_DatendicArray
          {
          //print("\(el["ind"] ) \(el["X"] ) \(el["Y"] )")
          }
          
         //dataTable.reloadData()
          
         lasttabledataindex = 0 // Zeile 0 in circlearray
         
      }
      
      let zeile:IndexSet = [0]
      dataTable.reloadData()
      dataTable.selectRowIndexes(zeile, byExtendingSelection: false)

      print("setPCB_Output End  CNC_DatendicArray count: \( CNC_DatendicArray.count)")
   } // setPCB_Output
   
   func DrillDaten(tiefe:Int) ->[[UInt8]]
   {
      var DrillDatenarray = [[UInt8]]()
      var drillArray:[[UInt8]] = [drillvektor(szInt: -tiefe),drillvektor(szInt: (tiefe))]
      
      var zhome = 0
      drillArray[0][24] = 0xBA
     
      drillArray[0][25] = 1 // erster Abschnitt
      drillArray[1][25] = 2 // letzter Abschnitt
      drillArray[0][27] = 0 // index
      drillArray[1][27] = 1 // index
      
      // PWM
      drillArray[0][29] = 128 // PWM down
      drillArray[1][29] = 64 // PWM up
 
      drillArray[0][32] = DEVICE_MILL
      drillArray[1][32] = DEVICE_MILL
      drillArray[0][33] = 0 // Drillstatus begin
      
      drillArray[0][36] = 0 // default H fuer tabledataZeile
      drillArray[0][37] = 0xFF // default L fuer tabledataZeile
      //print("DrillDaten count: \(drillArray.count) drillArray: \(drillArray)")
      
      return DrillDatenarray
   }
   
   func print_tabarray(_ floatarray:[[UInt8]]) //->[String] // Array von Strings mit tabs
   {
      //https://docs.swift.org/swift-book/LanguageGuide/Functions.html
      for z in stride(from: 0, to: floatarray.count-1, by: 1)
      {
         var zeilenstringarray = [String]()
         for element in floatarray[z]
         {
            let elementstring = String(element)
            zeilenstringarray.append(elementstring)
         }
         var zeilenstring = zeilenstringarray.joined(separator: "\t")
         print(zeilenstring)
      }
      
   }
   
   
   func print_tabzeile(_ floatarray:[UInt8]) // String mit tabs
   {
      //https://docs.swift.org/swift-book/LanguageGuide/Functions.html
          var zeilenstringarray = [String]()
         //var zeilenstring:String = ""
         for element in floatarray
         {
            let elementstring = String(element)
            zeilenstringarray.append(elementstring)
         }
         
       
      
      var zeilenstring = zeilenstringarray.joined(separator: "\t")

      print(zeilenstring)
   }

   func print_svgarray(floatarr:[[Double]])
   {
      print("print_svgarray  count: \(floatarr.count)")
      var ii = 0
      for el in floatarr
      {
         print("\(ii)\t\(el[0])\t \(el[1])\t ")
         ii += 1
      }
   }

   func print_array(floatarr:[[Double]])
   {
      print("print_array  count: \(floatarr.count)")
      var ii = 0
      for el in floatarr
      {
         print("\(el) ")
         
      }
   }
   func print_intarray(intarr:[[Int]])
   {
      print("print_intarray  count: \(intarr.count)")
      for el in intarr
      {
         print("\(el) ")
         
      }
   }

   func print_int8array(intarr:[[UInt8]])
   {
      print("print_intarray  count: \(intarr.count)")
      var ii = 0
      for el in intarr
      {
         print("\(el) ")
         
      }
   }

   
   
   func PCB_Abs_Daten(floatarray:[[Double]])->[[UInt8]]
   {
      print("PCB_Abs_Daten\n")
      //  var speed = speedFeld.intValue
      var PCB_Datenarray = [[UInt8]]()
      let tempweg = drillwegFeld.integerValue
      var drillArray:[[UInt8]] = [drillvektor(szInt: -drillweg),drillvektor(szInt: (drillweg))]
      
      //Schnittdatenarray.removeAll()
      Schnittdatenarray_n.removeAll()
      
      //      var SchritteArray:[[String:Any]] = [[:]]
      zoomfaktor = zoomFeld.doubleValue
      //     let steps = stepsFeld.intValue // Schritte fuer 1mm
      var code:UInt8 = 0
      
      var maxsteps:Double = 0
      //var relevanteschritte
      var zeilenposition = 0
      //      var zeilenanzahl = circlefloatarray.count
      
      var xhome = 0
      var yhome = 0
      
      //      for zeilenindex in stride(from: 0, to: circlefloatarray.count-1, by: 1)
      var anzeigezeile = 0 //zeilennumer fuer PlatteView
      var drillzeile = 0 //zeilennumer fuer drillarray
      
      
      for zeilenindex in stride(from: 0, to: floatarray.count-1, by: 1)
      {
         //         print("vor: \t xhome: \(xhome) yhome: \(yhome)")
         zeilenposition = 0
         if zeilenindex == 0
         {
            zeilenposition |= (1<<FIRST_BIT); // Erstes Element, Start
         }
         if zeilenindex == floatarray.count - 2
         {
            zeilenposition |= (1<<LAST_BIT);
         }
         
         //       let next = circlefloatarray[zeilenindex+1] // next punkt
         //       let akt = circlefloatarray[zeilenindex] // aktueller punkt
         
         let next = floatarray[zeilenindex+1] // next punkt
         let akt = floatarray[zeilenindex] // aktueller punkt
         
         
         // Differenz X
         let diffX:Double = next[1] //- akt[1]))
         
         floathomeX += diffX
         
         // Differenz Y
         let diffY:Double = next[2] //- akt[2]))
         floathomeY += diffY
         
         if diffX == 0 && diffY == 0
         {
            print(" stride *********    differenz null zeile: \(zeilenindex)")
            continue
         }
         
         // dic aufbauen
         var position:UInt16 = 0
         
         var zeilendic:[String:Any] = [:]
         
         
         let aktX = (akt[1]) //
         let aktY = (akt[2]) //
         let nextX = (next[1])
         let nextY = (next[2])
         //print("vor: \t diffX: \(diffX) diffY: \(diffY)")
         var wegArray = wegArrayMitWegXY(wegx: diffX, wegy: diffY)
         //         print("set_PCB_Daten wegArray\n\(wegArray)")
         
         wegArray[25] = UInt8(zeilenposition)
         wegArray[26] = UInt8((zeilenindex & 0xFF00)<<8)
         wegArray[27] = UInt8((zeilenindex & 0x00FF))
         wegArray[30] = UInt8(Int(zoomFeld.doubleValue * 10))
         
         wegArray[36] = 0 // default H fuer tabledataZeile
         wegArray[37] = 0xFF // default L fuer tabledataZeile
         
         wegArray[39] =  UInt8((anzeigezeile & 0xFF00)>>8)
         wegArray[40] =  UInt8(anzeigezeile & 0x00FF)
         // drillzeile ausschliessen
         wegArray[41] = 0xFF
         wegArray[42] = 0x01
         
         //print("code: \(wegArray[24]) ablaufstatus: \(ablaufstatus)")
         PCB_Datenarray.append(wegArray)
         //ablaufstatus |= (1<<DRILL_OK)
         //print("ablaufstatus: \(ablaufstatus)")
         if (drillOKKnopf.state == NSControl.StateValue.on)
         {
            ablaufstatus |= (1<<DRILL_OK)
         }
         else
         {
            ablaufstatus &= ~(1<<DRILL_OK)
         }
         
         if ((ablaufstatus & (1<<DRILL_OK) > 0) && (zeilenindex < (circlefloatarray.count - 1)))
         {
            //print("drillArray: \(drillArray)")
            // anzeigezeile angeben
            drillArray[0][39] =  UInt8((anzeigezeile & 0xFF00)>>8)
            drillArray[0][40] =  UInt8(anzeigezeile & 0x00FF)
            drillArray[1][39] =  UInt8((anzeigezeile & 0xFF00)>>8)
            drillArray[1][40] =  UInt8(anzeigezeile & 0x00FF)
           // drillzeile angeben
            drillArray[0][41] = UInt8((drillzeile & 0xFF00)>>8)
            drillArray[0][42] = UInt8(drillzeile & 0x00FF)
            drillArray[1][41] = UInt8((drillzeile & 0xFF00)>>8)
            drillArray[1][42] = UInt8(drillzeile & 0x00FF)
            drillzeile += 1 
            PCB_Datenarray.append(drillArray[0])
            PCB_Datenarray.append(drillArray[1])
         }
         anzeigezeile += 1
         
         
      } // for zeilenindex
 
      
      // Zeilennummern kontrollieren
      
      var z=0
      for z in 0..<PCB_Datenarray.count
      {
         PCB_Datenarray[z][27] = UInt8(z & 0x00FF)
         PCB_Datenarray[z][26] = UInt8((z & 0xFF00) >> 8)
         //print("PCBzeile: \(z) \(PCB_Datenarray[z][27])")
         
      }
  
      return PCB_Datenarray
   } 
   // MARK: ***      ***  PCB_Daten
   
   func PCB_Daten(floatarray:[[Double]])->[[UInt8]]
   {
      print("PCB_Daten\n")
      //  var speed = speedFeld.intValue
      var PCB_Datenarray = [[UInt8]]()
      drillweg = drillwegFeld.integerValue
      let microstepindex = schritteweitepop.indexOfSelectedItem
      let microstep = Int(schritteweitepop.itemTitle(at: microstepindex))
      print("microstep: \(microstep)")
      drillweg *= microstep ?? 1
      
      var drillArray:[[UInt8]] = [drillvektor(szInt: -drillweg),drillvektor(szInt: (drillweg))]
      
      //Schnittdatenarray.removeAll()
      Schnittdatenarray_n.removeAll()
      
      //      var SchritteArray:[[String:Any]] = [[:]]
      zoomfaktor = zoomFeld.doubleValue
      //     let steps = stepsFeld.intValue // Schritte fuer 1mm
      var code:UInt8 = 0
      
      var maxsteps:Double = 0
      //var relevanteschritte
      var zeilenposition = 0
      //      var zeilenanzahl = circlefloatarray.count
      
      var xhome = 0
      var yhome = 0
      
      //      for zeilenindex in stride(from: 0, to: circlefloatarray.count-1, by: 1)
      var anzeigezeile = 0 //zeilennumer fuer PlatteView
      var drillzeile = 0 //zeilennumer fuer drillarray
      
      //print("PCB Daten floatarray count vor: \(floatarray.count) circlefloatarray count: \(circlefloatarray.count) ")
      for zeilenindex in stride(from: 0, to: floatarray.count-1, by: 1)
      {
         //         print("vor: \t xhome: \(xhome) yhome: \(yhome)")
         zeilenposition = 0
         if zeilenindex == 0
         {
            zeilenposition |= (1<<FIRST_BIT); // Erstes Element, Start
         }
         if zeilenindex == floatarray.count - 2
         {
            zeilenposition |= (1<<LAST_BIT);
         }
         
         //       let next = circlefloatarray[zeilenindex+1] // next punkt
         //       let akt = circlefloatarray[zeilenindex] // aktueller punkt
         
         let next = floatarray[zeilenindex+1] // next punkt
         let akt = floatarray[zeilenindex] // aktueller punkt
         
         
         // Differenz X
         let diffX:Double = ((next[1] - akt[1]))
         
         floathomeX += diffX
         
         // Differenz Y
         let diffY:Double = ((next[2] - akt[2]))
         floathomeY += diffY
         
         if diffX == 0 && diffY == 0
         {
            print(" stride *********    differenz null zeile: \(zeilenindex)")
            continue
         }
         
         var wegArray = wegArrayMitWegXY(wegx: diffX, wegy: diffY)
         //         print("set_PCB_Daten wegArray\n\(wegArray)")
         
         wegArray[25] = UInt8(zeilenposition)
         wegArray[26] = UInt8((zeilenindex & 0xFF00)>>8)
         wegArray[27] = UInt8((zeilenindex & 0x00FF))
         wegArray[30] = UInt8(Int(zoomFeld.doubleValue * 10))
         wegArray[36] = 0 // default H fuer tabledataZeile
         wegArray[37] = 0xFF // default L fuer tabledataZeile
         
         wegArray[39] =  UInt8((anzeigezeile & 0xFF00)>>8)
         wegArray[40] =  UInt8(anzeigezeile & 0x00FF)
         // drillzeile ausschliessen
         wegArray[41] = 0xFF
         wegArray[42] = 0x01
         
        // print("code: \(wegArray[24]) ablaufstatus: \(ablaufstatus)")
         PCB_Datenarray.append(wegArray)
         //ablaufstatus |= (1<<DRILL_OK)
         //print("ablaufstatus: \(ablaufstatus)")
         if (drillOKKnopf.state == NSControl.StateValue.on)
         {
            ablaufstatus |= (1<<DRILL_OK)
         }
         else
         {
            ablaufstatus &= ~(1<<DRILL_OK)
         }
         //print("ablaufstatus: \(ablaufstatus) zeilenindex: \(zeilenindex)")
         if ((ablaufstatus & (1<<DRILL_OK) > 0) && (zeilenindex < (floatarray.count - 2)))
         {
            if zeilenindex >= 0
            {
               //print("drillArray anzeigezeile: \(anzeigezeile) drillzeile: \(drillzeile)")
               // anzeigezeile angeben
               drillArray[0][39] =  UInt8((anzeigezeile & 0xFF00)>>8)
               drillArray[0][40] =  UInt8(anzeigezeile & 0x00FF)
               drillArray[1][39] =  UInt8((anzeigezeile & 0xFF00)>>8)
               drillArray[1][40] =  UInt8(anzeigezeile & 0x00FF)
               // drillzeile angeben
               drillArray[0][41] = UInt8((drillzeile & 0xFF00)>>8)
               drillArray[0][42] = UInt8(drillzeile & 0x00FF)
               drillArray[1][41] = UInt8((drillzeile & 0xFF00)>>8)
               drillArray[1][42] = UInt8(drillzeile & 0x00FF)
               drillzeile += 1 
 
               if zeilenindex == 0 // nach erstem Schritt eine Stufe down
               {
                  PCB_Datenarray.append(drillArray[0])
               }
               PCB_Datenarray.append(drillArray[0])
               PCB_Datenarray.append(drillArray[1])
               
               if zeilenindex == (floatarray.count - 3)  // vor letztem Schritt eine Stufe up
               {
                  PCB_Datenarray.append(drillArray[1])
               }
            }
         }
         
         anzeigezeile += 1
         
         
      } // for zeilenindex
      
      // drilldown nach erstem Weg:
      // Zeilennummern kontrollieren
      
      //var z=0
      for z in 0..<PCB_Datenarray.count
      {
         PCB_Datenarray[z][27] = UInt8(z & 0x00FF)
         PCB_Datenarray[z][26] = UInt8((z & 0xFF00) >> 8)
         //print("PCBzeile: \(z) \(PCB_Datenarray[z][27])")
         //print("PCBzeile: \(z) \(PCB_Datenarray[z])")
         
      }
      //print_tabarray(PCB_Datenarray)
      return PCB_Datenarray
   }
   
     
   @IBAction func report_NN(_ sender: NSButton)
   {
      //print("report_NN")
      let state = sender.state
      var nn = false
      if state == .on
      {
         nn = true
      }
      print("report_NN nn: \(nn)")
      if circlefloatarray.count == 0
      {
         print("report_NN circlefloatarray leer")
         return
      }
      teensy.clear_writearray()
      Schnittdatenarray.removeAll()
      print("report_NN circlefloatarray.count: \(circlefloatarray.count)")
      var mill_floatarray = mill_floatArray_Funktion(circarray: circlefloatarray_raw) //
      
      if ((figurschliessen_checkbox.state == .on) && ((mill_floatarray[0][1]) != (mill_floatarray[mill_floatarray.count - 1][1])))
      {   
         print("Figur noch nicht geschlossen")
         mill_floatarray.append(mill_floatarray[0])
      }
 else 
      {
         print("Figur schon geschlossen")
      }
      //print("report_NN mill_floatarray: \(mill_floatarray)")
      
      setPCB_Output(floatarray: mill_floatarray, scale: 5, transform: transformfaktor)
      var PCBDaten = PCB_Daten(floatarray: mill_floatarray)
      
      //print("report_NN PCBDaten")
      Schnittdatenarray.append(contentsOf:PCBDaten)
   
   }
   
     
   @IBAction func report_drillOK(_ sender: NSButton)
   {
      print("report_Drill")
      let state = sender.state
      var drill = false
      if state == .on
      {
         drill = true
      }
      print("report_Drill drill: \(drill)")
      if circlefloatarray.count == 0
      {
         print("report_Drill circlefloatarray leer")
         return
      }
      Schnittdatenarray.removeAll()
      print("report_Drill circlefloatarray.count: \(circlefloatarray.count)")
      print("report_Drill circlefloatarray: \(circlefloatarray)")
      var mill_floatarray = mill_floatArray_Funktion(circarray: circlefloatarray_raw) 
      
      print("report_Drill circlefloatarray: \(circlefloatarray)")
      if ((figurschliessen_checkbox.state == .on) && ((mill_floatarray[0][1]) != (mill_floatarray[mill_floatarray.count - 1][1])))
      {   
         print("drill Figur noch nicht geschlossen")
         mill_floatarray.append(mill_floatarray[0])
      }
 else 
      {
         print("drill Figur schon geschlossen")
      }
      print("report_Drill mill_floatarray count: \(mill_floatarray.count)\n \(mill_floatarray)")
      
      setPCB_Output(floatarray: mill_floatarray, scale: 5, transform: transformfaktor)
      var PCBDaten = PCB_Daten(floatarray: mill_floatarray)
      
      //print("report_Drill PCBDaten")
      Schnittdatenarray.append(contentsOf:PCBDaten)
   
   }
   
   @IBAction func report_Nullpunkt(_ sender: NSButton)
   {
      print("report_Nullpunkt")
      
      teensy.write_byteArray[24] = 0xBC // code fuer set Nullpunkt
      if (teensy.status() > 0)
      {
         let senderfolg = teensy.send_USB()
         print("report_Nullpunkt senderfolg: \(senderfolg)")
      }

   }
   
   
   @IBAction func report_Pause(_ sender: NSButton)
   {
      print("report_Pause")
      let state = sender.state
      if state == .on
      {
         cncstatus |= (1<<PAUSE)
         print("PAUSE")
      }
      else
      {
         cncstatus &= ~(1<<PAUSE)
         print("GO")
         self.write_CNC_Abschnitt()
      }
      
   }
    
   @IBAction override func report_HALT(_ sender: NSButton)
   {
      print("report_HALT")
      /*
 [CNC_Preparetaste setEnabled:![sender state]];
 [CNC_Starttaste setEnabled:[sender state]];
 [CNC_Stoptaste setEnabled:![sender state]];
 [CNC_Sendtaste setEnabled:![sender state]];
 [CNC_Terminatetaste setEnabled:![sender state]];
 [DC_Taste setState:0];
 [self setStepperstrom:1];
 [self setBusy:0];
 [PositionFeld setIntValue:0];
 [PositionFeld setStringValue:@""];
 
 */
      var notdic = [String:Any]()
      notdic["haltstatus"] = CNC_HALT_Knopf.state
      notdic["push"] = 0
      print("haltstatus: \(CNC_HALT_Knopf.state)")    
      if CNC_HALT_Knopf.state == .on
      {
         teensy.write_byteArray[24] = 0xE0 // code
         teensy.write_byteArray[26] = 0 // indexh
         teensy.write_byteArray[27] = 0 // indexl
 //        var timerdic:[String:Int] = ["haltstatus":1, "home":0]
 //        var timer : Timer? = nil
  //       timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(USB_read(timer:)), userInfo: timerdic, repeats: true)
//         if (usbstatus > 0)
//         {
            let senderfolg = teensy.send_USB()
            print("report_HALT senderfolg: \(senderfolg)")
 //        }

         CNC_HALT_Knopf.state = .off
         teensy.clear_writearray()
      clear()
      }
  
      
   }

   @IBAction func report_send_Daten(_ sender: NSButton)
   {
      //print("report_send_Daten")
      
      var antwort:NSApplication.ModalResponse
      /*
       func dialogOKCancel(question: String, text: String) -> Bool {
       let alert = NSAlert()
       alert.messageText = question
       alert.informativeText = text
       alert.alertStyle = .warning
       alert.addButton(withTitle: "OK")
       alert.addButton(withTitle: "Cancel")
       return alert.runModal() == .alertFirstButtonReturn
       }
       let answer = dialogOKCancel(question: "Ok?", text: "Choose your answer.")
       */
      PCB_Test = 1
      if (PCB_Test == 0)
      {
         let alert = NSAlert()
         alert.messageText = "CNC-Task starten?"
         alert.informativeText = "Der Teensy ist noch nicht eingesteckt"
         alert.alertStyle = .warning
         alert.addButton(withTitle: "Einstecken und einschalten")
         alert.addButton(withTitle: "Zurück")
         antwort = alert.runModal()
         print("antwort: \(antwort)")
         switch antwort
         {
         case .alertFirstButtonReturn: // rawValue: 1000
            
            print("antwort 1")
            break
            
         case .alertSecondButtonReturn: // rawValue: 1001
            
            print("antwort 2")
            return;
            break
            
         default:
            break
            
         }
      }
      else 
      {
         PCB_Test = 0
      }
      if teensy.readtimervalid() == true
      {
         print("PCB readtimer valid vor")
      }
      else 
      {
         print("PCB readtimer not valid vor")
         var start_read_USB_erfolg = teensy.start_read_USB(true)
      }

      Plattefeld.clearMark()
      Plattefeld.stepperposition = 0
      cncstepperposition = 0
      ablaufzeitFeld.stringValue = zeitformatter.string(from: TimeInterval(0))!
      //     Plattefeld.setStepperposition(pos:cncstepperposition)
      let anzabschnitte = Schnittdatenarray.count
      
       
      if Schnittdatenarray.count == 0 // > Array im Teensy loeschen
      {
         teensy.write_byteArray[25] = 1 //erstes Element
         teensy.write_byteArray[24] = 0xF1 // Stopp
 //        if teensy.dev_present() > 0
 //        {
            let senderfolg = teensy.send_USB()
         print("report_send_Daten report_goXY senderfolg: \(senderfolg)")
 //        }
         teensy.clear_writearray()
         return
      }
      Schnittdatenarray[0][33] = UInt8((anzabschnitte & 0xFF00) >> 8)
      Schnittdatenarray[0][34] = UInt8(anzabschnitte & 0x00FF)

      /*
       var i = 0
       for linie in Schnittdatenarray
       {
       print("\(i) \(linie)")
       i += 1
       }
      */ 
      /*
      if teensy.readtimervalid() == true
      {
         print("PCB readtimer valid vor")
      }
      else 
      {
         print("PCB readtimer not valid vor")
         var start_read_USB_erfolg = teensy.start_read_USB(true)
      }
      */
      Plattefeld.resetStepperposition()
      teensy.clear_writearray()
      Plattefeld.setStepperposition(pos: 0) // Ersten Punkt markieren
      Schnittdatenarray[0][24] = 0xD5     // start neue serie
      for i in 1..<Schnittdatenarray.count
      {
     //    Schnittdatenarray[i][24] = 0xD5 //
     // Schnittdatenarray[1][24] = 0xD5 //
    //  Schnittdatenarray[2][24] = 0xD5 //
    //  Schnittdatenarray[3][24] = 0xD5 //
      }
      now = Date()
      startzeit = Date()
      write_CNC_Abschnitt()
      
         
      
      //    var start_read_USB_erfolg = teensy.start_read_USB(true)
      
      //      var readtimernote:[String:Int] = ["cncstepperposition":1]
      //      readtimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(USB_read(timer:)), userInfo: readtimernote, repeats: true)
      
      
   } // report_send_Daten
   
    
 
   func clear()
   {
      ablaufzeitFeld.stringValue = zeitformatter.string(from: TimeInterval(0))!
      cncstepperposition = 0
      teensy.clear_writearray()
      Schnittdatenarray.removeAll()
      circlearray.removeAll()
      circlefloatarray.removeAll()
      circlefloatarray_raw.removeAll()
      CNC_DatendicArray.removeAll()
      
      dataTable.reloadData()
      Plattefeld.clearWeg()
      Plattefeld.needsDisplay = true
      lastklickposition.x = 0
      lastklickposition.y = 0
      
      print("PCB reportclear homeX: \(homeX) homeY: \(homeY)")
      homeX = 0
      homeY = 0
      homexFeld.integerValue = 0
      homeyFeld.integerValue = 0
      

   }
   
   @IBAction func report_clear(_ sender: NSButton)
   {
      print("\n           PCB report_clear")
      teensy.write_byteArray[24] = 0xF1
      
      //write_CNC_Abschnitt()
      //    if (usbstatus > 0)
      //    {
      let senderfolg = teensy.send_USB()
      print("PCB report_clear senderfolg: \(senderfolg)")
      //    }
      clear()
       return
         
      ablaufzeitFeld.stringValue = zeitformatter.string(from: TimeInterval(0))!
      cncstepperposition = 0
      teensy.clear_writearray()
      Schnittdatenarray.removeAll()
      circlearray.removeAll()
      CNC_DatendicArray.removeAll()
      
      dataTable.reloadData()
      Plattefeld.clearWeg()
      Plattefeld.needsDisplay = true
      lastklickposition.x = 0
      lastklickposition.y = 0
      
      print("PCB reportclear homeX: \(homeX) homeY: \(homeY)")
      homeX = 0
      homeY = 0
      homexFeld.integerValue = 0
      homeyFeld.integerValue = 0
   }
   
   @IBAction func report_clear_weg(_ sender: NSButton)
   {
      print("\n           PCB report_clear_weg")
      teensy.write_byteArray[24] = 0xF3
      
      //write_CNC_Abschnitt()
      //    if (usbstatus > 0)
      //    {
      //let senderfolg = teensy.send_USB()
      //print("PCB report_clear_weg senderfolg: \(senderfolg)")
      //    }
     
      Plattefeld.clearMark()
      stepperpositionFeld.integerValue = 0
      
      return
      ablaufzeitFeld.stringValue = zeitformatter.string(from: TimeInterval(0))!
      cncstepperposition = 0
      //teensy.clear_writearray()
      //Schnittdatenarray.removeAll()
      //circlearray.removeAll()
      //CNC_DatendicArray.removeAll()
      
      //dataTable.reloadData()
      Plattefeld.clearWeg()
      Plattefeld.needsDisplay = true
      lastklickposition.x = 0
      lastklickposition.y = 0
      
      print("PCB reportclear homeX: \(homeX) homeY: \(homeY)")
      homeX = 0
      homeY = 0
      homexFeld.integerValue = 0
      homeyFeld.integerValue = 0
   }
   
   @IBAction func report_home(_ sender: NSButton)
   {
      
 //     print("PCB report_home homex: \(homeX) homey: \(homeY)")
  
      var dx = homexFeld.doubleValue * -1 
      var dy = homeyFeld.doubleValue * -1
      
      print("PCB report_home dx: \(dx) dy: \(dy)")
      lastklickposition.x = 0
      lastklickposition.y = 0
 
      var homewegarray = wegArrayMitWegXY(wegx:Double(dx), wegy:Double(dy))
      homewegarray[32] = DEVICE_MILL
      
      // print("homewegarray")
     // print("\(homewegarray)")
      homewegarray[25] = 3 // nur 1 Abschnitt
      homewegarray[24] = 0xD5
      
      //print_tabzeile(homewegarray)
      
      
      if homewegarray.count > 0
      {
         write_CNC_Zeile(zeilenarray: homewegarray)
         //    homeX += Int(dx)
          //   homeY += Int(dy)
         //     print("report_home homeX: \(homeX) homeY: \(homeY)")
         //    homexFeld.integerValue = homeX
         //    homeyFeld.integerValue = homeY
         
         if teensy.readtimervalid() == true
         {
       //     print("PCB readtimer valid vor")
            
         }
         else 
         {
            print("PCB readtimer not valid vor")
            
            var start_read_USB_erfolg = teensy.start_read_USB(true)
         }
      }
     // let senderfolg = teensy.send_USB()
      //print("PCB report home senderfolg: \(senderfolg)")
      
   }
   
   
   func schrittdatenvektor(sxInt:Int,syInt:Int,szInt:Int, zeit:Double) -> [UInt8]
   {
      //      print("+++++++++++                               schrittdatenvektor sxInt: \(sxInt) syInt: \(syInt) szInt: \(szInt) zeit: \(zeit)")
      // Vorzeichenbit auskomm:
      
      let sxInt_raw = (sxInt & 0x0FFFFFFF)
      let syInt_raw = (syInt & 0x0FFFFFFF)
      let szInt_raw = (szInt & 0x0FFFFFFF)
      
   //   let xx = -20
  //    let xx_raw = (xx & 0x0FFFFFFF)
      //print("\tschrittdatenvektor sxInt_raw: \(sxInt_raw) syInt_raw: \(syInt_raw) szInt_raw: \(szInt_raw) zeit: \(Int(zeit))")
      
   //   let stepwert = stepsFeld.integerValue
   //   var kgvx = kgv3(m:stepwert,n:sxInt_raw,o: syInt_raw)
   //   var ggt = ggt2(x:sxInt_raw, y:syInt_raw)
      
      //print("schrittdatenvektor sxInt_raw: \(sxInt_raw) syInt_raw: \(syInt_raw)  kgvx: \(kgvx) ggt: \(ggt)")

  //    var ggtt = ggt2(x:48,y:56)
 //     homeX += sxInt_raw
 //     homeY += syInt_raw
      
      
      var vektor = [UInt8]()
      //print("sxInt: \(sxInt) ")
      let sxA = UInt8(sxInt & 0x000000FF)
      let sxB = UInt8((sxInt & 0x0000FF00) >> 8)
      let sxC = UInt8((sxInt & 0x00FF0000) >> 16)
      let sxD = UInt8((sxInt & 0xFF000000) >> 24)
      //      print("schrittdatenvektor sxInt: \(sxInt) sxA: \(sxA) sxB: \(sxB)")
      vektor.append(sxA)
      vektor.append(sxB)
      vektor.append(sxC)
      vektor.append(sxD)
      
      let dx:Double = (zeit / Double((sxInt & 0x0FFFFFFF))) // Zeit pro schritt , Vorzeichen-Bit weg
      
      let dxIntround = round(dx)
      var dxInt = 0
      if dxIntround >= Double(Int.min) && dxIntround < Double(Int.max)
      {
         // print("delayxInt OK")
         dxInt = Int(dxIntround)
      }
      let dxA = UInt8(dxInt & 0x000000FF)
      let dxB = UInt8((dxInt & 0x0000FF00) >> 8)
      vektor.append(dxA)
      vektor.append(dxB)
      
      //      print("Fehlerkorrektur X")
      var korrekturintervallx:Int = 0
      
      var istzeitx:Double = 0
      var kontrolleintx = 0;
      if sxInt != 0
      {
         let vorzeichenx = (sxInt & 0x80000000)
         
         //         print("vorzeichenx: \(vorzeichenx)") // Richtung der Bewegung
         
         //         print("sxInt_raw: \(sxInt_raw) dx: \(dx) dxInt: \(dxInt)")
         let kontrolledoublex = Int(Double(sxInt_raw) * dx) //  Kontrolle mit Double-Wert von dx: Sollwert Fahrzeit
         
         kontrolleintx = sxInt_raw * dxInt //               Kontrolle mit Int-Wert von dx : Istwert Fahrzeit, tatsächliche Zeit
         istzeitx = Double(kontrolleintx)
         var diffx = Int(kontrolledoublex) - kontrolleintx // differenz, Rundungsfehler
         //print("zeit: \(zeit) kontrolledoublex: \(kontrolledoublex) kontrolleintx: \(kontrolleintx) diffx: \(diffx)")
         if diffx == 0
         {
            diffx = 1 // keine div /0
         }
         let intervallx = Double(kontrolleintx / diffx) // 
         
         let controlx = Double(sxInt_raw) / intervallx
         korrekturintervallx = Int(round(intervallx)) // Rundungsfehler aufteilen ueber Abschnitt: 
         // alle korrekturintervallx Schritte dexInt incrementieren oder decrementieren
         //       print("korrekturintervallx: \(korrekturintervallx) controlx: \(controlx)")
         
         if korrekturintervallx < 0 // negative korrektur
         {
            //            print("korrekturintervallx negativ")
            korrekturintervallx *= -1
            korrekturintervallx |= 0x8000
         }
         //         print("korrekturintervallx mit Vorzeichenkorr: \(korrekturintervallx) controlx: \(controlx)\n")
      }
      korrekturintervallx = 0;
      vektor.append(UInt8(korrekturintervallx & 0x00FF))
      vektor.append(UInt8((korrekturintervallx & 0xFF00)>>8))
      
      
      
      let syA = UInt8(syInt & 0x000000FF)
      let syB = UInt8((syInt & 0x0000FF00) >> 8)
      let syC = UInt8((syInt & 0x00FF0000) >> 16)
      let syD = UInt8((syInt & 0xFF000000) >> 24)
      vektor.append(syA)
      vektor.append(syB)
      vektor.append(syC)
      vektor.append(syD)
      
      //let dy:Double = (zeit / Double((syInt & 0x0FFFFFFF))) // Vorzeichen-Bit weg
      let dy:Double = (istzeitx / Double((syInt & 0x0FFFFFFF))) // Vorzeichen-Bit weg
      
      let dyIntround = round(dy)
      var dyInt = 0
      if dyIntround >= Double(Int.min) && dyIntround < Double(Int.max)
      {
         dyInt = Int(dyIntround)
      }
      let dyA = UInt8(dyInt & 0x000000FF)
      let dyB = UInt8((dyInt & 0x0000FF00) >> 8)
      vektor.append(dyA)
      vektor.append(dyB)
      
      
      //      print("Fehlerkorr Y")
      var korrekturintervally:Int = 0
      var korrekturintervall_xy:Int = 0
      if syInt != 0
      {
         let vorzeicheny = (syInt & 0x80000000)
         
         //print("vorzeicheny: \(vorzeicheny)")
         
         //print("syInt_raw: \(syInt_raw) dy: \(dy) dyInt: \(dyInt)")
         
         let kontrolledoubley = Int(Double(syInt_raw) * dy)       // Sollzeit y
         let kontrolleinty = syInt_raw * dyInt                    // Istzeit y mit integer
         
         var istdiffxy = kontrolleintx - kontrolleinty // Zeitfehler: Korrektur in delayY
         if istdiffxy == 0
         {
            istdiffxy = 1
         }
         //print("kontrolleintx(istzeitx): \(kontrolleintx) kontrolleinty: \(kontrolleinty) istdiffxy: \(istdiffxy) vorzeicheny: \(vorzeicheny)")
         
         
         var diffy = (kontrolledoubley) - kontrolleinty            
         //         print("kontrolledoubley: \(kontrolledoubley) kontrolleinty: \(kontrolleinty) diffxy: \(diffxy) vorzeicheny: \(vorzeicheny)")
         if diffy == 0
         {
            diffy = 1
         }
         let intervally = Double(kontrolleinty / diffy) // Intervall für Einschub der Korrekturzeit
         

         //let intervall_xy:Double = Double(kontrolleinty / istdiffxy) // Abstand der Einschübe
         
         let intervall_xy:Double = Double(syInt_raw / istdiffxy) // Abstand der Einschübe
         
         let controly = Double(syInt_raw) / intervally
         
         let controlxy = Double(syInt_raw) / intervall_xy 
         
         
         korrekturintervally = (Int(round(intervally)))
         //        print("korrekturintervally: \(korrekturintervally) \n")
         if korrekturintervally < 0 // negative korrektur, Korrekturwert ist negativ
         {
            //           print("korrekturintervally negativ")
            korrekturintervally *= -1
            korrekturintervally |= 0x8000
         }
         
         korrekturintervall_xy = (Int(round(intervall_xy)))
         //        print("korrekturintervall_xy: \(korrekturintervall_xy) \n")
         if korrekturintervall_xy < 0 // negative korrektur, Korrekturwert ist negativ
         {
            //           print("korrekturintervallxy negativ")
            korrekturintervall_xy *= -1
            korrekturintervall_xy |= 0x8000
            
         }

         
         
         
         //        print("korrekturintervally mit Vorzeichenkorr: \(korrekturintervally)  controly: \(controly)\n")
      }
      vektor.append(UInt8(korrekturintervall_xy & 0x00FF))
      vektor.append(UInt8((korrekturintervall_xy & 0xFF00)>>8))
      
      // Motor C Schritte
      if szInt == 0
      {
         vektor.append(0)
         vektor.append(0)
         vektor.append(0)
         vektor.append(0)
         // Motor C delay
         vektor.append(0)
         vektor.append(0)
         vektor.append(0)
         vektor.append(0)
      }
      else
      {
         let szA = UInt8(szInt & 0x000000FF)
         let szB = UInt8((szInt & 0x0000FF00) >> 8)
         let szC = UInt8((szInt & 0x00FF0000) >> 16)
         let szD = UInt8((szInt & 0xFF000000) >> 24)
         vektor.append(szA)
         vektor.append(szB)
         vektor.append(szC)
         vektor.append(szD)
         
         let dz:Double = (zeit / Double((szInt & 0x0FFFFFFF))) // Vorzeichen-Bit weg
         
         let dzIntround = round(dz)
         var dzInt = 0
         if dzIntround >= Double(Int.min) && dzIntround < Double(Int.max)
         {
            // print("delayxInt OK")
            dzInt = Int(dzIntround)
         }
         vektor.append(0)
         vektor.append(0)
         
         // keine Fehlerkorrektur
         vektor.append(0)
         vektor.append(0)
         
         
      }
      vektor.append(0) // el 24, code
      vektor.append(0) // el 25, lage
      
      vektor.append(0) // el 26, zeilenindexh
      vektor.append(0) // el 27, zeilenindexl
      
      // motorstatus
      var motorstatus:UInt8 = 0
      var maxsteps:Int = 0
      //      print("\tschrittdatenvektor sxInt_raw: \(sxInt_raw) syInt_raw: \(syInt_raw) szInt_raw: \(szInt_raw) zeit: \(Int(zeit))")
      /*
       if (fabs(dyIntround) > fabs(dxIntround)) // wer hat mehr schritte x
       {
       maxsteps = fabs(dyIntround)
       motorstatus = (1<<MOTOR_B)
       }
       else 
       {
       maxsteps = fabs(dxIntround)
       motorstatus = (1<<MOTOR_A)
       }
       */
      if (abs(syInt_raw) > abs(sxInt_raw)) // wer hat mehr schritte x
      {
         maxsteps = abs(syInt_raw)
         motorstatus = (1<<MOTOR_B)
      }
      else 
      {
         maxsteps = abs(sxInt_raw)
         motorstatus = (1<<MOTOR_A)
      }
      
      if (sxInt == 0) && (syInt == 0) && (szInt != 0)
      {
         motorstatus = (1<<MOTOR_C)
      }
 //     print("schrittdatenvektor motorstatus: \(motorstatus)")
      vektor.append(motorstatus)
      vektor.append(77) // Platzhalter PWM
      
      let timerintervall = timerintervallFeld.integerValue
      vektor.append(UInt8((timerintervall & 0xFF00)>>8))
      vektor.append(UInt8(timerintervall & 0x00FF))
      vektor.append(DEVICE_MILL)
      
      // Drill
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      
      // tableview
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)

      // 48
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)
      vektor.append(0)

 //     print("schrittdatenvektor count: \(vektor.count)")
      //     print("schrittdatenvektor sxInt: \(sxInt) dxInt: \(dxInt) syInt: \(syInt) dyInt: \(dyInt) zeit: \(zeit)")
      //print("schrittdatenvektor: \(vektor)")
      return vektor
   }

   func drillvektor(szInt:Int) -> [UInt8]
   {
      //      print("+++++++++++                               drillvektor szInt: \(szInt)")
      // von PCB_Daten
      // Vorzeichenbit auskomm:
      var szInt_raw = szInt
      if szInt < 0
      {
         print("drill down")
//            print("schrittezInt negativ")
         szInt_raw *= -1
         szInt_raw |= 0x80000000
      }
      var vektor:[UInt8] = wegArrayMitWegZ(wegz:Double(szInt))
      
      
       
      //var vektor = schrittdatenvektor(sxInt: 0, syInt: 0, szInt: szInt_raw, zeit: 1)
      
      vektor[25] = 0 // innerer Abschnitt
      vektor[32] = 1
      vektor[24] = 0
      vektor[30] = UInt8(Int(zoomFeld.doubleValue * 10))
      vektor[38] = 0
      vektor[36] = 0 // default H fuer tabledataZeile
      vektor[37] = 0xFF // default L fuer tabledataZeile

    
 //     print("drillvektor count: \(vektor.count)")
 //     print("drillvektor count: \(vektor.count) vektor: \n\(vektor)")
      
      return vektor
   }
   
   func wegArrayMitWegZ(wegz:Double) ->[UInt8]
   {
      
      zoomfaktor = zoomFeld.doubleValue
      //print("PCB wegArrayMitWegZ wegZ: \(wegz) propfaktor: \(propfaktor)")
      var maxsteps:Double = 0
      var weg = [Double]()
      
      let distanzZ = wegz //*  INTEGERFAKTOR
      
      //     let distanzZ = wegz *  1000000
      
      let wegZ = distanzZ * zoomfaktor 
      let distanz = wegZ
 //           print("++++          wegArrayMitWegZ  distanz: \(distanzZ)  ")
      var speed = speedFeld.intValue
      
      if ramp_OK_Check.state == NSControl.StateValue.on
      {
         speed *= 2
      }
       
      //  let start = [0,0]
      //let ziel = [wegZ]
      
      // Fahrzeit
      let zeit:Double = Double(distanz)/Double(speed) //   Schnittzeit für Distanz
      
      // print("********           wegArrayMitWegXY zeit: \(zeit) ")
      
      var schrittez = Double(stepsZFeld.integerValue) * distanzZ  
      //     var schrittex = Double(stepsFeld.integerValue) * wegX  
      
      
     // schrittez /= propfaktor // Umrechnung in mm
      let schrittezmm = schrittez/stepsZFeld.doubleValue
      //print("wegArrayMitWegZ schrittez mm: \(schrittezmm) mm")
      
      var schrittezRound = round(schrittez)
      var schrittezInt:Int = 0
      if schrittezRound >= Double(Int.min) && schrittezRound < Double(Int.max)
      {
         
         schrittezInt = Int(schrittezRound)
         //  print("wegArrayMitWegXY schritteXInt OK: \(schrittexInt)")
         if schrittezInt < 0 // negativer Weg
         {
            //print("schrittezInt negativ")
            schrittezInt *= -1
            schrittezInt |= 0x80000000
         }
      }
      else
      {
         print("schritteZround zu gross")
      }
      
      
       
      
      //      print("+++           wegArrayMitWegXY vor schnittdatenvektor schrittexInt: \(schrittexInt) schritteyInt: \(schritteyInt) schrittezInt: \(schrittezInt) zeit: \(zeit) speed: \(speed)")
      
      // Schrittdaten berechnen
      
      var wegschnittdatenarray:[UInt8] = schrittdatenvektor(sxInt:0,syInt:0, szInt:schrittezInt, zeit:zeit  )// Array mit Daten fuer USB
      
      return wegschnittdatenarray
   }
   
   func wegArrayMitWegXY(wegx:Double, wegy:Double) ->[UInt8]
   {
      
      zoomfaktor = zoomFeld.doubleValue
      //print("PCB wegArrayMitWegXY wegX: \(wegx) wegY: \(wegy) propfaktor: \(propfaktor)")
      var maxsteps:Double = 0
      var weg = [Double]()
      
      let distanzX = wegx *  INTEGERFAKTOR
      let distanzY = wegy *  INTEGERFAKTOR
      
      //     let distanzZ = wegz *  1000000
      
      let wegX = distanzX * zoomfaktor 
      let wegY = distanzY * zoomfaktor 
      let distanz = (wegX*wegX + wegY*wegY).squareRoot()
      //print("++++          wegArrayMitWegXY  distanzX: \(distanzX)  distanzY: \(distanzY)  distanz: \(distanz)")
      var speed = speedFeld.intValue
      
      if ramp_OK_Check.state == NSControl.StateValue.on
      {
         speed *= 2
      }
      /*
       SVG: 72 dpi / inch
       1 p > 0.3528mm
       1mm > 2.8346p
       Multiplikator in readSVG: 1000000 (INTEGERFAKTOR)
       
       */
       //let propfaktor = 2.8185448826E6 // M
      //let propfaktor = 2812907.7928348
      //let propfaktor = 2815159.92077142 // 211226
      //let propfaktor = 2787008.32156371 // 211228 neue M6
      //let propfaktor = 2788841.55370412
      //let propfaktor = 2801856.14762141
      let dpi2mmfaktor = 2.81516 // propfaktor / INTEGERFAKTOR
      
    //  let start = [0,0]
    //  let ziel = [wegX,wegY]
      
      // Fahrzeit
      let zeit:Double = Double(distanz)/Double(speed) //   Schnittzeit für Distanz
      
      // print("********           wegArrayMitWegXY zeit: \(zeit) ")
      
      var schrittex = Double(stepsFeld.integerValue) * distanzX  
      //     var schrittex = Double(stepsFeld.integerValue) * wegX  
      
      
      schrittex /= propfaktor // Umrechnung in mm
      let schrittexmm = schrittex/stepsFeld.doubleValue
      //print("wegArrayMitWegXY schrittex mm: \(schrittexmm) mm")
      
      var schrittexRound = round(schrittex)
      var schrittexInt:Int = 0
      if schrittexRound >= Double(Int.min) && schrittexRound < Double(Int.max)
      {
         
         schrittexInt = Int(schrittexRound)
         //  print("wegArrayMitWegXY schritteXInt OK: \(schrittexInt)")
         if schrittexInt < 0 // negativer Weg
         {
            //print("schrittexInt negativ")
            schrittexInt *= -1
            schrittexInt |= 0x80000000
         }
      }
      else
      {
         print("schritteXround zu gross")
      }
      
      
      var schrittey = Double(stepsFeld.integerValue) * distanzY 
      // var schrittey = Double(stepsFeld.integerValue) * wegY
      
      schrittey /= propfaktor
      let schritteymm = schrittey/stepsFeld.doubleValue
      //     print("wegArrayMitWegXY schrittey mm: \(schritteymm)")
      var schritteyRound = round(schrittey)
      var schritteyInt:Int = 0
      if schritteyRound >= Double(Int.min) && schritteyRound < Double(Int.max)
      {
         
         schritteyInt = Int(schritteyRound)
         //         print("wegArrayMitWegXY schritteyInt OK: \(schritteyInt)")
         if schritteyInt < 0 // negativer Weg
         {
            //print("schritteyInt negativ")
            schritteyInt *= -1
            schritteyInt |= 0x80000000
         }
      }
      else
      {
         print("schritteYround zu gross")
      }
      
      let schrittezInt = 0
      //      print("+++           wegArrayMitWegXY vor schnittdatenvektor schrittexInt: \(schrittexInt) schritteyInt: \(schritteyInt) schrittezInt: \(schrittezInt) zeit: \(zeit) speed: \(speed)")
      
      // Schrittdaten berechnen
      
      var wegschnittdatenarray:[UInt8] = schrittdatenvektor(sxInt:schrittexInt,syInt:schritteyInt, szInt:0, zeit:zeit  )// Array mit Daten fuer USB
      
      return wegschnittdatenarray
   }
   
   
   // MARK: ***       write_CNC_Abschnitt  
   
   func write_CNC_Abschnitt()
   {
      //print("+++              PCB write_CNC_Abschnitt cncstepperposition: \(cncstepperposition) Schnittdatenarray.count: \(Schnittdatenarray.count)")
      //print("+++              PCB write_CNC_Abschnitt cncstepperposition: \(cncstepperposition)")
      stepperpositionFeld.integerValue = cncstepperposition
 /*
      for i in 0..<Schnittdatenarray.count
      {
         print("i \(i) \(Schnittdatenarray[i])")
      }
  */    
      if cncstepperposition == Schnittdatenarray.count
      {
         print("write_CNC_Abschnitt cncstepperposition ist Schnittdatenarray.count, END")
         return
      }
      if (cncstepperposition == 0)
      {
         nextdatenarray = Schnittdatenarray[0]
      }
      if cncstepperposition < Schnittdatenarray.count
      {
         if CNC_HALT_Knopf.state == .on
         {
            // alles OFF
            print("\t\t\twrite_CNC_Abschnitt HALT")
         }
         else
         {
            //print("\t\t\twrite_CNC_Abschnitt NEXT")
           // teensy.write_byteArray.removeAll()
         //   let tempSchnittdatenArray:[UInt8] = Schnittdatenarray[cncstepperposition]
  //          var schritteAX:UInt32 = UInt32(tempSchnittdatenArray[0]) | UInt32(tempSchnittdatenArray[1])<<8 | UInt32(tempSchnittdatenArray[2])<<16 | UInt32((tempSchnittdatenArray[3] & 0x7F))<<24;
            //      print("schritteAX: \(schritteAX) ")
//            var schritteAY:UInt32 = UInt32(tempSchnittdatenArray[8]) | UInt32(tempSchnittdatenArray[9])<<8 | UInt32(tempSchnittdatenArray[10])<<16 | UInt32((tempSchnittdatenArray[11] & 0x7F))<<24;
            //    print("schritteAY: \(schritteAY) ")
  //          print("write_CNC     schritteAX: \(schritteAX) schritteAY: \(schritteAY)")
               
            
            Schnittdatenarray[cncstepperposition][20] = 0 
            Schnittdatenarray[cncstepperposition][21] = 0
            Schnittdatenarray[cncstepperposition][22] = 0
            Schnittdatenarray[cncstepperposition][23] = 0
            
            teensy.write_byteArray = Schnittdatenarray[cncstepperposition]
            
            /*
            var cncdata:[UInt8] =  [20, 0, 0, 128, 111, 10, 0, 0, 20, 0, 0, 0, 57, 0, 3, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 2, 77, 10, 128, 1, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            
            let teststeps:UInt16 = UInt16(SVG_Testfeld.integerValue)
            
            cncdata[0] = UInt8(teststeps & (1<<0x00FF))
            cncdata[1] = UInt8(teststeps & ((1<<0xFF00) >> 8))
            cncdata[8] = UInt8(teststeps & (1<<0x00FF))
            cncdata[9] = UInt8(teststeps & ((1<<0xFF00) >> 8))
            cncdata[26] = UInt8((cncstepperposition & 0xFF00) >> 8)
            cncdata[27] = UInt8(cncstepperposition & 0x00FF)
            if cncstepperposition == 0
            {
               print("start")
               cncdata[25] = 1
               cncdata[24] = 0xD5
            }
            if (cncstepperposition == Schnittdatenarray.count - 1)
            {
              // print("endpos an cncstepperposition \(cncstepperposition)")
               cncdata[25] = 2
            }
            //cncdata[24] = 0xD5
            //teensy.write_byteArray = cncdata
            */
             usbtime = CFAbsoluteTimeGetCurrent()
       //     print("write_CNCcncstepperposition: \(cncstepperposition) code:  \(teensy.write_byteArray[24]) next write_byteArray: \(teensy.write_byteArray)")
            //print(" code    write_byteArray24: \(teensy.write_byteArray[24])")
            
  //          if teensy.dev_present() > 0
            // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
     //       let seconds = 1.0
     //       DispatchQueue.main.asyncAfter(deadline: .now() + seconds) 
     //       {
            nextdatazeit = CFAbsoluteTimeGetCurrent() - nextdatatime
            responsetime = CFAbsoluteTimeGetCurrent()
            
               let senderfolg = self.teensy.send_USB()
            responsezeit = CFAbsoluteTimeGetCurrent() - responsetime 
            //print("write_CNC_Abschnitt senderfolg: \(senderfolg) responsezeit: \(responsezeit)")
            
     //       }
            /*
             
             print("0: \(tempSchnittdatenArray[0]) ")
             print("1: \(tempSchnittdatenArray[1]) ")
             print("2: \(tempSchnittdatenArray[2]) ")
             print("3: \(tempSchnittdatenArray[3]) ")
             */
            
 //           dataTable.selectRowIndexes(IndexSet(integer: cncstepperposition), byExtendingSelection: false)
 //           dataTable.scrollRowToVisible(cncstepperposition)
            
            cncstepperposition += 1
   //         nextdatenarray = Schnittdatenarray[cncstepperposition]
            
            
         } // else
         
      }// if count
   //   print("write_CNC END\n")
   }
   
   func write_CNC_Zeile(zeilenarray:[UInt8])
   {
     // print("+++              PCB write_CNC_Zeile zeilenarray: \(zeilenarray) \nSchnittdatenarray.count: \(Schnittdatenarray.count)")
      /*
      if steppercontKnopf.state == .on
      {
         stepperpositionFeld.integerValue = lasttabledataindex + 1
      }
      */
      if zeilenarray.count >  64 || zeilenarray.count == 0
      {
         print("write_CNC_Zeile data err")
         return
      }
      //if zeile < Schnittdatenarray.count
      
      if CNC_HALT_Knopf.state == .on
      {
         // alles OFF
         print("write_CNC_Zeile HALT")
      }
      else
      {
         
         teensy.write_byteArray.removeAll()
         //var tempSchnittdatenArray:[UInt8] = Schnittdatenarray[cncstepperposition]
         var schritteAX:UInt32 = UInt32(zeilenarray[0]) | UInt32(zeilenarray[1])<<8 | UInt32(zeilenarray[2])<<16 | UInt32((zeilenarray[3] & 0x7F))<<24;
         //      print("schritteAX: \(schritteAX) ")
         var schritteAY:UInt32 = UInt32(zeilenarray[8]) | UInt32(zeilenarray[9])<<8 | UInt32(zeilenarray[10])<<16 | UInt32((zeilenarray[11] & 0x7F))<<24;
         //    print("schritteAY: \(schritteAY) ")
         var schritteAZ:UInt32 = UInt32(zeilenarray[16]) | UInt32(zeilenarray[17])<<8 | UInt32(zeilenarray[18])<<16 | UInt32((zeilenarray[19] & 0x7F))<<24;
             print("schritteAZ: \(schritteAZ) ")
        
         
         //print("write_CNC_Zeile   code: \(phex(zeilenarray[24]))  schritteAX: \(schritteAX) schritteAY: \(schritteAY) schritteAZ: \(schritteAZ) lage: \(zeilenarray[25])")
       //  print("write_CNC_Zeile  zeilenarray: \(zeilenarray)")
         
         for element in zeilenarray
         {
            teensy.write_byteArray.append(element)
         }
  
         //Drillspeed
         var Drillspeed = drillspeedFeld.integerValue / 2
         
         teensy.write_byteArray[20] = UInt8(Drillspeed & 0x000000FF)
         teensy.write_byteArray[21] = UInt8((Drillspeed & 0x0000FF00) >> 8)
        
  //       print("write_CNC_Zeile  write_byteArray: \(teensy.write_byteArray)")x
  //       print("    write_byteArray24: \(teensy.write_byteArray[24])")
  //       print("write_CNC_Zeile    write_byteArray38: \(teensy.write_byteArray[38])")
         
  //       if teensy.dev_present() > 0
  //       {
            let senderfolg = teensy.send_USB()
            print("write_CNC_Zeile senderfolg: \(senderfolg)")
 //        }
         //   cncstepperposition += 1
         
         
         
         
         
      }// if count
     // print("                                            write_CNC_Zeile END\n")
   }
   
   
   
   
   
   
   
   
   @objc override func usbstatusAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      // print("PCB usbstatusAktion:\t \(info)")
      let status:Int = info!["usbstatus"] as! Int // 
      print("PCB usbstatusAktion:\t \(status)")
      //     usbstatus = Int32(status)
      
   }
   
   @objc override func usbattachAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      // print("PCB usbattachAktion:\t \(info)")
      let status:Int = info!["attach"] as! Int // 
      print("PCB usbattachAktion:\t \(status)")
      if status == USBREMOVED
      {
         
         // USB_OK_Feld.image = notokimage
      }
      //usbstatus = Int32(status)
   }
   
   @objc  func klickpunktAktion(_ notification:Notification)
   {
      /*
      if (circlefloatarray.count < lasttabledataindex)
      {
         return
      }
      */
      let info = notification.userInfo
      print("PCB klickpunktAktion:\t \(String(describing: info))")
      let klickpunkt = info?["klickpunkt"] as! NSPoint
      let index = info?["index"] as! Int
      let dx = Double(klickpunkt.x)
      let dy = Double(klickpunkt.y)
      let lastX = circlefloatarray[lasttabledataindex][1]
      let lastY = circlefloatarray[lasttabledataindex][2]
      let aktX = klickpunkt.x
      let aktY = klickpunkt.y
      var klickzeile = [Double]()
      klickzeile.append(Double(index))
      klickzeile.append(dx)
      klickzeile.append(dy)
      datatabletask(zeile: index)
   }
   
   
   // MARK: ***       MAUSSTATUSAKTION  
   
   @objc  override func mausstatusAktion(_ notification:Notification)
   {
      let info = notification.userInfo
     print("PCB mausstatusAktion:\t \(String(describing: info))")
      //let usb_ok = teensy.dev_present()
      //print("PCB mausstatusAktion usb_ok: \(usb_ok)")
      
      let devtag = info?["devtag"] as! Int
      let mousedownindex = info?["mousedown"] as! Int
      if devtag == 1
      {
         let pfeiltag = info?["tag"] as! Int
         var mausschrittweite = info?["schrittweite"] as! Int
         var schrittweite = 0
         schrittweite = 50
         var dx:Int = 0
         var dy:Int = 0
         var dz:Int = 0
         var vorzeichenx = 0;
         var vorzeicheny = 0;
         var vorzeichenz = 0;
         var mausstatus:UInt8 = 0
         
         if (mousedownindex == 1)
         {
            print("mousedown")
            mausstatus |= (1<<1)
         }
         else
         {
            print("mouseup")
            mausstatus &= ~(1<<1)
         }

         print("PCB mausstatusAktion devtag:\t \(devtag ) pfeiltag:\t \(pfeiltag ) schrittweite: \(schrittweite) mousedownindex: \(mousedownindex)\t")
         
         switch pfeiltag
         {
         case 1: // right
            dx = schrittweite
            break
         case 2: // up
            dy = schrittweite
            break
         case 3: // left
            dx = schrittweite * (-1)
            vorzeichenx = 1
            break
         case 4: // down
            dy = schrittweite * (-1)
            vorzeicheny = 1
            break
            
         case 22: // Drill UP
            print("mausstatusAktion  Drill UP")
            dz = schrittweite 
            
            break   
         case 24: // Drill DOWN
            print("mausstatusAktion  Drill DOWN")
            dz = schrittweite * (-1)
            vorzeichenz = 1
            break   
         
             
         case 26: // Drill StepDOWN
            print("mausstatusAktion  Drill STEP UP")
            dz = drillwegFeld.integerValue
            vorzeichenz = 1
            mausstatus |= (1<<2)
            break   
         
         case 28: // Drill StepUP
            print("mausstatusAktion  Drill STEP DOWN")
            dz = drillwegFeld.integerValue * (-1)
            mausstatus |= (1<<2)
            break

            
         default:
            break
         }
        // let teensyok = teensy.dev_present()
         /*
         if teensy.dev_present() < 0
         {
            print("mausstatusAktion: Kein Teensy")
            return
         }
 */
         print("mausstatusAktion dx: \(dx) dy: \(dy) dz: \(dz)")
         var pfeilwegarray = [UInt8]()
         if (pfeiltag > 20) // Z-Achse
         {
            pfeilwegarray = wegArrayMitWegZ(wegz:Double(dz))
         }
         else
         {
            pfeilwegarray = wegArrayMitWegXY(wegx:Double(dx), wegy:Double(dy))
         }
         pfeilwegarray[25] = 2 // nur ein Abschnitt
         pfeilwegarray[32] = 1
         pfeilwegarray[24] = 0xDF
         pfeilwegarray[38] = UInt8(pfeiltag)
         /*
         if (mousedownindex == 1)
         {
            mausstatus |= (1<<1)
         }
         else
         {
            print("mouseup")
            mausstatus &= ~(1<<1)
         }
         */
         print("mausstatusAktion mausstatus: \(mausstatus)")
         pfeilwegarray[43] = mausstatus
         
         for z in 0 ... pfeilwegarray.count-1
         {
            teensy.write_byteArray[z] = pfeilwegarray[z]
            //print("\(z) \(pfeilwegarray[z])")
         }
         print("mausstatusAktion pfeilwegarray 37: \(teensy.write_byteArray[43]) code: \(phex(pfeilwegarray[24])) ")
         //        print("\(pfeilwegarray)")
         
         
         
         //       teensy.write_byteArray[24] = 0xB3
         
         
         //      homeX += Int(dx)
         //     homeY += Int(dy)
         // print("mausstatusaktion homeX: \(homeX) homeY: \(homeY)")
         //     homexFeld.integerValue = homeX
         //     homeyFeld.integerValue = homeY
         
         
         if teensy.readtimervalid() == true
         {
            //print("PCB readtimer valid vor")
            
         }
         else 
         {
            print("PCB mausstatusAktion readtimer not valid vor")
            
            var start_read_USB_erfolg = teensy.start_read_USB(true)
         }
        // if (mausstatus & (1<<1) > 0 )
        // {
            write_CNC_Zeile(zeilenarray: pfeilwegarray)   
        // }
         //         let senderfolg = teensy.send_USB()
      }
   }
   
   @objc func dataTableAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      let zeilenindex:Int = info?["selrow"] as! Int
      let task:Int = info?["task"] as! Int
      if (task == 1)
      {
        // stepperpositionFeld.integerValue = zeilenindex
         //Zeilen_Stepper.integerValue = zeilenindex
         return
      }
      let datazeile = circlefloatarray[zeilenindex]
      print("dataTableAktion zeilenindex: \(zeilenindex) datazeile: \(datazeile) lasttabledataindex: \(lasttabledataindex)")
      let lastX = circlefloatarray[lasttabledataindex][1]
      let lastY = circlefloatarray[lasttabledataindex][2]
      let aktX = datazeile[1]
      let aktY = datazeile[2]
      var maxsteps:Double = 0
      var zeilendic:[String:Any] = [:]
      var position:UInt8 = 0
      lasttabledataindex = zeilenindex
      //  print("dataTableAktion zoomfaktor: \(zoomfaktor)")
      let diffX:Double = (Double(aktX - lastX)) * zoomfaktor
      let diffY:Double = (Double(aktY - lastY)) * zoomfaktor
      
      
      let distanzX = Double(aktX - lastX)  * zoomfaktor  
      let distanzY = Double(aktY - lastY)  * zoomfaktor  
      
      let dx = (Double(aktX - lastX))/propfaktor
      let dy = (Double(aktY - lastY))/propfaktor
      
      
      var dataTableWeg = wegArrayMitWegXY(wegx:dx, wegy:dy)
      dataTableWeg[32] = DEVICE_MILL
      dataTableWeg[24] = 0xB5
      dataTableWeg[25] = 3 
      
      
      // print("dataTableAktion dataTableWeg: \(dataTableWeg)")
      if Schnittdatenarray.count > zeilenindex
      {
         //      print("dataTableAktion zeilenindex: \(zeilenindex)\n Schnittdatenarray : \(Schnittdatenarray[zeilenindex])")
      }
      
      
      write_CNC_Zeile(zeilenarray: dataTableWeg)  
      
      //Schnittdatenarray.append(dataTableWeg)
      
      /*
      if Schnittdatenarray.count > 0
      {
         print("dataTableAktion start CNC ")
         write_CNC_Abschnitt()   
         
         //teensy.start_read_USB(true)
      }
      */
   }
  // MARK: ***       datatabletask  
   func datatabletask(zeile:Int)
   {
      if (circlefloatarray.count < zeile)
      {
         return
      }
      //let selrowindex = 
      dataTable.selectRowIndexes(.init(integer: zeile), byExtendingSelection: false) 
 //     let datafloatzeile = circlearray[zeile]
      let datafloatzeile = circlefloatarray[zeile]
     print("datatabletask zeile: \(zeile)")
 
      //let lastdatafloatzeile = circlearray[lasttabledataindex]
      let lastdatafloatzeile = circlefloatarray[lasttabledataindex]
      //print("datatabletask lastzeile: \(lasttabledataindex)  lastdatafloatzeile: \(lastdatafloatzeile)")
      
      //print("datatabletask zielzeile: \(zeile)  datafloatzeile: \(datafloatzeile)")

      
      if zeile == lasttabledataindex
      {
         print("zeile = lasttabledataindex")
         return
      }

      let lastX = circlefloatarray[lasttabledataindex][1]
      let lastY = circlefloatarray[lasttabledataindex][2]


      let aktX = (datafloatzeile[1])
      let aktY = datafloatzeile[2]
      var maxsteps:Double = 0
      var zeilendic:[String:Any] = [:]
      var position:UInt8 = 0
      
      //  print("dataTableAktion zoomfaktor: \(zoomfaktor)")
//      let diffX:Double = (Double(aktX - lastX)) * zoomfaktor
 //     let diffY:Double = (Double(aktY - lastY)) * zoomfaktor
      
      
 //     let distanzX = Double(aktX - lastX)  * zoomfaktor  
 //     let distanzY = Double(aktY - lastY)  * zoomfaktor  
      
    //  let dx = (Double(aktX - lastX))/propfaktor
    //  let dy = (Double(aktY - lastY))/propfaktor

      let dx = (Double(aktX - lastX))
      let dy = (Double(aktY - lastY))

      
      tabledatastatus |= 1<<0
      tabledatastatus = 126
      
      
      print("datatabletask zeile: \(zeile) wegx: \(dx) wegy: \(dy)")

      var dataTableWeg = wegArrayMitWegXY(wegx:dx, wegy:dy)
      dataTableWeg[32] = DEVICE_MILL
      
      dataTableWeg[24] = 0xCA
      dataTableWeg[25] = 3 // lage
      dataTableWeg[26] = 0
      dataTableWeg[27] = 0
      dataTableWeg[36] = UInt8((zeile & 0xFF00)>>8)
      dataTableWeg[37] = UInt8(zeile & 0x00FF)
      dataTableWeg[38] = tabledatastatus
      
      lasttabledataindex = zeile
      
      print("dataTableAktion lasttabledataindex: \(lasttabledataindex)")
//      dataTable.selectRowIndexes(IndexSet(integer: lasttabledataindex), byExtendingSelection: false)
//      dataTable.scrollRowToVisible(lasttabledataindex)
      if Schnittdatenarray.count > zeile
      {
  //       print("datatabletask zeilenindex: \(zeile)\n Schnittdatenarray : \(Schnittdatenarray[zeile])")
      }
      // print("dataTableAktion cncstepperposition: \(cncstepperposition)")
      // cncstepperposition = Schnittdatenarray.count
      // Schnittdatenarray.append(dataTableWeg)
      
      // print("dataTableAktion zeile: \(zeile)\n Schnittdatenarray at zeile : \(Schnittdatenarray[zeile])")
      
      
      // if Schnittdatenarray.count > 0
      //  {
      print("datatabletask start CNC_Zeile ")
      write_CNC_Zeile(zeilenarray: dataTableWeg)   
      
      //teensy.start_read_USB(true)
      //  }
      
      
   }
   
   func drillMoveArray(wegz:Double) ->[UInt8] // z-Richtung +: up -: down. wegz in mm
   {
      zoomfaktor = zoomFeld.doubleValue
      print("PCB drillUpDown weg z: \(wegz) mm ")
      
      let wegZ = wegz * zoomfaktor 
      var speed = speedFeld.intValue
      
      if ramp_OK_Check.state == NSControl.StateValue.on
      {
         speed *= 2
      }
      
      let distanz = abs(wegZ)
      print("distanz: \(distanz)")
      
      var schrittez = Double(stepsFeld.integerValue) * distanz// * distanzZ 
//      schrittez /= propfaktor
      let schrittezRound = round(schrittez)
      var schrittezInt:Int = 0
      if schrittezRound >= Double(Int.min) && schrittezRound < Double(Int.max)
      {
         //    
         schrittezInt = Int(schrittezRound)
  //       print("schrittezInt OK: \(schrittezInt)")
         if wegz < 0 // negativer Weg
         {
            print("drill down")
//            print("schrittezInt negativ")
    //        schrittezInt *= -1
            schrittezInt |= 0x80000000
         }
         else
         {
            print("drill up")
         }
      }
      else
      {
         print("schritteZround zu gross")
      }
      //     motorstatus = (1<<MOTOR_C)
      
      let drillschnittdatenarray:[UInt8] = schrittdatenvektor(sxInt:0, syInt:0, szInt:schrittezInt, zeit:0  )// Array mit Daten fuer USB
      
//      print("drillschnittdatenarray: \(drillschnittdatenarray)")
      return drillschnittdatenarray
   }
   
   @IBAction func report_move_Drill(_ sender: NSButton) // Drill-Pfeiltasten up/down
   {
      print("\n+++++++     report_move_Drill tag: \(sender.tag)")
      var drillweg = 10
      let drilltag = sender.tag
      if drilltag == 222
      {
         drillweg *= -1
      }
      
      
      var drillWegArray = drillMoveArray(wegz: Double(drillweg))
      drillWegArray[24] = 0xB7
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 3
      drillWegArray[32] = DEVICE_MILL
      
      drillWegArray[35] = 0xA0; // drillstatus, kein rueckweg
  //    Schnittdatenarray.append(drillWegArray)
      // write_CNC_Zeile(zeilenarray: drillWegArray)
      
 //     if Schnittdatenarray.count > 0
 //     {
         print("dataTableAktion start CNC_Zeile")
         //write_CNC_Abschnitt()   
         
         if teensy.readtimervalid() == true
         {
            //print("PCB readtimer valid vor")
         }
         else 
         {
            print("PCB report_move_Drill readtimer not valid vor")
            var start_read_USB_erfolg = teensy.start_read_USB(true)
         }
      write_CNC_Zeile(zeilenarray: drillWegArray)
      //}
      
   }
   
   
    @IBAction func report_Zeilen_Stepper(_ sender: NSStepper)
    {
      print("Zeilen_Stepper: \(sender.integerValue)")
      stepperpositionFeld.integerValue = sender.integerValue
   }
   
   
   
   @IBAction func report_goto_Zeile(_ sender: NSButton)
   {
      print("\n+++++++     report_goto_Zeile tag: \(sender.tag) ")
      
      let zielzeile = stepperpositionFeld.integerValue
      
      print("zielzeile: \(zielzeile)  lasttabledataindex: \(lasttabledataindex)")
      
      print("zielzeile in circlefloatarray: \(circlefloatarray[zielzeile])")
      
      print("quellzeile in circlefloatarray: \(circlefloatarray[lasttabledataindex])")
  
      print("zielzeile in CNC_DatendicArray: \(CNC_DatendicArray[zielzeile])")
      print("quellzeile in CNC_DatendicArray: \(CNC_DatendicArray[lasttabledataindex])")
 
      
      let wegx = circlefloatarray[zielzeile][1] - circlefloatarray[lasttabledataindex][1]
      let wegy = circlefloatarray[zielzeile][2] - circlefloatarray[lasttabledataindex][2]

      
      if circlefloatarray.count > zielzeile
      {
         if zielzeile == lasttabledataindex
         {
            print("schon da")
         }
         else 
         {
            var dataTableWeg = wegArrayMitWegXY(wegx:wegx, wegy:wegy)
            dataTableWeg[32] = DEVICE_MILL
            
            dataTableWeg[24] = 0xCA
            dataTableWeg[25] = 3 // lage
            dataTableWeg[26] = 0
            dataTableWeg[27] = 0
            dataTableWeg[36] = UInt8((zielzeile & 0xFF00)>>8)
            dataTableWeg[37] = UInt8(zielzeile & 0x00FF)

            print("datatabletask start CNC ")
            write_CNC_Zeile(zeilenarray: dataTableWeg)   

            //datatabletask(zeile:zielzeile)
            
            lasttabledataindex = zielzeile
            
         }
      }
      else 
      {
         print("keine Daten: circlearray count: \(circlearray.count)")
      }
      return
   }
   @IBAction func report_Drillmotor(_ sender: NSButton)
   {
      print("report_Drillmotor")
      let state = sender.state
      let sliderspeed = Motor_Slider.integerValue
      let int8pos = UInt8(Motor_Slider.intValue)
      // aus report_Motor_Slider
      teensy.write_byteArray[24] = 0xDA // Code 
  //    teensy.write_byteArray[DRILLSPEEDH_BIT] = UInt8((sliderspeed & 0xFF00)>>8)
  //    teensy.write_byteArray[DRILLSPEEDL_BIT] = UInt8(sliderspeed & 0x00FF)

      if state == .on
      {
         teensy.write_byteArray[DRILL_BIT] = int8pos
      }
      else
      {
         teensy.write_byteArray[DRILL_BIT] = 0
         
      }
      let senderfolg = teensy.send_USB()
      
      
   }

   func Drillmotor_stop()
   {
      print("Drillmotor_stop")
      //return;
      teensy.write_byteArray[24] = 0xDA // Code 
      teensy.write_byteArray[DRILL_BIT] = 0
         let senderfolg = teensy.send_USB()
         print("report_HALT senderfolg: \(senderfolg)")
      MotorKnopf.state = NSControl.StateValue.off
      
   }

   @IBAction func report_DrillspeedSlider(_ sender: NSSlider)
   {
      print("report_DrillspeedSlider Val: \(sender.integerValue) ")
      let sliderspeed = 0xFF - sender.integerValue
      drillspeedFeld.integerValue = sender.integerValue
      
      teensy.write_byteArray[24] = 0xB9
      teensy.write_byteArray[DRILLSPEEDH_BIT] = UInt8((sliderspeed & 0xFF00)>>8)
      teensy.write_byteArray[DRILLSPEEDL_BIT] = UInt8(sliderspeed & 0x00FF)
      let int8pos = UInt8(Motor_Slider.intValue)
      teensy.write_byteArray[DRILL_BIT] = int8pos
 //     if (usbstatus > 0)
 //     {
         let senderfolg = teensy.send_USB()
         print("report_DrillspeedSlider senderfolg: \(senderfolg)")
 //     }
   }
   
   @IBAction func report_Drill(_ sender: NSButton)
   {
      print("\n+++++++     report_Drill tag: \(sender.tag) ")
      let tempweg:Int = drillwegFeld.integerValue
      drilltask(weg:-tempweg,status:1)
   }
   
   @IBAction func report_Drill_up(_ sender: NSButton)
   {
      print("\n+++++++     report_Drill_up tag: \(sender.tag) ")
      
      drill_up()
      return
      var drillWegArray = drillMoveArray(wegz: Double(drillwegFeld.integerValue))
      drillWegArray[24] = 0xB7
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = 0 // drillstatus beginn

      write_CNC_Zeile(zeilenarray: drillWegArray)
   }
 
   @IBAction func report_Drill_Abs_up(_ sender: NSButton)
   {
      print("\n+++++++     report_Drill_Abs_up tag: \(sender.tag) ")
      
      var drillWegArray = drillMoveArray(wegz: Double(drillwegFeld.integerValue))
      drillWegArray[24] = 0xBC
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = 0 // drillstatus beginn

      write_CNC_Zeile(zeilenarray: drillWegArray)
   }

   @objc func drill_up()
   {
      print("\n+++++++     drill_up  ")
      var drillwegmod = Double(drillwegFeld.integerValue)
      
      // microstep einrechnen
      let microstepindex = schritteweitepop.indexOfSelectedItem
      let microstep = Double(schritteweitepop.itemTitle(at: microstepindex))
      print("microstep: \(microstep)")
      drillwegmod *= microstep ?? 1
      var drillWegArray = drillMoveArray(wegz: drillwegmod)
      drillWegArray[24] = 0xB7
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = 0 // drillstatus beginn
      drillWegArray[25] = 3
      //print("drill_up drillWegArray: \(drillWegArray)")
      write_CNC_Zeile(zeilenarray: drillWegArray)
   }

   @objc func drill_down()
   {
      print("\n+++++++     drill_down  ")
      var drillwegmod = Double(drillwegFeld.integerValue) * -1
      // microstep einrechnen
      let microstepindex = schritteweitepop.indexOfSelectedItem
      let microstep = Double(schritteweitepop.itemTitle(at: microstepindex))
      print("microstep: \(microstep)")
      drillwegmod *= microstep ?? 1
      var drillWegArray = drillMoveArray(wegz: drillwegmod)
      
      drillWegArray[24] = 0xB7
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = 0 // drillstatus beginn
      drillWegArray[25] = 3
      write_CNC_Zeile(zeilenarray: drillWegArray)
   }
   
   
   @IBAction func report_Drill_Abs_down(_ sender: NSButton)
   {
      print("\n+++++++     report_Drill_Abs_down tag: \(sender.tag) ")
      
      var drillWegArray = drillMoveArray(wegz: Double((drillwegFeld.integerValue) * -1))
      drillWegArray[24] = 0xBC
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = 0 // drillstatus beginn

      write_CNC_Zeile(zeilenarray: drillWegArray)
   }


   @IBAction func report_Drill_down(_ sender: NSButton)
   {
      print("\n+++++++     report_Drill_down tag: \(sender.tag) ")
    
      drill_down()
     }
   
   @IBAction func report_dicke(_ sender: NSButton)
   {
      print("report_dicke")
      var weg = dickeFeld.doubleValue 
     // var drillWegArray = drillMoveArray(wegz: (Double(dickeFeld.integerValue)) * -1)
      // microstep einrechnen
      let microstepindex = schritteweitepop.indexOfSelectedItem
      let microstep = Double(schritteweitepop.itemTitle(at: microstepindex))
      print("microstep: \(microstep)")
      weg *= microstep ?? 1

      var drillWegArray = drillMoveArray(wegz: (weg * -1))
      drillWegArray[24] = 0xB7
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = 0 // drillstatus beginn

      write_CNC_Zeile(zeilenarray: drillWegArray)

   }


   
   @objc func drilltask(weg:Int, status:UInt8)
   {
      print("\n+++++++     drill weg: \(weg)")
      let count = Schnittdatenarray.count
      print("drill Schnittdatenarray.count: \(count)");
      //let stepperpos = stepperpositionFeld.integerValue
      //print("drill stepperpos: \(stepperpos)");
      var tempdrillweg = weg
      // microstep einrechnen
      let microstepindex = schritteweitepop.indexOfSelectedItem
      let microstep = Double(schritteweitepop.itemTitle(at: microstepindex))
      print("microstep: \(microstep)")
      tempdrillweg *= Int(microstep ?? 1)

      
      var drillWegArray = drillMoveArray(wegz: Double(tempdrillweg))
      drillWegArray[24] = 0xBA
      drillWegArray[26] = 0
      drillWegArray[27] = 0
      drillWegArray[29] = 99 // PWM
      drillWegArray[25] = 2 // lage
      drillWegArray[32] = DEVICE_MILL
      drillWegArray[35] = status // drillstatus beginn
      drillWegArray[38] = 24 // pfeiltag down
      /*
      print("\n*********************************************************")
      print("report_Drill cncstepperposition: \(cncstepperposition)");
      print(" Schnittdatenarray vor insert count:\(Schnittdatenarray.count)")
      for line in Schnittdatenarray
      {
         print(line)
      }
      print("*********************************************************")
      Schnittdatenarray.insert(drillWegArray, at: cncstepperposition) 
      print("\n*********************************************************")
      print(" Schnittdatenarray nach insert: ")
      for line in Schnittdatenarray
      {
         print(line)
      }
      print("*********************************************************\n")
*/
      for line in Schnittdatenarray
      {
         print(line)
      }

      if teensy.readtimervalid() == true
      {
         //print("PCB readtimer valid vor")
      }
      else 
      {
         print("PCB readtimer not valid bevor")
         var start_read_USB_erfolg = teensy.start_read_USB(true)
      }
      /*
      if Schnittdatenarray.count > 0
      {
         print("report_Drill write CNC")
        // write_CNC_Abschnitt() 
         
         print("report_Drill cncstepperposition nach: \(cncstepperposition)");
         
      }
      */
      write_CNC_Zeile(zeilenarray: drillWegArray)
      
      
   }

   // MARK: joystickaktion
   @objc override func joystickAktion(_ notification:Notification) 
   {
      //    print("PCB joystickAktion usbstatus:\t \(usbstatus) selectedDevice: \(selectedDevice) ident: \(self.view.identifier)")
      let sel = NSUserInterfaceItemIdentifier.init(selectedDevice)
      // if (selectedDevice == self.view.identifier)
      if (sel == self.view.identifier)
      {
         print("PCB joystickAktion passt")
         
         let info = notification.userInfo
         let punkt:CGPoint = info?["punkt"] as! CGPoint
         let wegindex:Int = info?["index"] as! Int // 
         let first:Int = info?["first"] as! Int
         //       print("Basis joystickAktion:\t \(punkt)")
         print("x: \(punkt.x) y: \(punkt.y) index: \(wegindex) first: \(first)")
         
         
         teensy.write_byteArray[0] = SET_ROB // Code 
         
         // Horizontal Pot0
         let w = Double(Joystickfeld.bounds.size.width) // Breite Joystickfeld
         let faktorw:Double = (Pot0_Slider.maxValue - Pot0_Slider.minValue) / w
         //      print("w: \(w) faktorw: \(faktorw)")
         var x = Double(punkt.x)
         if (x > w)
         {
            x = w
         }
         goto_x.integerValue = Int(Double(x*faktorw))
         joystick_x.integerValue = Int(Double(x*faktorw))
         goto_x_Stepper.integerValue = Int(Double(x*faktorw))
         let weg0 = UInt16(Double(x*faktorw) * FAKTOR0)
         //print("x: \(x) weg0: \(weg0)")
         teensy.write_byteArray[SCHRITTEX_A] = UInt8((weg0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[SCHRITTEX_B] = UInt8((weg0 & 0x00FF) & 0xFF) // lb
         
         
         let h = Double(Joystickfeld.bounds.size.height)
         let faktorh:Double = (Pot1_Slider.maxValue - Pot1_Slider.minValue) / h
         
         let faktorz = 1
         //     print("h: \(h) faktorh: \(faktorh)")
         var y = Double(punkt.y)
         if (y > h)
         {
            y = h
         }
         let z = 0
         goto_y.integerValue = Int(Double(y*faktorh))
         joystick_y.integerValue = Int(Double(y*faktorh))
         goto_y_Stepper.integerValue = Int(Double(y*faktorh))
         let weg1 = UInt16(Double(y*faktorh) * FAKTOR1)
         //print("y: \(y) weg1: \(weg1)")
         teensy.write_byteArray[DELAYX_A] = UInt8((weg1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[DELAYX_B] = UInt8((weg1 & 0x00FF) & 0xFF) // lb
         let achse2 =  UInt16(Double(z*faktorz) * FAKTOR2)
         teensy.write_byteArray[SCHRITTEY_A] = UInt8((achse2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[SCHRITTEY_B] = UInt8((achse2 & 0x00FF) & 0xFF) // lb
         
         
         let message:String = info?["message"] as! String
         if ((message == "mousedown") && (first >= 0))// Polynom ohne mousedragged
         {
            teensy.write_byteArray[0] = SET_RING
            let anz = schnittPfad?.anzahlPunkte()
            if (wegindex > 1)
            {
               print("")
               print("basis joystickAktion cont weg0: \(weg0) weg1: \(weg1)  achse2: \(achse2) anz: \(String(describing: anz)) wegindex: \(wegindex)")
               
               let lastposition = schnittPfad?.pfadarray.last
               
               let lastx:Int = Int(lastposition!.x)
               let nextx:Int = Int(weg0)
               let hypx:Int = (nextx - lastx) * (nextx - lastx)
               
               let lasty:Int = Int(lastposition!.y)
               let nexty:Int = Int(weg1)
               let hypy:Int = (nexty - lasty) * (nexty - lasty)
               
               let lastz:Int = Int(lastposition!.z)
               let nextz:Int = Int(achse2)
               let hypz:Int = (nextz - lastz) * (nextz - lastz)
               
               print("joystickAktion lastx: \(lastx) nextx: \(nextx) lasty: \(lasty) nexty: \(nexty)")
               
               let hyp:Double = (sqrt((Double(hypx + hypy + hypz))))
               
               let anzahlsteps = hyp/schrittweiteFeld.doubleValue
               print("Basis joystickAktion hyp: \(hyp) anzahlsteps: \(anzahlsteps) ")
               
               teensy.write_byteArray[schrittezA] = UInt8((Int(hyp) & 0xFF00) >> 8) // hb
               teensy.write_byteArray[schrittezB] = UInt8((Int(hyp) & 0x00FF) & 0xFF) // lb
               
               teensy.write_byteArray[delayzC] = UInt8((Int(anzahlsteps) & 0xFF00) >> 8) // hb
               teensy.write_byteArray[delayzD] = UInt8((Int(anzahlsteps) & 0x00FF) & 0xFF) // lb
               
               teensy.write_byteArray[delayzA] = UInt8(((wegindex-1) & 0xFF00) >> 8) // hb // hb // Start, Index 0
               teensy.write_byteArray[delayzB] = UInt8(((wegindex-1) & 0x00FF) & 0xFF) // lb
               
               print("Basis joystickAktion hypx: \(hypx) hypy: \(hypy) hypz: \(hypz) hyp: \(hyp)")
               
            }
            else
            {
               print("basis joystickAktion start weg0: \(weg0) weg1: \(weg1)  achse2: \(achse2) anz: \(anz) wegindex: \(wegindex)")
               teensy.write_byteArray[schrittezA] = 0 // hb // Start, keine Hypo
               teensy.write_byteArray[schrittezB] = 0 // lb
               teensy.write_byteArray[delayzA] = 0 // hb // Start, Index 0
               teensy.write_byteArray[delayzB] = 0 // lb
               
            }
            
            schnittPfad?.addPosition(newx: weg0, newy: weg1, newz: 0)
         }
         
         if (usbstatus > 0)
         {
            let senderfolg = teensy.send_USB()
            print("joystickAktion senderfolg: \(senderfolg)")
         }
      }
      else
      {
         //       print("PCB joystickAktion passt nicht")
      }
      
   }
   
   // MARK: NEWDATAAKTION 
   @objc override func newDataAktion(_ notification:Notification) 
   {
      // analog readUSB() in USB_Stepper
      
      
      
      //print("                       newDataAktion  start\n")
      //    let lastData = teensy.getlastDataRead()
      
      // print("lastData:\t \(lastData[1])\t\(lastData[2])   ")
      var ii = 0
      while ii < 10
      {
         //       print("\(lastData[ii])\t")
         ii = ii+1
      }
      
      //let u = ((Int32(lastData[1])<<8) + Int32(lastData[2]))
      //print("hb: \(lastData[1]) lb: \(lastData[2]) u: \(u)")
      
      // let info = notification.userInfo
      
      //print("info: \(String(describing: info))")
      //print("new Data")
      
      var data1 = notification.userInfo?["data"] 
      var data:[UInt8] = notification.userInfo?["data"] as! [UInt8] // teensy.read_byteArray
      //      print("von teensy: data: \(String(describing: data)) ") // data: Optional([0, 9, 51, 0,....
      var i = 0
      
      let taskcode = data[0]
      let codehex = String(format:"%02X", taskcode)
      
      //print("newDataAktion taskcode: \(taskcode) hex: \(codehex)")
      
      if taskcode == 0
      {
         print("newDataAktion taskcode: NULL")
         return
      }
      var notificationDic = [String:Any]()
      
      
      let abschnittnummer:Int = Int((data[5] << 8) | data[6])
      let ladeposition = data[8]
      
      //     Plattefeld.setStepperposition(pos:abschnittnummer)
      //print("PCB newDataAktion  taskcode: \(taskcode)") 
      //print("PCB newDataAktion  taskcode: \(taskcode) hex: \(codehex) abschnittnummer: \(abschnittnummer) ladeposition: \(ladeposition)")
      let timeintervall =  Int((data[14] << 8) | data[15])
      
      var AnschlagSet:IndexSet = IndexSet()
      let nc = NotificationCenter.default
      var device = data[24]
      //      print("PCB newDataAktion  device: \(device)")
      // MARK: *** DEVICE_MILL       
      if device == DEVICE_MILL
      {
         //print("DEVICE_MILL")
         let ladepos =  Int(data[8])
         let abschnittnum = Int((data[5] << 8) | data[6])
         let sendstatus = UInt8(data[9])
         
         
         switch taskcode
         {
            // MARK: ***     A1
         case 0xA1:
            print("********* *********  *********  PCB newDataAktion  A1 abschnitte: \(Schnittdatenarray.count)") // mehrere Schritte
            
            //let ladepos =  Int(data[8])
            Plattefeld.setStepperposition(pos:ladepos)
            //let abschnittnum = Int((data[5] << 8) | data[6])
            //let sendstatus = Int(data[9])
            print("A1 \t ladeposition: \(ladeposition) abschnittnum: \(abschnittnum) sendstatus: \(sendstatus) hex: \(phex(sendstatus))")
            //Plattefeld.setStepperposition(pos:ladepos)
            let drillstatus = data[22]
            print("A1 \t drillstatus: \(drillstatus)")
            
            let state = steppercontKnopf.state
            
            if state == .off
            {
               print("PCB newDataAktion  A1 return");
               
               return
            }
            if teensy.readtimervalid() == true
            {
               //print("PCB newDataAktion readtimer valid vor")
            }
            else 
            {
               print("PCB newDataAktion readtimer not valid vor")
               var start_read_USB_erfolg = teensy.start_read_USB(true)
            }
            
            break
            
         case 0xA2:
            print("********* *********  *********  PCB newDataAktion  A2 ") //
            
            break;
            
            // MARK: ***     AD
         case 0xAD: // End Task
            print("\n********* *********  *********  PCB newDataAktion  AD TASK END ")
            //let ladepos =  Int(data[8])
            let abschnittnum = Int((data[5] << 8) | data[6])
            var anzeigezeile:Int = 0
            if Schnittdatenarray.count > 0 && abschnittnummer > 1
            {
               let aH = UInt16(Schnittdatenarray[abschnittnummer - 1][39])
               let aL =  UInt16(Schnittdatenarray[abschnittnummer - 1][40])
               anzeigezeile = Int(((aH << 8) | (aL )))
            }
            
            //   ***
            print("AD \t ladeposition: \(ladeposition) abschnittnum: \(abschnittnum)  sendstatus: \(sendstatus) anzeigezeile: \(anzeigezeile)")
            print("newDataAktion  AD tabledatastatus 23: \(data[23]) data (13): \(data[13]) lasttabledataindex: \(lasttabledataindex) ")
            
            let ZEILENSTATUS:UInt8 = 0
            if (data[23] < 0xFF) && ((data[23] & (1<<ZEILENSTATUS)) > 0 )
            {
               print("A newDataAktion  AD lasttabledataindex: \(lasttabledataindex)")
               Plattefeld.setStepperposition(pos:lasttabledataindex)
               break
            }
            
            if data[23] == 13
            {
               print("B newDataAktion  AD code 23 ist 13: \(data[23])  ")
               Plattefeld.setStepperposition(pos:lasttabledataindex)
            }
            
            let drillstatus = (data[22])
            print("newDataAktion  AD drillstatus: \(phex(drillstatus))")
            
            if drillstatus >= 0xA0 
            // Drillstatus wird in abschnittnummer==endposition von Motor C incrementiert, wenn abgelaufen. Signalisiert Rueckweg bei report_Drill A0 > A1
            {
               print("newDataAktion  AD code 22 ist >= A0: \(data[22]) \(phex(drillstatus))")
               //        break
            }
            
            print("newDataAktion  AD ladepos: \(ladepos)")
            
            // 220120 letzten Punkt fuellen
            Plattefeld.setStepperposition(pos:ladepos)
            
            print("newDataAktion  AD abschnittnummer: \(abschnittnum) ladepos: \(ladepos)")
            if(abschnittnum > 0)
            {
               Drillmotor_stop()
            }
            
            
            notificationDic["taskcode"] = taskcode
            
            nc.post(name:Notification.Name(rawValue:"usbread"),
                    object: nil,
                    userInfo: notificationDic)        
            break
            
         case 0xAF:
            
            print("newDataAktion  AF next ")
            //        let abschnittnum = Int((data[5] << 8) | data[6])
            //        let ladepos =  Int(data[8] )
            //        print("newDataAktion  AF abschnittnum: \(abschnittnum) ladepos: \(ladepos)")
            
            break
            
            
            // MARK: ***     B6  
         case 0xB6:
            //print("newDataAktion  B6 Abschnitt 0 abschnitte: \(Schnittdatenarray.count)")
            usbzeit = CFAbsoluteTimeGetCurrent() - usbtime
            tasktime = CFAbsoluteTimeGetCurrent() 
            //print("newDataAktion B6 usbzeit: \(pd3(usbzeit))")
            // Data angekommen
            /*
             let state = steppercontKnopf.state
             if state == .off
             {
             
             print("PCB newDataAktion  B6 return");
             //             return;
             }
             */
            
            return
            break
            
         case 0xB9:
            print("newDataAktion  B9 ")
            // Data angekommen
            /*
             let state = steppercontKnopf.state
             if state == .off
             {
             
             print("PCB newDataAktion  B6 return");
             //             return;
             }
             */
            
            
            break
            
            
            // MARK: ***     BB  
         case 0xBB: // Drill zurueck
            // Motor C abgelaufen, abschnittnummer = endposition
            print("newDataAktion  BB Drill zurueck \n")
            
            //let stepperpos = stepperpositionFeld.integerValue 
            //let datacount = Schnittdatenarray.count
            //    print("newDataAktion  BB stepperpos: \(stepperpos) datacount: \(datacount)")
            
            let drillstatus:UInt8 = data[22]
            print("newDataAktion  BB drillstatus: \(drillstatus)")
            if drillstatus > 1 // kein rueckweg
            {
               print("newDataAktion  BB drillstatus > 1 break")
               //break
            }
            // Rueckweg schicken
            drilltask(weg:drillwegFeld.integerValue, status:2)
            
            break
            var drillweg = 25
            var drillWegArray = drillMoveArray(wegz: Double(drillweg))
            drillWegArray[24] = 0xBA
            
            drillWegArray[29] = 0 // PWM
            drillWegArray[25] = 2  // lage , nur 1 Abschnitt
            drillWegArray[32] = DEVICE_MILL
            
            // 200825
            drillWegArray[35] = drillstatus
            drillWegArray[38] = 22 // pfeiltg up
            print("\n*********************************************************")
            print("BB cncstepperposition: \(cncstepperposition)");
            /*
             print(" Schnittdatenarray vor insert count:\(Schnittdatenarray.count)")
             for line in Schnittdatenarray
             {
             print(line)
             }
             print("*********************************************************")
             
             //       Schnittdatenarray.insert(drillWegArray, at: datacount)  
             print("\n*********************************************************")
             
             */ 
            print(" drillWegArray: \(drillWegArray)\n")
            print("***\n")
            
            // verzoegert abschicken
            // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
            let seconds = 0.4
            //          DispatchQueue.main.asyncAfter(deadline: .now() + seconds) 
            //         {
            // Put your code which should be executed with a delay here
            
            //print(" Schnittdatenarray nach insert: \(Schnittdatenarray)")
            self.write_CNC_Zeile(zeilenarray: drillWegArray)
            //         }
            if self.teensy.readtimervalid() == true
            {
               //print("PCB readtimer valid vor")
            }
            else 
            {
               print("PCB readtimer not valid bevor")
               self.teensy.start_read_USB(true)
            }
            
            break
            // MARK: ***     D1        
         case 0xD1:
            print("                      newDataAktion  D1 Response ")
            //print("\t usb: \t task: ")
            
            return
            break
            
            
            // MARK: ***     Pfeiltaste DC    
         case 0xDC:  // Pfeiltaste
            print("\n                      newDataAktion  DC Drill ")
            //let stepperpos = stepperpositionFeld.integerValue 
            let datacount = Schnittdatenarray.count
            //print("newDataAktion  DC stepperpos: \(stepperpos) datacount: \(datacount)")
            
            var abschnittnummer = data[5]<<8 + data[6]
            print("newDataAktion  DC abschnittnummer A: \(abschnittnummer) cncstepperposition: \(cncstepperposition)")
            abschnittnummer = data[5]<<8 | data[6]
            print("newDataAktion  DC abschnittnummer B: \(abschnittnummer)")
            
            let drillstatus:UInt8 = data[22]
            print("newDataAktion  DC drillstatus: \(drillstatus)")
            if drillstatus > 1 // 
            {
               print("                 newDataAktion  DC out \n")
               //break
               //cncstepperposition += 2
               return
            }
            
            var drillweg = -100
            var drillWegArray = drillMoveArray(wegz: Double(drillweg))
            drillWegArray[24] = 0xBA
            
            drillWegArray[29] = 99 // PWM
            drillWegArray[25] = 3 // lage
            drillWegArray[26] = 0 // index H
            drillWegArray[27] = 1
            drillWegArray[32] = DEVICE_MILL
            
            // 200825
            drillWegArray[35] = drillstatus
            print("\n*********************************************************")
            print("BC cncstepperposition: \(cncstepperposition)");
            print("BC Schnittdatenarray vor insert count:\(Schnittdatenarray.count)")
            for line in Schnittdatenarray
            {
               print(line)
            }
            print("*********************************************************")
            
            Schnittdatenarray.insert(drillWegArray, at: datacount)  
            print("\n*********************************************************")
            print("BC Schnittdatenarray nach insert: ")
            for line in Schnittdatenarray
            {
               print(line)
            }
            print("*********************************************************\n")
            
            //print(" Schnittdatenarray nach insert: \(Schnittdatenarray)")
            if teensy.readtimervalid() == true
            {
               print("PCB newDataAktion valid vor")
            }
            else 
            {
               print("PCB newDataAktion not valid vor")
               var start_read_USB_erfolg = teensy.start_read_USB(true)
            }
            
            /*
             print(" Schnittdatenarray vor insert: \(Schnittdatenarray)")
             Schnittdatenarray.insert(drillWegArray, at: datacount)  
             print(" Schnittdatenarray nach insert: \(Schnittdatenarray)")
             if teensy.readtimervalid() == true
             {
             //print("PCB readtimer valid vor")
             }
             else 
             {
             var start_read_USB_erfolg = teensy.start_read_USB(true)
             }
             */
            break
            
         case 0xBD: // teensystep
            print("newDataAktion  BD teensystep")
            return;
            
            break
            
            
         case 0xCB: 
            
            let x = 0
            print("newDataAktion  CB Antwort tabledataaktion")
            
            break;
            
         case 0xE1:
            print("newDataAktion  E1 mouseup HALT")
            Schnittdatenarray.removeAll()
            if teensy.readtimervalid() == true
            {
               teensy.readtimer?.invalidate()
            }
            cncstepperposition = 0
            
            clear()
            break
            
         case 0xEA:
            print("newDataAktion  home gemeldet")
            break
         case 0xD0: // not
            print("newDataAktion D0 letzter Abschnitt abschnittnummer: \(abschnittnummer)")
            Plattefeld.setStepperposition(pos:abschnittnummer)
            let ladepos =  Int(data[8] )
            notificationDic["taskcode"] = taskcode
            nc.post(name:Notification.Name(rawValue:"usbread"),
                    object: nil,
                    userInfo: notificationDic)
            break
            
            // MARK: ***     ***   D6        
         case 0xD6:
            //print("D6")
            if (Schnittdatenarray.count == 0)
            {
               break
            }
            taskzeit = CFAbsoluteTimeGetCurrent() - tasktime
            nextdatatime = CFAbsoluteTimeGetCurrent()
            
            // Rueckmeldung von motorfinished
            let d5 = UInt16(data[5])
            let d6 =  UInt16(data[6])
            
            var abschnittnummer:Int = Int(((d5 << 8) | (d6 )))
            let ladepos =  Int(data[8] )
            //print("newDataAktion  D6 abschnittnummer: \(abschnittnummer) cncstepperposition: \(cncstepperposition) ladepos: \(ladepos)")
            //print("\(abschnittnummer)\t\(pd4(responsezeit))\t \(pd3(usbzeit)) \t\(pd3(taskzeit))")
            //print("\(abschnittnummer)\t\(pd3(usbzeit)) \t\(pd3(taskzeit)) ")
            //print("\(abschnittnummer)")
            if (abschnittnummer < Schnittdatenarray.count)
            {
               //print("D6 abschnittnummer \(abschnittnummer) data: \(Schnittdatenarray[abschnittnummer][39]) \(Schnittdatenarray[abschnittnummer][40]) \(Schnittdatenarray[abschnittnummer][41]) \(Schnittdatenarray[abschnittnummer][42])")
               let aH = UInt16(Schnittdatenarray[abschnittnummer][39])
               let aL =  UInt16(Schnittdatenarray[abschnittnummer][40])
               var anzeigezeile:Int = Int(((aH << 8) | (aL )))
               
               let dH = UInt16(Schnittdatenarray[abschnittnummer][41])
               let dL = UInt16(Schnittdatenarray[abschnittnummer][42])
               let drillzeile:Int = Int(((dH << 8) | (dL )))
               
               //print("anzeigezeile: \(anzeigezeile) drillzeile: \(drillzeile)")
               if (drillzeile < 0xFF)
               {
                  //print("D6 drill mark")
                  Plattefeld.setStepperposition(pos:Int(anzeigezeile + 1))
                  stepperschritteFeld.integerValue = Int(anzeigezeile)
               }
               else if (drillzeile == 0xFF01)
               {
                  //print("D6 ohne drill mark")
                  Plattefeld.setStepperposition(pos:Int(anzeigezeile ))
                  stepperschritteFeld.integerValue = Int(anzeigezeile)
                  
               }
               
            }
            else // last anzeigezeile
            {
               
               let aH = UInt16(Schnittdatenarray[abschnittnummer-1][39])
               let aL =  UInt16(Schnittdatenarray[abschnittnummer-1][40])
               var anzeigezeile:Int = Int(((aH << 8) | (aL )))
               print("*** setStepperposition last anzeigezeile: \(anzeigezeile)")
               Plattefeld.setStepperposition(pos:Int(anzeigezeile + 1))
            }
            //        Plattefeld.setStepperposition(pos:Int(abschnittnummer))
            
            
            /*
             if cncstepperposition < Schnittdatenarray.count
             {
             write_CNC_Abschnitt()
             }
             */
            break
            
            
         case 0xC5:
            let motor = data[1]
            let anschlagstatus = data[12]
            let richtung = data[13]
            let cncstatus = data[20]
            let anschlagcode = data[14]
            print("newDataAktion  C5 Anschlag")
            print("  motor: \(motor)  \nanschlagstatus: \(anschlagstatus)  \nrichtung: \(richtung) \ncncstatus: \(cncstatus) \nanschlagcode: \(anschlagcode)")
            break
            
            
            // MARK: ***     default        
         default:
            let zeit = now.timeAgoDisplay()
            print("newDataAktion default abschnittnummer: \(abschnittnummer) zeir: \(zeit)")
            //Plattefeld.setStepperposition(pos:abschnittnummer)
            break
         }// switch taskcode
         
         
         //print("switch taskcode end taskcode: \(taskcode)")
         // **************************************
         let state = steppercontKnopf.state
         
         // print("newDataAktion writecncabschnitt steppercontKnopf state: \(state)")
         if (taskcode == 0xAD ) ||  (taskcode == 0xBB ) // Drill
         {
            
            return
         }
         //state = .on
         if state == .on
         {
            // https://tech.julienkarst.com/How-to-display-time-ago-from-a-date-in-Swift-(This-is-how-to-get-the-difference-between-two-dates-in-a-string)
            //var zeit = now.timeAgoDisplay()
            
            //print("newDataAktion zeit: \(zeit)")
            
            var zeitint =  startzeit.seconds(from:startzeit)
            //print("newDataAktion zeitint: \(zeitint)")
            
            //https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
            //let formatter = DateComponentsFormatter()
            // formatter.allowedUnits = [.hour, .minute, .second]
            // zeitformatter.allowedUnits = [ .minute, .second]
            // zeitformatter.unitsStyle = .positional
            // zeitformatter.zeroFormattingBehavior = [ .pad ]
            
            let ablaufzeitString = zeitformatter.string(from: TimeInterval(zeitint))!
            //print(ablaufzeitString)
            
            ablaufzeitFeld.stringValue = ablaufzeitString
            //print("newDataAktion writecncabschnitt go cncstepperposition: \(cncstepperposition) Schnittdatenarray.count: \(Schnittdatenarray.count)")
            if cncstepperposition < Schnittdatenarray.count
            { 
               if (((cncstatus & (1<<PAUSE)) != 0) && (Schnittdatenarray[cncstepperposition][41] == 255))
               {
                  return
               }
               //print("cncstepperposition < Schnittdatenarray.count: newDataAktion taskcode: \(taskcode)")
               self.write_CNC_Abschnitt()
               /*
                let seconds = 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) 
                {
                self.write_CNC_Abschnitt()
                }
                */
            }
         }
         
         // **************************************
         
         
      } // if DEVICE
      //print("                       newDataAktion  end\n")
   } // newDataAktion
   
   // MARK: ***      report_horizontalCheckbox  
   @IBAction  func report_horizontalCheckbox(_ sender: NSButton)
   {
      
      //print("report_horizontalCheckbox IntVal: \(sender.intValue)")
      var sortedarray = [[String:Double]]()
      var sortedfloatarray = [[Double]]()
      /*
      print("report_horizontal_checkbo vor sort circlefloatdicarray")
      var iii = 0
      for el in circlefloatdicarray
      {
      print("\(iii) \(el)")
      iii += 1
      }
       */
      /*
      print("report_horizontal_checkbo vor sort circlefloatarray_raw")
      var k = 0
      for el in circlefloatarray_raw
      {
      print("\(k) \(el)")
      k += 1
      }
*/
      
      switch sender.state
      {
      case .off:
         print("horizontal_checkbox: off")
//         sortedarray = sortDicArray_float(origDicArray: circlefloatdicarray,key0:"cx", key1:"cy", order: false)
         sortedfloatarray = sortArrayofArrays(origArray:circlefloatarray_raw, index:1, order:false)
      //sortedfloatarray = 
      case .on:
         print("horizontal_checkbox: on")
//         sortedarray = sortDicArray_float(origDicArray: circlefloatdicarray,key0:"cx", key1:"cy", order: true)
         sortedfloatarray = sortArrayofArrays(origArray:circlefloatarray_raw, index:2, order:false)
      default:
         break
      }
      
/*      
      print("report_horizontal_checkbox nach sort sortedfloatarray")
      var iiii = 0
      for el in sortedfloatarray
      {
      print("\(iiii) \(el)")
      iiii += 1
      }
 */
 /*
      print("report_horizontal_checkbox nach sort sortedarray")
      iii = 0
      for el in sortedarray
      {
      print("\(iii) \(el)")
      iii += 1
      }

   */   
      
      // Anpassen an microstep
      let microstepindex = schritteweitepop.indexOfSelectedItem
      let microstep = Double(schritteweitepop.itemTitle(at: microstepindex))

      var tempcirclearray = [[Double]]()
      var zeilenindex:Double = 0
      
      print("report_horizontal_checkbox sortedfloatarray")
      
      // zeilen neu indexieren
      zeilenindex = 0
      for zeile in sortedfloatarray
      {
         let cx:Double = (zeile[1]) // * (microstep ?? 1)
         let cy:Double = (zeile[2]) // * (microstep ?? 1)
         let cz:Double = (zeile[3]) // * (microstep ?? 1)
         
         print("\(zeilenindex) \(cx) \(cy)  \(cz)")
         let zeilenarray = [zeilenindex,cx,cy,cz] 
         tempcirclearray.append(zeilenarray)
         zeilenindex += 1
      }      
      
 
      if figurschliessen_checkbox.state == .on
      {
         tempcirclearray.append(tempcirclearray[0])
      }

 /*     
      print("report_horizontal_checkbox tempcirclearray")
      var iii = 0
      for el in tempcirclearray
      {
      print("\(iii) \(el)")
      iii += 1
      }
  */  
      setPCB_Output(floatarray: tempcirclearray, scale: 5, transform: transformfaktor)
      var PCBDaten = PCB_Daten(floatarray: tempcirclearray)
      Schnittdatenarray.removeAll()
      Schnittdatenarray.append(contentsOf:PCBDaten)
      return
      
     }
   
   @IBAction  func report_linearCheckbox(_ sender: NSButton)
   {
      print("report_linearCheckbox IntVal: \(sender.intValue)")
      let state = horizontal_checkbox.state
      var order = false
      if state == .on
      {
         order = true
      }
      var sortedarray = [[String:Int]]()
      sortedarray = sortDicArray_opt(origDicArray: circledicarray,key0:"cx", key1:"cy", order: order)
      
      var circlearray = [[Int]]()
      var zeilendicindex:Int = 0
      for zeilendic in sortedarray
      {
         let cx:Int = (zeilendic["cx"]!)
         let cy:Int = (zeilendic["cy"]!)
         
         //print("\(zeilendicindex) \(cx) \(cy)")
         let zeilendicarray = [zeilendicindex,cx,cy]
         circlearray.append(zeilendicarray)
         zeilendicindex += 1
      }
      
      let l = Plattefeld.setWeg(newWeg: circlearray, scalefaktor: 400 , transform:  transformfaktor)
      self.fahrtweg.integerValue = l
   }
   
   func kreuz(startnummer:Int)->[[UInt8]]
   {
      var index = startnummer
      var kreuzarray = [[UInt8]]()
      var dx:Double = 20
      var dy:Double = 20
      var lastkreuzpunktx = [0,0]
      var kreuzwegarray = wegArrayMitWegXY(wegx: dx , wegy: dy) // rechts oben
      //      kreuzwegarray[24] = 0xB3
      kreuzwegarray[25] = 0
      kreuzwegarray[32] = 1
      kreuzwegarray[26] = UInt8((index & 0xFF00) >> 8)
      kreuzwegarray[27] = UInt8(index & 0x00FF)
      index += 1
      startnummer
      kreuzarray.append(kreuzwegarray)
      kreuzwegarray = wegArrayMitWegXY(wegx: -2*dx , wegy: -2*dy) // links unten
      //     kreuzwegarray[24] = 0xB3
      kreuzwegarray[32] = 1
      kreuzwegarray[25] = 0
      kreuzwegarray[26] = UInt8((index & 0xFF00) >> 8)
      kreuzwegarray[27] = UInt8(index & 0x00FF)
      index += 1
      
      kreuzarray.append(kreuzwegarray)
      kreuzwegarray = wegArrayMitWegXY(wegx: dx , wegy: dy) // mitte 
      //     kreuzwegarray[24] = 0xB3
      kreuzwegarray[32] = 1
      kreuzwegarray[25] = 0
      kreuzwegarray[26] = UInt8((index & 0xFF00) >> 8)
      kreuzwegarray[27] = UInt8(index & 0x00FF)
      index += 1
      
      kreuzarray.append(kreuzwegarray)
      kreuzwegarray = wegArrayMitWegXY(wegx: -dx , wegy: dy) // links oben 
      //     kreuzwegarray[24] = 0xB3
      kreuzwegarray[32] = 1
      kreuzwegarray[25] = 0
      kreuzwegarray[26] = UInt8((index & 0xFF00) >> 8)
      kreuzwegarray[27] = UInt8(index & 0x00FF)
      index += 1
      
      kreuzarray.append(kreuzwegarray)
      kreuzwegarray = wegArrayMitWegXY(wegx: 2*dx , wegy: -2*dy) // rechts unten
      //    kreuzwegarray[24] = 0xB3
      kreuzwegarray[32] = 1
      kreuzwegarray[25] = 0
      kreuzwegarray[26] = UInt8((index & 0xFF00) >> 8)
      kreuzwegarray[27] = UInt8(index & 0x00FF)
      index += 1
      
      kreuzarray.append(kreuzwegarray)
      kreuzwegarray = wegArrayMitWegXY(wegx: -dx , wegy: dy) // mitte
      //     kreuzwegarray[24] = 0xB3
      kreuzwegarray[25] = 0
      kreuzwegarray[32] = 1
      kreuzwegarray[26] = UInt8((index & 0xFF00) >> 8)
      kreuzwegarray[27] = UInt8(index & 0x00FF)
      index += 1
      
      kreuzarray.append(kreuzwegarray)
      print("kreuzarray: \(kreuzarray)")
      
      return kreuzarray
   }
   
   func move(dx: Int, dy: Int)
   {
      print("move dx: \(dx) dy: \(dy)")
      lastklickposition.x = 0
      lastklickposition.y = 0

      let punkt:NSPoint = NSMakePoint(CGFloat(dx), CGFloat(dy))
      var wegarray = wegArrayMitWegXY(wegx: Double(punkt.x - CGFloat(lastklickposition.x)),wegy:Double(punkt.y - CGFloat(lastklickposition.y)))
      wegarray[32] = DEVICE_MILL
      wegarray[25] = 3 // nur 1 Abschnitt
      wegarray[24] = 0xDC 

      Schnittdatenarray.removeAll(keepingCapacity: true)
      cncstepperposition = 0
      var zeilenposition:UInt8 = 0
      Schnittdatenarray.append(wegarray)
      stepperschritteFeld.integerValue = Schnittdatenarray.count
      print("move Schnittdatenarray: \(Schnittdatenarray)")

      if Schnittdatenarray.count == 1
      {
         print("report_send_TextDaten start CNC")
         write_CNC_Abschnitt()   
         if teensy.readtimervalid() == true
         {
            //print("PCB readtimer valid vor")
         }
         else 
         {
            print("PCB move not valid vor")
            var start_read_USB_erfolg = teensy.start_read_USB(true)
            print("move start_read_USB_erfolg: \(start_read_USB_erfolg)")
         }
      }
   }
   
   @IBAction func report_send_Figur(_ sender: NSButton)
   {
      let dx = dxFeld.doubleValue
      let dy = dyFeld.doubleValue
      
      
      
      
   }
   @IBAction func report_send_Move(_ sender: NSButton)
   {
      print("report_send_Move")
      //    clearteensy()
      let dx = dxFeld.doubleValue
      let dy = dyFeld.doubleValue
      
      print("report_send_Move dx: \(dx) dy: \(dy)")
      lastklickposition.x = 0
      lastklickposition.y = 0
      let punkt:NSPoint = NSMakePoint(CGFloat(dx), CGFloat(dy))
     // print("report_send_Move lastklickposition x: \(lastklickposition.x) dy: \(lastklickposition.y)")
      // lastKlickposition ist (0,0)
      var wegarray = wegArrayMitWegXY(wegx: Double(punkt.x - CGFloat(lastklickposition.x)),wegy:Double(punkt.y - CGFloat(lastklickposition.y)))
      
      wegarray[32] = DEVICE_MILL
      
      //print("wegarray")
      //print("\(wegarray)")
      //print_tabzeile(wegarray)
      //
//      Schnittdatenarray.removeAll(keepingCapacity: true)
//      cncstepperposition = 0
      
      
      
      wegarray[25] = 3 // nur 1 Abschnitt
      wegarray[24] = 0xD5
      
      var zeilenposition:UInt8 = 0
      
 //     if Schnittdatenarray.count == 1
      if wegarray.count > 0
      {
         print("report_send_Move CNC")
         write_CNC_Zeile(zeilenarray: wegarray)
         
         if teensy.readtimervalid() == true
         {
            print("PCB readtimer valid vor")
         }
         else 
         {
            print("PCB report send Move not valid vor")
            var start_read_USB_erfolg = teensy.start_read_USB(true)
            //print("report_send_Movestart_read_USB_erfolg: \(start_read_USB_erfolg)")
         }
      }
   }
   
   @IBAction func report_send_TextDaten(_ sender: NSButton)
   {
      print("report_send_TextDaten")
      
   }// report_send_TextDaten
   
   @IBAction func report_flip_TextDaten(_ sender: NSButton)
   {
      print("report_flip_TextDaten")
      let buf = dxFeld.doubleValue
      dxFeld.doubleValue = dyFeld.doubleValue
      dyFeld.doubleValue = buf
   }
   
   @IBAction func report_inv_TextDaten(_ sender: NSButton)
   {
      print("report_inv_TextDaten")
      let buf = dxFeld.doubleValue
      dxFeld.doubleValue = dxFeld.doubleValue * (-1)
      dyFeld.doubleValue = dyFeld.doubleValue * (-1)
   }
   
   @IBAction  func report_SchrittweitePop(_ sender:NSPopUpButton)
   {
      let s:String = sender.titleOfSelectedItem ?? "4"
      pfeilschrittweite = Int(sender.titleOfSelectedItem ?? "4")!
      //print("report_SchrittweitePop Val: \(Int(sender.titleOfSelectedItem!))")
      print("report_SchrittweitePop pfeilschrittweite: \(pfeilschrittweite ?? 4)")
      //   updatePfeilschrittweite(sw: <#T##Int#>)
      
   }
   
   @IBAction func report_Motor_Slider(_ sender: NSSlider)
   {
      teensy.write_byteArray[24] = 0xDA // Code 
      //print("report_Motor_Slider IntVal: \(sender.intValue)")
      
      let pos = sender.doubleValue
      
      var int8pos:UInt8 = UInt8(sender.intValue)
      let Ustring = formatter.string(from: NSNumber(value: int8pos))
      
      
 //     print("report_Motor_Slider pos: \(pos) intpos: \(int8pos)  Ustring: \(Ustring ?? "0")")
      // Pot0_Feld.stringValue  = Ustring!
      Motor_Feld.integerValue  = Int(int8pos)
      //MotorKnopf.title = String(sender.integerValue)
      
 
      if (MotorKnopf.state == .on)
      {
         
         
         teensy.write_byteArray[DRILL_BIT] = int8pos
      
          let senderfolg = teensy.send_USB()
         //print("report_Motor_Slider senderfolg: \(senderfolg) code: \(teensy.write_byteArray[24])")
      }
   }
   
   
   
   @IBAction override func report_PWM_Slider(_ sender: NSSlider)
   {
      teensy.write_byteArray[24] = 0xD8 // Code 
  //    print("report_PWM_Slider: \(sender.intValue)")
      
      let pos = sender.integerValue
      
      let int8pos = UInt8(pos)
      let Ustring = formatter.string(from: NSNumber(value: int8pos))
      
      //print("report_PWM_Slider pos: \(pos) intpos: \(int8pos)  Ustring: \(Ustring ?? "0")")
      // Pot0_Feld.stringValue  = Ustring!
      PWM_Feld.integerValue  = Int(int8pos)
       
      teensy.write_byteArray[PWM_BIT] = int8pos
      
 //     if (usbstatus > 0)
 //     {
         let senderfolg = teensy.send_USB()
   //      print("report_PWM_Slider senderfolg: \(senderfolg)")
 //     }
   }
  
 
   
   
   //MARK: Slider 0
   @IBAction override func report_Slider0(_ sender: NSSlider)
   {
      teensy.write_byteArray[0] = SET_0 // Code 
      print("report_Slider0 IntVal: \(sender.intValue)")
      
      let pos = sender.doubleValue
      
      let intpos = UInt16(pos * FAKTOR0)
      let Ustring = formatter.string(from: NSNumber(value: intpos))
      
      //print("report_Slider0 pos: \(pos) intpos: \(intpos)  Ustring: \(Ustring ?? "0")")
      // Pot0_Feld.stringValue  = Ustring!
      Pot0_Feld.integerValue  = Int(intpos)
      Pot0_Stepper_L.integerValue  = Int(sender.minValue) // Stepper min setzen
      Pot0_Stepper_L_Feld.integerValue = Int(sender.minValue)
      Pot0_Stepper_H.integerValue  = Int(sender.maxValue) // Stepper max setzen
      Pot0_Stepper_H_Feld.integerValue = Int(sender.maxValue)
      
      teensy.write_byteArray[SCHRITTEX_A] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[SCHRITTEX_B] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         print("rBasis report_Slider0 senderfolg: \(senderfolg)")
      }
   }
   @IBAction override func report_Pot0_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("report_Pot0_Stepper_L IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot0_Stepper_L_Feld.integerValue = intpos
      
      Pot0_Slider.minValue = sender.doubleValue 
      print("report_Pot0_Stepper_L Pot0_Slider.minValue: \(Pot0_Slider.minValue)")
      
   }
   
   @IBAction override func report_Pot0_Stepper_H(_ sender: NSStepper)// Obere Grenze
   {
      print("report_Pot0_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot0_Stepper_H_Feld.integerValue = intpos
      
      Pot0_Slider.maxValue = sender.doubleValue 
      print("report_Pot0_Stepper_H Pot0_Slider.maxValue: \(Pot0_Slider.maxValue)")
      
   }
   @IBAction override func report_set_Pot0(_ sender: NSTextField)
   {
      teensy.write_byteArray[0] = SET_0 // Code 
      
      // senden mit faktor 1000
      //let u = Pot0_Feld.doubleValue 
      let Pot0_wert = Pot0_Feld.doubleValue * 100
      let Pot0_intwert = UInt(Pot0_wert)
      
      let Pot0_HI = (Pot0_intwert & 0xFF00) >> 8
      let Pot0_LO = Pot0_intwert & 0x00FF
      
      print("report_set_Pot0 Pot0_wert: \(Pot0_wert) Pot0 HI: \(Pot0_HI) Pot0 LO: \(Pot0_LO) ")
      let 
      intpos = sender.intValue 
      self.Pot0_Slider.doubleValue = Pot0_wert //sender.doubleValue
      self.Pot0_Stepper_L.doubleValue = Pot0_wert//sender.doubleValue
      
      teensy.write_byteArray[SCHRITTEX_A] = UInt8(Pot0_LO)
      teensy.write_byteArray[SCHRITTEX_B] = UInt8(Pot0_HI)
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         if (senderfolg < BUFFER_SIZE)
         {
            print("report_set_Pot0 U: %d",senderfolg)
         }
      }
   }
   
   
   
   
   // MARK:Slider 1
   @IBAction override func report_Slider1(_ sender: NSSlider)
   {
      teensy.write_byteArray[0] = SET_1 // Code
      print("report_Slider1 IntVal: \(sender.intValue)")
      
      let pos = sender.doubleValue
      let intpos = UInt16(pos * FAKTOR0)
      let Istring = formatter.string(from: NSNumber(value: intpos))
      print("intpos: \(intpos) IString: \(Istring)") 
      Pot1_Feld.integerValue  = Int(intpos)
      
      Pot1_Stepper_L.integerValue  = Int(sender.minValue) // Stepper min setzen
      Pot1_Stepper_L_Feld.integerValue = Int(sender.minValue)
      Pot1_Stepper_H.integerValue  = Int(sender.maxValue) // Stepper max setzen
      Pot1_Stepper_H_Feld.integerValue = Int(sender.maxValue)
      
      
      
      teensy.write_byteArray[DELAYX_A] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[DELAYX_B] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
      }
   }
   
   @IBAction override func report_Pot1_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("report_Pot1_Stepper_L IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot1_Stepper_L_Feld.integerValue = intpos
      
      Pot1_Slider.minValue = sender.doubleValue 
      print("report_Pot1_Stepper_L Pot1_Slider.minValue: \(Pot1_Slider.minValue)")
      
   }
   
   @IBAction override func report_Pot1_Stepper_H(_ sender: NSStepper)// Obere Grenze
   {
      print("report_Pot1_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot1_Stepper_H_Feld.integerValue = intpos
      
      Pot1_Slider.maxValue = sender.doubleValue 
      print("report_Pot1_Stepper_H Pot1_Slider.maxValue: \(Pot1_Slider.maxValue)")
      
   }
   // MARK:goto  
   
   
   @IBAction func report_goXY(_ sender: NSButton) // nicht benutzt, in mousedown bearbeitet
   {
      // 
      // left: 1, right: 2, up: 3, down: 4
      print("PCB report_goXY tag: \(sender.tag) propfaktor: \(propfaktor)")
      var dx = 0
      var dy = 0
      let schrittweite = 25
      switch sender.tag
      {
      case 1: // right
         dx = schrittweite
         break
      case 2: // up
         dy = schrittweite
         break
      case 3: // left
         dx = schrittweite * -1
         break
      case 4: // down
         dy = schrittweite * -1
         break
      case 13: // test
         dy = 20
         dx = 20
         break
         
      default:
         break
      }
      lastklickposition.x = 0
      lastklickposition.y = 0
      
      var wegarray = wegArrayMitWegXY(wegx: Double(dx),wegy:Double(dy))
      
      
      //     var wegarray = wegArrayMitWegXY(wegx:dx, wegy:dy)
      
      wegarray[32] = DEVICE_MILL
      Schnittdatenarray.removeAll(keepingCapacity: true)
      cncstepperposition = 0
      if Schnittdatenarray.count == 0 // Array im Teensy loeschen
      {
         wegarray[25] = 1 //erstes Element
         //teensy.write_byteArray[24] = 0xE0 // Stopp
         if teensy.dev_present() > 0
         {
            let senderfolg = teensy.send_USB()
            print("report_goXY report_goXY Array loeschen senderfolg: \(senderfolg)")
         }
         
      }
      
      var zeilenposition:UInt8 = 0
      Schnittdatenarray.append(wegarray)
       print("wegarray: \t\(wegarray)")
      
      if Schnittdatenarray.count == 1
      {
         print("report_goXY start CNC")
         write_CNC_Abschnitt()   
         
         
         if teensy.readtimervalid() == true
         {
            //print("PCB readtimer valid vor")
         }
         else 
         {
            print("PCB goto_XY not valid vor")
            var start_read_USB_erfolg = teensy.start_read_USB(true)
         }
      }
      
   }
   
   @IBAction override func report_goto_0(_ sender: NSButton)
   {
      print("report_goto_0")
      var x = goto_x.integerValue
      if x > Int(Pot0_Slider.maxValue)
      {
         x = Int(Pot0_Slider.maxValue)
      }
      var y = goto_y.integerValue
      if y > Int(Pot1_Slider.maxValue)
      {
         y = Int(Pot1_Slider.maxValue)
      }
      
      print("report_goto_0  x: \(x) y: \(y)")
      self.goto_0(x:Double(x),y:Double(y),z: 0)
   }
   
   override func goto_0(x:Double, y:Double, z:Double)
   {
      teensy.write_byteArray[0] = GOTO_0
      print("goto_0 x: \(x) y: \(y)")
      // achse 0
      let intposx = UInt16(x * FAKTOR0)
      goto_x_Stepper.integerValue = Int(x) //Int(intposx)
      teensy.write_byteArray[SCHRITTEX_A] = UInt8((intposx & 0xFF00) >> 8) // hb
      teensy.write_byteArray[SCHRITTEX_B] = UInt8((intposx & 0x00FF) & 0xFF) // lb
      
      // Achse 1
      let intposy = UInt16(y * FAKTOR1)
      goto_y_Stepper.integerValue = Int(y)
      teensy.write_byteArray[DELAYX_A] = UInt8((intposy & 0xFF00) >> 8) // hb
      teensy.write_byteArray[DELAYX_B] = UInt8((intposy & 0x00FF) & 0xFF) // lb
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
      }
      
      
   }
   @IBAction override func report_goto_x_Stepper(_ sender: NSStepper)
   {
      //teensy.write_byteArray[0] = SET_0 // Code 
      print("report_goto_x_Stepper IntVal: \(sender.intValue)")
      let intpos = sender.integerValue 
      goto_x.integerValue = intpos
      let intposx = UInt16(Double(intpos ) * FAKTOR0)
      teensy.write_byteArray[SCHRITTEX_A] = UInt8((intposx & 0xFF00) >> 8) // hb
      teensy.write_byteArray[SCHRITTEX_B] = UInt8((intposx & 0x00FF) & 0xFF) // lb
      
      let w = Double(Joystickfeld.bounds.size.width) // Breite Joystickfeld
      let invertfaktorw:Double = Double(w / (Pot0_Slider.maxValue - Pot0_Slider.minValue)) 
      
      var currpunkt:NSPoint = Joystickfeld.weg.currentPoint
      currpunkt.x = CGFloat(Double(intpos) * invertfaktorw)
      Joystickfeld.weg.line(to: currpunkt)
      Joystickfeld.needsDisplay = true 
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
      }
   }
   
   @IBAction override func report_goto_y_Stepper(_ sender: NSStepper)
   {
      //teensy.write_byteArray[0] = SET_0 // Code 
      //print("report_goto_y_Stepper IntVal: \(sender.intValue)")
      let intpos = sender.integerValue 
      goto_y.integerValue = intpos
      let intposy = UInt16(Double(intpos ) * FAKTOR0)
      teensy.write_byteArray[DELAYX_A] = UInt8((intposy & 0xFF00) >> 8) // hb
      teensy.write_byteArray[DELAYX_B] = UInt8((intposy & 0x00FF) & 0xFF) // lb
      
      let h = Double(Joystickfeld.bounds.size.width) // Breite Joystickfeld
      let invertfaktorh:Double = Double(h / (Pot1_Slider.maxValue - Pot1_Slider.minValue)) 
      
      var currpunkt:NSPoint = Joystickfeld.weg.currentPoint
      currpunkt.y = CGFloat(Double(intpos) * invertfaktorh)
      Joystickfeld.weg.line(to: currpunkt)
      Joystickfeld.needsDisplay = true 
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
      }
   }
   
   
   
   
   
   // MARK: Ring
   
   
   @IBAction override func report_clear_Ring(_ sender: NSButton)
   {
      print("report_clear_Ring ")
      teensy.write_byteArray[0] = CLEAR_RING
      teensy.write_byteArray[SCHRITTEX_A] = UInt8(((ACHSE0_START) & 0xFF00) >> 8) // hb
      teensy.write_byteArray[SCHRITTEX_B] = UInt8(((ACHSE0_START) & 0x00FF) & 0xFF) // lb
      
      teensy.write_byteArray[DELAYX_A] = UInt8(((ACHSE1_START) & 0xFF00) >> 8) // hb
      teensy.write_byteArray[DELAYX_B] = UInt8(((ACHSE1_START) & 0x00FF) & 0xFF) // lb
      
      teensy.write_byteArray[SCHRITTEY_A] = UInt8(((ACHSE2_START) & 0xFF00) >> 8) // hb
      teensy.write_byteArray[SCHRITTEY_B] = UInt8(((ACHSE2_START) & 0x00FF) & 0xFF) // lb
      
      teensy.write_byteArray[schrittezA] = 0 // hb
      teensy.write_byteArray[schrittezB] = 0 // lb
      
      teensy.write_byteArray[delayzA] = 0 // hb
      teensy.write_byteArray[delayzB] = 0 // lb
      Joystickfeld.clearWeg()
      schnittPfad?.clearPfadarray()
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
      }
      
   }
   
} // ViewController




//MARK: dataTable
extension rPCB: NSTableViewDataSource
{
   func numberOfRows(in tableView: NSTableView) -> Int {
      return (CNC_DatendicArray.count)
      
   }
   
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let zeile = CNC_DatendicArray[row]
      //print("p: \(person)")
      let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
      cell?.textField?.stringValue = (zeile[tableColumn!.identifier.rawValue]!)
      
      return cell
   }
}
