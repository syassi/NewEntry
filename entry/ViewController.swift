//
//  ViewController.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/19.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//
// github url :https://github.com/syassi/NewEntry

import UIKit

class ViewController: UIViewController {

    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var editBtnView: UIView!
    @IBOutlet weak var newBtnView: UIView!
    
    // MARK: life Cycle
    
    /**
      画面ロード完了時イベント
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /**
     画面　表示される直前イベント
     
     - parameter animated:　アニメーションフラグ
     
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBAction
    // TODO: テスト
    // FIXME: 最終的に直す
    // https://qiita.com/roworks/items/cd5cb05bd83585325db7
    
    @IBAction func tapButtonNew(_ sender: AnyObject) {
        print("- NewButton -")
        createEntry(kind:.new)
    }
    
    @IBAction func tapButtonEdit(_ sender: AnyObject) {
        print("- EditButton -")
        
        createEntry(kind:.edit)
    }
    
    // MARK: private
    
    private func createEntry(kind:ButtonKind) {
        
        let vc = EntryVC.instantiate()
        vc.kind = kind
        vc.modalPresentationStyle = .overCurrentContext
        
        //デリゲート設定
        vc.delegate = self
        
        // コールバック処理
        vc.callbackReturnTapped = {(userName:String) -> Void in
            print("- callback - userName:\(userName)")
            self.setupUI()
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    /**
     画面セットアップ用
     
     */
    private func setupUI() {
        
        guard let data = userDefaults.object(forKey: "entry") as? Data else {
            newBtnView.isHidden = false
            editBtnView.isHidden = true
            return
        }
        newBtnView.isHidden = false
        editBtnView.isHidden = false
        
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? Entry {
            print("useName:\(unarchiveEntry.userName)")
        }
    }
}

extension ViewController : EntryVCDelegate {
    func entryBtn(userName:String) {
        print("- delegate - userName:\(userName)")
        
    }
}

