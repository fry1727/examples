//
//  PrefereSelectableView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 10.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct PrefereSelectableView: View {
    @Binding var selectedOption: RegestrationPreference

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(RegestrationPreference.allCases, id: \.self) { preference in
                SelectableView(
                    text: preference.description,
                    isSelected: selectedOption == preference, action: {
                        selectedOption = preference
                    }
                )
            }
        }
    }
}

struct PrefereSelectableViewPreview: View {
    @State private var selectedOption: RegestrationPreference = .manSeekingWoman
    var body: some View {
        PrefereSelectableView(selectedOption: $selectedOption)
    }
}

struct PrefereSelectableView_Previews: PreviewProvider {
    static var previews: some View {
        PrefereSelectableViewPreview()
    }
}
