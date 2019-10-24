//
//  SalvarCelularController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 31/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class SalvarCelularController: UIViewController, UIPickerViewDelegate,  UIPickerViewDataSource {

    @IBOutlet weak var diaEscolhido: UITextField!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var txtHorario: UITextField!
    
    var txtEmailLider : String?
    var txtnomeLider : String?
    var txtEndereco: String?
    var txtNomeAnfitriao: String?
    
    var diaSelecionado : String?
    let datasource = ["Segunda", "Terça", "Quarta","Quinta","Sexta", "Sábado", "Domingo"]
    var celula : [Celulas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if celula[0].nomeLider != nil {
            diaEscolhido.text = celula[0].diaCelula
            txtHorario.text = celula[0].horarioCelula
            
        }
        
        CriaDiaPicker ()
        CriaTollBar ()
        
    }
    
    func ValidaDados () -> Bool {
        var validaDados : Bool = false
         if txtHorario.text != nil {validaDados=true} else {validaDados=false}
         return validaDados
    }
    
    func alterar_celula () {
        
        let aute = Auth.auth()
        
        guard let usuarioLogado = aute.currentUser?.uid else { return  }
        
        let database = Database.database().reference()
        let celulaData = database.child("celula")
        let usuario = database.child("usuario")
        
        guard let dia = diaEscolhido.text else {return}
        guard let horario = txtHorario.text else {return}
        
         let tipoGrupo = ""
        
        let celulaDados = ["lider" : self.txtnomeLider, "anfitriao" :self.txtNomeAnfitriao, "endereco" : txtEndereco, "dia" : dia, "horario": horario, "tipoGrupo": tipoGrupo] as [String : Any]
        
//                let celulaDados = ["lider" : self.txtnomeLider, "anfitriao" :self.txtNomeAnfitriao, "endereco" : txtEndereco, "dia" : dia, "horario": horario, "idCelula" : celula[0].uidCelula , "idUsuario" : celula[0].idUsuario] as [String : Any]
        
        celulaData.child(usuarioLogado).setValue(celulaDados)
        usuario.child(usuarioLogado).child("temCelula").setValue("S")
        
        self.performSegue(withIdentifier: "voltaPrincipal", sender: nil)
        
        
    }
    
    func incluir_celula () {
        let autenticacao = Auth.auth() //inicio - pega o usuario logado
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            let usuarioLogado = usuario
            
            //inicio - salva usuarios no banco de dados do firebase
            // if self.ValidaDados () {
            let database = Database.database().reference()
            
            //pega dados do usuario logado - email e nome
            let usuarios = database.child("usuarios").queryOrderedByKey().queryEqual(toValue: usuarioLogado?.uid)
            usuarios.observe(DataEventType.childAdded, with: {(usuarioRecuperado) in
                let usuDados = usuarioRecuperado.value as! NSDictionary
                if let idUsuario = usuDados.value(forKey: "email") {
                    self.txtEmailLider = idUsuario as! String
                    print (idUsuario)
                    print ("#####################")
                }
                let nomeUsuario = usuDados.value(forKey: "nome")

            let celulas = database.child("celula")
            let usuario = database.child("usuarios")
            let celulaDados = ["idCelula" : self.txtEmailLider, "lider" : self.txtnomeLider , "anfitriao": self.txtNomeAnfitriao, "endereco": self.txtEndereco, "dia": self.diaEscolhido, "horario" : self.txtHorario.text, "idUsuario": self.txtEmailLider] as [String : Any]
            
            celulas.child(usuarioLogado!.uid).setValue(celulaDados)
            usuario.child(usuarioRecuperado.key).child("temCelula").setValue("S")
            self.exibeMensagemAlerta(titulo: "Sucesso.", mensagem: "Usuario cadastrado com sucesso.")
            self.performSegue(withIdentifier: "voltaPrincipal", sender: nil)
            })
        }//fim - pega usuario logado
        
    }

    @IBAction func salvar_celula(_ sender: Any) {
        
        if self.celula.count > 0 {
            alterar_celula()
        }else {
            incluir_celula()
        }
        
        
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
    
}
