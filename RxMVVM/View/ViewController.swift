//
//  ViewController.swift
//  RxMVVM
//
//  Created by Oğuzhan Abuhanoğlu on 4.11.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
   
    let tableView = UITableView()
    
    var cryptoList = [Crypto]()
    
    let cryptoVM = cryptoViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRect(x: 0, y: 0, width: widht, height: height)
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        setupBindings()
        cryptoVM.requestData()
        
        /*
        --- bu kodla webservice in çalıstıgını test ettik.şimdi mvvm ve rx kullanarak view modelle yapıp öyle devam edeceğiz.yani altaaki kodu ciewmodele taşıyacağız.----çünkü bu kısım mvvm de sadece kullanıcının göreceğği işlemleri içermeli bu data işlemini burdan alacağız.
         
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!
        Webservice().downloadCurrencies(url: url) { result in
            switch result{
            case .success(let cryptos):
                self.cryptoList = cryptos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }*/
    }
    
    
    private func setupBindings() {
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }.disposed(by: disposeBag)
        
        //bu niye çalışmadı anlamadım
        /*cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.cryptoList = cryptos
                self.tableView.reloadData()
            }.disposed(by: disposeBag)*/
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { event in
                if let cryptos = event.element {
                    self.cryptoList = cryptos
                    self.tableView.reloadData()
                } else if let error = event.error {
                    print("Bir hata oluştu: \(error)")
                }
            }.disposed(by: disposeBag)

            
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        //content.text = "cryptoName"
        //content.secondaryText = "price"
        
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
        
    }
    

}

