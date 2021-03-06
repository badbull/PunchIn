//
//  ViewController.swift
//  punchin
//
//  Created by Arto Heino on 24/03/16.
//  Copyright © 2016 Arto Heino. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ESTBeaconManagerDelegate, DataParserObserver {
    
    
    var nearestBeaconMajor: NSNumber = 0
    
    var nearestBeacon: CLBeacon?
    
    var crsId: Int = 0
    
    var lsId: Int = 0
    
    
    
    //BUTTONS

    @IBAction func cancelFromCourseView(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var classroom: UILabel!
    
    
    @IBAction func searchBeacons(sender: AnyObject) {
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
        nearestBeacon = nil
        classroom?.text = "No beacons nearby, can't punch in!"
        courseLabel?.text = "No course available!"
        
    }
    
    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var studentIdTextField: UITextField!
    
    @IBOutlet weak var saveLoginButton: UIButton!

    @IBOutlet weak var lessonTextField: UILabel!
    
    @IBOutlet weak var teachersTextField: UILabel!
    
    
    @IBAction func materialsAction(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://drive.google.com/drive/u/1/folders/0B9Ne_ibI0-RHTzZzTWg1ekdNYUE")!)
        
    }
    
    
    
    // BEACON MANAGER
    
    
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "DBB26A86-A7FD-45F7-AEEA-3A1BFAC8D6D9")!,
        identifier: "ranged region")
    
    
    
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()

        lastnameTextField?.delegate = self
        studentIdTextField?.delegate = self


        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        let logoImage = UIImageView(frame: CGRect(x:0, y:0, width: 200, height: 45))
        logoImage.contentMode = .ScaleAspectFit
        
        let logo = UIImage(named: "Image")
        logoImage.image = logo
        self.navigationItem.titleView = logoImage
        
        
        }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    

    

    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon],
                       inRegion region: CLBeaconRegion) {
        
        if beacons.first != nil {
            
        
            
            if nearestBeacon == nil {
                let dataParser = DataParser()
                nearestBeacon = beacons.first
                dataParser.getBeaconData((nearestBeacon?.major)!, parserObserver:self)
            }
        
        
            else if beacons.first!.major != nearestBeacon?.major {
                let dataParser = DataParser()
                nearestBeacon = beacons.first!
                dataParser.getBeaconData((nearestBeacon?.major)!, parserObserver:self)
            
        }
    }
    }
    
    
    
    //setting the parsed data to textfields
    
    func dataParsed(parsedData: Room) {

        classroom?.text = "\(parsedData.getRoomTitle()), \(parsedData.getRoomNumber())"
        lessonTextField?.text = "\(parsedData.lesson.getLessonTitle())"
        teachersTextField?.text = "\(parsedData.lesson.getTeachers())"
        courseLabel?.text = "\(parsedData.lesson.getLessonTitle())"
        
        crsId = parsedData.lesson.getCourseId()
        lsId = parsedData.lesson.getLessonId()
        
        saveIdFromRoom()
        

    }
    
    func studentParsed(students: [Student]) {
        
    }
    
    func saveIdFromRoom() {
        
        let savedIds = NSUserDefaults.standardUserDefaults()
        
        savedIds.setObject(crsId, forKey: "courseid")
        savedIds.setObject(lsId, forKey: "lessonid")
        savedIds.synchronize()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            let svc = segue.destinationViewController as! StudentsViewController;
            
            svc.lessonIdToPass = lsId
            
        }
    }
    
    
    
    
    }




