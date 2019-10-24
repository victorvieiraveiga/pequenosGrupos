//
//  TipoGrupoController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 28/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class TipoGrupoController: UIViewController, UIPickerViewDelegate,  UIPickerViewDataSource {
    

    @IBOutlet weak var txtTipoEscolhido: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var datasource : [String] = []
    var tipoSource : [TipoGrupo] = []
    
    var tipoSelecionado : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        let usuarioLogado = autenticacao.currentUser?.uid
        
        let dataBase = Database.database().reference()
        
        let tipoGrupoDado = dataBase.child("usuarios").child(usuarioLogado!).child("tipoGrupo")
        
        tipoGrupoDado.observe(DataEventType.childAdded) { (snapShot) in
            let grupoDados = snapShot.value as! NSDictionary
            let nomeTipoGrupo = grupoDados["nome"]
            let tipoGrupo = TipoGrupo(nome: nomeTipoGrupo as! String)
            self.tipoSource.append(tipoGrupo)
           
            self.pickerView.reloadAllComponents()
        }
        
        
        CriaTipoPicker()
        CriaTollBar()

    
    } //fim didiLoad
    
    func CriaTipoPicker () {
        let tipoPicker = UIPickerView()
        tipoPicker.delegate = self as! UIPickerViewDelegate
        
        self.txtTipoEscolhido.inputView = tipoPicker
    }
    
    func CriaTollBar () {
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let botaoOk = UIBarButtonItem(title: "OK", style: .done, target: self, action:#selector(self.dismissKeyboard))
        toolBar.setItems([botaoOk], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtTipoEscolhido.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
//        if tipoSource.count > 0 {
//           return tipoSource.count
//        }else {
//             self.performSegue(withIdentifier: "defineTipoSegue", sender: nil)
//        }
        return tipoSource.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //return datasource[row]
        return tipoSource[row].nome
    
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        tipoSelecionado = tipoSource[row].nome
        txtTipoEscolhido.text = tipoSelecionado
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "grupoSegue" as String {
            let Destino = segue.destination as! ConfiguraCelulaController
            
            Destino.tipoGrupo = txtTipoEscolhido.text
        }
    }
    
}



