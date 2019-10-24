//
//  SalvarGrupoController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 04/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class SalvarGrupoController: UIViewController, UIPickerViewDelegate,  UIPickerViewDataSource {
    
    
    @IBOutlet weak var diaEscolhido: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var txtHorario: UITextField!
    
    
    var txtEmailLider : String?
    var txtnomeLider : String?
    var txtEndereco: String?
    var txtNomeAnfitriao: String?
    var diaSelecionado : String?
    var tipoGrupo : String?
    
    let datasource = ["Segunda", "Terça", "Quarta","Quinta","Sexta", "Sábado", "Domingo"]
    var celula : [Celulas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CriaDiaPicker ()
        CriaTollBar ()
    }
    func ValidaDados () -> Bool {
        var validaDados : Bool = false
        if txtHorario.text != nil {validaDados=true} else {validaDados=false}
        return validaDados
    }

    func incluir_celula () {
        let autenticacao = Auth.auth() //inicio - pega o usuario logado
        //autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            let usuarioLogado = autenticacao.currentUser?.uid
            
            //inicio - salva usuarios no banco de dados do firebase
            // if self.ValidaDados () {
            let database = Database.database().reference()
            
            //pega dados do usuario logado - email e nome
           // let usuarios = database.child("usuarios").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            //usuarios.observe(DataEventType.childAdded, with: {(usuarioRecuperado) in
                //let usuDados = usuarioRecuperado.value as! NSDictionary
                //if let idUsuario = usuDados.value(forKey: "email") {
               //     self.txtEmailLider = idUsuario as! String
               // }
                //let nomeUsuario = usuDados.value(forKey: "nome")
           
            let celulas = database.child("usuarios")
        let grupos = database.database.reference()
            //let usuario = database.child("usuarios")
                
        let celulaDados = [ "lider" : self.txtnomeLider , "anfitriao": self.txtNomeAnfitriao, "endereco": self.txtEndereco, "dia": self.diaEscolhido.text, "horario" : self.txtHorario.text, "tipoGrupo" : self.tipoGrupo] as [String : Any]
            
        celulas.child(usuarioLogado!).child("grupo").childByAutoId().setValue(celulaDados)
        celulas.child(usuarioLogado!).child("temCelula").setValue("S")
        grupos.child("grupos").child(usuarioLogado!).childByAutoId().setValue(celulaDados)
        
        
        //usuario.child(usuarioLogado!).child("temCelula").setValue("S")
    
        self.performSegue(withIdentifier: "grupoSegueRetorno", sender: nil)
           // })
       // }//fim - pega usuario logado
    }

    @IBAction func salvar(_ sender: Any) {
         incluir_celula()
    }
    
    func CriaDiaPicker () {
        let diaPicker = UIPickerView()
        diaPicker.delegate = self as! UIPickerViewDelegate
        
        self.diaEscolhido.inputView = diaPicker
    }
    
    func CriaTollBar () {
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let botaoOk = UIBarButtonItem(title: "OK", style: .done, target: self, action:#selector(self.dismissKeyboard))
        toolBar.setItems([botaoOk], animated: false)
        toolBar.isUserInteractionEnabled = true
        diaEscolhido.inputAccessoryView = toolBar
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        diaSelecionado = datasource[row]
        diaEscolhido.text = diaSelecionado
    }
    
    
    @IBAction func esconder_teclado_hor(_ sender: Any) {
        self.resignFirstResponder()
    }
    
}
