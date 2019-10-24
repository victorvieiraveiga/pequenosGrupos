//
//  HomeViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 04/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HomeCelulaViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    

    @IBOutlet var telaview: UIView!
    
    
    var celulaModel: [Celulas] = []
    var dadosLogin : NSDictionary = [:]
    
    let bUsuario = BuscaUsuario()
    
    var nome : String = ""
    
    @IBOutlet weak var txtCelula: UILabel!
    @IBOutlet weak var txtAnfitriao: UILabel!
    @IBOutlet weak var txtEndereco: UILabel!
    @IBOutlet weak var txtDia: UILabel!
    @IBOutlet weak var txtHorario: UILabel!
    @IBOutlet weak var txtIdCelula: UILabel!
    @IBOutlet weak var emailUsuario: UILabel!
    @IBOutlet weak var btSalvar: UIButton!
    
   
  var Celula = String()
  var Endereco = String()
  var Dia = String ()
  var Anfitriao = String ()
  var Horario = String()
  var idCelula = String ()
  var logado = String ()
  var temCelula = String ()
  
    
    //var txtIdCelula  : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        logado = VerificaUsuarioLogado()
        
        if logado == "desconectado" {
                performSegue(withIdentifier: "voltaPraHome", sender: logado)
        }
        else {
                //if idCelula.isEmpty {
            
                    let autenticacao = Auth.auth()
                    autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
                        if let usuarioLogado = usuario {
                            let usuarioSelecionado = usuarioLogado.uid
                            //verifica se usuario tem celula
                            let database  = Database.database().reference()

                            
                            
                            let usuarios = database.child("usuarios").queryOrderedByKey().queryEqual(toValue: usuarioSelecionado)
                            
                            usuarios.observe(DataEventType.childAdded, with: { (usuSnap) in
                                let usuDados = usuSnap.value as! NSDictionary
                                
                                 self.temCelula = usuDados["temCelula"] as! String
                                
                                if self.temCelula == "N" {
                                    self.performSegue(withIdentifier: "configuraGrupo", sender: nil)
                                }else {
                                    
                                    let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioSelecionado)
                                    
                                    celula.observe(DataEventType.childAdded, with: {(celulaRecuperada) in
                                        let dados = celulaRecuperada.value as! NSDictionary
                                        //recupera dados
                                        print(celulaRecuperada.key)
                                        let uidCelula = dados["idCelula"]
                                        let  nomeLider = dados["lider"]
                                        let nomeAnfitriao = dados["anfitriao"]
                                        let endCelula = dados["endereco"]
                                        let diaCelula = dados["dia"]
                                        let horarioCelula = dados["horario"]
                                        let idUsuario = dados["idUsuario"]
                                        let tipoGrupo = dados ["tipoGrupo"]
                                        
                                        
                                        let celulas = Celulas( uidCelula: uidCelula as! String, nomeLider: nomeLider as! String, nomeAnfitriao: nomeAnfitriao as! String, endCelula: endCelula as! String, diaCelula: diaCelula as! String, horarioCelula: horarioCelula as! String, tipoGrupo: tipoGrupo as! String )
                                        
                                        //                                                       let celulas = Celulas(uidCelula: uidCelula as! String, nomeLider: nomeLider as! String, nomeAnfitriao: nomeAnfitriao as! String, endCelula: endCelula as! String, diaCelula: diaCelula as! String, horarioCelula: horarioCelula as! String, idUsuario: idUsuario as! String )
                                        
                                        //self.celulaModel = celulas
                                        //adiciona no array
                                        self.celulaModel.append(celulas)
                                        self.txtCelula.text =  celulas.nomeLider
                                        self.txtAnfitriao.text = celulas.nomeAnfitriao
                                        self.txtEndereco.text = celulas.endCelula
                                        self.txtDia.text = celulas.diaCelula
                                        self.txtHorario.text = celulas.horarioCelula + "H"
                                        //self.txtIdCelula.text = celulas.uidCelula
                                        //self.emailUsuario.text = celulas.idUsuario
                                    })
                                    
                                }
                                
                            })
                            

                       }
                    }

           }
    }
    
    @IBAction func salvar_celula(_ sender: Any) {
        
        let autenticacao = Auth.auth() //inicio - pega o usuario logado
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            let usuarioLogado = usuario
            
            //inicio - salva usuarios no banco de dados do firebase
           
                let database = Database.database().reference()
                let celulas = database.child("celula")
            
                let celulaDados = ["idCelula" : self.txtIdCelula.text, "lider" : self.txtCelula.text , "anfitriao": self.txtAnfitriao.text, "endereco": self.txtEndereco.text, "dia": self.txtDia.text, "horario" : self.txtHorario.text, "idUsuario": self.emailUsuario.text]
            
            do {
               celulas.child(usuarioLogado!.uid).setValue(celulaDados)
               self.exibeMensagemAlerta(titulo: "Sucesso.", mensagem: "Celula cadastrada com sucesso.")
            }
            catch {
                self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Erro ao salvar celula.")
           }
        }//fim - pega usuario logado
       
        
        
    }

    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    func chamaXib (nome: String, bemvindo: String) {
        let view = Home(frame: CGRect(x: 0, y: 0, width: self.telaview.frame.width, height: self.telaview.frame.height))
        view.set(nome: nome)
        view.set(bemvindo: bemvindo)
        self.telaview = view
    }
    
    //passa valor para outra tela
    override func prepare (for segue: UIStoryboardSegue, sender: Any? ){
        if logado == "logado"   {
            if self.temCelula != "N" {
                let nextViewController  = segue.destination as! CelulaViewController
                nextViewController.celula = self.celulaModel
            }
        }
    }
    
    func VerificaUsuarioLogado () -> String {
        var logado : String = ""
        
        let autenticacao = Auth.auth()
        
        if let usuariologado = autenticacao.currentUser?.uid {
            logado = "logado"
        }
        else {
            logado = "desconectado"
        }
        return logado
    }
}

//extension HomeCelulaViewController {
//
//    func verificaUsuarioLogado () -> String {
//        let usuarioLogado : Autenticacao
//
//        if let logado: String = usuarioLogado.VerificaUsuarioLogado() {
//            let log = logado as String
//        }
//
//        if log == "desconectado" {
//            return log
//        } else {
//            return "logado"
//        }
//    }
//}

