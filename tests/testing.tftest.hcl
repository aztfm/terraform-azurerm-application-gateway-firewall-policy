provider "azurerm" {
  features {}
}

run "setup" {
  module {
    source = "./tests/environment"
  }
}

// variables {

// }

// run "plan" {
//   command = plan

//   variables {

//   }

//   assert {
//     condition     = 
//     error_message = ""
//   }
// }

// run "apply" {
//   command = apply

//   variables {

//   }

//   assert {
//     condition     = 
//     error_message = ""
//   }
// }
