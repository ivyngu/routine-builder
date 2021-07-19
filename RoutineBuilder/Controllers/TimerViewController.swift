//
//  TimerViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/14/21.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet var countdownSecondsLabel: UILabel!
    @IBOutlet var countdownMinutesLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var activeButton: UIButton!
       
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var routineItems = [RoutineItem]()

    private var index = 0
    private var secondsRemaining: Int16 = 0
    private var minutesRemaining: Int16 = 0
    private var timer: Timer!
    private var timerOn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        loadTimer()
    }
       
    private func loadTimer() {
        minutesRemaining = routineItems[index].durationMinutes
        secondsRemaining = routineItems[index].durationSeconds
        countdownMinutesLabel.text = "\(routineItems[index].durationMinutes)"
        countdownSecondsLabel.text = "\(routineItems[index].durationSeconds)"
        activityLabel.text = routineItems[index].name
        activeButton.setTitle("Start", for: .normal)
    }
       
    @IBAction func playButtonTapped(_ sender: Any) {
        if !timerOn {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
            activeButton.setTitle("Pause", for: .normal)
        } else {
            timer.invalidate()
            activeButton.setTitle("Start", for: .normal)
        }
        timerOn.toggle()
    }
       
    private func increaseIndex() {
        if (index < routineItems.count) {
            index += 1
        }
    }
       
    @objc func step() {
        if minutesRemaining > 0 || secondsRemaining > 0 {
            secondsRemaining -= 1
            if (secondsRemaining == -1) {
                secondsRemaining = 59
                minutesRemaining -= 1
            }
        } else {
            timer.invalidate()
            if index == routineItems.count - 1 {
                let congratsAlert = UIAlertController(title: "Congrats!", message: "You finished your routine. Amazing work!", preferredStyle: .alert)
                congratsAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {_ in
                    self.storyboard?.instantiateInitialViewController()
                }))
                present(congratsAlert, animated: true)
            } else {
                increaseIndex()
                minutesRemaining = routineItems[index].durationMinutes
                secondsRemaining = routineItems[index].durationSeconds
                activityLabel.text = routineItems[index].name
                activeButton.setTitle("Start", for: .normal)
                timerOn.toggle()
            }
        }
        countdownSecondsLabel.text = "\(secondsRemaining)"
        countdownMinutesLabel.text = "\(minutesRemaining)"
    }
       
    private func getAllItems() {
        do {
            routineItems = try context.fetch(RoutineItem.fetchRequest())
            DispatchQueue.main.async {}
        }
        catch {
            //error
        }
    }
}
