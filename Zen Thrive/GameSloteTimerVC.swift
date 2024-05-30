//
//  GameSloteTimerVC.swift
//  Zen Thrive
//
//  Created by Hitesh Mac on 18/05/24.
//

import UIKit

class GameSloteTimerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let ImgIcons = [#imageLiteral(resourceName: "Artboard 15") , #imageLiteral(resourceName: "Artboard 14"), #imageLiteral(resourceName: "Artboard 18"), #imageLiteral(resourceName: "Artboard 20"), #imageLiteral(resourceName: "Artboard 16"), #imageLiteral(resourceName: "Artboard 13"), #imageLiteral(resourceName: "Artboard 22"), #imageLiteral(resourceName: "Artboard 17"), #imageLiteral(resourceName: "Artboard 21")]
    
    @IBOutlet weak var machineImageView: UIImageView!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var chanceLabel: UILabel!
    @IBOutlet weak var visibleCountLabel: UILabel!
    @IBOutlet weak var TimerLbl: UILabel!

    var timer : Timer?
    var timeMedi = 60
    var Round = 0 {
        didSet {
            if visibleCount == 7 {
                viewAlertRoundComplete(title: "Round Complete", message: "Your Round 1 is Completed")
                Round += 1
            }
            else if visibleCount == 19 {
                viewAlertRoundComplete(title: "Round Complete", message: "Your Round 2 is Completed")
                Round += 1
                saveHistory(player: "Your Total Visible Item are \(self.visibleCount) in without time game")
            }
           
            }
            
        }
    }
    
    var chances = 15 {
        didSet {
            if chances == 0 {
                showAlert(title: "You Lose", message: "You Are Out of Chances! Play Again and Try to Win")
                saveHistory(player: "Your Total Visible Item are \(self.visibleCount) in without time game")
                restartGame()
            } else {
                chanceLabel.text = "Chance: \(chances)"
            }
        }
    }
    
    var selectedImageIndex: Int?
    var points = 0 {
        didSet {
            scoreLabel.text = "Score: \(points)"
        }
    }
    
    var visibleCount = 0 {
        didSet {
            visibleCountLabel.text = "Visible: \(visibleCount)"
        }
    }

    var imageViewsVisibility = [Bool](repeating: false, count: 9)

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        roll()
        setupImageViews()
        showAlert(title: "Info", message: "Spin the wheel and get three items . if spin image is more than 1 than that image visible user has to comple the whole rounds of games and win the game in the 20 chances and 60 seconds Timing")
        
        setupSwipeGesture()
        setupInitialUI()
        StartTimer()

    }
    func StartTimer() {

        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
   
    
    @objc func updateTimer() {
        
        timeMedi -= 1
        
        let minutes = timeMedi / 60
        let seconds = timeMedi % 60
        TimerLbl.text = String(format: " %02d:%02d", minutes, seconds)
        if timeMedi <= 0 {
            timer?.invalidate()
            self.timeUp()
        }
    }
    
    func timeUp() {
        
            self.saveHistory(player: "Times Up Your Total points are  \(self.points) in 60 seconds of Time Period")
    }
    
    @IBAction func BackBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func viewAlert1(title : String ,message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    
    func setupImageViews() {
        for (index, imageView) in imageViews.enumerated() {
            imageView.image = ImgIcons[index % ImgIcons.count]
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = false
        }
    }
    
    func setupSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func setupInitialUI() {
        view.center = self.view.center
        scoreLabel.text = "Score: \(points)"
        chanceLabel.text = "Chance: \(chances)"
        visibleCountLabel.text = "Visible: \(visibleCount)"
        navigationItem.hidesBackButton = true
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedImageView = sender.view as? UIImageView else { return }
        guard let index = imageViews.firstIndex(of: selectedImageView) else { return }
        selectedImageIndex = index
        highlightSelectedImage(index: index)
        barImageView.isUserInteractionEnabled = true
    }

    func highlightSelectedImage(index: Int) {
        for (i, imageView) in imageViews.enumerated() {
            imageView.alpha = (i == index) ? 1.0 : 0.5
        }
    }

    func highlightMatchedImages(indices: [Int]) {
        for index in indices {
            if !imageViewsVisibility[index] {
                imageViewsVisibility[index] = true
                visibleCount += 1
            }
        }
        for (index, imageView) in imageViews.enumerated() {
            imageView.alpha = imageViewsVisibility[index] ? 1.0 : 0.5
        }
    }
    

    func saveHistory(player: String) {
        let historyData: [String: Any] = ["Scores": player,
                                           "Rounds": Round]
        
        var historyArray = UserDefaults.standard.array(forKey: "history") as? [[String: Any]] ?? []
        historyArray.append(historyData)
        UserDefaults.standard.set(historyArray, forKey: "history")
    }
    
    func roll() {
        var delay: TimeInterval = 0
        for i in 0..<pickerView.numberOfComponents {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.randomSelectRow(in: i)
            }
            delay += 0.30
        }
    }
    
    func randomSelectRow(in component: Int) {
        let rowCount = ImgIcons.count * 10
        let randomRow = Int(arc4random_uniform(UInt32(rowCount - ImgIcons.count))) + ImgIcons.count
        pickerView.selectRow(randomRow, inComponent: component, animated: true)
    }
    
    func checkWin() {
         let selectedImageIndex = selectedImageIndex
        let machineIndices = (0..<pickerView.numberOfComponents).map { pickerView.selectedRow(inComponent: $0) % ImgIcons.count }
        
        let counts = machineIndices.reduce(into: [:]) { counts, index in counts[index, default: 0] += 1 }
        let matchedImages = counts.filter { $0.value > 1 }
        
        if !matchedImages.isEmpty {
            points += 10 * matchedImages.count
            Model.instance.play(sound: Constant.win_sound)
            animate(view: machineImageView, images: [#imageLiteral(resourceName: "wg"), #imageLiteral(resourceName: "sw")], duration: 1, repeatCount: 3)
            scoreLabel.text = "Score: \(points)"
            
            
            let matchedIndices = matchedImages.keys.map { $0 }
            highlightMatchedImages(indices: matchedIndices)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    func viewAlertRoundComplete(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.RestartRound()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func RestartRound() {
        chances = 15
        timeMedi = 60
        scoreLabel.text = "Score: \(points)"
        chanceLabel.text = "Chance: \(chances)"
    }
    func restartGame() {
        points = 0
        chances = 15
        timeMedi = 60
        scoreLabel.text = "Score: \(points)"
        chanceLabel.text = "Chance: \(chances)"
        visibleCount = 0
        imageViewsVisibility = [Bool](repeating: false, count: 9)
        for imageView in imageViews {
            imageView.alpha = 0.5
        }
    }

    @IBAction func spinBarAction(_ sender: UITapGestureRecognizer) {
        spinAction()
    }
    
    func spinAction() {
         let selectedImageIndex = selectedImageIndex
        barImageView.isUserInteractionEnabled = false
        animate(view: barImageView, images: #imageLiteral(resourceName: "mot").spriteSheet(cols: 13, rows: 1), duration: 0.2, repeatCount: 1)
        Model.instance.play(sound: Constant.spin_sound)
        roll()
        chances -= 1
        chanceLabel.text = "Chance: \(chances)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
            self.barImageView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - UIPickerView DataSource & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ImgIcons.count * 9
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % ImgIcons.count
        let img = UIImageView(image: ImgIcons[index])
        img.frame.size = CGSize(width: 60, height: 60)
        return img
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == .down {
                spinAction()
            }
        }
    }
}



