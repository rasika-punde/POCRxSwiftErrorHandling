//
//  ViewController.swift
//  POCRxSwiftErrorHandling
//
//  Created by Punde, Rasika Nanasaheb on 03/06/20.
//  Copyright © 2020 Punde, Rasika Nanasaheb (US - Mumbai). All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    let resources = Resources.total

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewModel().xyz()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (result) in
            print(result)
            print("Resource count \(self?.resources)")
        }).disposed(by: disposeBag)
    }
}
