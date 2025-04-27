//
//  MakeAlarmViewModel.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/27/25.
//

final class MakeAlarmViewModel {
    
    enum Mode{
        case createMode
        case editMode
    }
    
    var mode : Mode
    
    //MARK: - Input
    
    //MARK: - Output

    //MARK: - Init
    init(mode: Mode) {
        self.mode = mode
        
    }

}
