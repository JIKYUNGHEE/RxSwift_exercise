//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"


class 나중에생기는데이터<T> {    //Observable<T>
    private let task: (@escaping (T) -> Void) -> Void
       
    init(task: @escaping (@escaping (T) -> Void) -> Void) {
        self.task = task
    }
    
    func 나중에오면(_ f: @escaping (T) -> Void) {    //subscribe
        task(f)
    }
}

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // RxSwift
    //비동기로 오는 데이터를 return 값으로 사용하고 싶어서
    
    //Observable의 생명주기
    // 1. Create
    // 2. Subscribe                 ------ 구독 되었을 떄, task 실행됨
    // 3. onNext / onError          ------ 데이터 전달됨
    // ----- 끝 -----(재사용 불가)
    // 4. onCompleted / onError
    // 5. Disposed
    
    func downloadJson(_ url: String) -> Observable<String?> {
        //1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
       return Observable.create() { emitter in
            let url = URL(string: url)!
                    //URLSession 은 main 스레드가 아닌, 다른 스레드
            let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
                guard err == nil else {
                    emitter.onError(err!)
                    return
                }
                
                if let dat = data, let json = String(data: dat, encoding: .utf8) {
                    emitter.onNext(json)
                }
            
                emitter.onCompleted()
            }
        task.resume()
        
        return Disposables.create() {
            task.cancel()
        }
    }
//        return Observable.create { f in
//            DispatchQueue.global().async {
//                let url = URL(string: url)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//                DispatchQueue.main.async {
//                    f.onNext(json)
//                }
//            }
//
//            return Disposables.create()
//        }
    }

    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
        //2. Observable로 오는 데이터를 받아서 처리하는 방법
        let disposable = downloadJson(MEMBER_LIST_URL)
            .debug()
            .subscribe { event in
                switch event {
                case let .next(json):
                    self.editView.text = json
                    self.setVisibleWithAnimation(self.activityIndicator, false)
                    //clouser 사라짐 -> reference count 사라짐
                case .completed:    //reference 없어짐
                    break
                case .error:        //reference 없어짐
                    break
                }
            }
        
        disposable.dispose()    // 이후에는 새로운 subscribe 가 있어야 실행(?) 가능 --- 재사용 불가
        
        
    }
}
