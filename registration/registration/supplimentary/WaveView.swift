//
//  WaveView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 7.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct WaveView: Shape {
    @ObservedObject private var keyboard = KeyboardResponder()

    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        let origin = CGPoint(x: 0, y: 0 - keyboard.currentHeight)

        var path = Path()
        path.move(to: origin)

        path.addCurve(
            to: CGPoint(x: width * 0.24, y: origin.y - 25.6),
            control1: CGPoint(x: width * 0.08, y: origin.y - 11.3),
            control2: CGPoint(x: width * 0.16, y: origin.y - 22.5)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: origin.y - 22.5),
            control1: CGPoint(x: width * 0.33, y: origin.y - 29.7),
            control2: CGPoint(x: width * 0.42, y: origin.y - 25.6)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.75, y: origin.y - 14.3),
            control1: CGPoint(x: width * 0.58, y: origin.y - 18.4),
            control2: CGPoint(x: width * 0.66, y: origin.y - 14.3)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.96, y: origin.y - 20.5),
            control1: CGPoint(x: width * 0.83, y: origin.y - 14.3),
            control2: CGPoint(x: width * 0.92, y: origin.y - 18.4)
        )
        path.addLine(to: CGPoint(x: width, y: origin.y - 22.5))

        path.addLine(to: CGPoint(x: width, y: width))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))

        return path
    }
}
