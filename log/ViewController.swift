import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        print("Login Pressed")
        guard let email = username.text, !email.isEmpty
            else {
            showAlert(alertTitle: "Null entry", alertMessage: "Please enter your email id", alertAction: "Ok")
            return
        }
        guard let pword = password.text, !pword.isEmpty
            else {
            showAlert(alertTitle: "Null entry", alertMessage: "Please enter your password", alertAction: "Ok")
            return
        }
        checkForValidUser(userEmail:email, userPword: pword)
    }
    
    @IBAction func newUserButton(_ sender: Any) {
        self.performSegue(withIdentifier: "userreg", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkForValidUser(userEmail: String, userPword: String)
        {
            let parameters: Parameters = ["email": userEmail,"password": userPword, "fun": "usAu"]
            let url  = "https://bgfexn4owb.execute-api.me-south-1.amazonaws.com/prod/myApp"
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("LoginAPIJSON: \(json)")
                    if (json["statusCode"] == 200) {
                        print("Login Successfull")
                        UserDefaults.standard.set(userEmail, forKey: "userEmail")
                        self.performSegue(withIdentifier: "validUser", sender: self)
                    }
                    else {
                        print("Invalid credentials")
                        self.showAlert(alertTitle: "Invalid credentials", alertMessage: "Invalid email or Password", alertAction: "Ok")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: alertAction, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

