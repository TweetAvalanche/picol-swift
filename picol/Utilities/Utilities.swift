//
//  Utilities.swift
//  picol
//

import Foundation

func delay(_ seconds: Double, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}
