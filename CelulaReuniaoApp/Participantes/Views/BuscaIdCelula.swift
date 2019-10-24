//
//  BuscaIdCelula.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 19/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class BuscaIdCelula: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func BuscaCelulaId () -> String {
        var idCelula : String = ""
        //Carregar o id da celula do usuario logado
        var autenticacao = Auth.auth()
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            let usuarioLogado = usuario?.uid
            let database = Database.database().reference()
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            
            celula.observe(DataEventType.childAdded, with: { (CelulaSnapshot) in
                let dadosCel = CelulaSnapshot.value as! NSDictionary
                do {
                    idCelula = dadosCel["idCelula"] as! String
                }
                catch {
                    print ("Erro")
                }
            })
            
            
        }
        
        return idCelula
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
