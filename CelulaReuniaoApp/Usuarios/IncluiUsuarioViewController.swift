//
//  IncluiUsuarioViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 31/07/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import CoreData

class IncluiUsuarioViewController: UIViewController {
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    
    var context : NSManagedObjectContext!
    var usuario : NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if usuario != nil {
            if let nome = usuario.value(forKey: "nome") {
                self.txtNome.text = String(describing: nome)
            }
        
            if let login = usuario.value(forKey: "login") {
                self.txtUsuario.text = String(describing: login)
            }
            if let senha = usuario.value(forKey: "senha") {
                self.txtSenha.text = String(describing:senha )
            }
        }
        else {
            txtNome.text = ""
            txtUsuario.text = ""
            txtSenha.text = ""
        }
    }
    
    
    func AlteraUsuario () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if usuario != nil {
               usuario.setValue(self.txtNome.text, forKey: "nome")
               usuario.setValue(self.txtUsuario.text, forKey: "login")
               usuario.setValue(self.txtSenha.text, forKey: "senha")
            do {
                try context.save()
                print ("Sucesso")
                self.navigationController?.popToRootViewController(animated: true)
            } catch let erro as Error {
                print ("Erro ao atualizar. \(erro.localizedDescription) ")
            }
        }else {
            print ("Erro!!!")
        }
    }
    
    @IBAction func IncluiUsuario(_ sender: Any) {
        if usuario != nil {
            self.AlteraUsuario()
        }else {
            self.SalvarUsuario()
        }
    }
    
    func SalvarUsuario () {
        
        var validaUsuario : Bool = false
        
        //Cria objetos conexao
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let usuario = NSEntityDescription.insertNewObject(forEntityName: "Usuarios", into: context)
        
        //configura objeto
        usuario.setValue(txtNome.text, forKey: "nome")
        usuario.setValue(txtUsuario.text, forKey: "login")
        usuario.setValue(txtSenha.text, forKey: "senha")
        
        //persistir dados
        
        do {
            
            if (txtNome.text!.isEmpty) {
                print ("Digite o Nome do Usuario")
                validaUsuario = false
            }
            else{validaUsuario = true}
            
            if (txtUsuario.text!.isEmpty) {
                print ("Digite o Login")
                validaUsuario = false
            }
            else {validaUsuario = true}
            if (txtSenha.text!.isEmpty){
                print ("Digite a Senha")
                validaUsuario = false
            }else {
                validaUsuario = true
            }
            
            if validaUsuario {
                try context.save()
                print("Dados Salvos")
                txtNome.text = ""
                txtUsuario.text = ""
                txtSenha.text = ""
                 self.performSegue(withIdentifier: "CadastroLoginSegue", sender: nil)
            }
        }catch {
            print ("Erro ao salvar dados")
        }
    }
}
