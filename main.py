from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, validator
from mailscout import Scout

app = FastAPI(title="Email Generator")

class InputData(BaseModel):
    first_name: str
    last_name: str
    domain: str

    @validator("domain")
    def clean_domain(cls, v):
        if "@" in v:
            raise ValueError("Domain should not include '@'")
        return v.lower()

class EmailResponse(BaseModel):
    email: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/generate", response_model=EmailResponse)
def generate_email(data: InputData):
    """Generate and return the first email candidate using MailScout only."""
    scout = Scout()
    candidates = scout.find_valid_emails(
        data.domain,
        [[data.first_name, data.last_name]],
    )
    if not candidates:
        raise HTTPException(status_code=404, detail="No candidate emails generated")

    return EmailResponse(email=candidates[0])
