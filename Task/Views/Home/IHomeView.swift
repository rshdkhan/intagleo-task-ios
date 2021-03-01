//
//  IHomeView.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import Foundation

protocol IHomeView {
    func displayPhotoes(photoes: [UIModel])
    func showLoader()
    func hidLoader()
    func showErrorMessage(errorMessage: String)
}
