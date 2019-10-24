//
//  CelulaViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 07/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class CelulaViewController: UIViewController {


    //@IBOutlet weak var txtEmailLider: UITextField!
    @IBOutlet weak var txtnomeLider: UITextField!
    @IBOutlet weak var txtNomeAnfitriao: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
//    @IBOutlet weak var txtDia: UITextField!
//    @IBOutlet weak var txtHorario: UITextField!
//    @IBOutlet weak var txtEmailUsuario: UILabel!
    //var celula : [Celulas] = []
   var celula : [Celulas] = []

    func ValidaDados () -> Bool {
        var validaDados : Bool = false
        
        //if txtEmailLider.text != nil {validaDados=true} else {validaDados=false}
        if txtnomeLider.text != nil {validaDados=true} else {validaDados=false}
        if txtNomeAnfitriao.text != nil {validaDados=true} else {validaDados=false}
        if txtEndereco.text != nil {validaDados=true} else {validaDados=false}
       // if txtDia.text != nil {validaDados=true} else {validaDados=false}
       // if txtHorario.text != nil {validaDados=true} else {validaDados=false}
        
        return validaDados
    }
    
    @IBAction func vaiParaProximaTela(_ sender: Any) {
        
        if txtnomeLider.text!.isEmpty {
             exibeMensagemAlerta(titulo: "Erro.", mensagem: "Favor informar o Nome do Lider do Pequeno Grupo.")
           
        }else {
            if txtNomeAnfitriao.text!.isEmpty {
                exibeMensagemAlerta(titulo: "Erro.", mensagem: "Favor informar o Nome do Anfitrião do Pequeno Grupo.")
            } else {
                if txtEndereco.text!.isEmpty {
                    exibeMensagemAlerta(titulo: "Erro.", mensagem: "Favor informar o endereço do Pequeno Grupo.")
                } else {
                    performSegue(withIdentifier: "proximoTela", sender: nil)
                }
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.celula != nil {
            txtnomeLider.text = self.celula[0].nomeLider
            txtNomeAnfitriao.text = self.celula[0].nomeAnfitriao
            txtEndereco.text = self.celula[0].endCelula
        }else {
            print ("nada")
        }
    }
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destino = segue.destination as! SalvarCelularController
        if ValidaDados() == true {
       
        destino.txtnomeLider = txtnomeLider.text//self.txtnomeLider as? String
        destino.txtNomeAnfitriao = txtNomeAnfitriao.text//self.txtNomeAnfitriao as? String
        destino.txtEndereco = txtEndereco.text//self.txtEndereco as? String
        destino.celula = self.celula    
            
            
        }
        else {
            exibeMensagemAlerta(titulo: "Erro", mensagem:"Ha campos não preenchidos")
        }
    }
    
}


