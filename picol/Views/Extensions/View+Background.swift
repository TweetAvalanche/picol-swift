//
//  View+Background.swift
//  picol
//

import SwiftUI

/// 背景画像と背景色を適用するカスタムモディファイア
struct BackgroundModifier: ViewModifier {
    var imageName: String?
    var colorName: String?

    var darken: Bool = false
    var animation: Animation = .easeInOut(duration: 0.5)
    var transition: AnyTransition = .opacity

    func body(content: Content) -> some View {
        ZStack {
            // 背景色を設定
            if let colorName = colorName {
                Color(colorName)
                    .edgesIgnoringSafeArea(.all)
                    .transition(transition)
                    .animation(animation, value: colorName)
            }

            // 背景画像を設定
            if let imageName = imageName {
                Color.clear.overlay(
                    Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(darken ? 0.5 : 1.0)
                    .transition(transition)
                    .animation(animation, value: imageName)
                ).edgesIgnoringSafeArea(.all)
            }

            // コンテンツを前面に表示
            content
        }
    }
}

extension View {
    /// 背景画像を適用するカスタムモディファイア
    /// - Parameters:
    ///   - imageName: Assets.xcassetsに登録された画像名（オプショナル）
    ///   - darken: 背景画像を暗くするかどうか
    /// - Returns: 背景が適用されたビュー
    func backgroundImage(_ imageName: String, darken: Bool = false) -> some View {
        self.modifier(BackgroundModifier(imageName: imageName, darken: darken))
    }

    /// 背景色を適応するカスタムモディファイア
    /// - Parameters:
    ///   - colorName: Assets.xcassetsに登録されたカラー名
    /// - Returns: 背景色が適用されたビュー
    func backgroundColor(_ colorName: String) -> some View {
        self.modifier(BackgroundModifier(colorName: colorName))
    }
}
