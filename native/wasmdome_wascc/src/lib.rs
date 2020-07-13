use rustler::{Binary, NifStruct};
use wascap::jwt::TokenValidation;
use wascap::prelude::{validate_token, Account, Claims}; // do not want the wascap Result type

#[rustler::nif]
fn decode_jwt(jwt: String) -> Result<AccountClaims, String> {
    match Claims::<Account>::decode(&jwt) {
        Ok(c) => Ok(map_claims(c)),
        Err(e) => Err(format!("{}", e)),
    }
}

#[rustler::nif]
fn validate_jwt(jwt: String) -> Result<ValidationResponse, String> {
    let v = validate_token::<Account>(&jwt); // doesn't really matter which type we use
    match v {
        Ok(tv) => Ok(map_validation(tv)),
        Err(e) => Err(format!("{}", e)),
    }
}

#[rustler::nif]
fn extract_jwt(bytes: Binary) -> Result<String, String> {
    wascap::wasm::extract_claims(bytes.as_slice())
        .map_err(|e| format!("{}", e))
        .and_then(|ot| ot.ok_or("No embedded token".to_string()))
        .map(|t| t.jwt.to_string())
}

#[rustler::nif]
fn lattice_inventory() -> Result<LatticeInventory, String> {
    let c = latticeclient::Client::new("127.0.0.1", None, std::time::Duration::from_millis(500));
    let hosts = match c.get_hosts() {
        Ok(h) => h,
        Err(_) => return no_inventory(),
    };
    let actors = match c.get_actors() {
        Ok(a) => a,
        Err(_) => return no_inventory(),
    };
    Ok(LatticeInventory {
        hosts: hosts.len() as u32,
        actors: actors.len() as u32,
    })
}

rustler::init!(
    "Elixir.Wasmdome.Wascc",
    [decode_jwt, validate_jwt, extract_jwt, lattice_inventory]
);

fn map_validation(tv: TokenValidation) -> ValidationResponse {
    ValidationResponse {
        expired: tv.expired,
        cannot_use_yet: tv.cannot_use_yet,
        expires_human: tv.expires_human,
        not_before_human: tv.not_before_human,
        signature_valid: tv.signature_valid,
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
#[module = "Wasmdome.Wascc.ValidationResponse"]
struct ValidationResponse {
    pub expired: bool,
    pub cannot_use_yet: bool,
    pub expires_human: String,
    pub not_before_human: String,
    pub signature_valid: bool,
}

#[derive(NifStruct)]
#[module = "Wasmdome.Wascc.AccountClaims"]
struct AccountClaims {
    pub issuer: String,
    pub subject: String,
    pub name: String,
}

#[derive(NifStruct)]
#[module = "Wasmdome.Wascc.LatticeInventory"]
struct LatticeInventory {
    pub hosts: u32,
    pub actors: u32,
}

fn no_inventory() -> Result<LatticeInventory, String> {
    Ok(LatticeInventory {
        hosts: 0,
        actors: 0,
    })
}
