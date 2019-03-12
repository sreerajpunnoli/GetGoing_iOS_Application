//
//  FiltersViewController.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-02-04.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit
import CoreLocation

enum RankBy {
    case prominence, distance
    
    func description() -> String {
        switch self {
        case .distance:
            return String(describing: self).capitalized
        case .prominence:
            return String(describing: self).capitalized
        }
    }
}

class FiltersViewController: UIViewController {
    // Mark: - IBOutlets
    var radius: Int = 10
    var rankBy: String = RankBy.prominence.description()
    var isOpen: Bool = true
    
    weak var delegate: FilterServiceDelegate?
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var isOpenNow: UISwitch!
    @IBOutlet weak var rankByLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var rankBySelectedLabel: UILabel!
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let rankUsing: String = rankBySelectedLabel.text ?? RankBy.distance.description()
        delegate?.didUpdateFilter(radius: Int(radiusSlider.value), rankBy: rankUsing, isOpen: isOpenNow.isOn)
        dismiss(animated: true, completion: nil)
    }
    
    // Mark: - View Controller LifeCycle
    var rankByDictionary: [RankBy] = [.prominence, .distance]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        rankByLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rankByLabelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rankByLabel.addGestureRecognizer(tapGestureRecognizer)
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0)
        let toolBar = UIToolbar(frame: frame)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hidePicker))
        toolBar.setItems([doneItem], animated: true)
        pickerView.addSubview(toolBar)
        
        rankBySelectedLabel.text = rankBy
        isOpenNow.isOn = isOpen
        radiusSlider.value = Float(radius)
        if rankBy == RankBy.prominence.description() {
            pickerView.selectRow(0, inComponent: 0, animated: true)
        } else {
            pickerView.selectRow(1, inComponent: 0, animated: true)
        }
        
    }
    
    // Mark: - IBAction
    
    @IBAction func resetFilter(_ sender: UIButton) {
        radiusSlider.value = Float(10)
        rankBySelectedLabel.text = RankBy.prominence.description()
        isOpenNow.isOn = true

        // Comment below line If you don't want to save the default filters when you close filter view
        delegate?.didUpdateFilter(radius: Int(radiusSlider.value), rankBy: rankBySelectedLabel.text!, isOpen: isOpenNow.isOn)
    }
    
    @objc func rankByLabelTapped() {
        print("Label Was Tapped!")
        pickerView.isHidden = !pickerView.isHidden
    }
    
    @objc func hidePicker() {
        pickerView.isHidden = true
    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func radiusSliderChangedValue(_ sender: UISlider) {
        print("Slider Value Changed to \(sender.value) \(Int(sender.value))")
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print("Changed: \(sender.isOn)")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rankByDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rankByDictionary[row].description()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rankBySelectedLabel.text = rankByDictionary[row].description()
    }
    
}

protocol FilterServiceDelegate: class {
    func didUpdateFilter(radius: Int, rankBy: String, isOpen: Bool)
    
}
