//
//  Debouncer.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 31/12/23.
//

import Foundation
class Debouncer {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval
    private let callback: () -> Void
    
    init(delay: TimeInterval, callback: @escaping () -> Void) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            self?.callback()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
