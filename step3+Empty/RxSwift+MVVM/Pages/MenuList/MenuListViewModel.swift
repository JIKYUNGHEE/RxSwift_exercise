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
    let menus: [Menu] = [
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김2", price: 100, count: 0),
        Menu(name: "튀김3", price: 100, count: 0),
        Menu(name: "튀김4", price: 100, count: 0),
        Menu(name: "튀김5", price: 100, count: 0),
        Menu(name: "튀김6", price: 100, count: 0)
    ]
    
    var itemCount: Int = 5
//    var totalPrice: Observable<Int> = Observable.just(10000)
    
    //Subject - 외부에서 값 통제 가능
    var totalPrice: PublishSubject<Int> = PublishSubject()
}
