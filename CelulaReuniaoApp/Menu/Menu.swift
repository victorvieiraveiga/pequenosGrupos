//
//  Menu.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 30/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class Menu: UITableViewController {

    @IBOutlet weak var txtLogin: UILabel!
    
    @IBOutlet weak var iconLog: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let usuario = VerificaUsuarioLogado()
        
        if usuario == "logado" {
            self.txtLogin.text = "Logout"
            self.iconLog.image = UIImage(named: "exit24.png")
        }else {
            self.txtLogin.text = "Login"
            self.iconLog.image = UIImage(named: "login2.png")
        }
    }
    
    
    func Deslogar () {
       
        let autenticacao = Auth.auth()
        do {
            try autenticacao.signOut()
            //redireciona para tela de login
            //self.performSegue(withIdentifier: "voltaParaLogin", sender: nil)
        } catch  {
            print ("Erro ao Deslogar.")
        }
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


extension Menu {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 5:
            Deslogar()

        case 4:
            if self.txtLogin.text == "Logout" {
                Deslogar()
            }
    
        default:
            return
        }
        
        
        
        if indexPath.row == 5 {
            Deslogar()
            print (indexPath.row)
            exit(-1)
        }
        
        
    }
    

}
