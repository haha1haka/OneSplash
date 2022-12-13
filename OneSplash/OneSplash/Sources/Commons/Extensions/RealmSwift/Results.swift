//
//  Results.swift
//  OneSplash
//
//  Created by HWAKSEONG KIM on 2022/12/13.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return compactMap {$0}
    }
}
