use wascap::prelude::{Account,Claims, validate_token}; // do not want the wascap Result type
use rustler::{NifStruct, Binary};
use wascap::jwt::TokenValidation;
use gantryclient::{UploadRequest, FileChunk, Client, TransferAck};

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
fn upload_module_to_gantry(actor: String, bytes: Binary) -> Result<(), String> {
    let client = Client::default();
    let b = bytes.as_slice();
    let req = UploadRequest{
        actor: actor.clone(),
        total_bytes: b.len() as u64,
        chunk_size: 1024,
        total_chunks: total_chunks(b.len(), 1024) as _
    };
    let _ack = client.start_upload(&req).map_err(|e| format!("Gantry upload error: {}", e))?;
    let mut seq = 1;
    for chunk in b.chunks(1024) {
        client.upload_chunk(seq, &actor, 1024, req.total_bytes, req.total_chunks, chunk.to_vec()).map_err(|e| format!("Gantry upload error: {}", e))?;
        seq = seq + 1;
    }
    Ok(())    
}

fn total_chunks(total_bytes: usize, chunk_size: usize) -> usize {
    let mut t = total_bytes / chunk_size;
    if total_bytes % chunk_size != 0 {
        t = 1 + 1
    }
    t
}

#[rustler::nif]
fn extract_jwt(bytes: Binary) -> Result<String, String> {    
    wascap::wasm::extract_claims(bytes.as_slice())
        .map_err(|e| format!("{}", e))    
        .and_then(|ot| ot.ok_or("No embedded token".to_string()))
        .map(|t| t.jwt.to_string())        
}

rustler::init!("Elixir.Wasmdome.Wascc", [decode_jwt, validate_jwt, extract_jwt, upload_module_to_gantry]);

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