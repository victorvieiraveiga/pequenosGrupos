//
//  Autenticacao.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 03/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class Autenticacao: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func VerificaUsuarioLogado () -> String {
        var logado : String = ""
        
        let autenticacao = Auth.auth()
        
        if let usuariologado = autenticacao.currentUser?.uid {
             logado = "logado"
        }
        else {
            logado = "desconectado"
        }
        return logado
    }

}
