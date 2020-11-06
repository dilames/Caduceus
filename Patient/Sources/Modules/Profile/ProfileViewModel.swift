//
//  ProfileViewModel.swift
//  Patient
//
//  Created by Andrew Chersky  on 5/30/18.
//

import Foundation
import Domain
import ReactiveSwift
import Result

final class ProfileViewModel: ViewModel {
    
    typealias SectionViewModels = [SectionViewModel<EmptySectionViewModel, ProfileCellViewModel>]
    typealias UseCases = HasCurrentUserUseCase
    typealias AdditionalInfoCellViewModels = (email: ProfileInfoCellViewModel,
        gender: ProfileInfoCellViewModel, birthDate: ProfileInfoCellViewModel)
    
    struct Input {
        let selectedIndexPaths: Signal<IndexPath, Never>
    }
    
    struct Output {
        let sectionViewModels: Property<SectionViewModels>
    }
    
    private let useCases: UseCases
    private let user: User
    
    init(useCases: UseCases, user: User) {
        self.useCases = useCases
        self.user = user
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            sectionViewModels: .init(value: sectionViewModels)
        )
    }
    
}

extension ProfileViewModel {
    private var sectionViewModels: SectionViewModels {
        return [
            .init(cells: [.mainInfo(mainInfoCellViewModel)]),
            .init(cells:
                [
                    .email(additionInfoCellViewModels.email),
                    .gender(additionInfoCellViewModels.gender),
                    .birthDate(additionInfoCellViewModels.birthDate)
                ])
        ]
    }
    
    private var mainInfoCellViewModel: MainInfoCellViewModel {
        let testURL = URL(string: "https://i.pinimg.com/736x/96/c1/77/96c177a8fd610c76394dd932aa6369a8--man-bun-undercut-men-haircut-undercut.jpg")
        let name = (user.firstName ?? "No name") + " " + (user.lastName ?? "")
        return MainInfoCellViewModel(
            imageURL: testURL,
            name: name,
            phone: user.phone ?? "Not specified")
    }
    
    private var additionInfoCellViewModels: AdditionalInfoCellViewModels {
        return (.init(icon: #imageLiteral(resourceName: "email-icon"), key: "Email", value: user.email ?? "Not specified"),
                .init(icon: #imageLiteral(resourceName: "gender-icon"), key: "Gender", value: "Male"),
                .init(icon: #imageLiteral(resourceName: "date-icon"), key: "Birth Date", value: "15th May"))
    }
}
