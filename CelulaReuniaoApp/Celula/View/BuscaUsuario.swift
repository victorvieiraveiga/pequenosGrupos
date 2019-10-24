//
//  BuscaIdUsuario.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 14/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase


public class BuscaUsuario: UIViewController {
    var emailUsuario = String ()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
     func BuscaIdUsuarioLogado () -> String {
        
        let autenticacao = Auth.auth() //inicio - pega o usuario logado
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            let usuarioLogado = usuario
            
        let database = Database.database().reference()
        
        //pega dados do usuario logado - email e nome
        let usuarios = database.child("usuarios").queryOrderedByKey().queryEqual(toValue: usuarioLogado?.uid)
        usuarios.observe(DataEventType.childAdded, with: {(usuarioRecuperado) in
            let usuDados = usuarioRecuperado.value as! NSDictionary
            if let idUsuario = usuDados.value(forKey: "email") {
                 let emailUsuRecuperado = idUsuario as! String
            
            let nomeUsuario = usuDados.value(forKey: "nome")
            print (emailUsuRecuperado + "  ##### teste" )
                self.emailUsuario = emailUsuRecuperado
                print (self.emailUsuario + " testando #########")
                
            }
        })
            
        }
        print (self.emailUsuario)
        print ("##### email do usuario ########")
       return self.emailUsuario
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
