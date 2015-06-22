//
//  Model.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/22/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
class Model {
    
    //Singleton
    private struct Static {
        static var instance: Model?
    }
    class var sharedInstance: Model {
        if (Static.instance == nil) {
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    var integerNum = 0
    var calculating = "0"
    var calculator : Float = 0.00
    var selectedIndex: Int?
    var category = true
    var calculatorNumbers = ["7","8","9","/","4","5","6","x","1","2","3","-","0",".","=","+"]
    var data = ["a","b","c","d","e","f","g","h","i"]
    var subdata = ["sa","sb","sc","sd","se"]
    
    func resetInput() {
        integerNum = 0
        calculating = "0"
        calculator = 0.00
    }
    
    func getTotalAndCalculation(indexPressed:Int, lastTotal:String, calculatingString:String) -> (String,String) {
        var keyPressed = calculatorNumbers[indexPressed]
        var totalText = ""
        var calculationText = ""
        if keyPressed == "=" {
            totalText = lastTotal
            calculationText = lastTotal + " "
            //integerNum = 0
            calculating = "0"
            calculator = (lastTotal as NSString).floatValue
            return (totalText,calculationText)
        }
        if (indexPressed + 1)%4 != 0 && indexPressed != 14{
            if indexPressed == 13 {
                integerNum = 1
                totalText = lastTotal
                calculationText = lastTotal
                //calculating = "0"
            } else if calculating == "0"{
                var total = "0"
                if integerNum == 0 {
                    if lastTotal == "0" {
                        total = keyPressed + ".00"
                    } else {
                        total = getNumberWhithoutDot(lastTotal) + keyPressed + ".00"
                    }
                    totalText = total
                    calculationText = total + " "
                    println("Pressed \(keyPressed) at \(indexPressed)")
                } else if integerNum == 1{
                    integerNum = 2
                    total = getNumberWhithoutDot(lastTotal) + "." + keyPressed + "0"
                    totalText = total
                    calculationText = total + " "
                    println("PRIMEIRO DECIMAL")
                }
                else if integerNum == 2{
                    
                    total = lastTotal.substringToIndex(lastTotal.endIndex.predecessor()) + keyPressed
                    totalText = total
                    calculationText = total + " "
                    println("SEGUNDO DECIMAL")
                    integerNum = 3
                }
            } else {
                
                var firstNum : Float = (lastTotal as NSString).floatValue
                var secondNum : Float = 0.00
                if calculator != 0.00 {
                    secondNum  = ("\(Int(calculator))" + keyPressed + ".00" as NSString).floatValue
                } else {
                    secondNum  = (keyPressed + ".00" as NSString).floatValue
                }
                calculator = secondNum
                println("Calculando \(firstNum) \(secondNum)")
                //var sum = calculateTotal(firstNum, n2: secondNum, type: calculating)
                
                //totalText = "\(sum)"
                
                //calculateTotal()
                calculationText = calculatingString + " " + keyPressed + ".00 "
                totalText =  "\(calculateTotal(calculationText))"
                
                //calculating = "0"
            }
            
        } else {
            totalText = lastTotal
            calculating = keyPressed
            calculationText =  calculatingString  + keyPressed
            
            println("others")
        }
        return (totalText,calculationText)
    }
    
    func getNumberWhithoutDot(str: String) -> String {
        var t : String = ""
        for s in str{
            if s == "."{
                break
            }
            t = t + "\(s)"
        }
        return t
    }
    
    func keepPreference (ops:[String]) -> Bool {
        var hasPreference = false
        for op in ops {
            if op == "x" || op == "/" {
                hasPreference = true
            }
        }
        return hasPreference
    }
    
    func calculateTotal(str:String) -> Float {
        //var str = "6.00 / 3.00 - 18.00 "
        println("STR ==== " + str)
        var n : [Float] = []
        var o : [String] = []
        var num : String = ""
        var numOrOp = 0
        for s in str {
            // if isNum(s){
            if s != " " {
                num = num + "\(s)"
            }
            //}
            if s == " " {
                if numOrOp == 0 {
                    var floatNum : Float = (num as NSString).floatValue
                    n.append(floatNum)
                    num = ""
                    numOrOp = 1 }
                else {
                    o.append(num)
                    numOrOp = 0
                    num = ""
                }
            }
            
        }
        println(n)
        println(o)
        if o.count > 0 {
            var empty = false
            var hasPreference : Bool = keepPreference(o)
            
            while !empty {
                for i in 0 ... o.count {
                    if hasPreference {
                        if o[i] == "x" {
                            var res = n[i]*n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        } else if o[i] == "/" {
                            var res = n[i]/n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        }
                    } else {
                        println("\(i)")
                        if o[i] == "+" {
                            println("+")
                            var res = n[i]+n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            break
                        }
                        if o[i] == "-" {
                            var res = n[i]-n[i+1]
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
        println(n)
        return n[0]
    }
    
    
}