//
//  StressCheckResult.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/08/29.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import Foundation

enum RefreshId: Int {
    case GoOut
    case Neck
    case Back
    case LowBack
    case Dummy
    static let count = Dummy.rawValue
}

struct RefreshCheckItem {
    var id: RefreshId
    var isRefreshDone: Bool
    var freq: Double
    
    init(id: RefreshId, isRefreshDone: Bool){
        self.id = id
        self.isRefreshDone = isRefreshDone
        self.freq = 0.0
    }
}

var refreshCheckResult: [RefreshCheckItem] =
    [RefreshCheckItem(id: .GoOut, isRefreshDone: false),
     RefreshCheckItem(id: .Neck, isRefreshDone: false),
     RefreshCheckItem(id: .Back, isRefreshDone: false),
     RefreshCheckItem(id: .LowBack, isRefreshDone: false)
]

enum StressSignLevel: Int{
    case Strong
    case Mid
    case Weak
}

enum StressSignId: Int {
    case Jinmashin  /*Strong Stress Sign*/
    case Tears
    case Suicide
    case CannotDoAny
    case Konaien    /*Mid Stress Sign*/
    case StomachAche
    case Dizzy
    case Sleepy
    case ShallowSleep
    case Nightmare
    case Silent
    case BadLook
    case Frustrated
    case Tired
    case StrongStiffNeck
    case CarelessMiss
    case AvoidCommunication
    case DrinkThreeTimesMore
    case WeakStiffNeck  /*Weak Stress Sign*/
    case Tension
    case EatSweets
    case Drink
    case RepeatSame
    case Dummy
    static let count = Dummy.rawValue
}

struct StressCheckItem {
    var level: StressSignLevel
    var id: StressSignId
    var isExistStress: Bool
    var freq: Double
    
    init(level: StressSignLevel, id: StressSignId, isExistStress: Bool){
        self.level = level
        self.id = id
        self.isExistStress = isExistStress
        self.freq = 0.0
    }
}

var stressCheckResult: [StressCheckItem] =
    [StressCheckItem(level: .Strong, id: .Jinmashin, isExistStress: false),
     StressCheckItem(level: .Strong, id: .Tears, isExistStress: false),
     StressCheckItem(level: .Strong, id: .Suicide, isExistStress: false),
     StressCheckItem(level: .Strong, id: .CannotDoAny, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Konaien, isExistStress: false),
     StressCheckItem(level: .Mid, id: .StomachAche, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Dizzy, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Sleepy, isExistStress: false),
     StressCheckItem(level: .Mid, id: .ShallowSleep, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Nightmare, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Silent, isExistStress: false),
     StressCheckItem(level: .Mid, id: .BadLook, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Frustrated, isExistStress: false),
     StressCheckItem(level: .Mid, id: .Tired, isExistStress: false),
     StressCheckItem(level: .Mid, id: .StrongStiffNeck, isExistStress: false),
     StressCheckItem(level: .Mid, id: .CarelessMiss, isExistStress: false),
     StressCheckItem(level: .Mid, id: .AvoidCommunication, isExistStress: false),
     StressCheckItem(level: .Mid, id: .DrinkThreeTimesMore, isExistStress: false),
     StressCheckItem(level: .Weak, id: .WeakStiffNeck, isExistStress: false),
     StressCheckItem(level: .Weak, id: .Tension, isExistStress: false),
     StressCheckItem(level: .Weak, id: .EatSweets, isExistStress: false),
     StressCheckItem(level: .Weak, id: .Drink, isExistStress: false),
     StressCheckItem(level: .Weak, id: .RepeatSame, isExistStress: false)
]



let stressSignList: [StressSignLevel: [StressSignId]] =
    [.Strong:[.Jinmashin, .Tears, .Suicide, .CannotDoAny],
     .Mid:[.Konaien, .StomachAche, .Dizzy, .Sleepy, .ShallowSleep, .Nightmare, .Silent, .BadLook, .Frustrated, .Tired, .StrongStiffNeck, .CarelessMiss, .AvoidCommunication, .DrinkThreeTimesMore],
     .Weak: [.WeakStiffNeck, .Tension, .EatSweets, .Drink, .RepeatSame]]

let strongSignStart:Int = 0
let strongSignEnd: Int = (stressSignList[.Strong]?.count)!
let midSignStart:Int = strongSignEnd
let midSignEnd:Int = midSignStart + (stressSignList[.Mid]?.count)!
let weakSignStart:Int = midSignEnd
let weakSignEnd:Int = weakSignStart + (stressSignList[.Weak]?.count)!

let stressSignIndex: [StressSignLevel: (Int,Int)] =
    [.Strong: (start: strongSignStart, end: strongSignEnd),
     .Mid: (start:midSignStart, end:midSignEnd),
     .Weak:(start:weakSignStart, end:weakSignEnd)]

let isExistStressToString : [Bool : String] = [true: "有", false: "無"]
let stressSignLevelString: [StressSignLevel: String] = [.Strong: "ストレスサイン:強", .Mid: "ストレスサイン:中", .Weak:"ストレスサイン:弱"]

let stressSignString: [StressSignId : String] =
    [.Jinmashin: "蕁麻疹", .Tears: "涙が出る", .Suicide: "消えたくなる・死にたくなる", .CannotDoAny: "何もできなくなる",
     .Konaien: "口内炎・にきび", .StomachAche: "腹痛", .Dizzy: "顔の張り・目眩", .Sleepy: "日中の眠気", .ShallowSleep: "入眠困難・中途覚醒", .Nightmare: "夜中にうなされる", .Silent: "無口になる", .BadLook:"外見を気にしなくなる", .Frustrated: "苛々・落込み・しんどさ・焦燥・空虚", .Tired: "疲労感・仕事が遅・同じ事を３回以上", .StrongStiffNeck: "肩凝り強・後頭部張り", .CarelessMiss: "ケアレスミス・物忘れ増加", .AvoidCommunication: "苦手な人とのコミュニケーションを避ける",.DrinkThreeTimesMore:"飲酒週３回以上",
     .WeakStiffNeck: "首・肩・背中・腰・脹脛・足裏の疲れ", .Tension: "緊張感", .EatSweets: "甘いものを食べたくなる", .Drink: "酒を飲みたくなる", .RepeatSame: "仕事のことを考え過ぎ・同じことを繰返す"]

func saveStressCheckResult(){
    for i in 0..<stressCheckResult.count {
        if stressCheckResult[i].isExistStress {
            stressCheckResult[i].freq += 1
        }
    }
}


func addCheckResult(level : StressSignLevel) -> String {
    var str: String = ""
    str += stressSignLevelString[level]! + "\n"
    for i in (stressSignIndex[level]!.0)..<(stressSignIndex[level]!.1){
        str += stressSignString[stressCheckResult[i].id]! + "\t"
        str += isExistStressToString[stressCheckResult[i].isExistStress]! + "\n"
    }
    str += "\n"
    return str
}
