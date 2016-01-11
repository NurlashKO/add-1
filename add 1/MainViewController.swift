//
//  MainViewController.swift
//  add 1
//
//  Created by Nurlan on 11/01/2016.
//  Copyright © 2016 Nurlan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var numbersLabel: UILabel?;
    @IBOutlet weak var scoreLabel: UILabel?;
    @IBOutlet weak var inputField: UITextField?;
    @IBOutlet weak var timeLabel: UILabel?;

    var score: Int = 0;
    var hud: MBProgressHUD?;

    var timer: NSTimer?;
    var seconds: Int = 60;

    override func viewDidLoad() {
        super.viewDidLoad()

        setRandomLabel();
        updateScoreLabel();
        updateTimeLabel();

        hud = MBProgressHUD(view: self.view);

        if (hud != nil) {
            self.view.addSubview(hud!);
        }

        if (inputField != nil) {
            inputField!.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged);
        }
        // Do any additional setup after loading the view.
    }

    func textFieldDidChange(textField: UITextField) {

        if (inputField!.text?.characters.count < 4) {
            return;
        }

        let numbers: Int? = Int(numbersLabel!.text!);
        let input: Int? = Int(inputField!.text!);
        if (numbers != nil && inputField != nil) {
            print("Comparing: \(inputField!.text) minus \(numbersLabel!.text!) == \(input! - numbers!)");
            if (input! - numbers! == 1111) {
                print("Correct!");
                showHUDWithAnswer(true);
                score++;
            }
            else
            {
                print("Incorrect!");
                showHUDWithAnswer(false);
                score--;
            }
        }
        setRandomLabel();
        updateScoreLabel();
        if (timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("onUpdateTimer"), userInfo: nil, repeats: true);
        }
        inputField!.text = "";

    }

    func onUpdateTimer() -> Void {
        if (0 < seconds && seconds <= 60) {
            seconds--;
            updateTimeLabel();
        }
        else
        {
            if (timer != nil)
            {
                timer!.invalidate();
                timer = nil;

                let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(score) points. Very good!",
                    preferredStyle: .Alert);
                let restartAction = UIAlertAction(title: "Restart", style: .Default, handler: nil);

                alertController.addAction(restartAction);

                self.presentViewController(alertController, animated: true, completion: nil);
                score = 0;
                seconds = 60;

                updateTimeLabel();
                updateScoreLabel();
                setRandomLabel();
            }
        }
    }

    func updateTimeLabel() {
        if (timeLabel != nil)
        {
            let min: Int = (seconds / 60) % 60;
            let sec: Int = (seconds % 60);
            let min_p: String = String(format: "%02d", min);
            let sec_p: String = String(format: "%02d", sec);

            timeLabel!.text = "\(min_p):\(sec_p)";
        }
    }

    func showHUDWithAnswer(isRight: Bool) {
        if (hud != nil) {
            let rightImage: UIImage? = UIImage(named: "thumbs-up");
            let wrongImage: UIImage? = UIImage(named: "thumbs-down");
            var hudImageView: UIImageView?;
            if (isRight && rightImage != nil) {
                hudImageView = UIImageView(image: rightImage!);

            }
            if (!isRight && wrongImage != nil) {
                hudImageView = UIImageView(image: wrongImage!);
            }
            if (hudImageView != nil) {
                hud!.mode = MBProgressHUDMode.CustomView;
                hud!.customView = hudImageView;
                hud!.show(true);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                    Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.hud!.hide(true);
                }
            }

        }
    }

    func updateScoreLabel() {
        if (scoreLabel != nil) {
            scoreLabel!.text = "\(score)";
        }
    }

    func setRandomLabel() {
        if (numbersLabel != nil) {
            numbersLabel!.text = generateRandomNumber();
        }
    }

    func generateRandomNumber() -> String {
        var result: String = "";
        for _ in 1...4 {
            let digit: Int = Int(arc4random_uniform(8) + 1);
            result += "\(digit)";
        }
        return result;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
