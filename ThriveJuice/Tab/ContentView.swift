//
//  ContentView.swift
//  CustomTabBar
//
// Created by BLCKBIRDS
// Visit BLCKBIRDS.COM FOR MORE TUTORIALS

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    @State var showPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .shops:
                    Text("Shop")
                case .offer:
                    Text("Offers")
                case .order:
                   Text("Orders")
                case .account:
                    Text("Account")
                }
                Spacer()
                ZStack {
                    if showPopUp {
                        PlusMenu(widthAndHeight: geometry.size.width/7)
                            .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .shops, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "ShopSelected", tabName: "Shop")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .offer, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "OffersSelected", tabName: "Offers")
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image("Cart1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65.0 , height: 65.0)
                                .foregroundColor(Color("White"))
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/8/2)
                            .onTapGesture {
                                withAnimation {
                                    showPopUp.toggle()
                                }
                            }
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .order, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "OrdersSelected", tabName: "Orders")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .account, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "AccountSelected", tabName: "Account")
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height/8)
                    .background(Color("TabBarBackground").shadow(radius: 2))
                }
            }
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .preferredColorScheme(.light)
    }
}

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color("White"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "record.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .foregroundColor(Color("White"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
        }
            .transition(.scale)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String

    var body: some View {
        VStack {
            Image(systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
            .padding(.horizontal, -4)
            .onTapGesture {
                viewRouter.currentPage = assignedPage
            }
            .foregroundColor(viewRouter.currentPage == assignedPage ? Color("TabBarHighlight") : .gray)
    }
}
