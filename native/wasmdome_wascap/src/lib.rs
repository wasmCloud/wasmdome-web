use wascap::prelude::{Account,Claims, validate_token}; // do not want the wascap Result type
use rustler::{NifStruct, Binary};
use wascap::jwt::TokenValidation;

#[rustler::nif]
fn decode_jwt(jwt: String) -> Result<AccountClaims, String> {        
    match Claims::<Account>::decode(&jwt) {
        Ok(c) => {
            Ok(map_claims(c))
        },
        Err(e) => Err(format!("{}", e))
    }
}

#[rustler::nif]
fn validate_jwt(jwt: String) -> Result<ValidationResponse, String> {
    let v = validate_token::<Account>(&jwt); // doesn't really matter which type we use
    match v {
        Ok(tv) => { 
            Ok(map_validation(tv)) 
        },
        Err(e) => Err(format!("{}", e))
    }
}

#[rustler::nif]
fn extract_jwt(bytes: Binary) -> Result<String, String> {    
    wascap::wasm::extract_claims(bytes.as_slice())
        .map_err(|e| format!("{}", e))    
        .and_then(|ot| ot.ok_or("No embedded token".to_string()))
        .map(|t| t.jwt.to_string())        
}

rustler::init!("Elixir.Wasmdome.Wascap", [decode_jwt, validate_jwt, extract_jwt]);

fn map_validation(tv: TokenValidation) -> ValidationResponse {
    ValidationResponse {
        expired: tv.expired,
        cannot_use_yet: tv.cannot_use_yet,
        expires_human: tv.expires_human,
        not_before_human: tv.not_before_human,
        signature_valid: tv.signature_valid
    }
}

fn map_claims(claims: Claims<Account>) -> AccountClaims {
    AccountClaims {
        issuer: claims.issuer.to_string(),
        subject: claims.subject.to_string(),
        name: claims.name().to_string(),
    }
}

#[derive(NifStruct)]
#[module = "Wasmdome.Wascap.ValidationResponse"]
struct ValidationResponse {
    pub expired: bool,
    pub cannot_use_yet: bool,
    pub expires_human: String,
    pub not_before_human: String,
    pub signature_valid: bool,
}

#[derive(NifStruct)]
#[module = "Wasmdome.Wascap.AccountClaims"]
struct AccountClaims {
    pub issuer: String,
    pub subject: String,
    pub name: String,    
}