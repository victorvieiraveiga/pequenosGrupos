//
//  IncluiParticipantesViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 05/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class IncluiParticipantesViewController: UIViewController {

    @IBOutlet weak var txtIdCelula: UILabel!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var dtDataNascimento: UIDatePicker!
    
    @IBOutlet weak var btnSeleFoto: UIButton!
    @IBOutlet weak var btnSelefoto: UIButton!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var lblCarregando: UILabel!
    
//    var context : NSManagedObjectContext!
//    var participante : NSManagedObject!
    var participante : [Participante] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var autenticacao = Auth.auth()
        
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            let usuarioLogado = usuario?.uid
            
            let database = Database.database().reference()
            
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            
            celula.observe(DataEventType.childAdded, with: { (CelulaSnapshot) in
            
                let dadosCel = CelulaSnapshot.value as! NSDictionary
                
                do {
                    self.txtIdCelula.text = dadosCel["idCelula"] as! String
                }
                catch {
                    print ("Erro")
                }
                
            })
            
   

//        if participante != nil {
//            if let nome = participante.value(forKey: "nome") {
//                self.txtNome.text = String(describing: nome)
//            }
//
//            if let endereco = participante.value(forKey: "endereco") {
//                self.txtEndereco.text = String(describing: endereco)
//            }
//            if let telefone = participante.value(forKey: "telefone") {
//                self.txtTelefone.text = String(describing:telefone )
//            }
//
//            if let email = participante.value(forKey: "email") {
//                self.txtEmail.text = String(describing:email )
//            }
//
//            if let dataNascimento = participante.value(forKey: "dataNascimento") {
//                self.dtDataNascimento.date = dataNascimento as! Date
//            }
//        }
//        else {
//            txtNome.text = ""
//            txtEndereco.text = ""
//            txtTelefone.text = ""
//            txtEmail.text = ""
//            dtDataNascimento.date = Date()
        //}
    }
    
//    func exibeMensagemAlerta (titulo: String, mensagem:String){
//        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
//        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
//        myAlert.addAction(oKAction)
//        self.present(myAlert, animated: true, completion: nil)
//    }
    
  //  @IBAction func SalvarParticipante(_ sender: Any) {
//        if participante != nil {
//            AlteraParticipante()
//        }else {
//           self.Salvar()
//        }
//    }
    
    func AlteraParticipante () {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        if participante != nil {
//            participante.setValue(self.txtNome.text, forKey: "nome")
//            participante.setValue(self.txtEndereco.text, forKey: "endereco")
//            participante.setValue(self.txtTelefone.text, forKey: "telefone")
//            participante.setValue(self.txtEmail.text, forKey: "email")
//            participante.setValue(self.dtDataNascimento.date, forKey: "dataNascimento")
//            do {
//                try context.save()
//                exibeMensagemAlerta (titulo: "Sucesso", mensagem: "Alteração realizada.")
//                self.navigationController?.popToRootViewController(animated: true)
//            } catch let erro as Error {
//                print ("Erro ao atualizar. \(erro.localizedDescription) ")
//            }
//        }else {
//            exibeMensagemAlerta (titulo: "Erro", mensagem: "Erro.")
//        }
    }

    func Salvar () {
       // var validaUsuario : Bool = false
        
        let autenticacao = Auth.auth()
        
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            let usuarioLogado = usuario?.uid
            
            let database = Database.database().reference()
            
            let participantes = database.child("participantes")
            
            let participanteDados = ["idCelula" : self.txtIdCelula.text, "nome" : self.txtNome.text, "endereco" : self.txtEndereco.text, "email" : self.txtEmail.text, "telefone" : self.txtTelefone.text, "dataNascimento" : self.dtDataNascimento.date] as! [String : Any]
            
            do {
                participantes.child(usuarioLogado!).setValue(participanteDados)
                self.exibeMensagemAlerta(titulo: "Sucesso.", mensagem: "Participante cadastrada com sucesso.")
            }
            catch {
                self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Erro ao salvar participante.")
            }
            
        }
        
        
//        //Cria objetos conexao
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let participante = NSEntityDescription.insertNewObject(forEntityName: "Participantes", into: context)
//
//        //configura objeto
//        participante.setValue(txtNome.text, forKey: "nome")
//        participante.setValue(txtEndereco.text, forKey: "endereco")
//        participante.setValue(txtTelefone.text, forKey: "telefone")
//        participante.setValue(txtEmail.text, forKey: "email")
//        participante.setValue(dtDataNascimento.date, forKey: "dataNascimento")
//
//        //persistir dados
//
//        do {
//
//            if (txtNome.text!.isEmpty) {
//                exibeMensagemAlerta (titulo: "Dado Invalido.", mensagem: "Preencha o Nome do Usuario.")
//                validaUsuario = false
//            }
//            else{validaUsuario = true}
//
//            if (txtEndereco.text!.isEmpty) {
//                exibeMensagemAlerta (titulo: "Dado Invalido.", mensagem: "Preencha o Login.")
//                validaUsuario = false
//            }
//            else {validaUsuario = true}
//
//            if (txtTelefone.text!.isEmpty){
//                exibeMensagemAlerta (titulo: "Dado Invalido.", mensagem: "Preencha o Telefone")
//                validaUsuario = false
//            }else {validaUsuario = true}
//
//            if (txtEmail.text!.isEmpty){
//                exibeMensagemAlerta (titulo: "Dado Invalido.", mensagem: "Preencha o email.")
//                validaUsuario = false
//            }else {validaUsuario = true}
//
//
//
//            if validaUsuario {
//                try context.save()
//                exibeMensagemAlerta (titulo: "Sucesso", mensagem: "Participante Criado com Sucesso")
//                txtNome.text = ""
//                txtEmail.text = ""
//                txtEndereco.text = ""
//                txtTelefone.text = ""
//                dtDataNascimento.date = Date()
//                self.performSegue(withIdentifier: "cadastroParticipanteSegue", sender: nil)
//            }
//        }catch {
//            exibeMensagemAlerta (titulo: "Erro", mensagem: "Erro ao salvar.")
//        }
   }
    
    }
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}
