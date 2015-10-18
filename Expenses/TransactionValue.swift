//
//  TransactionValue.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/18/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class TransactionValue {
    var integerNum = 0
    var calculating = "0"
    var totalText = "0"
    var calculationText = ""
    var oneDot : Bool = false
    var oneOp : Bool = false
    var calculatorNumbers = ["Photo","7","8","9","/","Date","4","5","6","x","Note","1","2","3","-","Location","0",".","=","+"]
    let calculator:Calculator = Calculator()
    func resetInput() {
        integerNum = 0
        calculating = "0"
        totalText = "0"
        calculationText = "0"
        oneDot = false
        oneOp = false
    }
    func getTotalAndCalculation(indexPressed:Int) -> (String,String) {
        let keyPressed = calculatorNumbers[indexPressed]
        print("PRESSED KEY \(keyPressed) AT POSITION \(indexPressed)")
        //=
        if keyPressed == "=" {
            equalPressed()
        }
        //.
        if keyPressed == "." {
            dotPresssed()
        }
        //Number
        if (indexPressed + 1)%5 != 0 && indexPressed != 17 && indexPressed != 18{
            numberPressed(keyPressed)
            
        }
        //Operation
        if (indexPressed + 1)%5 == 0{
            operatorPressed(keyPressed)
            
        }
        return (calculator.getUsualTotal(totalText),calculator.getReadableString(calculationText))
    }
    
    func equalPressed(){
        calculationText = totalText
        calculating = "0"
    }
    
    func dotPresssed(){
        integerNum = 1
        //First dot
        if !oneDot {
            if calculating == "0" {
                totalText += "."
            }
            calculationText += "."
        }
        oneDot = true
        
    }
    
    func numberPressed(inputNumber:String){
        if calculating == "0"{
           //Just add Number
            oneOp = false
            if integerNum == 0 {
                if totalText == "0" {
                    totalText  = inputNumber
                } else {
                    totalText += inputNumber
                }
                calculationText = totalText
                
            } else if integerNum == 1 || integerNum == 2{
                integerNum++
                totalText += inputNumber
                calculationText = totalText
            }
        }
        else {
            //Calculate result
            oneOp = false
            calculationText = calculationText + inputNumber
            totalText =  "\(calculator.calculateTotal(calculationText))"
        }
    }
    
    func operatorPressed(operatorPressed:String){
        if !oneOp {
            //totalText = lastTotal
            calculating = operatorPressed
            calculationText =  calculationText  + operatorPressed
        }
        oneOp = true
        oneDot = false
    }
    
}