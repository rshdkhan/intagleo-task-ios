//
//  HomeViewPresenter.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import Foundation

struct UIModel {
    var albumId: Int?
    var items: [Item]?
}

final class HomeViewPresenter {
    var homeView: IHomeView!
    
    init(homeView: IHomeView) {
        self.homeView = homeView
    }
    
    func getPhotoes() {
        self.homeView.showLoader()
        
        PhotoRepositories.getAll { (response) in
            self.homeView.hidLoader()
            
            switch response.status {
            case .success:
                guard let photoes = response.data else {
                    self.homeView.showErrorMessage(errorMessage: "")
                    return
                }
                
                let groupByAlbumId = Dictionary(grouping: photoes) { $0.albumId }
                
                var viewModel = [UIModel]()
                for item in groupByAlbumId {
                    viewModel.append(UIModel(albumId: item.key, items: item.value))
                }
                
                self.homeView.displayPhotoes(photoes: viewModel)
                break
                
            case .failure:
                self.homeView.showErrorMessage(errorMessage: response.failureMsg ?? "Oops something went wrong.")
                break
            }
        }
    }
}
