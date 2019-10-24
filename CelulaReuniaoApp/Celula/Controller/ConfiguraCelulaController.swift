//
//  ConfiguraCelulaController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 04/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class ConfiguraCelulaController: UIViewController {

    @IBOutlet weak var txtNomeLider: UITextField!
    @IBOutlet weak var txtAnfitriao: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    var tipoGrupo : String?
    
    var celula : [Celulas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
   
    @IBAction func proximo(_ sender: Any) {
        
        if txtNomeLider.text!.isEmpty {
            exibeMensagemAlerta(titulo: "Erro.", mensagem: "Favor informar o Nome do Lider do Pequeno Grupo.")
        }else {
            if txtAnfitriao.text!.isEmpty {
                exibeMensagemAlerta(titulo: "Erro.", mensagem: "Favor informar o Nome do Anfitrião do Pequeno Grupo.")
            } else {
                if txtEndereco.text!.isEmpty {
                    exibeMensagemAlerta(titulo: "Erro.", mensagem: "Favor informar o endereço do Pequeno Grupo.")
                } else {
                    performSegue(withIdentifier: "proximaTela", sender: nil)
                }
            }
        }
    }
    
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func ValidaDados () -> Bool {
        var validaDados : Bool = false
        
        //if txtEmailLider.text != nil {validaDados=true} else {validaDados=false}
        if txtNomeLider.text != nil {validaDados=true} else {validaDados=false}
        if txtAnfitriao.text != nil {validaDados=true} else {validaDados=false}
        if txtEndereco.text != nil {validaDados=true} else {validaDados=false}
        // if txtDia.text != nil {validaDados=true} else {validaDados=false}
        // if txtHorario.text != nil {validaDados=true} else {validaDados=false}
        
        return validaDados
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destino = segue.destination as! SalvarGrupoController
        
        if ValidaDados() == true {
            destino.txtnomeLider = txtNomeLider.text//self.txtnomeLider as? String
            destino.txtNomeAnfitriao = txtAnfitriao.text//self.txtNomeAnfitriao as? String
            destino.txtEndereco = txtEndereco.text//self.txtEndereco as? String
            destino.celula = self.celula
            destino.tipoGrupo = self.tipoGrupo
        }
        else {
            exibeMensagemAlerta(titulo: "Erro", mensagem:"Ha campos não preenchidos")
        }
    }
    
    @IBAction func esconde_teclado(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func esconde_teclado_anf(_ sender: Any) {
        self.resignFirstResponder()
    }
    
 
    @IBAction func esconde_teclado_end(_ sender: Any) {
        self.resignFirstResponder()
    }
    
}
