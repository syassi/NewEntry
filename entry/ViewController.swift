//
//  ViewController.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/19.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//

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
    
    @IBAction func tapButtonNew(_ sender: AnyObject) {
        let vc = EntryVC.instantiate()
        vc.kind = .new
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapButtonEdit(_ sender: AnyObject) {
        let vc = EntryVC.instantiate()
        vc.kind = .edit
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: private
    
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

