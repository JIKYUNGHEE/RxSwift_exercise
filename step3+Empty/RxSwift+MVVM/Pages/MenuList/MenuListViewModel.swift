//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 지경희 on 2021/04/02.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
//    lazy var menuObservable = PublishSubject<[Menu]>()
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    init() {
        let menus: [Menu] = [
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김2", price: 100, count: 0),
            Menu(name: "튀김3", price: 100, count: 0),
            Menu(name: "튀김4", price: 100, count: 0),
            Menu(name: "튀김5", price: 100, count: 0),
            Menu(name: "튀김6", price: 100, count: 0)
        ]
        menuObservable.onNext(menus)
    }
    
    lazy var itemCount = menuObservable.map {
        $0.map{ $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {
        $0.map{ $0.price * $0.count }.reduce(0, +)
    }
}
