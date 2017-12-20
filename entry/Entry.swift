//
//  Entry.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/20.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//
import Foundation

class Entry: NSObject, NSCoding {
    var userName:String
    //必須ではないのでオプショナル
    var email:String?
    //２択で男性を選択肢状態の為、非オプショナル
    var sex:Int
    //””でも0を選択する為、非オプショナル
    var sweetKind:Int
    
    
    // イニシャライザ
    init(
        userName: String,
        email: String?,
        sex: Int,
        sweetKind: Int
        )
    {
        self.userName = userName
        self.email = email
        self.sex = sex
        self.sweetKind = sweetKind
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey:"userName")
        aCoder.encode(email, forKey:"email")
        aCoder.encode(sex, forKey:"sex")
        aCoder.encode(sweetKind, forKey:"sweetKind")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.sex = aDecoder.decodeInteger(forKey: "sex")
        self.sweetKind = aDecoder.decodeInteger(forKey: "sweetKind")
    }
    
    
}
