//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    let viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()
    
    let cellId = "MenuItemTableViewCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        
        viewModel.menuObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = "\(item.name)"
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
            }
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .scan(0,accumulator: +)
            .map{ $0.currencyKR() }
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .scan(0, accumulator: +)
            .map{ $0.currencyKR()}
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!

    @IBAction func onClear() {
    }

    @IBAction func onOrder(_ sender: UIButton) {        
        viewModel.itemCount
            .map{ "\($0)"}
            .subscribe(onNext: {
                self.itemCountLabel.text = $0
            })
            .disposed(by: disposeBag)
    }

}
//
//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menuObservable.
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let cellMenu = viewModel.menus[indexPath.row]
//        cell.title.text = "MENU \(cellMenu.name)"
//        cell.price.text = "\(cellMenu.price)"
//        cell.count.text = "\(cellMenu.count)"
//
//        return cell
//    }
//}
