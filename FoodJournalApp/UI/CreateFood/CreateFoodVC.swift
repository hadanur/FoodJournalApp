//
//  CreateFoodVC.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import UIKit

class CreateFoodVC: UIViewController {
    @IBOutlet private weak var foodImage: UIImageView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    private var viewModel: CreateFoodVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createDatePicker()
        viewModel.delegate = self
        setupUI()
        
    }

    @IBAction private func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
              let day = dateTextField.text,
              let image = foodImage.image else { viewModel.delegate?.error()
            return
        }
        
        if titleTextField.text != "",
           foodImage.image != nil,
           dateTextField.text != "" {
            viewModel.delegate?.saveButtonTapped(title: title, day: day, image: image)
        } else {
            viewModel.delegate?.error()
        }
    }
    
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func createDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc private func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM EEEE"
        self.view.endEditing(true)
    }
    
    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
        
    }
    
    @objc private func dateChange(datePicker: UIDatePicker){
        dateTextField.text = formatDate(date: datePicker.date)
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "d MMMM EEEE"
        return formatter.string(from: date)
    }
    
    private func setupUI() {
        foodImage.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectDailyImage))
        foodImage.addGestureRecognizer(imageTapRecognizer)
    }
}

extension CreateFoodVC {
    static func create() -> CreateFoodVC {
        let vc = CreateFoodVC(nibName: "CreateFoodVC", bundle: nil)
        vc.viewModel = CreateFoodVM()
        return vc
    }
}

extension CreateFoodVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc private func selectDailyImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true

        present(picker, animated: true)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        foodImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}

extension CreateFoodVC: CreateFoodVMDelegate {
    func saveButtonTapped(title: String, day: String, image: UIImage) {
        viewModel.saveFood(title: title, day: day, image: image)
        navigationController?.popViewController(animated: true)
    }
    
    func saveSuccess() {
        navigationController?.popViewController(animated: true)
    }
    
    func error() {
        showAlert(title: "Error", message: "Error")
    }
}
