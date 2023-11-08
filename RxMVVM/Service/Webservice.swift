//
//  Webservice.swift
//  RxMVVM
//
//  Created by Oğuzhan Abuhanoğlu on 4.11.2023.
//

import Foundation

//problemi adim adim debug etmek için enum yapısı kullandık
enum CryptoError : Error {
    case serverError
    case parsingError
}

class Webservice {
    
    // download currency fonksiyonunu özelleştirdik kendi completion bloklu özel fonksiyonumuz haline getirdik.Escaping burda anladığım kadarıyla bu yazımın bir kuralı.Hemen altında duran dataTask closure ı gibi bir yazım olusturduk ve result değerlerini listeleyen bir enum yapısı yazdık.Aslında hatanın server error u parsing error mu oldugunu loglardan okuyabilmek için.
    
    func downloadCurrencies(url : URL, completion : @escaping (Result<[Crypto],CryptoError>) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            //oluşturduğumuz completion blok kontrollerini gerçeklştirdiğimiz kod bloğu
            if let error = error {
                completion(.failure(.serverError))
            }else if let data = data{
                
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                //crypto listi optionaldan cıkarmak için
                if let cryptoList = cryptoList {
                    completion(.success(cryptoList))
                }else{
                    completion(.failure(.parsingError))
                }
                

                
            }
            
            
        }.resume()
    }
    
    
}




