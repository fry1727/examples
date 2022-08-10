//
//  RegistrationPhotoRulesView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct PhotoRulesViewModel {
    struct Rule: Hashable {
        let text: String
        let type: PhotoRuleType
    }

    let textRules: [Rule] =
        [Rule(text: L10n.uploadClearPhotoShowingYourFace, type: .accepted),
         Rule(text: L10n.uploadPhotoThatShowsYourInterests, type: .accepted),
         Rule(text: L10n.nudityOrPornographyAreProhibited, type: .declined)]

    var imageRules: [Rule] {
        [Rule(text: sex == .male ? "manRuleOne" : "womanRuleOne", type: .accepted),
         Rule(text: sex == .male ? "manRuleTwo" : "womanRuleTwo", type: .accepted),
         Rule(text: sex == .male ? "manRuleThree" : "womanRuleThree", type: .declined)]
    }

    let sex: SexEnum
}

struct PhotoRulesView: View {
    private let viewModel: PhotoRulesViewModel

    init(sex: SexEnum) {
        viewModel = PhotoRulesViewModel(sex: sex)
    }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.textRules, id: \.self) { rule in
                PhotoTextRuleView(text: rule.text, type: rule.type)
            }

            imageRules()
        }
    }

    private func imageRules() -> some View {
        HStack(spacing: 8) {
            ForEach(viewModel.imageRules, id: \.self) { rule in
                PhotoImageRuleView(imageName: rule.text, type: rule.type)
            }
        }.padding(.top, 8)
    }
}

struct RegistrationPhotoRulesView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRulesView(sex: .male)
    }
}
