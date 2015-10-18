//
//  Calculator.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/18/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class Calculator {
    
    
    func keepPreference (ops:[String]) -> Bool {
        var hasPreference = false
        for op in ops {
            if op == "x" || op == "/" {
                hasPreference = true
            }
        }
        return hasPreference
    }
    
    func isNum(c:Character) -> Bool{
        if c == "0" || c == "1" || c == "2" || c == "3" || c == "4" || c == "5" || c == "6" || c == "7" || c == "8" || c == "9" || c == "."{
            return true
        } else {
            return false
        }
    }
    func isOp(c:Character) -> Bool{
        if c == "+" || c == "-" || c == "/" || c == "x" {
            return true
        } else {
            return false
        }
    }
    
    func getReadableString(str:String) -> String {
        var newStr = ""
        for s in str.characters {
            if isOp(s) {
                newStr += " " + "\(s)" + " "
            }
            else {
                newStr += "\(s)"
            }
        }
        return newStr
    }
    
    func getUsualTotal(total:String) -> String {
        var newTotal : String = ""
        var twoStepsForward : Int = 0
        for t in total.characters {
            
            if twoStepsForward == 1 {
                newTotal += "\(t)"
                twoStepsForward = 2
            } else if twoStepsForward == 2 {
                newTotal += "\(t)"
                twoStepsForward = 3
            }
            if t == "." {
                newTotal += "\(t)"
                twoStepsForward = 1
            }
            if twoStepsForward == 0 {
                newTotal += "\(t)"
            }
        }
        return newTotal
    }
    
    func calculateTotal(str:String) -> Float {
        //var str = "6.00 / 3.00 - 18.00"
        print("STR ==== " + str)
        var n : [Float] = []
        var o : [String] = []
        var tempChar : String = ""
        var numOrOp : Int // 0 for num 1 for op
        numOrOp = 0
        let strLength = str.characters.count
        var cnt = 0
        for currentChar in str.characters {
            cnt++
            // if isNum(s){
            if numOrOp == 0 && isNum(currentChar){
                tempChar = tempChar + "\(currentChar)"
            }
            if numOrOp == 0 && isOp(currentChar) {
                let floatNum : Float = (tempChar as NSString).floatValue
                n.append(floatNum)
                tempChar = "\(currentChar)"
                numOrOp = 1
            }
            if numOrOp == 1 && isNum(currentChar){
                o.append(tempChar)
                numOrOp = 0
                tempChar = "\(currentChar)"
            }
            
            if cnt == strLength{
                let floatNum : Float = (tempChar as NSString).floatValue
                n.append(floatNum)
                tempChar = "\(currentChar)"
                numOrOp = 1
            }
            
        }
        print(n)
        print(o)
        if o.count > 0 {
            var empty = false
            var hasPreference : Bool = keepPreference(o)
            
            while !empty {
                for i in 0 ... o.count {
                    if hasPreference {
                        if o[i] == "x" {
                            let res = n[i]*n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        } else if o[i] == "/" {
                            let res = n[i]/n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        }
                    } else {
                        print("\(i)")
                        if o[i] == "+" {
                            print("+")
                            let res = n[i]+n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            break
                        }
                        if o[i] == "-" {
                            let res = n[i]-n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            break
                        }
                    }
                }
                if o.count == 0 {
                    empty = true
                }
                
            }
        }
        print(n)
        return n[0]
    }
    
    

}