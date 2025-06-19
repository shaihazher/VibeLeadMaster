from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, validator
from mailscout import Scout
import httpx
import os

app = FastAPI(title="Email Generator & Verifier")

# URL of the local Reacher service (running in the same container)
REACHER_URL = os.getenv("REACHER_URL", "http://127.0.0.1:8080/v0/check_email")

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
    is_deliverable: bool
    is_catch_all: bool
    is_role: bool

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/generate", response_model=EmailResponse)
async def generate_email(data: InputData):
    """Generate email candidates, validate with Reacher, return first deliverable."""
    scout = Scout()
    candidates = scout.find_valid_emails(
        data.domain,
        [[data.first_name, data.last_name]],
        check_variants=True,
        check_catchall=True
    )
    if not candidates:
        raise HTTPException(status_code=404, detail="No candidate emails generated")

    async with httpx.AsyncClient(timeout=10) as client:
        for email in candidates:
            try:
                resp = await client.post(REACHER_URL, json={"to_email": email})
            except httpx.RequestError as exc:
                raise HTTPException(status_code=502, detail=f"Reacher unavailable: {exc}")
            if resp.status_code != 200:
                # Skip unusable responses
                continue
            r = resp.json()
            smtp = r.get("smtp", {})
            misc = r.get("misc", {})
            if smtp.get("is_deliverable"):
                return EmailResponse(
                    email=email,
                    is_deliverable=True,
                    is_catch_all=smtp.get("is_catch_all", False),
                    is_role=misc.get("is_role_account", False)
                )
    raise HTTPException(status_code=422, detail="No deliverable email found")
