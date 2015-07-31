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
    var calculationText = ""
    var oneDot : Bool = false
    var oneOp : Bool = false
    
    func resetInput() {
        integerNum = 0
        calculating = "0"
        calculator = 0.00
    }
    
    func getTotalAndCalculation(indexPressed:Int, lastTotal:String) -> (String,String) {
        var keyPressed = calculatorNumbers[indexPressed]
        var totalText = lastTotal
        if keyPressed == "=" {
            totalText = lastTotal
            calculationText = lastTotal
            //integerNum = 0
            calculating = "0"
            calculator = (lastTotal as NSString).floatValue
            return (totalText,calculationText)
        }
        if (indexPressed + 1)%4 != 0 && indexPressed != 14{ //Nao + - / *
            if indexPressed == 13 { //.
                integerNum = 1
                println(calculating)
                if calculating == "0" && !oneDot {
                    totalText = lastTotal + "."
                    calculationText += "."
                }
                if calculating != "0" && !oneDot {
                    //totalText = lastTotal + "."
                    calculationText += "."
                }
                println("TotalText: \(totalText)")

                
                //calculating = "0"
                oneDot = true
            } else if calculating == "0"{
                println("NUMERO")
                oneOp = false
                var total = "0"
                if integerNum == 0 {
                    if lastTotal == "0" {
                        total = keyPressed
                    } else {
                        total = getNumberWhithoutDot(lastTotal) + keyPressed
                    }
                    totalText = total
                    calculationText = total
                    println("Pressed \(keyPressed) at \(indexPressed)")
                } else if integerNum == 1{
                    integerNum = 2
                    total = lastTotal + keyPressed
                    totalText = total
                    calculationText = total
                    println("PRIMEIRO DECIMAL")
                }
                else if integerNum == 2{
                    
                    total = lastTotal + keyPressed
                    totalText = total
                    calculationText = total
                    println("SEGUNDO DECIMAL")
                    integerNum = 3
                }
            } else {
                println("OP 1")
                oneOp = false
                /*var firstNum : Float = (lastTotal as NSString).floatValue
                var secondNum : Float = 0.00
                if calculator != 0.00 {
                    secondNum  = ("\(Int(calculator))" + keyPressed + ".00" as NSString).floatValue
                } else {
                    secondNum  = (keyPressed + ".00" as NSString).floatValue
                }
                calculator = secondNum*/
                //println("Calculando \(firstNum) \(secondNum)")
                //var sum = calculateTotal(firstNum, n2: secondNum, type: calculating)
                
                //totalText = "\(sum)"
                
                //calculateTotal()
                
               /* var almostLast =  advance(calculationText.endIndex, -2)
                println(calculationText[almostLast])
                if calculationText[almostLast] == "0" {
                    println("NAO CALCULANDO SO ADICIONANDO")
                    calculationText = calculationText + keyPressed
                    println("AKI >>> \(calculationText)")
                    totalText =  "\(calculateTotal(calculationText))"
                    
                } else {*/
                    calculationText = calculationText + keyPressed
                    println("AKI >>> \(calculationText)")
                    totalText =  "\(calculateTotal(calculationText))"
                    //calculating = "0"
                //}
                
                
                
                //calculating = "0"
            }
            
        } else {
            println("OP 2")
            
            
            //println("ELSE DO ADICIONAR NUMERO \(lastTotal) e \(keyPressed)")
            if !oneOp {
                totalText = lastTotal
                calculating = keyPressed
                calculationText =  calculationText  + keyPressed
            }
            oneOp = true
            oneDot = false
            //println("others")
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
        for s in str {
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
        for t in total {
            
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
        println("STR ==== " + str)
        var n : [Float] = []
        var o : [String] = []
        var tempChar : String = ""
        var op : String = ""
        var numOrOp : Int // 0 for num 1 for op
        numOrOp = 0
        var strLength = count(str)
        var cnt = 0
        for currentChar in str {
            cnt++
            // if isNum(s){
            if numOrOp == 0 && isNum(currentChar){
                tempChar = tempChar + "\(currentChar)"
            }
            if numOrOp == 0 && isOp(currentChar) {
                var floatNum : Float = (tempChar as NSString).floatValue
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
                var floatNum : Float = (tempChar as NSString).floatValue
                n.append(floatNum)
                tempChar = "\(currentChar)"
                numOrOp = 1
            }
            
            //}
/*
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
            }*/
            
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