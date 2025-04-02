//
//  ViewRouter.swift
//  CustomTabBar
//
// Created by BLCKBIRDS
// Visit BLCKBIRDS.COM FOR MORE TUTORIALS

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .shops
    
}


enum Page {
    case shops
    case offer
    case order
    case account
}
