from fastapi import FastAPI

app = FastAPI(title="devsecops-demo")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/")
def root():
    return {"message": "secure pipeline demo"}
