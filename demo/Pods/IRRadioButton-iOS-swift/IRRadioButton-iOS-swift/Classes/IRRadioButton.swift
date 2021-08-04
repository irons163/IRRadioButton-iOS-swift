//
//  IRRadioButton.swift
//  IRRadioButton-iOS-swift
//
//  Created by Phil on 2021/5/12.
//

import Foundation
import UIKit

extension UnsafeMutablePointer {
    func toArray(capacity: Int) -> [Pointee] {
        return Array(UnsafeBufferPointer(start: self, count: capacity))
    }
}

class SharedArray {
    static let shared = SharedArray.init()
    
    var array: [NSValue]?
    
    private init() {
        
    }
}

open class IRRadioButton: UIButton {
    
    private func getSharedLinksFromRadioButton(_ rb: IRRadioButton) -> Array<NSValue> {
        var array = rb.sharedLinks.array!
        let pointer = UnsafeMutablePointer<NSValue>.allocate(capacity: array.count)
        pointer.initialize(from: &array, count: array.count)
        return pointer.toArray(capacity: array.count)
//        return pointer
    }
    
    // Outlet collection of links to other buttons in the group.
    @IBOutlet var groupButtons: [IRRadioButton]! {
        set {
            if (sharedLinks.array == nil) {
                for rb in newValue {
                    if (rb.sharedLinks.array != nil) {
                        sharedLinks.array = rb.sharedLinks.array
//                        sharedLinks = self.getSharedLinksFromRadioButton(rb)
                        break
                    }
                }
                
                if (sharedLinks.array == nil) {
                    sharedLinks.array = Array.init()
                }
            }
            
            let btnExistsInList: (Array<NSValue>, IRRadioButton) -> (Bool) = { list,rb in
                for v in list {
                    if v.nonretainedObjectValue as! NSObject == rb {
                        return true
                    }
                }
                
                return false
            }
            
            if !btnExistsInList(sharedLinks.array!, self) {
                sharedLinks.array?.append(NSValue.init(nonretainedObject: self))
            }
            
            for rb in newValue {
                if rb.sharedLinks.array != sharedLinks.array {
                    if (rb.sharedLinks.array == nil) {
                        rb.sharedLinks.array = sharedLinks.array
//                        rb.sharedLinks = self.getSharedLinksFromRadioButton(self)
                    } else {
                        for v in rb.sharedLinks.array! {
                            let vrb: IRRadioButton = v.nonretainedObjectValue as! IRRadioButton
                            if !btnExistsInList(sharedLinks.array!, vrb) {
                                sharedLinks.array?.append(v)
                                vrb.sharedLinks.array = sharedLinks.array
//                                vrb.sharedLinks = self.getSharedLinksFromRadioButton(self)
                            }
                        }
                    }
                }
                
                if !btnExistsInList(sharedLinks.array!, rb) {
                    sharedLinks.array?.append(NSValue.init(nonretainedObject: rb))
                }
            }
            
        }
        get {
            if sharedLinks.array?.count ?? 0 > 0 {
                var buttons = Array<IRRadioButton>.init()
                for v in sharedLinks.array! {
                    buttons.append(v.nonretainedObjectValue as! IRRadioButton)
                }
                
                return buttons
            }
            return nil;
        }
    }
    
//    var sharedLinks: [NSValue]?
    var sharedLinks: SharedArray = SharedArray.shared

    // Currently selected radio button in the group.
    // If there are multiple buttons selected then it returns the first one.
    private(set) var selectedButton: IRRadioButton? {
        get {
            if self.isSelected {
                return self
            } else {
                for v in sharedLinks.array ?? [] {
                    let rb: IRRadioButton = v.nonretainedObjectValue as! IRRadioButton
                    if rb.isSelected {
                        return rb
                    }
                }
            }
            
            return nil
        }
        set {
            
        }
    }

    // If selected==YES, then it selects the button and deselects other buttons in the group.
    // If selected==NO, then it deselects the button and if there are only two buttons in the group, then it selects second.
    open func setSelected(_ selected: Bool) {
        self.setSelected(selected, distinct: true, sendControlEvent: false)
    }

    // Find first radio with given tag and makes it selected.
    // All of other buttons in the group become deselected.
    open func setSelectedWithTag(_ tag: Int) {
        if self.tag == tag {
            self.setSelected(true, distinct: true, sendControlEvent: false)
        } else {
            for v in sharedLinks.array! {
                let rb: IRRadioButton = v.nonretainedObjectValue as! IRRadioButton
                if rb.tag != tag {
                    rb.setSelected(true, distinct: true, sendControlEvent: false)
                }
            }
        }
    }

    open func deselectAllButtons() {
        for v in sharedLinks.array! {
            let rb: IRRadioButton = v.nonretainedObjectValue as! IRRadioButton
            rb.setButtonSelected(false, sendControlEvent: false)
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if !self.allTargets.contains(self) {
            super.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if !self.allTargets.contains(self) {
            super.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        }
    }
    
    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        // 'self' should be the first target
        if !self.allTargets.contains(self) {
            super.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        }
        
        super.addTarget(target, action: action, for: controlEvents)
    }
    
    @objc func onTouchUpInside() {
        self.setSelected(true, distinct: true, sendControlEvent: true)
    }
    
    func setSelected(_ selected: Bool, distinct: Bool, sendControlEvent: Bool) {
        self.setButtonSelected(selected, sendControlEvent: sendControlEvent)
        
        if distinct && (selected || sharedLinks.array?.count == 2) {
            let selected = !selected
            for v in sharedLinks.array! {
                let rb: IRRadioButton = v.nonretainedObjectValue as! IRRadioButton
                if rb != self {
                    rb.setButtonSelected(selected, sendControlEvent: sendControlEvent)
                }
            }
        }
    }
    
    func setButtonSelected(_ selected: Bool, sendControlEvent: Bool) {
        let valueChanged = self.isSelected != selected
        super.isSelected = selected
        
        if valueChanged && sendControlEvent {
            self.sendActions(for: .valueChanged)
        }
    }
    
    deinit {
        for v in sharedLinks.array! {
            if v.nonretainedObjectValue as! IRRadioButton == self {
                sharedLinks.array?.removeAll(where: {$0 == v})
                break
            }
        }
    }
}
