//
//  UIWindow.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import Foundation

//extension UIWindow {
//    
//    let container: PopoverGestureContainer
//    if let existingContainer = window.popoverContainerView {
//        container = existingContainer
//
//        /// The container is already laid out in the window, so we can go ahead and show the popover.
//        displayPopover(in: container)
//    } else {
//        container = PopoverGestureContainer(frame: window.bounds)
//
//        /**
//         Wait until the container is present in the view hierarchy before showing the popover,
//         otherwise all the layout math will be working with wonky frames.
//         */
//        container.onMovedToWindow = { [weak container] in
//            if let container = container {
//                displayPopover(in: container)
//            }
//        }
//
//        window.addSubview(container)
//    }
//    
//}
