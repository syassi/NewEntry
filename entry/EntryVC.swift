//
//  EntryVC.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/19.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//

import UIKit

// ボタン種別　（新規 /　編集）
enum ButtonKind:Int {
    case new = 0
    case edit = 1
}

class EntryVC: UIViewController {

    let pickerView: UIPickerView = UIPickerView()
    let sweetlist = ["","ショコラパルフェ","大きな白玉クリームぜんざい",
                "大きな窯出しとろけるプリン","ふんわり生どら焼（白玉入り）","香ばしほうじ茶ラテ"]
    
    var kind:ButtonKind!
    
    private var sex:Int = 0
    private var sweet:Int = 0
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var editBtnView: UIView!
    @IBOutlet weak var newBtnView: UIView!
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var sweetText: UITextField!
    @IBOutlet weak var sexSeg: UISegmentedControl!
    
    // MARK: life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(kind:self.kind)
        setupPicker()
    }
    
    // MARK: IBAction
    
    @IBAction func tapButtonClose(_ sender: AnyObject) {
        closeScreen()
    }
    
    @IBAction func tapButtonNew(_ sender: AnyObject) {
        if validate() {
            registEntry()
            closeScreen()
        } else {
            validateMsg()
        }
        
    }
    
    @IBAction func tapButtonEdit(_ sender: AnyObject) {
        if validate() {
            registEntry()
            closeScreen()
        } else {
            validateMsg()
        }
        
    }
    
    @IBAction func sexSegmentedControl(sender: UISegmentedControl) {
        
        //データを取る
        print("性別:\(sender.selectedSegmentIndex)")
        sex = sender.selectedSegmentIndex
    }
    
    // MARK: private
    private func closeScreen() {
        //キーボードを閉じる
        self.view.endEditing(true)
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(kind:ButtonKind) {
        
        //共通
        // UITextFieldDelegate を受ける為
        self.userNameText.delegate = self
        self.emailText.delegate = self
        
        switch kind {
        case .new:
            //新規画面
            setupNew()
            
        case .edit:
            //編集画面
            setupEdit()
        }
    }
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EntryVC.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EntryVC.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        //選択
        pickerView.selectRow(self.sweet, inComponent: 0, animated: true)
        sweetText.text = sweetlist[self.sweet]
        
        // タップした時のView（通常はキーボード）
        self.sweetText.inputView = pickerView
        // アクセサリー追加
        self.sweetText.inputAccessoryView = toolbar
    }
    
    @objc private func cancel() {
        self.sweetText.text = ""
        //Pickerを閉じる
        self.sweetText.endEditing(true)
    }
    
    @objc private func done() {
        //Pickerを閉じる
        self.sweetText.endEditing(true)
    }
    
    private func setupNew() {
        newBtnView.isHidden = false
        editBtnView.isHidden = true
    }
    
    private func setupEdit() {
        newBtnView.isHidden = true
        editBtnView.isHidden = false
        
        guard let data = userDefaults.object(forKey: "entry") as? Data else {
            return
        }
        
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? Entry {
            print("useName:\(unarchiveEntry.userName)")
            userNameText.text = unarchiveEntry.userName
            emailText.text = unarchiveEntry.email
            sex = unarchiveEntry.sex
            sexSeg.selectedSegmentIndex = unarchiveEntry.sex
            sweet = unarchiveEntry.sweetKind
            
        }
    }
    
    private func validateMsg() {
        let alertController = UIAlertController(title: nil, message: "名前を入力して下さい。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func validate() -> Bool {
        var check = true
        
        if self.userNameText.text?.count == 0 {
            check = false
        }
        
        return check
    }
    
    private func registEntry() {
        let entry = Entry(
            userName:self.userNameText.text!,
            email:self.emailText.text,
            sex:self.sex,
            sweetKind:self.sweet
        )
        //シリアライズ
        let archive = NSKeyedArchiver.archivedData(withRootObject: entry)
        userDefaults.set(archive, forKey:"entry")
        userDefaults.synchronize()
        
    }
    
    /**
        CGRectMake　Swift3で変更した対応
     
     - parameter x: 横
     - parameter y: 縦
     - parameter width: 幅
     - parameter height: 高さ
     
     - returns:　CGRectのインスタンス
     
     */
    private func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension EntryVC : UIPickerViewDataSource {
    //Picerviewの列の数は1とする
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //PicerViewの要素の数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return sweetlist.count
    }
}

extension EntryVC : UIPickerViewDelegate {
    
    //タイトル
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return sweetlist[row]
    }
    
    //選択時の処理
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        self.sweet = row
        self.sweetText.text = sweetlist[row]
    }
}

extension EntryVC : UITextFieldDelegate {
    // Returnキーを押したと判定される直前イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}

extension EntryVC : StoryboardInstantiable {}
