//
//  SalvarTipoGrupo.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 29/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class SalvarTipoGrupo: UIViewController {

    @IBOutlet weak var txtNomeGrupo: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func salvar_grupo(_ sender: Any) {
        
        let database = Database.database().reference()
        let autenticacao = Auth.auth()
        let usuarioLogado = autenticacao.currentUser?.uid
        
        
        let tipoGrupo = database.child("usuarios").child(usuarioLogado!).child("tipoGrupo")
        
        
        if self.txtNomeGrupo.text != nil {
            let tipoGrupoDados = ["nome": self.txtNomeGrupo.text]
            
            tipoGrupo.childByAutoId().setValue(tipoGrupoDados)
            
            self.txtNomeGrupo.text = ""
            self.performSegue(withIdentifier: "voltaTipoSegue", sender: nil)
            
    }else {
            exibeMensagemAlerta(titulo: "Erro.", mensagem: "Digite o nome do Tipo do Pequeno Grupo")
        }
    }
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
