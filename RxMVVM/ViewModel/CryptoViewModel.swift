//
//  CryptoViewModel.swift
//  RxMVVM
//
//  Created by Oğuzhan Abuhanoğlu on 4.11.2023.
//

import Foundation
import RxCocoa
import RxSwift

class cryptoViewModel {
    
    // kullanıcıyla etkilesime geçmesi gereken verileri bu değişkenlerde tuttuk
    let cryptos : PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    //bu veriyi alip viewcontrollera göndermemiz için 3 temel yaklasım var 1)rx swift 3) combine framework 3) delegate pattern
    func requestData(){
        
        self.loading.onNext(true)
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!
        Webservice().downloadCurrencies(url: url) { result in
            self.loading.onNext(false)
            switch result{
            case .success(let cryptos):
                self.cryptos.onNext(cryptos)
                
            case .failure(let error):
                switch error {
                case .parsingError:
                    self.error.onNext("Parsing error")
                    
                case .serverError:
                    self.error.onNext("Server error")
                }
            }
        }
    
    }

}
