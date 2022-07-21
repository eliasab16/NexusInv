//
//  Divider.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI

struct ExDivider: View {
    var width: CGFloat = 1
    //var direction: Axis.Set = .horizontal
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? Color(red: 0.278, green: 0.278, blue: 0.290) : Color(red: 0.706, green: 0.706, blue: 0.714))
                .frame(width: width, height: 40)
                .edgesIgnoringSafeArea(.vertical)
        }
    }
}

