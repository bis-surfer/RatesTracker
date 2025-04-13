//
//  ColorableViewModel.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 10.04.2025.
//

import Combine

class ColorableViewModel: ObservableObject {
    @Published var palette: Palette = Settings.shared.palette
    
    var cancellableBag = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        Settings.shared.$palette.sink(receiveValue: { [weak self] palette in
            self?.palette = palette
        })
        .store(in: &cancellableBag)
    }
}
