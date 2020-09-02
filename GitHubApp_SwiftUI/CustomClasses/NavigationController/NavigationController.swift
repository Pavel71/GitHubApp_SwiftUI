//
//  NavigationController.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 02.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//



import SwiftUI


// MARK: - Views

struct NavControllerView<Content>: View where Content: View{
    
    @ObservedObject private var viewModel: NavControllerViewModel
    
    private let content: Content
    private let transitions: (push: AnyTransition, pop: AnyTransition)
    
    init(transition: NavTransition,
         easing: Animation = .easeOut(duration: 0.33),
         @ViewBuilder content: @escaping () -> Content)
    {
        self.viewModel = NavControllerViewModel(easing: easing)
        self.content = content()
        switch transition {
        case .custom(let trans):
            self.transitions = (trans, trans)
        case .none:
            self.transitions = (.identity, .identity)
        /*default:
            self.transitions = (.identity, .identity)*/
        }
    }
    
    var body: some View {
        let isRoot = viewModel.currentScreen == nil
        return ZStack {
            if isRoot {
                content
                    .transition(viewModel.navigationType == .push ? transitions.push : transitions.pop )
                    .environmentObject(viewModel)
            } else {
                viewModel.currentScreen!.nextScreen
                    .transition(viewModel.navigationType == .push ? transitions.push : transitions.pop )
                    .environmentObject(viewModel)
            }
        }
    }
    
}

struct NavPushButton<Label, Destination>: View where Label: View, Destination: View {
    
    @EnvironmentObject private var viewModel: NavControllerViewModel
    
    private let destination: Destination
    private let label: Label

    init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        label.onTapGesture {
            self.push()
        }
    }
    
    private func push() {
        self.viewModel.push(self.destination)
    }
}

struct NavPopButton<Label>: View where Label: View {
    
    @EnvironmentObject private var viewModel: NavControllerViewModel
    
    private let destination: PopDestination
    private let label: Label
    
    init(destination: PopDestination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        label.onTapGesture {
            self.pop()
        }
    }
    
    private func pop() {
        viewModel.pop(to: destination)
    }
    
}

// MARK: - Enums

enum NavTransition {
    case none
    case custom(AnyTransition)
}

enum NavType {
    case push
    case pop
}

enum PopDestination {
    case previous
    case root
}

// MARK: - Logic

// Model Node of Screen
private struct Screen: Identifiable, Equatable {
    
    let id: String
    let nextScreen: AnyView
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}

final class NavControllerViewModel: ObservableObject {
    
    private let easing: Animation
    
    var navigationType = NavType.push
    
    @Published fileprivate var currentScreen: Screen?
    private var screenStack = ScreenStack() {
        didSet {
            currentScreen = screenStack.top()
        }
    }
    
    // Init
    
    init(easing: Animation) {
        self.easing = easing
    }
    
    // API
    
    func push<S: View>(_ screenView: S) {
        withAnimation(easing) {
            navigationType = .push
            let screen = Screen(id: UUID().uuidString, nextScreen: AnyView(screenView))
            screenStack.push(screen)
        }
    }
    
    func pop(to: PopDestination = .previous) {
        withAnimation(easing) {
            navigationType = .pop
            switch to {
            case .root:
                screenStack.popToRoot()
            case .previous:
                screenStack.popToPrevious()
            /*default:
                screenStack.popToPrevious()*/
            }
        }
    }
    
    // Nested Stack Model
    
    private struct ScreenStack {
        
        private var screens = [Screen]()
        
        func top() -> Screen? {
            screens.last
        }
        
        mutating func push(_ s:Screen) {
            screens.append(s)
        }
        
        mutating func popToPrevious() {
            _ = screens.popLast()
        }
        
        mutating func popToRoot() {
            screens.removeAll()
        }
    }
}
