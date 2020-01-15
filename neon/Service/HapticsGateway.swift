//
//  AudioGateway.swift
//  neon
//
//  Created by James Saeed on 22/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

class HapticsGateway {
    
    static let shared = HapticsGateway()
    
    func triggerAddBlockHaptic() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.75)
    }
    
    func triggerClearBlockHaptic() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 1)
    }
    
    func triggerCompletionHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func triggerLightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}