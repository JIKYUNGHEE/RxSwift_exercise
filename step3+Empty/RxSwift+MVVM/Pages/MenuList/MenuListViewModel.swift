//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 지경희 on 2021/04/02.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MenuListViewModel {
    
//    lazy var menuObservable = PublishSubject<[Menu]>()
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
//    lazy var menuObservable = BehaviorRelay<[Menu]>(value: [])
    
    init() {
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response:Decodable {
                    let menus:[MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus:[Menu] = []
                menuItems.enumerated().forEach { (index, item) in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
               return menus
            }
            .take(1)
            .bind(to: menuObservable)
    }
    
    lazy var itemCount = menuObservable.map {
        $0.map{ $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {
        $0.map{ $0.price * $0.count }.reduce(0, +)
    }
    
    func clearAllItemSelected() {
        _ = menuObservable
            .map { menus in
                menus.map { menu in
                    Menu(id: menu.id, name: menu.name, price: menu.price, count: 0)
                }
            }
            .take(1)    //1번만 수행할거다.
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { menu in
                    if menu.id == item.id {
                        return Menu(id: menu.id, name: menu.name, price: menu.price, count: menu.count + increase)
                    } else {
                        return Menu(id: menu.id, name: menu.name, price: menu.price, count: menu.count)
                    }
                }
            }
            .take(1)    //1번만 수행할거다.
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func onOrder() {
        
    }
}
