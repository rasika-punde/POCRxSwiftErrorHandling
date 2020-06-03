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

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllTracks()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (result) in
            print(result)
        })
        .disposed(by: disposeBag)
    }
}

